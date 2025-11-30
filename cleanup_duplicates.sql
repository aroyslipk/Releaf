-- Clean up duplicate user_tasks entries for H2 Database
-- Keep only the most recent submission for each user-task combination

-- First, identify duplicates (run this to see what will be cleaned)
SELECT user_id, task_id, COUNT(*) as count
FROM user_tasks
GROUP BY user_id, task_id
HAVING COUNT(*) > 1;

-- Create a temporary table with IDs to keep (most recent for each user-task)
CREATE TEMPORARY TABLE IF NOT EXISTS tasks_to_keep AS
SELECT MAX(id) as id
FROM user_tasks
GROUP BY user_id, task_id;

-- Delete duplicates (keep only the IDs in tasks_to_keep)
DELETE FROM user_tasks
WHERE id NOT IN (SELECT id FROM tasks_to_keep);

-- Drop temporary table
DROP TABLE IF EXISTS tasks_to_keep;

-- Verify no duplicates remain
SELECT user_id, task_id, COUNT(*) as count
FROM user_tasks
GROUP BY user_id, task_id
HAVING COUNT(*) > 1;
