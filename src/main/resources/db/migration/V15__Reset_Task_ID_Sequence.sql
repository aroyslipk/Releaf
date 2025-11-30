-- Reset task ID sequence to start after all existing tasks (72 greenverse + 10 funlab = 82 total, so next ID should be 83)
ALTER TABLE tasks AUTO_INCREMENT = 83;
