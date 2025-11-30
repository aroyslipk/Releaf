-- Add columns to store last submitted topic and difficulty
-- Run this in H2 console if columns don't auto-create

ALTER TABLE users ADD COLUMN IF NOT EXISTS last_submitted_topic VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_submitted_difficulty VARCHAR(50);

-- Verify columns were added
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'USERS' 
AND COLUMN_NAME IN ('LAST_SUBMITTED_TOPIC', 'LAST_SUBMITTED_DIFFICULTY');
