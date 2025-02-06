-- Weather type table
CREATE TABLE weather_type (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

-- Sub Category Table, we already have category table
CREATE TABLE sub_category (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category_id INT NOT NULL REFERENCES item_category(id) ON DELETE CASCADE
  weather_type_id INT NOT NULL REFERENCES weather_type(id) ON DELETE CASCADE
);

-- Add weather_type_id to category
ALTER TABLE item_category ADD COLUMN weather_type_id INT REFERENCES weather_type(id) ON DELETE SET NULL;
