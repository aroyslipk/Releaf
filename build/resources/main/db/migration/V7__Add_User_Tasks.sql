CREATE TABLE IF NOT EXISTS user_tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    task_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING_REVIEW',
    proof_image VARCHAR(255),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewer_notes TEXT,
    reviewed_by BIGINT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES admins(id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_task (user_id, task_id)
);

-- Create index for better performance
CREATE INDEX idx_user_tasks_status ON user_tasks(status);
CREATE INDEX idx_user_tasks_user_id ON user_tasks(user_id);
CREATE INDEX idx_user_tasks_submitted_at ON user_tasks(submitted_at); 