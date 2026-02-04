-- Fix Schedule JSON Trigger
-- Problem: Old trigger uses 3 parts per chapter, new formula is 1 chapter = 1 class
-- Also: Trigger only fires on INSERT, not UPDATE

-- Drop old trigger
DROP TRIGGER IF EXISTS trg_subscription_json ON mentor.subscriptions;

-- Create updated function with 1 chapter = 1 class formula
CREATE OR REPLACE FUNCTION mentor.fn_generate_schedule_json()
RETURNS TRIGGER AS $$
DECLARE
    day_codes TEXT[];
    day_code TEXT;
    day_name TEXT;
    day_names TEXT[] := ARRAY[]::TEXT[];
    subj_codes TEXT[];
    subj_code TEXT;
    subj_name TEXT;
    subject_names TEXT[] := ARRAY[]::TEXT[];
    subject_chapters INT[] := ARRAY[]::INT[];
    subject_current_ch INT[] := ARRAY[]::INT[];
    chapters INT;
    total_classes_count INT := 0;
    schedule_array JSONB := '[]'::JSONB;
    current_date_val DATE;
    subject_index INT := 1;
    class_number INT := 1;
    i INT;
BEGIN
    -- Convert day codes to names if needed
    day_codes := string_to_array(NEW.schedule_days, ',');
    
    FOREACH day_code IN ARRAY day_codes LOOP
        day_code := trim(day_code);
        IF day_code ~ '^[0-9]+$' THEN
            SELECT name INTO day_name FROM mentor.days_ref WHERE code = day_code::INT;
            IF day_name IS NOT NULL THEN
                day_names := array_append(day_names, day_name);
            END IF;
        ELSE
            -- Already a day name
            day_names := array_append(day_names, day_code);
        END IF;
    END LOOP;
    
    IF array_length(day_names, 1) > 0 THEN
        NEW.schedule_days := array_to_string(day_names, ',');
    END IF;
    
    -- Process subjects
    subj_codes := string_to_array(NEW.subjects, ',');
    subject_names := ARRAY[]::TEXT[];
    subject_chapters := ARRAY[]::INT[];
    subject_current_ch := ARRAY[]::INT[];
    
    FOREACH subj_code IN ARRAY subj_codes LOOP
        subj_code := trim(subj_code);
        IF subj_code = '' THEN
            CONTINUE;
        END IF;
        
        IF subj_code ~ '^[0-9]+$' THEN
            SELECT name INTO subj_name FROM mentor.subjects_ref WHERE code = subj_code::INT;
        ELSE
            subj_name := subj_code;
        END IF;
        
        IF subj_name IS NOT NULL THEN
            subject_names := array_append(subject_names, subj_name);
            
            SELECT total_chapters INTO chapters
            FROM mentor.chapters
            WHERE class = NEW.class AND subject = subj_name;
            
            IF chapters IS NULL THEN
                chapters := 15; -- Default if not found
            END IF;
            
            subject_chapters := array_append(subject_chapters, chapters);
            subject_current_ch := array_append(subject_current_ch, 1);
            
            -- NEW FORMULA: 1 chapter = 1 class (no parts)
            total_classes_count := total_classes_count + chapters;
        END IF;
    END LOOP;
    
    IF array_length(subject_names, 1) > 0 THEN
        NEW.subjects := array_to_string(subject_names, ',');
    END IF;
    
    NEW.total_classes := total_classes_count;
    
    -- Generate schedule JSON (1 class per chapter, no parts)
    current_date_val := COALESCE(NEW.start_date, CURRENT_DATE);
    subject_index := 1;
    
    WHILE class_number <= total_classes_count AND class_number <= 500 LOOP
        i := ((subject_index - 1) % GREATEST(array_length(subject_names, 1), 1)) + 1;
        
        IF subject_current_ch[i] <= subject_chapters[i] THEN
            schedule_array := schedule_array || jsonb_build_object(
                'class_num', class_number,
                'date', current_date_val::TEXT,
                'subject', subject_names[i],
                'chapter', subject_current_ch[i],
                'part', 1,
                'done', false
            );
            
            -- Move to next chapter (no parts)
            subject_current_ch[i] := subject_current_ch[i] + 1;
            class_number := class_number + 1;
        END IF;
        
        subject_index := subject_index + 1;
        
        IF array_length(subject_names, 1) IS NOT NULL AND subject_index > array_length(subject_names, 1) THEN
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

-- Create trigger that fires on BOTH INSERT and UPDATE
CREATE TRIGGER trg_subscription_json
BEFORE INSERT OR UPDATE ON mentor.subscriptions
FOR EACH ROW
EXECUTE FUNCTION mentor.fn_generate_schedule_json();
