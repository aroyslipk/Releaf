-- Fix Group Membership Constraints
-- This migration ensures proper handling of group membership relationships

-- Add index for better performance on group membership queries
CREATE INDEX IF NOT EXISTS idx_users_group_id ON users(group_id);

-- Add index for user-group relationship queries
CREATE INDEX IF NOT EXISTS idx_users_group_membership ON users(id, group_id);

-- Ensure the group_id column allows NULL values (users can be without a group)
-- This is already handled by the @ManyToOne annotation, but let's make it explicit
ALTER TABLE users MODIFY COLUMN group_id BIGINT NULL;

-- Add a check constraint to ensure group_id is either NULL or references a valid group
-- Note: MySQL doesn't support CHECK constraints in the same way, so we'll rely on foreign key constraints

-- Verify foreign key constraint exists and is properly configured
-- The foreign key should already exist from the JPA mapping, but let's ensure it's correct
-- This is handled automatically by Hibernate/JPA 