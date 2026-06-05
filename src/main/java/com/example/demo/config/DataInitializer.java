package com.example.demo.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@Order(1)
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        System.err.println("================================================");
        System.err.println("DataInitializer: Starting cleanup...");
        System.err.println("================================================");

        try {
            // 1. Count users before deletion
            Integer userCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Integer.class);
            Integer adminCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM admins", Integer.class);
            System.err.println("Found " + (userCount != null ? userCount : 0) + " user(s) and " + (adminCount != null ? adminCount : 0) + " admin(s)");

            // 2. Delete dependent records (in correct FK order)
            // AdminNotification depends on UserTask
            System.err.println("Deleting admin_notifications...");
            jdbcTemplate.update("DELETE FROM admin_notifications");
            
            // UserTask depends on users / tasks
            System.err.println("Deleting user_tasks...");
            jdbcTemplate.update("DELETE FROM user_tasks");
            
            // UserTopicProgress depends on users
            System.err.println("Deleting user_topic_progress...");
            jdbcTemplate.update("DELETE FROM user_topic_progress");

            // GroupMessage depends on users / groups
            System.err.println("Deleting group_messages...");
            jdbcTemplate.update("DELETE FROM group_messages");
            
            // User <-> Task (completed_tasks join table)
            System.err.println("Deleting user_completed_tasks...");
            jdbcTemplate.update("DELETE FROM user_completed_tasks");
            
            // User <-> Reward join table
            System.err.println("Deleting user_rewards...");
            jdbcTemplate.update("DELETE FROM user_rewards");
            
            // Clear user group associations
            System.err.println("Clearing user group associations...");
            jdbcTemplate.update("UPDATE users SET group_id = NULL");

            // 3. Delete all users
            System.err.println("Deleting all users...");
            int usersDeleted = jdbcTemplate.update("DELETE FROM users");
            System.err.println("Deleted " + usersDeleted + " user(s)");
            
            // 4. Delete all admins
            System.err.println("Deleting all admins...");
            int adminsDeleted = jdbcTemplate.update("DELETE FROM admins");
            System.err.println("Deleted " + adminsDeleted + " admin(s)");
            
            // 5. Create the new hardcoded admin
            String username = "R@lef4";
            String encodedPassword = passwordEncoder.encode("@rp!15>40S098Q");
            jdbcTemplate.update(
                "INSERT INTO admins (username, password, created_at, updated_at) VALUES (?, ?, NOW(), NOW())",
                username, encodedPassword
            );
            System.err.println("Created new admin: " + username);
            
            // 6. Verify
            Integer remainingUsers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Integer.class);
            Integer remainingAdmins = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM admins", Integer.class);
            System.err.println("After cleanup: " + (remainingUsers != null ? remainingUsers : 0) + " user(s), " + (remainingAdmins != null ? remainingAdmins : 0) + " admin(s)");
            
            System.err.println("================================================");
            System.err.println("DataInitializer: Cleanup COMPLETE!");
            System.err.println("================================================");
            
        } catch (Exception e) {
            System.err.println("DataInitializer ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}