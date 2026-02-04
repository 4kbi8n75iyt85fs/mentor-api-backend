-- =====================================================
-- MENTOR COMPLETE DATABASE SETUP FOR SUPABASE
-- Run this entire file in Supabase SQL Editor
-- =====================================================

-- Step 1: Create Schema
CREATE SCHEMA IF NOT EXISTS mentor;

-- =====================================================
-- LOOKUP TABLES
-- =====================================================

-- Days Reference (1-7)
CREATE TABLE mentor.days_ref (
    code INTEGER PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    name_bn VARCHAR(20)
);

INSERT INTO mentor.days_ref (code, name, name_bn) VALUES
(1, 'Sat', 'শনিবার'),
(2, 'Sun', 'রবিবার'),
(3, 'Mon', 'সোমবার'),
(4, 'Tue', 'মঙ্গলবার'),
(5, 'Wed', 'বুধবার'),
(6, 'Thu', 'বৃহস্পতিবার'),
(7, 'Fri', 'শুক্রবার');

-- Subjects Reference with codes
CREATE TABLE mentor.subjects_ref (
    code INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    classes TEXT
);

INSERT INTO mentor.subjects_ref (code, name, classes) VALUES
(1, 'চারুপাঠ', '6'),
(2, 'সপ্তবর্ণা', '7'),
(3, 'সাহিত্য-কণিকা', '8'),
(4, 'বাংলা সাহিত্য', '9,10'),
(5, 'বাংলা ব্যাকরণ ও নির্মিতি', '6,7,8,9,10'),
(10, 'English For Today', '6,7,8,9,10'),
(11, 'English Grammar', '6,7,8,9,10'),
(20, 'গণিত', '6,7,8,9,10'),
(21, 'উচ্চতর গণিত', '9,10'),
(30, 'বিজ্ঞান', '6,7,8'),
(31, 'পদার্থবিজ্ঞান', '9,10'),
(32, 'রসায়ন', '9,10'),
(33, 'জীববিজ্ঞান', '9,10'),
(40, 'বাংলাদেশ ও বিশ্বপরিচয়', '6,7,8,9,10'),
(50, 'ইসলাম ও নৈতিক শিক্ষা', '6,7,8,9,10'),
(51, 'হিন্দুধর্ম ও নৈতিক শিক্ষা', '6,7,8,9,10'),
(60, 'তথ্য ও যোগাযোগ প্রযুক্তি', '9,10'),
(70, 'কৃষি শিক্ষা', '9,10'),
(71, 'গার্হস্থ্য বিজ্ঞান', '9,10'),
(80, 'চারু ও কারুকলা', '6,7,8'),
(81, 'শারীরিক শিক্ষা', '6,7,8,9,10'),
(82, 'সংগীত', '6,7,8'),
(83, 'কর্ম ও জীবনমুখী শিক্ষা', '6,7,8'),
(90, 'হিসাববিজ্ঞান', '9,10'),
(91, 'ফিন্যান্স ও ব্যাংকিং', '9,10'),
(92, 'ব্যবসায় উদ্যোগ', '9,10');

-- =====================================================
-- CHAPTERS TABLE (How many chapters per subject)
-- =====================================================
CREATE TABLE mentor.chapters (
    id SERIAL PRIMARY KEY,
    class INTEGER NOT NULL,
    subject VARCHAR(255) NOT NULL,
    total_chapters INTEGER DEFAULT 10,
    parts_per_chapter INTEGER DEFAULT 3,
    UNIQUE(class, subject)
);

INSERT INTO mentor.chapters (class, subject, total_chapters, parts_per_chapter) VALUES
-- Class 6
(6, 'চারুপাঠ', 15, 3),
(6, 'English For Today', 12, 3),
(6, 'গণিত', 14, 3),
(6, 'বিজ্ঞান', 12, 3),
(6, 'বাংলাদেশ ও বিশ্বপরিচয়', 12, 3),
(6, 'ইসলাম ও নৈতিক শিক্ষা', 10, 3),
-- Class 7
(7, 'সপ্তবর্ণা', 15, 3),
(7, 'English For Today', 12, 3),
(7, 'গণিত', 14, 3),
(7, 'বিজ্ঞান', 14, 3),
(7, 'বাংলাদেশ ও বিশ্বপরিচয়', 12, 3),
(7, 'ইসলাম ও নৈতিক শিক্ষা', 10, 3),
-- Class 8
(8, 'সাহিত্য-কণিকা', 20, 1),
(8, 'English For Today', 12, 3),
(8, 'গণিত', 14, 3),
(8, 'বিজ্ঞান', 14, 3),
(8, 'বাংলাদেশ ও বিশ্বপরিচয়', 14, 3),
(8, 'ইসলাম ও নৈতিক শিক্ষা', 10, 3),
-- Class 9
(9, 'বাংলা সাহিত্য', 25, 1),
(9, 'English For Today', 15, 3),
(9, 'গণিত', 16, 1),
(9, 'পদার্থবিজ্ঞান', 12, 3),
(9, 'রসায়ন', 12, 3),
(9, 'জীববিজ্ঞান', 12, 3),
(9, 'বাংলাদেশ ও বিশ্বপরিচয়', 15, 3),
(9, 'ইসলাম ও নৈতিক শিক্ষা', 10, 3),
(9, 'উচ্চতর গণিত', 14, 3),
(9, 'তথ্য ও যোগাযোগ প্রযুক্তি', 6, 3),
-- Class 10
(10, 'বাংলা সাহিত্য', 25, 1),
(10, 'English For Today', 15, 3),
(10, 'গণিত', 16, 1),
(10, 'পদার্থবিজ্ঞান', 12, 3),
(10, 'রসায়ন', 12, 3),
(10, 'জীববিজ্ঞান', 12, 3),
(10, 'বাংলাদেশ ও বিশ্বপরিচয়', 15, 3),
(10, 'ইসলাম ও নৈতিক শিক্ষা', 10, 3),
(10, 'উচ্চতর গণিত', 14, 3),
(10, 'তথ্য ও যোগাযোগ প্রযুক্তি', 6, 3);

-- =====================================================
-- TEACHERS TABLE
-- =====================================================
CREATE TABLE mentor.teachers (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    active INTEGER DEFAULT 1,
    salary_amount DECIMAL(10,2) DEFAULT 0,
    join_date DATE DEFAULT CURRENT_DATE
);

-- Insert a teacher
INSERT INTO mentor.teachers (id, name, phone, password) VALUES
('T1', 'Teacher One', '01700000000', '123456'),
('T2', 'Shahariar Hossain', '01631522059', '12341234');

-- =====================================================
-- SUBSCRIPTIONS TABLE (Main student data)
-- =====================================================
CREATE TABLE mentor.subscriptions (
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL,
    student_phone VARCHAR(20),
    guardian_name VARCHAR(255),
    guardian_phone VARCHAR(20),
    class INTEGER NOT NULL,
    subjects TEXT NOT NULL,
    teacher_id VARCHAR(50) NOT NULL,
    days_per_week INTEGER DEFAULT 3,
    schedule_days TEXT NOT NULL,
    time VARCHAR(20) DEFAULT '10:00 AM',
    amount DECIMAL(10,2) DEFAULT 0,
    billing_date INTEGER DEFAULT 1,
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    total_classes INTEGER DEFAULT 0,
    completed_classes INTEGER DEFAULT 0,
    progress_percent DECIMAL(5,2) DEFAULT 0,
    schedule_json JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SCHEDULE TABLE (Per-subject progress tracking)
-- =====================================================
CREATE TABLE mentor.schedule (
    id SERIAL PRIMARY KEY,
    subscription_id INTEGER REFERENCES mentor.subscriptions(id) ON DELETE CASCADE,
    subject VARCHAR(255) NOT NULL,
    current_chapter INTEGER DEFAULT 1,
    current_part INTEGER DEFAULT 1,
    total_parts_done INTEGER DEFAULT 0,
    total_parts_needed INTEGER DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- PROGRESS TABLE (Completed lessons log)
-- =====================================================
CREATE TABLE mentor.progress (
    id SERIAL PRIMARY KEY,
    subscription_id INTEGER REFERENCES mentor.subscriptions(id) ON DELETE CASCADE,
    schedule_id INTEGER REFERENCES mentor.schedule(id) ON DELETE CASCADE,
    subject VARCHAR(255) NOT NULL,
    chapter INTEGER NOT NULL,
    part INTEGER NOT NULL,
    teacher_id VARCHAR(50),
    notes TEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- HOLIDAYS TABLE
-- =====================================================
CREATE TABLE mentor.holidays (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) DEFAULT 'public'
);

-- =====================================================
-- QUICK REFERENCE VIEW
-- =====================================================
CREATE VIEW mentor.quick_reference AS
SELECT 'DAY' as type, code, name, name_bn as extra FROM mentor.days_ref
UNION ALL
SELECT 'SUBJECT' as type, code, name, classes as extra FROM mentor.subjects_ref
ORDER BY type, code;

-- =====================================================
-- TRIGGER: Auto-generate schedule JSON on insert
-- =====================================================
CREATE OR REPLACE FUNCTION mentor.fn_generate_schedule_json()
RETURNS TRIGGER AS $$
DECLARE
    subj_codes TEXT[];
    subj_name TEXT;
    subj_code TEXT;
    chapters INT;
    parts_per_ch INT;
    day_codes TEXT[];
    day_names TEXT[];
    day_code TEXT;
    day_name TEXT;
    
    schedule_array JSONB := '[]'::JSONB;
    current_date_val DATE;
    class_number INT := 1;
    subject_index INT := 0;
    total_classes_count INT := 0;
    
    subject_chapters INT[];
    subject_parts INT[];
    subject_names TEXT[];
    subject_current_ch INT[];
    subject_current_pt INT[];
    i INT;
    all_done BOOLEAN;
BEGIN
    -- Convert day codes to names
    day_codes := string_to_array(NEW.schedule_days, ',');
    day_names := ARRAY[]::TEXT[];
    
    FOREACH day_code IN ARRAY day_codes LOOP
        day_code := trim(day_code);
        IF day_code ~ '^[0-9]+$' THEN
            SELECT name INTO day_name FROM mentor.days_ref WHERE code = day_code::INT;
            IF day_name IS NOT NULL THEN
                day_names := array_append(day_names, day_name);
            END IF;
        ELSE
            day_names := array_append(day_names, day_code);
        END IF;
    END LOOP;
    
    IF array_length(day_names, 1) > 0 THEN
        NEW.schedule_days := array_to_string(day_names, ',');
    END IF;
    
    -- Convert subject codes to names
    subj_codes := string_to_array(NEW.subjects, ',');
    subject_names := ARRAY[]::TEXT[];
    subject_chapters := ARRAY[]::INT[];
    subject_parts := ARRAY[]::INT[];
    subject_current_ch := ARRAY[]::INT[];
    subject_current_pt := ARRAY[]::INT[];
    
    FOREACH subj_code IN ARRAY subj_codes LOOP
        subj_code := trim(subj_code);
        
        IF subj_code ~ '^[0-9]+$' THEN
            SELECT name INTO subj_name FROM mentor.subjects_ref WHERE code = subj_code::INT;
        ELSE
            subj_name := subj_code;
        END IF;
        
        IF subj_name IS NOT NULL THEN
            subject_names := array_append(subject_names, subj_name);
            
            SELECT total_chapters, parts_per_chapter 
            INTO chapters, parts_per_ch
            FROM mentor.chapters
            WHERE class = NEW.class AND subject = subj_name;
            
            IF chapters IS NULL THEN
                chapters := 10;
                parts_per_ch := 3;
            END IF;
            
            subject_chapters := array_append(subject_chapters, chapters);
            subject_parts := array_append(subject_parts, parts_per_ch);
            subject_current_ch := array_append(subject_current_ch, 1);
            subject_current_pt := array_append(subject_current_pt, 1);
            
            total_classes_count := total_classes_count + (chapters * parts_per_ch);
        END IF;
    END LOOP;
    
    IF array_length(subject_names, 1) > 0 THEN
        NEW.subjects := array_to_string(subject_names, ',');
    END IF;
    
    NEW.total_classes := total_classes_count;
    
    -- Generate schedule JSON
    current_date_val := COALESCE(NEW.start_date, CURRENT_DATE);
    subject_index := 1;
    
    WHILE class_number <= total_classes_count AND class_number <= 500 LOOP
        i := ((subject_index - 1) % array_length(subject_names, 1)) + 1;
        
        IF subject_current_ch[i] <= subject_chapters[i] THEN
            schedule_array := schedule_array || jsonb_build_object(
                'class_num', class_number,
                'date', current_date_val::TEXT,
                'subject', subject_names[i],
                'chapter', subject_current_ch[i],
                'part', subject_current_pt[i],
                'done', false
            );
            
            subject_current_pt[i] := subject_current_pt[i] + 1;
            IF subject_current_pt[i] > subject_parts[i] THEN
                subject_current_pt[i] := 1;
                subject_current_ch[i] := subject_current_ch[i] + 1;
            END IF;
            
            class_number := class_number + 1;
        END IF;
        
        subject_index := subject_index + 1;
        
        IF subject_index > array_length(subject_names, 1) THEN
            subject_index := 1;
            current_date_val := current_date_val + 1;
        END IF;
    END LOOP;
    
    NEW.schedule_json := jsonb_build_object(
        'total_classes', total_classes_count,
        'subjects', subject_names,
        'days', day_names,
        'generated_at', CURRENT_TIMESTAMP,
        'classes', schedule_array
    );
    
    IF total_classes_count > 0 THEN
        NEW.progress_percent := ROUND((NEW.completed_classes::DECIMAL / total_classes_count) * 100, 2);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_subscription_json
BEFORE INSERT ON mentor.subscriptions
FOR EACH ROW
EXECUTE FUNCTION mentor.fn_generate_schedule_json();

-- =====================================================
-- DONE! Database is ready.
-- Now connect NocoDB to this database.
-- =====================================================
