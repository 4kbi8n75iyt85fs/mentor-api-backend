-- ===========================================
-- DATABASE RESTRUCTURING - CONTENT MANAGEMENT
-- Run this in Supabase SQL Editor
-- ===========================================

-- PART 1: Create content table for lesson content
-- ===========================================

CREATE TABLE IF NOT EXISTS mentor.content (
    id SERIAL PRIMARY KEY,
    class INT NOT NULL,
    subject TEXT NOT NULL,
    chapter_number INT NOT NULL,
    chapter_title TEXT,
    content_json JSONB NOT NULL DEFAULT '{"sections": []}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(class, subject, chapter_number)
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_content_class_subject ON mentor.content(class, subject);

-- PART 2: Remove unused reference tables
-- ===========================================

DROP TABLE IF EXISTS mentor.days_ref CASCADE;
DROP TABLE IF EXISTS mentor.subjects_ref CASCADE;

-- PART 3: Create updated_at trigger for content table
-- ===========================================

CREATE OR REPLACE FUNCTION mentor.update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_content_modtime
    BEFORE UPDATE ON mentor.content
    FOR EACH ROW
    EXECUTE FUNCTION mentor.update_modified_column();

-- PART 4: Grant permissions (for Supabase)
-- ===========================================

GRANT ALL ON mentor.content TO authenticated;
GRANT ALL ON mentor.content TO service_role;
GRANT USAGE, SELECT ON SEQUENCE mentor.content_id_seq TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE mentor.content_id_seq TO service_role;

-- Done!
-- Next: Run the content migration script to populate this table
