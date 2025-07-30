-- Location: supabase/migrations/20250128134700_alpha_skincare_schema.sql
-- Alpha Skincare Mobile Application Database Schema
-- Full implementation with authentication, skin analysis, product recommendations, and progress tracking

-- 1. Types and Enums
CREATE TYPE public.user_role AS ENUM ('free', 'premium', 'admin');
CREATE TYPE public.subscription_status AS ENUM ('active', 'inactive', 'cancelled', 'expired');
CREATE TYPE public.skin_type AS ENUM ('oily', 'dry', 'combination', 'normal', 'sensitive');
CREATE TYPE public.skin_concern AS ENUM ('wrinkles', 'dark_spots', 'acne', 'dryness', 'sensitivity', 'pores', 'redness', 'texture');
CREATE TYPE public.product_category AS ENUM ('cleanser', 'moisturizer', 'serum', 'treatment', 'sunscreen', 'exfoliant', 'toner', 'mask');
CREATE TYPE public.analysis_status AS ENUM ('processing', 'completed', 'failed');

-- 2. Core Tables

-- User profiles (intermediary for auth relationships)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role DEFAULT 'free'::public.user_role,
    skin_type public.skin_type,
    date_of_birth DATE,
    profile_image_url TEXT,
    subscription_status public.subscription_status DEFAULT 'inactive'::public.subscription_status,
    subscription_expires_at TIMESTAMPTZ,
    scans_remaining INTEGER DEFAULT 5,
    total_scans_used INTEGER DEFAULT 0,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Skin analyses records
CREATE TABLE public.skin_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    analysis_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    overall_score INTEGER CHECK (overall_score >= 0 AND overall_score <= 100),
    status public.analysis_status DEFAULT 'processing'::public.analysis_status,
    metrics JSONB DEFAULT '{}',
    ai_analysis_results JSONB DEFAULT '{}',
    processing_time_seconds REAL,
    confidence_score REAL CHECK (confidence_score >= 0 AND confidence_score <= 1),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Skin metrics breakdown
CREATE TABLE public.skin_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID REFERENCES public.skin_analyses(id) ON DELETE CASCADE,
    metric_name TEXT NOT NULL,
    score INTEGER CHECK (score >= 0 AND score <= 100),
    improvement_status TEXT CHECK (improvement_status IN ('improved', 'stable', 'declined')),
    previous_score INTEGER,
    confidence REAL CHECK (confidence >= 0 AND confidence <= 1),
    details JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Product database
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    brand TEXT NOT NULL,
    category public.product_category NOT NULL,
    description TEXT,
    ingredients TEXT[],
    image_url TEXT,
    price_range TEXT,
    rating REAL CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER DEFAULT 0,
    suitable_skin_types public.skin_type[],
    targets_concerns public.skin_concern[],
    purchase_links JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Product recommendations
CREATE TABLE public.product_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    analysis_id UUID REFERENCES public.skin_analyses(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    recommendation_score REAL CHECK (recommendation_score >= 0 AND recommendation_score <= 1),
    reasoning TEXT,
    priority_order INTEGER,
    is_viewed BOOLEAN DEFAULT false,
    is_saved BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Educational content
CREATE TABLE public.educational_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    content_type TEXT CHECK (content_type IN ('tip', 'article', 'routine', 'ingredient_guide')),
    preview_text TEXT,
    full_content TEXT NOT NULL,
    image_url TEXT,
    tags TEXT[],
    target_skin_types public.skin_type[],
    target_concerns public.skin_concern[],
    reading_time_minutes INTEGER,
    is_featured BOOLEAN DEFAULT false,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User goals and progress tracking
CREATE TABLE public.user_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    goal_type TEXT NOT NULL,
    target_metric TEXT NOT NULL,
    target_value INTEGER,
    current_value INTEGER DEFAULT 0,
    target_date DATE,
    is_achieved BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User achievements/badges
CREATE TABLE public.user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    achievement_type TEXT NOT NULL,
    achievement_name TEXT NOT NULL,
    description TEXT,
    badge_icon TEXT,
    earned_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    milestone_value INTEGER
);

-- 3. Indexes for performance
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_skin_analyses_user_id ON public.skin_analyses(user_id);
CREATE INDEX idx_skin_analyses_date ON public.skin_analyses(analysis_date DESC);
CREATE INDEX idx_skin_analyses_status ON public.skin_analyses(status);
CREATE INDEX idx_skin_metrics_analysis_id ON public.skin_metrics(analysis_id);
CREATE INDEX idx_products_category ON public.products(category);
CREATE INDEX idx_products_brand ON public.products(brand);
CREATE INDEX idx_products_active ON public.products(is_active);
CREATE INDEX idx_product_recommendations_user_id ON public.product_recommendations(user_id);
CREATE INDEX idx_product_recommendations_analysis_id ON public.product_recommendations(analysis_id);
CREATE INDEX idx_educational_content_category ON public.educational_content(category);
CREATE INDEX idx_educational_content_featured ON public.educational_content(is_featured);
CREATE INDEX idx_user_goals_user_id ON public.user_goals(user_id);
CREATE INDEX idx_user_achievements_user_id ON public.user_achievements(user_id);

-- 4. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skin_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skin_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.educational_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions for RLS
CREATE OR REPLACE FUNCTION public.is_premium_user()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() 
    AND up.role = 'premium'::public.user_role
    AND up.subscription_status = 'active'::public.subscription_status
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_analysis(analysis_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.skin_analyses sa
    WHERE sa.id = analysis_uuid AND sa.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.owns_recommendation(recommendation_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.product_recommendations pr
    WHERE pr.id = recommendation_uuid AND pr.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.owns_goal(goal_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_goals ug
    WHERE ug.id = goal_uuid AND ug.user_id = auth.uid()
)
$$;

-- 6. RLS Policies
CREATE POLICY "users_own_profile" ON public.user_profiles FOR ALL
USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "users_manage_own_analyses" ON public.skin_analyses FOR ALL
USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_view_own_metrics" ON public.skin_metrics FOR SELECT
USING (public.can_access_analysis(analysis_id));

CREATE POLICY "products_public_read" ON public.products FOR SELECT
TO public USING (is_active = true);

CREATE POLICY "users_manage_own_recommendations" ON public.product_recommendations FOR ALL
USING (public.owns_recommendation(id)) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "educational_content_public_read" ON public.educational_content FOR SELECT
TO public USING (true);

CREATE POLICY "users_manage_own_goals" ON public.user_goals FOR ALL
USING (public.owns_goal(id)) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_view_own_achievements" ON public.user_achievements FOR SELECT
USING (auth.uid() = user_id);

-- 7. Functions for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'free'::public.user_role)
  );  
  RETURN NEW;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 8. Functions for updating timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Apply timestamp triggers
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_skin_analyses_updated_at
    BEFORE UPDATE ON public.skin_analyses
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_educational_content_updated_at
    BEFORE UPDATE ON public.educational_content
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_goals_updated_at
    BEFORE UPDATE ON public.user_goals
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 9. Mock Data
DO $$
DECLARE
    demo_user_id UUID := gen_random_uuid();
    premium_user_id UUID := gen_random_uuid();
    analysis1_id UUID := gen_random_uuid();
    analysis2_id UUID := gen_random_uuid();
    product1_id UUID := gen_random_uuid();
    product2_id UUID := gen_random_uuid();
    product3_id UUID := gen_random_uuid();
    content1_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (demo_user_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'demo@alphaskincare.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Demo User"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (premium_user_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'premium@alphaskincare.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Premium User"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create sample skin analyses
    INSERT INTO public.skin_analyses (id, user_id, image_url, overall_score, status, metrics, confidence_score)
    VALUES 
        (analysis1_id, demo_user_id, 
         'https://images.pexels.com/photos/3762879/pexels-photo-3762879.jpeg?auto=compress&cs=tinysrgb&w=400',
         78, 'completed'::public.analysis_status,
         '{"wrinkles": 82, "dark_spots": 75, "hydration": 68, "texture": 85}'::jsonb, 0.89),
        (analysis2_id, premium_user_id,
         'https://images.pexels.com/photos/3762870/pexels-photo-3762870.jpeg?auto=compress&cs=tinysrgb&w=400',
         85, 'completed'::public.analysis_status,
         '{"wrinkles": 88, "dark_spots": 82, "hydration": 90, "texture": 80}'::jsonb, 0.92);

    -- Create detailed metrics
    INSERT INTO public.skin_metrics (analysis_id, metric_name, score, improvement_status, confidence)
    VALUES 
        (analysis1_id, 'Wrinkles & Fine Lines', 82, 'improved', 0.91),
        (analysis1_id, 'Dark Spots', 75, 'stable', 0.87),
        (analysis1_id, 'Hydration', 68, 'declined', 0.83),
        (analysis1_id, 'Texture', 85, 'improved', 0.89),
        (analysis2_id, 'Wrinkles & Fine Lines', 88, 'improved', 0.93),
        (analysis2_id, 'Dark Spots', 82, 'improved', 0.90),
        (analysis2_id, 'Hydration', 90, 'improved', 0.95),
        (analysis2_id, 'Texture', 80, 'stable', 0.88);

    -- Create sample products
    INSERT INTO public.products (id, name, brand, category, description, price_range, rating, suitable_skin_types, targets_concerns)
    VALUES 
        (product1_id, 'Hydrating Serum', 'AlphaSkin Pro', 'serum'::public.product_category,
         'Advanced hyaluronic acid serum for deep hydration', '$25-35', 4.5,
         ARRAY['dry', 'normal', 'combination']::public.skin_type[],
         ARRAY['dryness', 'texture']::public.skin_concern[]),
        (product2_id, 'Vitamin C Brightening Serum', 'GlowLabs', 'serum'::public.product_category,
         'Powerful antioxidant serum for brightening and evening skin tone', '$30-45', 4.7,
         ARRAY['normal', 'combination', 'oily']::public.skin_type[],
         ARRAY['dark_spots', 'texture']::public.skin_concern[]),
        (product3_id, 'Gentle Daily Cleanser', 'PureSkin', 'cleanser'::public.product_category,
         'Mild, non-stripping cleanser suitable for all skin types', '$15-20', 4.3,
         ARRAY['dry', 'normal', 'combination', 'oily', 'sensitive']::public.skin_type[],
         ARRAY['sensitivity', 'dryness']::public.skin_concern[]);

    -- Create product recommendations
    INSERT INTO public.product_recommendations (user_id, analysis_id, product_id, recommendation_score, reasoning, priority_order)
    VALUES 
        (demo_user_id, analysis1_id, product1_id, 0.92, 
         'Your hydration score indicates dry skin. This serum will help restore moisture balance.', 1),
        (demo_user_id, analysis1_id, product2_id, 0.78,
         'To address dark spots and improve overall texture and brightness.', 2),
        (premium_user_id, analysis2_id, product2_id, 0.85,
         'Perfect for maintaining your current skin improvements and preventing future dark spots.', 1);

    -- Create educational content
    INSERT INTO public.educational_content (id, title, category, content_type, preview_text, full_content, target_concerns)
    VALUES 
        (content1_id, 'The Power of Hyaluronic Acid', 'Hydration', 'tip',
         'Hyaluronic acid can hold up to 1000 times its weight in water, making it a powerful hydrating ingredient...',
         'Hyaluronic acid can hold up to 1000 times its weight in water, making it a powerful hydrating ingredient for all skin types. This naturally occurring substance in our skin helps maintain moisture levels and plumpness. As we age, our natural hyaluronic acid production decreases, leading to drier, less elastic skin. Incorporating products with hyaluronic acid into your routine can help restore moisture and improve skin texture.',
         ARRAY['dryness', 'wrinkles']::public.skin_concern[]);

    -- Create sample goals
    INSERT INTO public.user_goals (user_id, goal_type, target_metric, target_value, current_value, target_date)
    VALUES 
        (demo_user_id, 'skin_improvement', 'overall_score', 85, 78, '2025-04-01'),
        (demo_user_id, 'hydration', 'hydration_score', 80, 68, '2025-03-15');

    -- Create achievements
    INSERT INTO public.user_achievements (user_id, achievement_type, achievement_name, description, milestone_value)
    VALUES 
        (demo_user_id, 'first_scan', 'First Analysis Complete', 'Completed your first skin analysis', 1),
        (premium_user_id, 'consistency', 'Weekly Scanner', 'Completed 4 weekly scans in a row', 4);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;