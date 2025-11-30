-- Fix Message Recipients
-- This migration updates any existing messages where toUser contains email addresses
-- instead of user names to ensure consistency with the updated admin message form

-- Update messages where toUser contains an @ symbol (indicating it's an email)
-- to use the corresponding user's name instead
UPDATE messages m 
JOIN users u ON m.toUser = u.email 
SET m.toUser = u.name 
WHERE m.toUser LIKE '%@%';

-- Update messages where fromUser contains an @ symbol (indicating it's an email)
-- to use the corresponding admin's username instead
UPDATE messages m 
JOIN admins a ON m.fromUser = a.email 
SET m.fromUser = a.username 
WHERE m.fromUser LIKE '%@%'; 