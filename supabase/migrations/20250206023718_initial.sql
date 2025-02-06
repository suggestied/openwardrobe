-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Brand Table
CREATE TABLE brand (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);


-- Item Category Table
CREATE TABLE item_category (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE
);


-- Wardrobe Item Table
CREATE TABLE wardrobe_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    brand_id UUID REFERENCES brand(id) ON DELETE SET NULL,
    category_id UUID REFERENCES item_category(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    deleted_at TIMESTAMP DEFAULT NULL
);

-- Outfit Table
CREATE TABLE outfit (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    deleted_at TIMESTAMP DEFAULT NULL
);

-- Outfit Items (Junction Table)
CREATE TABLE outfit_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    outfit_id UUID REFERENCES outfit(id) ON DELETE CASCADE,
    wardrobe_item_id UUID REFERENCES wardrobe_item(id) ON DELETE CASCADE
);

-- Use Outfit Table
CREATE TABLE use_outfit (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    outfit_id UUID REFERENCES outfit(id) ON DELETE CASCADE,
    used_at TIMESTAMP DEFAULT now(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Use Item Table
CREATE TABLE use_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wardrobe_item_id UUID REFERENCES wardrobe_item(id) ON DELETE CASCADE,
    used_at TIMESTAMP DEFAULT now(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);



-- Item Metadata Table
CREATE TABLE item_metadata (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wardrobe_item_id UUID PRIMARY KEY REFERENCES wardrobe_item(id) ON DELETE CASCADE,
);

-- Pic Table
CREATE TABLE pic (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    storage TEXT NOT NULL,
    wardrobe_item_id UUID REFERENCES wardrobe_item(id) ON DELETE CASCADE,
    outfit_id UUID REFERENCES outfit(id) ON DELETE SET NULL,
    description TEXT
);

-- Indexes for Performance
CREATE INDEX idx_wardrobe_item_user_id ON wardrobe_item(user_id);
CREATE INDEX idx_outfit_user_id ON outfit(user_id);
CREATE INDEX idx_use_outfit_outfit_id ON use_outfit(outfit_id);
CREATE INDEX idx_use_item_wardrobe_item_id ON use_item(wardrobe_item_id);

-- Auto-Update Timestamp Triggers
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_wardrobe_item
BEFORE UPDATE ON wardrobe_item
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_outfit
BEFORE UPDATE ON outfit
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Views for optimized frontend queries
CREATE VIEW v_user_wardrobe AS
SELECT w.*, b.name AS brand_name, c.name AS category_name
FROM wardrobe_item w
LEFT JOIN brand b ON w.brand_id = b.id
LEFT JOIN item_category c ON w.category_id = c.id
WHERE w.deleted_at IS NULL;

CREATE VIEW v_user_outfits AS
SELECT o.*, COUNT(oi.wardrobe_item_id) AS item_count
FROM outfit o
LEFT JOIN outfit_items oi ON o.id = oi.outfit_id
WHERE o.deleted_at IS NULL
GROUP BY o.id;

CREATE VIEW v_recent_usage AS
SELECT ui.user_id, ui.wardrobe_item_id, wi.name AS item_name, ui.used_at
FROM use_item ui
JOIN wardrobe_item wi ON ui.wardrobe_item_id = wi.id
WHERE ui.used_at > NOW() - INTERVAL '30 days';

-- Row Level Security (RLS)
ALTER TABLE wardrobe_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfit ENABLE ROW LEVEL SECURITY;
ALTER TABLE use_outfit ENABLE ROW LEVEL SECURITY;
ALTER TABLE use_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_category ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE pic ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can manage their wardrobe items" ON wardrobe_item
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage their outfits" ON outfit
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can use outfits" ON use_outfit
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can use wardrobe items" ON use_item
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage brands" ON brand
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view item categories" ON item_category
    FOR SELECT USING (true);

CREATE POLICY "Users can manage item metadata" ON item_metadata
    FOR ALL USING (EXISTS (SELECT 1 FROM wardrobe_item WHERE wardrobe_item.id = item_metadata.wardrobe_item_id AND wardrobe_item.user_id = auth.uid()))
    WITH CHECK (EXISTS (SELECT 1 FROM wardrobe_item WHERE wardrobe_item.id = item_metadata.wardrobe_item_id AND wardrobe_item.user_id = auth.uid()));

CREATE POLICY "Users can manage pictures" ON pic
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM wardrobe_item WHERE wardrobe_item.id = pic.wardrobe_item_id AND wardrobe_item.user_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM outfit WHERE outfit.id = pic.outfit_id AND outfit.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM wardrobe_item WHERE wardrobe_item.id = pic.wardrobe_item_id AND wardrobe_item.user_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM outfit WHERE outfit.id = pic.outfit_id AND outfit.user_id = auth.uid()
        )
    );
