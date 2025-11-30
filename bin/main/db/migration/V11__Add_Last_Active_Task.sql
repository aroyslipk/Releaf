-- Add last_active_task_id column to users table
ALTER TABLE users ADD COLUMN last_active_task_id BIGINT;

-- Add foreign key constraint to reference tasks table
ALTER TABLE users ADD CONSTRAINT fk_users_last_active_task 
    FOREIGN KEY (last_active_task_id) REFERENCES tasks(id) ON DELETE SET NULL; 