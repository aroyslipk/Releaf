-- Add FunLab task support columns to tasks table
ALTER TABLE tasks ADD COLUMN task_type VARCHAR(20) DEFAULT 'GREENVERSE';
ALTER TABLE tasks ADD COLUMN impact TEXT;
ALTER TABLE tasks ADD COLUMN proof_type VARCHAR(20);

-- Create index for better performance
CREATE INDEX idx_tasks_task_type ON tasks(task_type);
CREATE INDEX idx_tasks_type_topic ON tasks(task_type, topic);
CREATE INDEX idx_tasks_type_level ON tasks(task_type, level); 