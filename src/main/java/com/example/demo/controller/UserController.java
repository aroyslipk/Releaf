package com.example.demo.controller;

import com.example.demo.entity.*;
import com.example.demo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import com.example.demo.entity.UserTask;
import com.example.demo.entity.UserTopicProgress;
import com.example.demo.dto.GroupDTO;
import com.example.demo.repository.UserTaskRepository;

@Controller
@RequestMapping("/user")
@Transactional
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private GroupMessageService groupMessageService;

    @Autowired
    private UserTaskService userTaskService;

    @Autowired
    private UserTopicProgressService userTopicProgressService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private UserTaskRepository userTaskRepository;

    private void addUserToModel(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            Optional<User> userOpt = userService.findById(userId);
            userOpt.ifPresent(user -> {
                model.addAttribute("user", user);
                model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            });
        }
    }

    // Group Chat Endpoints
    @PostMapping("/groups/send-message")
    @ResponseBody
    public ResponseEntity<?> sendGroupMessage(HttpSession session, @RequestParam String message) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Not logged in"));
        }

        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isEmpty() || userOpt.get().getGroup() == null) {
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Not in a group"));
        }

        User user = userOpt.get();
        Group group = user.getGroup();

        GroupMessage chatMessage = groupMessageService.sendMessage(group, user, message);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", chatMessage.getId());
        response.put("username", user.getName());
        response.put("message", chatMessage.getMessageText());
        response.put("timestamp", chatMessage.getCreatedAt().toString());
        
        return ResponseEntity.ok(response);
    }


    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");

            // 🔐 Not logged in? Redirect to login
            if (userId == null) {
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            model.addAttribute("user", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            model.addAttribute("userName", user.getName()); // Add this for session scope
            session.setAttribute("userName", user.getName()); // Set in session

            List<Notice> notices = noticeService.getActiveNotices();
            if (notices != null) {
                model.addAttribute("notices", notices.size() > 3 ? notices.subList(0, 3) : notices);
            } else {
                model.addAttribute("notices", java.util.Collections.emptyList());
            }

            // Add default values for properties that might be null
            if (user.getXpPoints() == null) {
                user.setXpPoints(0);
            }
            if (user.getUnlockedRewards() == null) {
                user.setUnlockedRewards(new java.util.HashSet<>());
            }

            return "user/dashboard";
        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/tasks")
    public String tasks(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        addUserToModel(session, model);
        return "user/tasks-landing";
    }

    @GetMapping("/funlab")
    public String funlab(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // Get all FunLab tasks (all unlocked from start)
        List<Task> funlabTasks = taskService.getFunLabTasks();
        
        // Get user task statuses for each task
        List<UserTask> userTasks = userTaskService.getUserTasks(userId);
        
        addUserToModel(session, model);
        model.addAttribute("funlabTasks", funlabTasks);
        model.addAttribute("userTasks", userTasks);

        return "user/funlab";
    }

    @PostMapping("/funlab/complete-task")
    public String completeFunLabTask(@RequestParam Long taskId,
                                   @RequestParam(value = "proofFile", required = false) MultipartFile proofFile,
                                   @RequestParam(value = "proofText", required = false) String proofText,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            Optional<Task> taskOpt = taskService.findById(taskId);
            if (!taskOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Task not found.");
                return "redirect:/user/funlab";
            }

            Task task = taskOpt.get();
            if (!"FUNLAB".equals(task.getTaskType())) {
                redirectAttributes.addFlashAttribute("error", "Invalid task type.");
                return "redirect:/user/funlab";
            }

            // Determine XP reward based on proof type
            int xpReward = 10; // Default for no file
            String proofImage = null;

            if (proofFile != null && !proofFile.isEmpty()) {
                xpReward = 20; // Bonus XP for file upload
                
                // Save the proof file
                String originalFilename = proofFile.getOriginalFilename();
                String fileExtension = originalFilename != null && originalFilename.contains(".") 
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".jpg";
                String filename = userId + "_" + taskId + "_" + UUID.randomUUID().toString() + fileExtension;
                
                Path uploadPath = Paths.get("src/main/resources/static/uploads/proofs");
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                
                Path filePath = uploadPath.resolve(filename);
                Files.copy(proofFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                proofImage = filename;
            }

            // Create user task submission
            UserTask userTask = new UserTask(userService.findById(userId).orElseThrow(), task);
            userTask.setProofImage(proofImage);
            userTask.setStatus(UserTask.TaskStatus.PENDING_REVIEW);
            
            // Save the user task
            userTaskRepository.save(userTask);

            // Award XP to user
            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setXpPoints(user.getXpPoints() + xpReward);
                userService.updateUser(user);
            }

            redirectAttributes.addFlashAttribute("success", 
                "Task submitted successfully! You earned " + xpReward + " XP. Your submission is pending review.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error submitting task: " + e.getMessage());
        }

        return "redirect:/user/funlab";
    }

    @GetMapping("/greenverse")
    public String greenverse(@RequestParam(required = false) String view, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // If no specific view is requested or landing is requested, show the landing page
        if (view == null || view.equals("landing")) {
            addUserToModel(session, model);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            return "user/greenverse-landing";
        }

        // Initialize user progress if not already done
        try {
            userTopicProgressService.initializeUserProgress(userId);
        } catch (Exception e) {
            // Log error but continue
            e.printStackTrace();
        }

        // Get topic progress data
        Map<String, Object> progressData = userTopicProgressService.getTopicProgressData(userId);
        @SuppressWarnings("unchecked")
        List<UserTopicProgress> progressList = (List<UserTopicProgress>) progressData.get("progressList");
        UserTopicProgress currentTopic = (UserTopicProgress) progressData.get("currentTopic");
        UserTopicProgress nextTopic = (UserTopicProgress) progressData.get("nextTopic");
        @SuppressWarnings("unchecked")
        Map<String, Map<String, Integer>> taskCounts = (Map<String, Map<String, Integer>>) progressData.get("taskCounts");

        // Get available tasks for the user
        List<Task> availableTasks = userTopicProgressService.getAvailableTasksForUser(userId);

        addUserToModel(session, model);
        model.addAttribute("progressList", progressList);
        model.addAttribute("currentTopic", currentTopic);
        model.addAttribute("nextTopic", nextTopic);
        model.addAttribute("availableTasks", availableTasks);
        model.addAttribute("taskCounts", taskCounts);
        
        // Add user task statuses for each task
        if (userId != null) {
            List<UserTask> userTasks = userTaskService.getUserTasks(userId);
            model.addAttribute("userTasks", userTasks);
            
            // Get user's last active task ID for "Current" label display
            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                model.addAttribute("lastActiveTaskId", user.getLastActiveTaskId());
            }
        }

        return "user/tasks";
    }

    @GetMapping("/achievements")
    public String achievements(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        addUserToModel(session, model);

        // Calculate progress
        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            int totalTasks = taskService.getAllTasks().size();
            int completedTasks = user.getCompletedTasks().size();
            double progressPercentage = totalTasks > 0 ? (double) completedTasks / totalTasks * 100 : 0;
            model.addAttribute("progressPercentage", Math.round(progressPercentage));
        }

        return "user/achievements";
    }

@GetMapping("/profile")
    public String userProfile(Model model, HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                // User is not logged in, redirect them
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                model.addAttribute("error", "User not found");
                return "redirect:/login";
            }

            User user = userOpt.get();
            model.addAttribute("user", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            
            return "user/profile";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            return "error";
        }
    }

    @PostMapping("/profile/upload")
    public String uploadProfilePicture(@RequestParam("file") MultipartFile file,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
                                           
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please select a file to upload.");
            return "redirect:/user/profile";
        }

        // Validate file size (5MB limit)
        if (file.getSize() > 5 * 1024 * 1024) {
            redirectAttributes.addFlashAttribute("error", "File size must be less than 5MB.");
            return "redirect:/user/profile";
        }

        // Validate file type
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png"))) {
            redirectAttributes.addFlashAttribute("error", "Only JPG and PNG files are allowed.");
            return "redirect:/user/profile";
        }

        try {
            userService.updateUserProfilePicture(userId, file);
            redirectAttributes.addFlashAttribute("success", "Profile picture updated successfully!");
        } catch (IOException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to upload profile picture. " + e.getMessage());
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/user/profile";
    }


    @PostMapping("/complete-task")
    public String completeTask(@RequestParam Long taskId,
                              @RequestParam("proofImage") MultipartFile proofImage,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        if (proofImage.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please provide proof photo to complete this task.");
            return "redirect:/user/tasks";
        }

        // Validate file type
        String contentType = proofImage.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png"))) {
            redirectAttributes.addFlashAttribute("error", "Only JPG and PNG files are allowed.");
            return "redirect:/user/tasks";
        }

        // Validate file size (5MB limit)
        if (proofImage.getSize() > 5 * 1024 * 1024) {
            redirectAttributes.addFlashAttribute("error", "File size must be less than 5MB.");
            return "redirect:/user/tasks";
        }

        try {
            userTaskService.submitTaskWithProof(userId, taskId, proofImage);
            redirectAttributes.addFlashAttribute("success", "Task submitted for review! Your proof photo has been uploaded. You'll receive XP once an admin approves your submission.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Failed to upload proof photo. Please try again.");
        }

        return "redirect:/user/tasks";
    }

    @GetMapping("/proof-image/{filename}")
    @ResponseBody
    public ResponseEntity<byte[]> getProofImage(@PathVariable String filename) {
        try {
            byte[] imageBytes = userTaskService.getProofImage(filename);
            
            // Determine content type based on file extension
            String contentType = "image/jpeg"; // default
            if (filename.toLowerCase().endsWith(".png")) {
                contentType = "image/png";
            } else if (filename.toLowerCase().endsWith(".jpg") || filename.toLowerCase().endsWith(".jpeg")) {
                contentType = "image/jpeg";
            }
            
            return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .body(imageBytes);
        } catch (IOException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/notices")
    public String notices(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        addUserToModel(session, model);
        List<Notice> notices = noticeService.getActiveNotices();
        model.addAttribute("notices", notices);
        return "user/notices";
    }


    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String name,
                           @RequestParam String email,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Check if name and email are actually different
            boolean nameChanged = !user.getName().equals(name);
            boolean emailChanged = !user.getEmail().equals(email);

            // If no changes, just redirect back
            if (!nameChanged && !emailChanged) {
                return "redirect:/user/profile";
            }

            try {
                // The updateUserProfile method will check the limits and throw exceptions if exceeded
                user = userService.updateUserProfile(user, name, email);
                session.setAttribute("userName", user.getName());
                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("error", e.getMessage());
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "User not found");
        }
        return "redirect:/user/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPassword,
                               @RequestParam String newPassword,
                               @RequestParam String confirmPassword,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "New passwords do not match");
            return "redirect:/user/profile";
        }

        try {
            userService.changePassword(userId, currentPassword, newPassword);
            redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/user/profile";
    }

    @GetMapping("/groups")
    public String groups(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            addUserToModel(session, model);
            
            // Get current user's group info first
            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                model.addAttribute("error", "User not found");
                return "error";
            }
            
            User user = userOpt.get();
            model.addAttribute("currentUser", user);
            
            // Get groups with members to avoid lazy loading issues
            List<Group> groups = groupService.getAllGroupsWithMembers();
            
            // Convert groups to DTOs with calculated fields
            List<GroupDTO> groupDTOs = groups.stream()
                .filter(group -> group != null && group.getGroupName() != null)
                .map(group -> {
                    // Ensure members set is not null
                    if (group.getMembers() == null) {
                        group.setMembers(new java.util.HashSet<>());
                    }
                    // Filter out null members
                    group.setMembers(group.getMembers().stream()
                        .filter(member -> member != null && member.getName() != null)
                        .collect(java.util.stream.Collectors.toSet()));
                    
                    GroupDTO dto = new GroupDTO(group);
                    
                    // Calculate average XP
                    double avgXp = group.getMembers().stream()
                        .filter(member -> member.getXpPoints() != null)
                        .mapToInt(member -> member.getXpPoints())
                        .average()
                        .orElse(0.0);
                    dto.setAvgXp((int) Math.round(avgXp));
                    
                    // Get top 3 members by XP
                    List<User> topMembers = group.getMembers().stream()
                        .filter(member -> member.getXpPoints() != null)
                        .sorted((m1, m2) -> Integer.compare(m2.getXpPoints(), m1.getXpPoints()))
                        .limit(3)
                        .collect(java.util.stream.Collectors.toList());
                    dto.setTopMembers(topMembers);
                    
                    return dto;
                })
                .collect(java.util.stream.Collectors.toList());
            
            model.addAttribute("groups", groupDTOs);

            return "user/groups";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred while loading groups. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/groups/messages")
    @ResponseBody
    public ResponseEntity<?> getGroupMessages(HttpSession session, @RequestParam(required = false) Long groupId) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return ResponseEntity.status(401).body(Collections.singletonMap("error", "Not logged in"));
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty() || userOpt.get().getGroup() == null) {
                return ResponseEntity.ok(Collections.emptyList());
            }

            User user = userOpt.get();
            Long targetGroupId = groupId != null ? groupId : user.getGroup().getId();
            
            // Verify user is in the requested group
            if (!targetGroupId.equals(user.getGroup().getId())) {
                return ResponseEntity.status(403).body(Collections.singletonMap("error", "Access denied"));
            }
            
            List<GroupMessage> messages = groupMessageService.getRecentMessages(targetGroupId);
            return ResponseEntity.ok(messages);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Collections.singletonMap("error", "Failed to load messages"));
        }
    }

    @GetMapping("/join-group")
    public String showJoinGroup(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            addUserToModel(session, model);
            
            // Get available groups
            List<Group> availableGroups = groupService.getAllGroups();
            model.addAttribute("availableGroups", availableGroups);
            
            // Check if user is already in a group
            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                model.addAttribute("currentUser", user);
                if (user.getGroup() != null) {
                    model.addAttribute("warning", "You are already in a group. You must leave your current group before joining another one.");
                }
            }

            return "user/join-group";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred while loading available groups. Please try again later.");
            return "error";
        }
    }

    @PostMapping("/join-group/{groupId}")
    public String joinGroup(@PathVariable Long groupId,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // Validate groupId parameter
            if (groupId == null || groupId <= 0) {
                redirectAttributes.addFlashAttribute("error", "Invalid group ID provided.");
                return "redirect:/user/groups";
            }

            userService.joinGroup(userId, groupId);
            redirectAttributes.addFlashAttribute("success", "Successfully joined the group!");
        } catch (RuntimeException e) {
            // Handle specific error cases
            String errorMessage = e.getMessage();
            if (errorMessage.contains("already a member")) {
                redirectAttributes.addFlashAttribute("warning", errorMessage);
            } else if (errorMessage.contains("already in a group")) {
                redirectAttributes.addFlashAttribute("warning", errorMessage);
            } else {
                redirectAttributes.addFlashAttribute("error", errorMessage);
            }
        } catch (Exception e) {
            // Log unexpected errors
            System.err.println("Unexpected error in joinGroup: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "An unexpected error occurred. Please try again later.");
        }

        return "redirect:/user/groups";
    }

    @PostMapping("/leave-group")
    public String leaveGroup(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            userService.leaveGroup(userId);
            redirectAttributes.addFlashAttribute("success", "Successfully left the group!");
        } catch (RuntimeException e) {
            // Handle specific error cases
            String errorMessage = e.getMessage();
            if (errorMessage.contains("not in any group")) {
                redirectAttributes.addFlashAttribute("warning", errorMessage);
            } else {
                redirectAttributes.addFlashAttribute("error", errorMessage);
            }
        } catch (Exception e) {
            // Log unexpected errors
            System.err.println("Unexpected error in leaveGroup: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "An unexpected error occurred. Please try again later.");
        }

        return "redirect:/user/groups";
    }

    @GetMapping("/messages")
    public String messages(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            addUserToModel(session, model);
            
            // Get messages for the current user
            List<Message> userMessages = messageService.getReceivedMessages(user.getName());
            model.addAttribute("messages", userMessages);
            model.addAttribute("unreadCount", messageService.getUnreadMessageCount(user.getName()));

            return "user/messages";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred while loading messages. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/messages/{id}")
    public String viewMessage(@PathVariable Long id, HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            addUserToModel(session, model);

            // Get the specific message
            Optional<Message> messageOpt = messageService.findById(id);
            if (messageOpt.isEmpty()) {
                model.addAttribute("error", "Message not found.");
                return "error";
            }

            Message message = messageOpt.get();
            
            // Security check: ensure the user can only view their own messages
            if (!message.getToUser().equals(user.getName())) {
                model.addAttribute("error", "Access denied. You can only view messages sent to you.");
                return "error";
            }

            // Mark message as read
            messageService.markAsRead(id);
            
            model.addAttribute("message", message);
            return "user/message-view";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred while loading the message. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/delete-account")
    public String showDeleteAccount(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            
            // Ensure user has required properties initialized
            if (user.getXpPoints() == null) {
                user.setXpPoints(0);
            }
            if (user.getUnlockedRewards() == null) {
                user.setUnlockedRewards(new java.util.HashSet<>());
            }
            if (user.getCompletedTasks() == null) {
                user.setCompletedTasks(new java.util.HashSet<>());
            }
            
            // Add user to model with safe values
            model.addAttribute("user", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            
            return "user/delete-account";
        } catch (Exception e) {
            // Log the detailed error for debugging
            System.err.println("Error in showDeleteAccount: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/debug-user")
    public String debugUser(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            model.addAttribute("userId", userId);
            
            if (userId != null) {
                Optional<User> userOpt = userService.findById(userId);
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    model.addAttribute("userName", user.getName());
                    model.addAttribute("userEmail", user.getEmail());
                    model.addAttribute("userXpPoints", user.getXpPoints());
                    model.addAttribute("userProfilePicture", user.getProfilePicture());
                } else {
                    model.addAttribute("userName", "User not found");
                }
            } else {
                model.addAttribute("userName", "No user session");
            }
            
            return "debug-user";
        } catch (Exception e) {
            System.err.println("Error in debugUser: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", e.getMessage());
            return "error";
        }
    }

    @GetMapping("/delete-account-test")
    public String showDeleteAccountTest(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            
            // Ensure user has required properties initialized
            if (user.getXpPoints() == null) {
                user.setXpPoints(0);
            }
            if (user.getUnlockedRewards() == null) {
                user.setUnlockedRewards(new java.util.HashSet<>());
            }
            if (user.getCompletedTasks() == null) {
                user.setCompletedTasks(new java.util.HashSet<>());
            }
            
            // Add user to model with safe values
            model.addAttribute("user", user);
            
            return "user/delete-account-simple";
        } catch (Exception e) {
            // Log the detailed error for debugging
            System.err.println("Error in showDeleteAccountTest: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            return "error";
        }
    }

    @PostMapping("/delete-account")
    public String deleteAccount(@RequestParam String password,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                System.err.println("Delete account attempt without user session");
                return "redirect:/login";
            }

            // Validate password is not empty
            if (password == null || password.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Password is required to delete your account.");
                return "redirect:/user/delete-account";
            }

            System.err.println("Attempting to delete account for user ID: " + userId);
            
            // Delete the account
            userService.deleteAccount(userId, password);
            
            System.err.println("Account deleted successfully for user ID: " + userId);
            
            // Invalidate session to log out the user
            session.invalidate();
            
            // Redirect to goodbye page
            return "redirect:/goodbye";
            
        } catch (RuntimeException e) {
            // Handle specific error cases
            String errorMessage = e.getMessage();
            System.err.println("RuntimeException in deleteAccount: " + errorMessage);
            
            if (errorMessage.contains("Incorrect password")) {
                redirectAttributes.addFlashAttribute("error", errorMessage);
            } else if (errorMessage.contains("User not found")) {
                redirectAttributes.addFlashAttribute("error", "User not found. Please log in again.");
                return "redirect:/login";
            } else {
                redirectAttributes.addFlashAttribute("error", errorMessage);
            }
        } catch (Exception e) {
            // Log unexpected errors
            System.err.println("Unexpected error in deleteAccount: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "An unexpected error occurred. Please try again later.");
        }

        return "redirect:/user/delete-account";
    }
}