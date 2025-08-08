package com.example.demo;

import com.example.demo.entity.User;
import com.example.demo.entity.Task;
import com.example.demo.service.UserService;
import com.example.demo.service.TaskService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class UserLastActiveTaskTest {

    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    @Test
    public void testLastActiveTaskTracking() {
        // Create a test user
        User user = userService.createUser("Test User", "test@example.com", "password123");
        assertNotNull(user);
        assertNull(user.getLastActiveTaskId()); // Initially should be null

        // Create a test task
        Task task = taskService.createTask("Test Topic", "Easy", "Test task description");
        assertNotNull(task);

        // Set the last active task
        user.setLastActiveTaskId(task.getId());
        userService.updateUser(user);

        // Retrieve the user and verify the last active task is set
        User retrievedUser = userService.findById(user.getId()).orElse(null);
        assertNotNull(retrievedUser);
        assertEquals(task.getId(), retrievedUser.getLastActiveTaskId());
    }
} 