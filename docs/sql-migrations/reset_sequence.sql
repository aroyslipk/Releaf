-- This script resets the task ID sequence to the next available ID
-- Run this manually if you need to fix sequence issues

-- First, find the current maximum ID
SELECT COALESCE(MAX(id), 0) AS current_max_id FROM tasks;

-- Then manually run this with the correct next ID (max_id + 1)
-- Replace XXX with (current_max_id + 1) from the query above
ALTER TABLE tasks ALTER COLUMN id RESTART WITH 1;

-- Example: If max ID is 78, use:
-- ALTER TABLE tasks ALTER COLUMN id RESTART WITH 79;
