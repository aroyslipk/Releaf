
package com.example.demo.controller;

import com.example.demo.entity.Admin;
import com.example.demo.entity.User;
import com.example.demo.entity.Task;
import com.example.demo.entity.Group;
import com.example.demo.entity.Notice;
import com.example.demo.entity.Message;
import com.example.demo.entity.UserTask;
import com.example.demo.service.AdminService;
import com.example.demo.service.UserService;
import com.example.demo.service.TaskService;
import com.example.demo.service.GroupService;
import com.example.demo.service.NoticeService;
import com.example.demo.service.MessageService;
import com.example.demo.service.UserTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import java.util.Map;
import java.util.HashMap;
import java.util.TreeMap;
import java.time.format.DateTimeFormatter;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.transaction.annotation.Transactional;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private GroupService groupService;


    @Autowired
    private NoticeService noticeService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private UserTaskService userTaskService;

    // Helper method for escaping CSV fields
    private String escapeCsvField(String field) {
        if (field == null) return "";
        return "\"" + field.replace("\"", "\"\"") + "\"";
    }

    private ResponseEntity<String> generateCsvResponse(String csvContent, String filename) {
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
            .header(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION)
            .header(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*")
            .contentType(MediaType.parseMediaType("text/csv;charset=UTF-8"))
            .body(csvContent);
    }

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String dashboard(HttpSession session, Model model) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return "redirect:/login?type=admin";
        }

        // Get all lists at once to avoid multiple database calls
        List<User> allUsers = userService.getAllUsers();
        List<Task> allTasks = taskService.getAllTasks();
        List<Group> allGroups = groupService.getAllGroups();
        List<Notice> activeNotices = noticeService.getActiveNotices();

        // Add statistics to model
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("totalTasks", allTasks.size());
        model.addAttribute("totalGroups", allGroups.size());
        model.addAttribute("totalNotices", activeNotices.size());

        // Add top performers for the dashboard
        model.addAttribute("topUsers", allUsers.stream()
            .sorted((a, b) -> b.getXpPoints().compareTo(a.getXpPoints()))
            .limit(5)
            .toList());

        // Add recently added tasks
        model.addAttribute("recentTasks", allTasks.stream()
            .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
            .limit(5)
            .toList());

        // Add active notices
        model.addAttribute("recentNotices", activeNotices.stream()
            .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
            .limit(3)
            .toList());

        return "admin/dashboard";
    }

    // ############ START: CHANGED METHOD ############
    @GetMapping("/tasks")
    public String tasks(Model model) {
        return "admin/tasks-landing";
    }

    @GetMapping("/funlab")
    public String funlabTasks(@RequestParam(value = "topic", required = false) String topic,
                             @RequestParam(value = "level", required = false) String level,
                             Model model) {
        
        // Get FunLab tasks with filtering
        List<Task> tasks;
        if (topic != null && !topic.isEmpty() && level != null && !level.isEmpty()) {
            tasks = taskService.getTasksByTypeAndTopic("FUNLAB", topic);
            tasks = tasks.stream().filter(t -> t.getLevel().equals(level)).toList();
        } else if (topic != null && !topic.isEmpty()) {
            tasks = taskService.getTasksByTypeAndTopic("FUNLAB", topic);
        } else if (level != null && !level.isEmpty()) {
            tasks = taskService.getTasksByTypeAndLevel("FUNLAB", level);
        } else {
            tasks = taskService.getFunLabTasks();
        }
        
        // Add tasks and dropdown data to the model
        model.addAttribute("tasks", tasks);
        model.addAttribute("topics", taskService.getTopicsByTaskType("FUNLAB"));
        model.addAttribute("levels", taskService.getLevelsByTaskType("FUNLAB"));

        // Add selected values back to the model to keep filters selected on the page
        model.addAttribute("selectedTopic", topic);
        model.addAttribute("selectedLevel", level);
        
        return "admin/funlab";
    }

    @GetMapping("/funlab/tasks/new")
    public String newFunLabTask() {
        return "admin/funlab-task-form";
    }

    @PostMapping("/funlab/tasks/create")
    public String createFunLabTask(@RequestParam String topic,
                                  @RequestParam String level,
                                  @RequestParam String description,
                                  @RequestParam String impact,
                                  @RequestParam String proofType,
                                  @RequestParam(defaultValue = "20") Integer xpReward,
                                  RedirectAttributes redirectAttributes) {
        try {
            Task task = taskService.createFunLabTask(topic, level, description, impact, proofType);
            task.setXpReward(xpReward);
            taskService.updateTask(task);
            redirectAttributes.addFlashAttribute("success", "FunLab task created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating FunLab task: " + e.getMessage());
        }
        return "redirect:/admin/funlab";
    }

    @GetMapping("/funlab/tasks/edit/{id}")
    public String editFunLabTask(@PathVariable Long id, Model model) {
        Optional<Task> taskOpt = taskService.findById(id);
        if (taskOpt.isPresent() && "FUNLAB".equals(taskOpt.get().getTaskType())) {
            model.addAttribute("task", taskOpt.get());
            return "admin/funlab-task-form";
        }
        return "redirect:/admin/funlab";
    }

    @PostMapping("/funlab/tasks/update/{id}")
    public String updateFunLabTask(@PathVariable Long id,
                                  @RequestParam String topic,
                                  @RequestParam String level,
                                  @RequestParam String description,
                                  @RequestParam String impact,
                                  @RequestParam String proofType,
                                  @RequestParam(defaultValue = "20") Integer xpReward,
                                  RedirectAttributes redirectAttributes) {
        Optional<Task> taskOpt = taskService.findById(id);
        if (taskOpt.isPresent() && "FUNLAB".equals(taskOpt.get().getTaskType())) {
            Task task = taskOpt.get();
            task.setTopic(topic);
            task.setLevel(level);
            task.setDescription(description);
            task.setImpact(impact);
            task.setProofType(proofType);
            task.setXpReward(xpReward);
            taskService.updateTask(task);
            redirectAttributes.addFlashAttribute("success", "FunLab task updated successfully!");
        }
        return "redirect:/admin/funlab";
    }

    @PostMapping("/funlab/tasks/delete/{id}")
    public String deleteFunLabTask(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Optional<Task> taskOpt = taskService.findById(id);
        if (taskOpt.isPresent() && "FUNLAB".equals(taskOpt.get().getTaskType())) {
            taskService.deleteTask(id);
            redirectAttributes.addFlashAttribute("success", "FunLab task deleted successfully!");
        }
        return "redirect:/admin/funlab";
    }

    @GetMapping("/greenverse/tasks")
    public String greenverseTasks(@RequestParam(value = "topic", required = false) String topic,
                        @RequestParam(value = "level", required = false) String level,
                        Model model) {
        
        // Call the new service method that handles filtering
        List<Task> tasks = taskService.findTasksByCriteria(topic, level);
        
        // Use the new method to get topics excluding unwanted ones
        List<String> topics = taskService.getTopicsExcludingUnwanted();
        
        // Add tasks and dropdown data to the model
        model.addAttribute("tasks", tasks);
        model.addAttribute("topics", topics);
        model.addAttribute("levels", taskService.getAllLevels());

        // Add selected values back to the model to keep filters selected on the page
        model.addAttribute("selectedTopic", topic);
        model.addAttribute("selectedLevel", level);
        
        return "admin/tasks";
    }
    // ############ END: CHANGED METHOD ############

    @GetMapping("/greenverse/tasks/new")
    public String newTask() {
        return "admin/task-form";
    }

    @PostMapping("/greenverse/tasks/create")
    public String createTask(@RequestParam String topic,
                             @RequestParam String level,
                             @RequestParam String description,
                             RedirectAttributes redirectAttributes) {
        try {
            taskService.createTask(topic, level, description);
            redirectAttributes.addFlashAttribute("success", "Task created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating task: " + e.getMessage());
        }
        return "redirect:/admin/greenverse/tasks";
    }

    @GetMapping("/greenverse/tasks/edit/{id}")
    public String editTask(@PathVariable Long id, Model model) {
        Optional<Task> taskOpt = taskService.findById(id);
        if (taskOpt.isPresent()) {
            model.addAttribute("task", taskOpt.get());
            return "admin/task-form";
        }
        return "redirect:/admin/greenverse/tasks";
    }

    @PostMapping("/greenverse/tasks/update/{id}")
    public String updateTask(@PathVariable Long id,
                             @RequestParam String topic,
                             @RequestParam String level,
                             @RequestParam String description,
                             RedirectAttributes redirectAttributes) {
        Optional<Task> taskOpt = taskService.findById(id);
        if (taskOpt.isPresent()) {
            Task task = taskOpt.get();
            task.setTopic(topic);
            task.setLevel(level);
            task.setDescription(description);
            taskService.updateTask(task);
            redirectAttributes.addFlashAttribute("success", "Task updated successfully!");
        }
        return "redirect:/admin/greenverse/tasks";
    }

    @PostMapping("/greenverse/tasks/delete/{id}")
    public String deleteTask(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<Task> task = taskService.findById(id);
            if (!task.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Task not found with ID: " + id);
                return "redirect:/admin/greenverse/tasks";
            }
            taskService.deleteTask(id);
            redirectAttributes.addFlashAttribute("success", "Task deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting task: " + e.getMessage());
        }
        return "redirect:/admin/greenverse/tasks";
    }

    // ... The rest of your controller methods remain unchanged ...
    // (users, groups, notices, messages, reports, profile, etc.)

    @GetMapping("/users")
    @Transactional(readOnly = true)
    public String users(@RequestParam(required = false) String searchName, Model model) {
        List<User> users;
        if (searchName != null && !searchName.trim().isEmpty()) {
            // Using trim() to remove any whitespace
            users = userService.findUsersByNameContaining(searchName.trim());
        } else {
            users = userService.getAllUsers();
        }
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("/groups")
    @Transactional(readOnly = true)
    public String groups(Model model) {
        List<Group> groups = groupService.getAllGroupsWithMembers();
        model.addAttribute("groups", groups);
        return "admin/groups";
    }

    @GetMapping("/groups/new")
    public String newGroup() {
        return "admin/group-form";
    }

    @GetMapping("/groups/edit/{id}")
    public String editGroup(@PathVariable Long id, Model model) {
        Optional<Group> groupOpt = groupService.findById(id);
        if (groupOpt.isPresent()) {
            model.addAttribute("group", groupOpt.get());
            model.addAttribute("isEdit", true);
            return "admin/group-form";
        }
        return "redirect:/admin/groups";
    }

    @PostMapping("/groups/update/{id}")
    public String updateGroup(@PathVariable Long id,
                            @RequestParam String groupName,
                            @RequestParam String description,
                            RedirectAttributes redirectAttributes) {
        try {
            Optional<Group> groupOpt = groupService.findById(id);
            if (groupOpt.isPresent()) {
                Group group = groupOpt.get();
                group.setGroupName(groupName);
                group.setDescription(description);
                groupService.updateGroup(group);
                redirectAttributes.addFlashAttribute("success", "Group updated successfully!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating group: " + e.getMessage());
        }
        return "redirect:/admin/groups";
    }

    @PostMapping("/groups/create")
    public String createGroup(@RequestParam String groupName,
                                @RequestParam String description,
                                RedirectAttributes redirectAttributes) {
        try {
            groupService.createGroup(groupName, description);
            redirectAttributes.addFlashAttribute("success", "Group created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating group: " + e.getMessage());
        }
        return "redirect:/admin/groups";
    }

    @PostMapping("/groups/delete/{id}")
    public String deleteGroup(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            groupService.deleteGroup(id);
            redirectAttributes.addFlashAttribute("success", "Group deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting group: " + e.getMessage());
        }
        return "redirect:/admin/groups";
    }

    @GetMapping("/notices")
    public String notices(Model model) {
        List<Notice> notices = noticeService.getAllNotices();
        model.addAttribute("notices", notices);
        return "admin/notices";
    }

    @GetMapping("/notices/new")
    public String newNotice() {
        return "admin/notice-form";
    }

    @GetMapping("/notices/edit/{id}")
    public String editNotice(@PathVariable Long id, Model model) {
        Optional<Notice> noticeOpt = noticeService.findById(id);
        if (noticeOpt.isPresent()) {
            model.addAttribute("notice", noticeOpt.get());
            model.addAttribute("isEdit", true);
            return "admin/notice-form";
        }
        return "redirect:/admin/notices";
    }

    @PostMapping("/notices/update/{id}")
    public String updateNotice(@PathVariable Long id,
                         @RequestParam String title,
                         @RequestParam String content,
                         RedirectAttributes redirectAttributes) {
        try {
            Optional<Notice> noticeOpt = noticeService.findById(id);
            if (noticeOpt.isPresent()) {
                Notice notice = noticeOpt.get();
                notice.setTitle(title);
                notice.setContent(content);
                noticeService.updateNotice(notice);
                redirectAttributes.addFlashAttribute("success", "Notice updated successfully!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating notice: " + e.getMessage());
        }
        return "redirect:/admin/notices";
    }

    @PostMapping("/notices/delete/{id}")
    public String deleteNotice(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            noticeService.deleteNotice(id);
            redirectAttributes.addFlashAttribute("success", "Notice deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting notice: " + e.getMessage());
        }
        return "redirect:/admin/notices";
    }

    @PostMapping("/notices/create")
    public String createNotice(@RequestParam String title,
                                 @RequestParam String content,
                                 RedirectAttributes redirectAttributes) {
        try {
            noticeService.createNotice(title, content);
            redirectAttributes.addFlashAttribute("success", "Notice created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating notice: " + e.getMessage());
        }
        return "redirect:/admin/notices";
    }

    @PostMapping("/notices/toggle/{id}")
    public String toggleNotice(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        noticeService.toggleNoticeStatus(id);
        redirectAttributes.addFlashAttribute("success", "Notice status updated!");
        return "redirect:/admin/notices";
    }

    @GetMapping("/messages")
    public String messages(HttpSession session, Model model) {
        String adminUsername = (String) session.getAttribute("adminUsername");
        List<Message> receivedMessages = messageService.getReceivedMessages(adminUsername);
        List<Message> sentMessages = messageService.getSentMessages(adminUsername);
        
        model.addAttribute("receivedMessages", receivedMessages);
        model.addAttribute("sentMessages", sentMessages);
        return "admin/messages";
    }

    @GetMapping("/messages/new")
    public String newMessage(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin/message-form";
    }

    @PostMapping("/messages/send")
    public String sendMessage(@RequestParam String toUser,
                                @RequestParam String subject,
                                @RequestParam String body,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        String adminUsername = (String) session.getAttribute("adminUsername");
        if (adminUsername == null) {
            redirectAttributes.addFlashAttribute("error", "Admin session has expired. Please login again.");
            return "redirect:/login?type=admin";
        }

        try {
            Message message = new Message();
            message.setFromUser(adminUsername);
            message.setToUser(toUser);
            message.setSubject(subject);
            message.setBody(body);
            messageService.sendMessage(adminUsername, toUser, subject, body);
            redirectAttributes.addFlashAttribute("success", "Message sent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error sending message: " + e.getMessage());
        }
        return "redirect:/admin/messages";
    }

    @GetMapping("/reports")
    @Transactional(readOnly = true)
    public String reports(@RequestParam(required = false) String searchUser, Model model) {
        // Fetch all required data in parallel using streams to optimize database queries
        List<Task> allTasks = taskService.getAllTasks();
        List<Group> allGroups = groupService.getAllGroups();
        List<User> allUsers;
        
        if (searchUser != null && !searchUser.trim().isEmpty()) {
            allUsers = userService.findUsersByNameContaining(searchUser.trim());
        } else {
            allUsers = userService.getLeaderboard(); // Already ordered by XP
        }

        // Basic stats
        int totalUsers = allUsers.size();
        int activeUsers = (int) allUsers.stream()
            .filter(u -> !u.getCompletedTasks().isEmpty())
            .count();
        int totalTasks = allTasks.size();
        int completedTasks = (int) allTasks.stream()
            .filter(t -> !t.getCompletedByUsers().isEmpty())
            .count();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("activeUsers", activeUsers);
        model.addAttribute("totalTasks", totalTasks);
        model.addAttribute("completedTasks", completedTasks);

        // Calculate statistics from the fetched data
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM yyyy");
        Map<String, Long> monthlyRegistrations = new HashMap<>();
        Map<String, Long> monthlyActivities = new HashMap<>();

        // Process users data in a single stream
        List<User> topUsers = allUsers.stream()
            .limit(10)
            .toList();

        long totalCompletedTasks = allUsers.stream()
            .flatMap(user -> {
                // Process monthly registrations
                monthlyRegistrations.merge(
                    user.getCreatedAt().format(formatter),
                    1L,
                    Long::sum
                );
                
                // Process completed tasks
                return user.getCompletedTasks().stream();
            })
            .peek(task -> {
                if (task.getCreatedAt() != null) {
                    monthlyActivities.merge(
                        task.getCreatedAt().format(formatter),
                        1L,
                        Long::sum
                    );
                }
            })
            .count();

        // Sort months chronologically
        TreeMap<String, Long> sortedRegistrations = new TreeMap<>(monthlyRegistrations);
        TreeMap<String, Long> sortedActivities = new TreeMap<>(monthlyActivities);

        // Add all attributes to model
        model.addAttribute("topUsers", topUsers);
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("totalTasks", allTasks.size());
        model.addAttribute("totalGroups", allGroups.size());
        model.addAttribute("monthlyRegistrations", sortedRegistrations);
        model.addAttribute("monthlyActivities", sortedActivities);
        model.addAttribute("totalCompletedTasks", totalCompletedTasks);
        model.addAttribute("totalInProgressTasks", allTasks.size() - totalCompletedTasks);

        return "admin/reports";
    }

    @GetMapping("/export/users")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<?> exportUsers(HttpSession session) {
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                return ResponseEntity.status(401)
                    .body("Please log in again to export data.");
            }

            StringBuilder csv = new StringBuilder();
            csv.append("Name,Email,XP Points,Completed Tasks,Join Date\n");
            
            List<User> users = userService.getAllUsers();
            for (User user : users) {
                try {
                    csv.append(String.format("%s,%s,%d,%d\n",
                        escapeCsvField(user.getName()),
                        escapeCsvField(user.getEmail()),
                        user.getXpPoints(),
                        user.getCompletedTasks() != null ? user.getCompletedTasks().size() : 0
                    ));
                } catch (Exception e) {
                    e.printStackTrace();
                    // Skip problematic user but continue with others
                    continue;
                }
            }
            
            String csvContent = csv.toString();
            
            // First try to return as CSV
            try {
                return generateCsvResponse(csvContent, "users.csv");
            } catch (Exception e) {
                // If CSV fails, return as plain text
                return ResponseEntity.ok()
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(csvContent);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                .contentType(MediaType.TEXT_PLAIN)
                .body("Failed to export data. Error: " + e.getMessage());
        }
    }

    @GetMapping("/export/tasks")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<?> exportTasks(HttpSession session) {
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                return ResponseEntity.status(401).build();
            }

            StringBuilder csv = new StringBuilder();
            csv.append("Topic,Level,Description,Completion Count\n");
            
            List<Task> tasks = taskService.getAllTasks();
            for (Task task : tasks) {
                try {
                    long completionCount = userService.getAllUsers().stream()
                        .filter(user -> user.getCompletedTasks() != null && user.getCompletedTasks().contains(task))
                        .count();

                    csv.append(String.format("%s,%s,%s,%d\n",
                        escapeCsvField(task.getTopic()),
                        escapeCsvField(task.getLevel()),
                        escapeCsvField(task.getDescription()),
                        completionCount
                    ));
                } catch (Exception e) {
                    e.printStackTrace();
                    // Skip problematic task but continue with others
                    continue;
                }
            }
            
            return generateCsvResponse(csv.toString(), "tasks.csv");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                .contentType(MediaType.TEXT_PLAIN)
                .body("Failed to export data. Please try again.");
        }
    }

    @GetMapping("/export/groups")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<?> exportGroups(HttpSession session) {
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                return ResponseEntity.status(401).build();
            }

            StringBuilder csv = new StringBuilder();
            csv.append("Group Name,Description,Member Count,Total Group XP\n");
            
            List<Group> groups = groupService.getAllGroups();
            for (Group group : groups) {
                try {
                    int totalXp = group.getMembers().stream()
                        .mapToInt(User::getXpPoints)
                        .sum();
                        
                    csv.append(String.format("%s,%s,%d,%d\n",
                        escapeCsvField(group.getGroupName()),
                        escapeCsvField(group.getDescription()),
                        group.getMembers() != null ? group.getMembers().size() : 0,
                        totalXp
                    ));
                } catch (Exception e) {
                    e.printStackTrace();
                    // Skip problematic group but continue with others
                    continue;
                }
            }
            
            return generateCsvResponse(csv.toString(), "groups.csv");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                .contentType(MediaType.TEXT_PLAIN)
                .body("Failed to export data. Please try again.");
        }
    }

    @GetMapping("/export/summary")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<?> exportSummary(HttpSession session) {
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                return ResponseEntity.status(401).build();
            }

            StringBuilder csv = new StringBuilder();
            csv.append("Metric,Value\n");
            
            List<User> users = userService.getAllUsers();
            int totalUsers = users.size();
            int totalTasks = taskService.getAllTasks().size();
            int totalGroups = groupService.getAllGroups().size();
            
            int totalXp = 0;
            int completedTasks = 0;
            
            for (User user : users) {
                try {
                    totalXp += user.getXpPoints();
                    completedTasks += user.getCompletedTasks() != null ? user.getCompletedTasks().size() : 0;
                } catch (Exception e) {
                    e.printStackTrace();
                    // Skip problematic user but continue counting others
                    continue;
                }
            }
            
            csv.append(String.format("Total Users,%d\n", totalUsers));
            csv.append(String.format("Total Tasks,%d\n", totalTasks));
            csv.append(String.format("Total Groups,%d\n", totalGroups));
            csv.append(String.format("Total XP Earned,%d\n", totalXp));
            csv.append(String.format("Total Completed Tasks,%d\n", completedTasks));
            if (totalUsers > 0) {
                csv.append(String.format("Average XP per User,%.2f\n", (double)totalXp/totalUsers));
            }
            
            return generateCsvResponse(csv.toString(), "summary.csv");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                .contentType(MediaType.TEXT_PLAIN)
                .body("Failed to export data. Please try again.");
        }
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return "redirect:/login?type=admin";
        }

        Optional<Admin> adminOpt = adminService.findById(adminId);
        if (adminOpt.isPresent()) {
            model.addAttribute("admin", adminOpt.get());
        }

        return "admin/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String newPassword,
                                   @RequestParam String confirmPassword,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return "redirect:/login?type=admin";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            return "redirect:/admin/profile";
        }

        try {
            adminService.changePassword(adminId, newPassword);
            redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error changing password: " + e.getMessage());
        }

        return "redirect:/admin/profile";
    }

    @GetMapping("/task-reviews")
    public String taskReviews(HttpSession session, Model model) {
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                return "redirect:/login?type=admin";
            }

            System.out.println("Fetching pending review tasks...");
            List<UserTask> pendingTasks = userTaskService.getPendingReviewTasks();
            System.out.println("Found " + pendingTasks.size() + " pending tasks");
            
            model.addAttribute("pendingTasks", pendingTasks);
            model.addAttribute("pendingCount", pendingTasks.size());

            return "admin/task-reviews";
        } catch (Exception e) {
            System.err.println("Error in taskReviews: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "An error occurred while loading task reviews: " + e.getMessage());
            return "admin/task-reviews";
        }
    }

    @PostMapping("/task-reviews/approve/{userTaskId}")
    public String approveTask(@PathVariable Long userTaskId,
                             @RequestParam(required = false) String notes,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return "redirect:/login?type=admin";
        }

        try {
            userTaskService.approveTask(userTaskId, adminId, notes);
            redirectAttributes.addFlashAttribute("success", "Task approved successfully! User has been awarded XP.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", "Error approving task: " + e.getMessage());
        }

        return "redirect:/admin/task-reviews";
    }

    @PostMapping("/task-reviews/reject/{userTaskId}")
    public String rejectTask(@PathVariable Long userTaskId,
                            @RequestParam(required = false) String notes,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return "redirect:/login?type=admin";
        }

        try {
            userTaskService.rejectTask(userTaskId, adminId, notes);
            redirectAttributes.addFlashAttribute("success", "Task rejected. User can resubmit with new proof.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", "Error rejecting task: " + e.getMessage());
        }

        return "redirect:/admin/task-reviews";
    }
}