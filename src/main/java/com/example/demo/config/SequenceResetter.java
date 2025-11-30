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
            jdbcTemplate.execute("ALTER TABLE tasks ALTER COLUMN id RESTART WITH 73");
            System.out.println("Task ID sequence has been reset to start at 73");
        };
    }
}
