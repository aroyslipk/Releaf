package com.example.demo.controller;

import com.example.demo.entity.Group;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.service.GroupService;
import com.example.demo.service.TaskService;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

// Use @RestController for API endpoints
@RestController
// A unique base path for report APIs
@RequestMapping("/api/reports")
public class ReportController {

    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private GroupService groupService;

    // A single, clean endpoint for all exports using a PathVariable
    @GetMapping("/export/{type}")
    @Transactional(readOnly = true)
    public ResponseEntity<Resource> exportReport(@PathVariable String type) throws IOException {
        switch (type) {
            case "users":
                return exportUserData();
            case "tasks":
                return exportTaskData();
            case "groups":
                return exportGroupData();
            case "summary":
                return exportSummaryReport();
            default:
                // Return a bad request error if the type is unknown
                return ResponseEntity.badRequest().build();
        }
    }

    private ResponseEntity<Resource> exportUserData() {
        List<User> users = userService.getAllUsers();
        StringBuilder csvData = new StringBuilder("ID,Name,Email,XP Points,Completed Tasks,Join Date\n");
        for (User user : users) {
            csvData.append(String.format("%d,%s,%s,%d,%d,%s\n",
                    user.getId(), user.getName(), user.getEmail(), user.getXpPoints(),
                    user.getCompletedTasks().size(), user.getCreatedAt().toLocalDate()));
        }
        return generateCsvResponse(csvData.toString(), "users_report.csv");
    }

    private ResponseEntity<Resource> exportTaskData() {
        List<Task> tasks = taskService.getAllTasks();
        StringBuilder csvData = new StringBuilder("ID,Topic,Level,Description\n");
        for (Task task : tasks) {
            String description = task.getDescription() != null ? task.getDescription().replace(",", ";") : "";
            csvData.append(String.format("%d,%s,%s,\"%s\"\n",
                    task.getId(), task.getTopic(), task.getLevel(), description));
        }
        return generateCsvResponse(csvData.toString(), "tasks_report.csv");
    }

    private ResponseEntity<Resource> exportGroupData() {
        List<Group> groups = groupService.getAllGroupsWithMembers();
        StringBuilder csvData = new StringBuilder("ID,Group Name,Description,Member Count\n");
        for (Group group : groups) {
            String description = group.getDescription() != null ? group.getDescription().replace(",", ";") : "";
            csvData.append(String.format("%d,%s,\"%s\",%d\n",
                    group.getId(), group.getGroupName(), description, group.getMembers().size()));
        }
        return generateCsvResponse(csvData.toString(), "groups_report.csv");
    }
    
    private ResponseEntity<Resource> exportSummaryReport() {
        StringBuilder csvData = new StringBuilder("Metric,Value\n");
        int totalUsers = userService.getAllUsers().size();
        int totalTasks = taskService.getAllTasks().size();
        csvData.append(String.format("Total Users,%d\n", totalUsers));
        csvData.append(String.format("Total Tasks,%d\n", totalTasks));
        // Add more summary metrics if needed
        return generateCsvResponse(csvData.toString(), "summary_report.csv");
    }

    // Helper method to generate the final downloadable file response
    private ResponseEntity<Resource> generateCsvResponse(String csvData, String filename) {
        try {
            ByteArrayResource resource = new ByteArrayResource(csvData.getBytes("UTF-8"));
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .contentType(MediaType.parseMediaType("text/csv;charset=UTF-8"))
                    .contentLength(resource.contentLength())
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}