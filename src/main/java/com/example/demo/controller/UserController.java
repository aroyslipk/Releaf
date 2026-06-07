package com.example.demo.controller;

import com.example.demo.entity.*;
import com.example.demo.service.*;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
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

import com.example.demo.dto.GroupDTO;
import com.example.demo.repository.UserTaskRepository;
import org.springframework.transaction.annotation.Transactional;

@Controller
@RequestMapping("/user")
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
    private TaskGuideService taskGuideService;

    @Autowired
    private UserTaskRepository userTaskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RewardService rewardService;

    private void addUserToModel(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            Optional<User> userOpt = userService.findByIdWithCollections(userId);
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
        try {
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
            
            // Ensure message is not empty
            String trimmedMessage = message != null ? message.trim() : "";
            if (trimmedMessage.isEmpty()) {
                return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Message cannot be empty"));
            }

            GroupMessage chatMessage = groupMessageService.sendMessage(group, user, trimmedMessage);
            
            Map<String, Object> response = new HashMap<>();
            response.put("id", chatMessage.getId());
            response.put("username", user.getName());
            response.put("userId", user.getId());
            response.put("messageText", chatMessage.getMessageText());
            response.put("createdAt", chatMessage.getCreatedAt() != null ? chatMessage.getCreatedAt().toString() : "");
            response.put("profilePicture", user.getProfilePicture());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Collections.singletonMap("error", "Failed to send message: " + e.getMessage()));
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");

            // 🔐 Not logged in? Redirect to login
            if (userId == null) {
                return "redirect:/login";
            }

            // 🔧 FIX: Use findByIdWithCollections to eagerly load completedTasks, unlockedRewards, and group
            Optional<User> userOpt = userService.findByIdWithCollections(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }

            User user = userOpt.get();
            model.addAttribute("user", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            model.addAttribute("userName", user.getName());
            session.setAttribute("userName", user.getName());

            List<Notice> notices = noticeService.getActiveNotices();
            if (notices != null) {
                model.addAttribute("notices", notices.size() > 3 ? notices.subList(0, 3) : notices);
            } else {
                model.addAttribute("notices", java.util.Collections.emptyList());
            }

            // 🔧 FIX: Ensure xpPoints is never null before passing to rewardService
            int xpPoints = (user.getXpPoints() != null) ? user.getXpPoints() : 0;
            if (user.getXpPoints() == null) {
                user.setXpPoints(0);
            }
            if (user.getUnlockedRewards() == null) {
                user.setUnlockedRewards(new java.util.HashSet<>());
            }

            // Add reward level information (safe even with 0 XP)
            String currentRewardLevel = rewardService.getCurrentRewardLevel(xpPoints);
            Integer nextRewardXP = rewardService.getNextRewardXP(xpPoints);
            Integer currentLevelXP = rewardService.getCurrentLevelXP(xpPoints);
            
            model.addAttribute("currentRewardLevel", currentRewardLevel);
            model.addAttribute("nextRewardXP", nextRewardXP);
            model.addAttribute("currentLevelXP", currentLevelXP);

            return "user/dashboard";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Dashboard error: " + e.getMessage());
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

    // Add common model attributes
    addUserToModel(session, model);

    // If no specific view is requested or landing is requested, show the landing page
    // Use a switch statement for better view management
    String targetView = view == null ? "landing" : view;

    switch (targetView) {
        case "landing":
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            return "user/greenverse-landing";

        case "tasks":
            try {
                // Verify user exists
                System.out.println("Fetching user with ID: " + userId);
                User user = userService.findByIdWithCollections(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
                System.out.println("User found: " + user.getName());

                // Step 1: Initialize user topic progress (idempotent operation)
                System.out.println("Initializing user topic progress...");
                try {
                    userTopicProgressService.initializeUserProgress(userId);
                    System.out.println("User topic progress initialized.");
                } catch (Exception e) {
                    System.err.println("Warning: Error initializing user progress: " + e.getMessage());
                    // Continue anyway - this shouldn't stop the page from loading
                }

                // Step 2: Get topic progress data
                System.out.println("Fetching topic progress data...");
                Map<String, Object> progressData = userTopicProgressService.getTopicProgressData(userId);
                if (progressData == null) {
                    progressData = new HashMap<>();
                }
                System.out.println("Topic progress data fetched.");

                // Step 3: Extract and validate progress data
                List<UserTopicProgress> progressList = progressData.containsKey("progressList") ?
                    (List<UserTopicProgress>) progressData.get("progressList") :
                    Collections.emptyList();
                    
                if (progressList == null) {
                    progressList = Collections.emptyList();
                }

                UserTopicProgress currentTopic = progressData.containsKey("currentTopic") ?
                    (UserTopicProgress) progressData.get("currentTopic") :
                    null;

                UserTopicProgress nextTopic = progressData.containsKey("nextTopic") ?
                    (UserTopicProgress) progressData.get("nextTopic") :
                    null;

                @SuppressWarnings("unchecked")
                Map<String, Map<String, Integer>> taskCounts = progressData.containsKey("taskCounts") ?
                    (Map<String, Map<String, Integer>>) progressData.get("taskCounts") :
                    new HashMap<>();

                // Step 4: Get available tasks for the user (all unlocked tasks)
                List<Task> availableTasks = userTopicProgressService.getAvailableTasksForUser(userId);
                if (availableTasks == null) {
                    availableTasks = Collections.emptyList();
                }
                
                // Get incomplete available tasks for dashboard count (excludes completed tasks)
                List<Task> incompleteAvailableTasks = userTopicProgressService.getIncompleteAvailableTasksForUser(userId);
                if (incompleteAvailableTasks == null) {
                    incompleteAvailableTasks = Collections.emptyList();
                }

                // Step 5: Get user's task completion status
                List<UserTask> userTasks = userTaskService.getUserTasks(userId);
                if (userTasks == null) {
                    userTasks = Collections.emptyList();
                }

                // Step 6: Get the last submitted task
                UserTask lastSubmittedTask = null;
                if (!userTasks.isEmpty()) {
                    // Sort by submitted date in descending order and get the first one
                    lastSubmittedTask = userTasks.stream()
                        .max((a, b) -> a.getSubmittedAt().compareTo(b.getSubmittedAt()))
                        .orElse(null);
                }

                // Add all required attributes to the model
                model.addAttribute("progressList", progressList);
                model.addAttribute("currentTopic", currentTopic);
                model.addAttribute("nextTopic", nextTopic);
                model.addAttribute("availableTasks", availableTasks);
                model.addAttribute("incompleteAvailableTasks", incompleteAvailableTasks);
                model.addAttribute("userTasks", userTasks);
                model.addAttribute("lastSubmittedTask", lastSubmittedTask);
                model.addAttribute("taskCounts", taskCounts);
                model.addAttribute("topicsAvailable", progressList.stream()
                        .filter(p -> p != null && p.getIsUnlocked())
                        .mapToInt(p -> 1)
                        .sum());

                // Add statistics
                try {
                    model.addAttribute("totalTasks", taskService.getTotalTasksCount());
                    model.addAttribute("completedTasks", taskService.getCompletedTasksCount(userId));
                    model.addAttribute("activeTasks", taskService.getActiveTasksCount(userId));
                    model.addAttribute("unreadNotices", noticeService.getUnreadNoticesCount(userId));
                } catch (Exception e) {
                    System.err.println("Warning: Error fetching statistics: " + e.getMessage());
                    model.addAttribute("totalTasks", 0);
                    model.addAttribute("completedTasks", 0);
                    model.addAttribute("activeTasks", 0);
                    model.addAttribute("unreadNotices", 0);
                }
                
                model.addAttribute("lastActiveTaskId", user.getLastActiveTaskId());
                model.addAttribute("lastSubmittedTopic", user.getLastSubmittedTopic());
                model.addAttribute("lastSubmittedDifficulty", user.getLastSubmittedDifficulty());

                // Return the tasks view
                return "user/greenverse-tasks";

            } catch (Exception e) {
                // Log the error
                System.err.println("Error in greenverse controller: " + e.getMessage());
                e.printStackTrace();

                // Add error information to model
                model.addAttribute("error", "Failed to load Greenverse tasks: " + e.getMessage());
                return "error";
            }

        default:
            // Default to landing if the view is unknown
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            return "user/greenverse-landing";
    }
}

    @GetMapping("/achievements")
    public String achievements(HttpSession session, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            // Use the new repository method to fetch user with all collections
            Optional<User> userOpt = userRepository.findByIdWithCollections(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }
            
            User user = userOpt.get();
            
            // Initialize values if they're null
            if (user.getXpPoints() == null) {
                user.setXpPoints(0);
                userRepository.save(user);
            }
            
            model.addAttribute("user", user);

            long completedTasksCount = userService.getCompletedTasksCount(userId);
            model.addAttribute("completedTasksCount", completedTasksCount);

            int totalTasks = taskService.getAllTasks().size();
            double progressPercentage = totalTasks > 0 ? ((double) completedTasksCount / totalTasks) * 100 : 0;
            model.addAttribute("progressPercentage", Math.round(progressPercentage));

            // Add reward level information
            String currentRewardLevel = rewardService.getCurrentRewardLevel(user.getXpPoints());
            Integer nextRewardXP = rewardService.getNextRewardXP(user.getXpPoints());
            Integer currentLevelXP = rewardService.getCurrentLevelXP(user.getXpPoints());
            int unlockedRewardsCount = rewardService.getUnlockedRewardsCount(user.getXpPoints());
            java.util.List<java.util.Map<String, Object>> unlockedRewardsList = rewardService.getUnlockedRewardsList(user.getXpPoints());
            
            model.addAttribute("currentRewardLevel", currentRewardLevel);
            model.addAttribute("nextRewardXP", nextRewardXP);
            model.addAttribute("currentLevelXP", currentLevelXP);
            model.addAttribute("unlockedRewardsCount", unlockedRewardsCount);
            model.addAttribute("unlockedRewardsList", unlockedRewardsList);
            
            // Calculate XP progress for the next reward
            long currentXpInLevel = user.getXpPoints() - currentLevelXP;
            long xpForNextReward = nextRewardXP - currentLevelXP;
            long xpPercentage = xpForNextReward > 0 ? Math.round(((double) currentXpInLevel / xpForNextReward) * 100) : 100;
            model.addAttribute("xpPercentage", xpPercentage);

            return "user/achievements";
            
        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            return "error";
        }
    }

    @GetMapping("/profile")
    public String userProfile(Model model, HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            // 🔧 FIX: Use findByIdWithCollections to eagerly load all collections
            Optional<User> userOpt = userService.findByIdWithCollections(userId);
            if (userOpt.isEmpty()) {
                model.addAttribute("error", "User not found");
                return "redirect:/login";
            }

            User user = userOpt.get();
            
            // 🔧 FIX: Null-safety for all fields
            if (user.getXpPoints() == null) user.setXpPoints(0);
            if (user.getUnlockedRewards() == null) user.setUnlockedRewards(new java.util.HashSet<>());
            if (user.getCompletedTasks() == null) user.setCompletedTasks(new java.util.HashSet<>());
            
            model.addAttribute("user", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            
            return "user/profile";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Profile error: " + e.getMessage());
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
            // Fetch the updated user object from the database
            Optional<User> updatedUserOpt = userService.findById(userId);
            if (updatedUserOpt.isPresent()) {
                session.setAttribute("user", updatedUserOpt.get()); // Update the user object in the session
            }
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
    @ResponseBody
    public ResponseEntity<Map<String, Object>> completeTask(@RequestParam Long taskId,
                                          @RequestParam("proofImage") MultipartFile proofImage,
                                          HttpSession session) {
        try {
            System.out.println("=== TASK SUBMISSION STARTED ===");
            System.out.println("Task ID: " + taskId);
            System.out.println("File name: " + (proofImage != null ? proofImage.getOriginalFilename() : "null"));
            System.out.println("File size: " + (proofImage != null ? proofImage.getSize() : 0));
            
            Long userId = (Long) session.getAttribute("userId");
            System.out.println("User ID: " + userId);
            
            if (userId == null) {
                System.out.println("ERROR: User not logged in");
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("error", "User not logged in");
                return ResponseEntity.status(401)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(errorResponse);
            }

            if (proofImage == null || proofImage.isEmpty()) {
                System.out.println("ERROR: No proof image provided");
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("error", "Please provide proof photo to complete this task.");
                return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(errorResponse);
            }

            // Validate file type
            String contentType = proofImage.getContentType();
            System.out.println("Content type: " + contentType);
            if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("image/jpg"))) {
                System.out.println("ERROR: Invalid file type");
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("error", "Only JPG and PNG files are allowed.");
                return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(errorResponse);
            }

            // Validate file size (5MB limit)
            if (proofImage.getSize() > 5 * 1024 * 1024) {
                System.out.println("ERROR: File too large");
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("error", "File size must be less than 5MB.");
                return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(errorResponse);
            }

            System.out.println("Calling userTaskService.submitTaskWithProof...");
            UserTask submittedTask = userTaskService.submitTaskWithProof(userId, taskId, proofImage);
            System.out.println("=== TASK SUBMISSION SUCCESSFUL ===");
            System.out.println("Submitted task ID: " + submittedTask.getId());
            System.out.println("Status: " + submittedTask.getStatus());
            
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", "Task submitted successfully! Your submission is pending review by our AI system and admin team.");
            successResponse.put("taskId", submittedTask.getId());
            successResponse.put("status", submittedTask.getStatus().toString());
            
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(successResponse);
        } catch (RuntimeException e) {
            System.err.println("=== RUNTIME EXCEPTION IN TASK SUBMISSION ===");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.status(500)
                .contentType(MediaType.APPLICATION_JSON)
                .body(errorResponse);
        } catch (IOException e) {
            System.err.println("=== IO EXCEPTION IN TASK SUBMISSION ===");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to upload proof photo. Please try again.");
            return ResponseEntity.status(500)
                .contentType(MediaType.APPLICATION_JSON)
                .body(errorResponse);
        } catch (Exception e) {
            System.err.println("=== UNEXPECTED EXCEPTION IN TASK SUBMISSION ===");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error class: " + e.getClass().getName());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "An unexpected error occurred: " + e.getMessage());
            return ResponseEntity.status(500)
                .contentType(MediaType.APPLICATION_JSON)
                .body(errorResponse);
        }
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
    
    /**
     * Public endpoint for users to get task guide data.
     * Uses getGuideDataAsMap() which copies all @ElementCollection data
     * into plain Java objects inside the @Transactional method,
     * avoiding all lazy-loading issues.
     */
    @GetMapping("/tasks/{taskId}/guide")
    @ResponseBody
    public ResponseEntity<?> getTaskGuide(@PathVariable Long taskId) {
        try {
            // This method runs inside @Transactional on the service,
            // so all lazy collections are resolved before returning
            Map<String, Object> guideData = taskGuideService.getGuideDataAsMap(taskId);
            
            if (guideData != null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("guide", guideData);
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.ok(Map.of("success", false, "message", "No guide found"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("success", false, "error", e.getMessage()));
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
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        try {
            // Get basic user info
            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                return "redirect:/login";
            }
            
            User user = userOpt.get();
            model.addAttribute("user", user);
            model.addAttribute("currentUser", user);
            model.addAttribute("completedTasksCount", userService.getCompletedTasksCount(userId));
            
            // Get all groups - simple query without complex joins
            List<Group> allGroups = groupService.getAllGroups();
            model.addAttribute("groups", allGroups != null ? allGroups : new java.util.ArrayList<>());

            return "user/groups";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading groups: " + e.getMessage());
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
            
            // Convert to DTOs with eager-loaded user data to prevent lazy loading issues
            List<Map<String, Object>> messageDTOs = messages.stream().map(msg -> {
                try {
                    Map<String, Object> dto = new HashMap<>();
                    dto.put("id", msg.getId());
                    dto.put("messageText", msg.getMessageText() != null ? msg.getMessageText() : "");
                    dto.put("createdAt", msg.getCreatedAt() != null ? msg.getCreatedAt().toString() : "");
                    if (msg.getUser() != null) {
                        dto.put("username", msg.getUser().getName() != null ? msg.getUser().getName() : "Unknown");
                        dto.put("userId", msg.getUser().getId());
                        dto.put("profilePicture", msg.getUser().getProfilePicture());
                    }
                    return dto;
                } catch (Exception e) {
                    System.err.println("Error processing message: " + e.getMessage());
                    e.printStackTrace();
                    Map<String, Object> errorDto = new HashMap<>();
                    errorDto.put("id", msg.getId());
                    errorDto.put("messageText", "Error loading message");
                    errorDto.put("createdAt", "");
                    errorDto.put("username", "System");
                    errorDto.put("userId", -1L);
                    return errorDto;
                }
            }).collect(java.util.stream.Collectors.toList());
            
            return ResponseEntity.ok(messageDTOs);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error fetching messages: " + e.getMessage());
            return ResponseEntity.status(500).body(Collections.singletonMap("error", "Failed to load messages: " + e.getMessage()));
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

            // Use findByIdWithCollections to properly load user data (matching dashboard/greenverse pattern)
            Optional<User> userOpt = userService.findByIdWithCollections(userId);
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

    @GetMapping("/eco-store")
    public String ecoStore(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        addUserToModel(session, model);
        return "user/eco-store";
    }

    // Notification count endpoint for bell icon
    @GetMapping("/notifications/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getNotificationCount(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("count", 0);
                return ResponseEntity.ok(response);
            }

            Optional<User> userOpt = userService.findById(userId);
            if (userOpt.isEmpty()) {
                response.put("count", 0);
                return ResponseEntity.ok(response);
            }

            User user = userOpt.get();
            
            // Count unread messages
            long unreadMessages = messageService.getUnreadMessageCount(user.getName());
            
            response.put("count", unreadMessages);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("count", 0);
            return ResponseEntity.ok(response);
        }
    }
}