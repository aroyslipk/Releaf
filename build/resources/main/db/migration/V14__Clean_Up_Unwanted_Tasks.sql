-- Clean up unwanted tasks
DELETE FROM tasks WHERE topic IN ('nothing', 'Eco-Puzzle Day', 'Green Frame of the Day', 'Voice for Earth (1-Min Audio)');

-- Also clean up any tasks with empty or null topics
DELETE FROM tasks WHERE topic IS NULL OR topic = ''; 