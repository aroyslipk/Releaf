package com.example.demo.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
public class SequenceResetter {
    @Bean
    public CommandLineRunner resetSequence(JdbcTemplate jdbcTemplate) {
        return args -> {
            try {
                // Get the maximum ID from the tasks table
                Long maxId = jdbcTemplate.queryForObject(
                    "SELECT COALESCE(MAX(id), 0) FROM tasks", 
                    Long.class
                );
                
                // Set the sequence to start from the next available ID
                Long nextId = maxId + 1;
                String sql = "ALTER TABLE tasks ALTER COLUMN id RESTART WITH " + nextId;
                jdbcTemplate.execute(sql);
                
                System.out.println("Task ID sequence has been reset to start at " + nextId + 
                                   " (current max ID is " + maxId + ")");
            } catch (Exception e) {
                System.err.println("Error resetting task sequence: " + e.getMessage());
                // If table doesn't exist yet, start from 1
                jdbcTemplate.execute("ALTER TABLE tasks ALTER COLUMN id RESTART WITH 1");
                System.out.println("Task ID sequence initialized to start at 1");
            }
        };
    }
}
