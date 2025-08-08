CREATE TABLE user_topic_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    topic VARCHAR(100) NOT NULL,
    topic_order INT NOT NULL,
    is_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    easy_completed INT NOT NULL DEFAULT 0,
    medium_completed INT NOT NULL DEFAULT 0,
    hard_completed INT NOT NULL DEFAULT 0,
    easy_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    medium_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    hard_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_topic (user_id, topic)
);

-- Create index for better performance
CREATE INDEX idx_user_topic_progress_user_id ON user_topic_progress(user_id);
CREATE INDEX idx_user_topic_progress_topic_order ON user_topic_progress(topic_order); 