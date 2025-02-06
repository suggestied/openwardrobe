CREATE TABLE IF NOT EXISTS public.weather_based_suggestions (
    id uuid DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    weather jsonb NOT NULL,
    suggested_at timestamp without time zone DEFAULT now()
);

-- Koppel tabel voor outfit en weather_based_suggestions, zodat nul, of meerdere outfits gekoppeld kunnen worden aan een suggestie
CREATE TABLE IF NOT EXISTS public.weather_based_suggestions_outfits (
    id uuid DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    weather_based_suggestion_id uuid NOT NULL REFERENCES public.weather_based_suggestions(id) ON DELETE CASCADE,
    outfit_id uuid NOT NULL REFERENCES public.outfit(id) ON DELETE CASCADE
);

-- Enable Row Level Security
ALTER TABLE public.weather_based_suggestions ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to access their own suggestions
CREATE POLICY "Users can view their weather suggestions"
    ON public.weather_based_suggestions
    USING (auth.uid() = user_id);

-- Policy to allow users to access their own suggestions
CREATE POLICY "Users can view their weather suggestions"
    ON public.weather_based_suggestions_outfits
    USING (auth.uid() = (SELECT user_id FROM public.weather_based_suggestions WHERE id = weather_based_suggestion_id));
