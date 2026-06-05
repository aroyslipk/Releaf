package com.example.demo.service;

import com.example.demo.entity.UserTask;
import com.example.demo.entity.User;
import com.example.demo.entity.Task;
import com.example.demo.entity.Admin;
import com.example.demo.repository.UserTaskRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class UserTaskService {

    @Autowired
    private UserTaskRepository userTaskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private UserTopicProgressService userTopicProgressService;

    @Autowired(required = false)
    private AdminNotificationService adminNotificationService;

    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/proofs";

    public UserTask submitTaskWithProof(Long userId, Long taskId, MultipartFile proofImage) throws IOException {
        System.out.println("📝 Starting task submission - User: " + userId + ", Task: " + taskId);
        
        // Check if user and task exist
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Task> taskOpt = taskRepository.findById(taskId);

        if (userOpt.isEmpty() || taskOpt.isEmpty()) {
            System.err.println("❌ User or Task not found");
            throw new RuntimeException("User or Task not found");
        }

        User user = userOpt.get();
        Task task = taskOpt.get();
        
        System.out.println("✓ User found: " + user.getName());
        System.out.println("✓ Task found: " + task.getDescription());

        // Check if user already has a pending or approved submission for this task
        List<UserTask> existingSubmissions = userTaskRepository.findByUserIdAndTaskId(userId, taskId);
        UserTask existingRejected = null;
        if (!existingSubmissions.isEmpty()) {
            // Get the most recent submission
            UserTask existing = existingSubmissions.get(0);
            if (existing.getStatus() == UserTask.TaskStatus.PENDING_REVIEW) {
                System.err.println("❌ User already has pending submission");
                throw new RuntimeException("You already have a pending submission for this task");
            }
            if (existing.getStatus() == UserTask.TaskStatus.APPROVED) {
                System.err.println("❌ Task already completed");
                throw new RuntimeException("You have already completed this task");
            }
            if (existing.getStatus() == UserTask.TaskStatus.REJECTED) {
                // User is resubmitting a rejected task - we'll update the existing record
                existingRejected = existing;
                System.out.println("🔄 Resubmitting previously rejected task - will update existing record");
            }
        }

        // Save the proof image
        System.out.println("💾 Saving proof image...");
        String imageFileName = saveProofImage(proofImage, userId, taskId);
        System.out.println("✓ Image saved: " + imageFileName);

        UserTask savedTask;
        if (existingRejected != null) {
            // Update existing rejected record instead of creating new one
            // This avoids the UNIQUE(user_id, task_id) constraint violation
            existingRejected.setProofImage(imageFileName);
            existingRejected.setStatus(UserTask.TaskStatus.PENDING_REVIEW);
            existingRejected.setSubmittedAt(LocalDateTime.now());
            existingRejected.setReviewerNotes("Awaiting AI analysis and admin review");
            existingRejected.setReviewedAt(null);
            existingRejected.setReviewedBy(null);
            savedTask = userTaskRepository.save(existingRejected);
            System.out.println("✅ Task resubmitted successfully! ID: " + savedTask.getId());
        } else {
            // Create new UserTask submission - ALWAYS PENDING, NO AI YET
            UserTask userTask = new UserTask(user, task);
            userTask.setProofImage(imageFileName);
            userTask.setStatus(UserTask.TaskStatus.PENDING_REVIEW);
            userTask.setReviewerNotes("Awaiting AI analysis and admin review");
            savedTask = userTaskRepository.save(userTask);
            System.out.println("✅ Task submitted successfully! ID: " + savedTask.getId());
        }
        
        // Update user's last active task and topic/difficulty
        user.setLastActiveTaskId(taskId);
        user.setLastSubmittedTopic(task.getTopic());
        user.setLastSubmittedDifficulty(task.getLevel());
        userRepository.save(user);
        
        // Create admin notification for review
        if (adminNotificationService != null) {
            try {
                adminNotificationService.createTaskReviewNotification(savedTask, "New task submission - awaiting AI analysis");
                System.out.println("✓ Admin notification created");
            } catch (Exception e) {
                System.err.println("⚠️ Failed to create admin notification: " + e.getMessage());
            }
        }
        
        return savedTask;
    }

    public UserTask approveTask(Long userTaskId, Long adminId, String notes) {
        Optional<UserTask> userTaskOpt = userTaskRepository.findById(userTaskId);
        Optional<Admin> adminOpt = adminRepository.findById(adminId);

        if (userTaskOpt.isEmpty() || adminOpt.isEmpty()) {
            throw new RuntimeException("UserTask or Admin not found");
        }

        UserTask userTask = userTaskOpt.get();
        Admin admin = adminOpt.get();

        if (userTask.getStatus() != UserTask.TaskStatus.PENDING_REVIEW) {
            throw new RuntimeException("Task is not in pending review status");
        }

        // Update UserTask status
        userTask.setStatus(UserTask.TaskStatus.APPROVED);
        userTask.setReviewedAt(LocalDateTime.now());
        userTask.setReviewedBy(admin);
        userTask.setReviewerNotes(notes);

        // Add task to user's completed tasks and award XP
        User user = userTask.getUser();
        Task task = userTask.getTask();
        
        user.getCompletedTasks().add(task);
        user.setXpPoints(user.getXpPoints() + task.getXpReward());
        userRepository.save(user);

        // Update topic progress
        userTopicProgressService.updateTaskCompletion(user.getId(), task.getTopic(), task.getLevel());

        return userTaskRepository.save(userTask);
    }

    public UserTask rejectTask(Long userTaskId, Long adminId, String notes) {
        Optional<UserTask> userTaskOpt = userTaskRepository.findById(userTaskId);
        Optional<Admin> adminOpt = adminRepository.findById(adminId);

        if (userTaskOpt.isEmpty() || adminOpt.isEmpty()) {
            throw new RuntimeException("UserTask or Admin not found");
        }

        UserTask userTask = userTaskOpt.get();
        Admin admin = adminOpt.get();

        if (userTask.getStatus() != UserTask.TaskStatus.PENDING_REVIEW) {
            throw new RuntimeException("Task is not in pending review status");
        }

        // Update UserTask status
        userTask.setStatus(UserTask.TaskStatus.REJECTED);
        userTask.setReviewedAt(LocalDateTime.now());
        userTask.setReviewedBy(admin);
        userTask.setReviewerNotes(notes);

        return userTaskRepository.save(userTask);
    }

    public List<UserTask> getPendingReviewTasks() {
        try {
            System.out.println("Calling findPendingReviewTasks...");
            List<UserTask> tasks = userTaskRepository.findPendingReviewTasks();
            System.out.println("Retrieved " + tasks.size() + " pending tasks");
            return tasks;
        } catch (Exception e) {
            System.err.println("Error in getPendingReviewTasks: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public List<UserTask> getUserTasks(Long userId) {
        return userTaskRepository.findByUserId(userId);
    }

    public List<UserTask> getUserTasksByStatus(Long userId, UserTask.TaskStatus status) {
        return userTaskRepository.findByUserIdAndStatus(userId, status);
    }

    public Optional<UserTask> getUserTask(Long userId, Long taskId) {
        List<UserTask> tasks = userTaskRepository.findByUserIdAndTaskId(userId, taskId);
        return tasks.isEmpty() ? Optional.empty() : Optional.of(tasks.get(0));
    }

    public long getPendingReviewCount() {
        return userTaskRepository.findByStatus(UserTask.TaskStatus.PENDING_REVIEW).size();
    }

    public long getUserTaskCountByStatus(Long userId, UserTask.TaskStatus status) {
        return userTaskRepository.countByUserIdAndStatus(userId, status);
    }

    private String saveProofImage(MultipartFile file, Long userId, Long taskId) throws IOException {
        try {
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            System.out.println("📁 Upload directory path: " + uploadPath.toAbsolutePath());
            
            if (!Files.exists(uploadPath)) {
                System.out.println("📁 Creating upload directory...");
                Files.createDirectories(uploadPath);
                System.out.println("✓ Upload directory created");
            } else {
                System.out.println("✓ Upload directory exists");
            }

            // Generate unique filename
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".") ? 
                originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
            String filename = userId + "_" + taskId + "_" + System.currentTimeMillis() + extension;
            
            System.out.println("📝 Generated filename: " + filename);

            // Save file
            Path filePath = uploadPath.resolve(filename);
            System.out.println("💾 Saving file to: " + filePath.toAbsolutePath());
            
            Files.copy(file.getInputStream(), filePath);
            
            System.out.println("✅ File saved successfully");
            return filename;
        } catch (IOException e) {
            System.err.println("❌ Failed to save proof image: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Failed to save proof image: " + e.getMessage(), e);
        }
    }

    public byte[] getProofImage(String filename) throws IOException {
        Path filePath = Paths.get(UPLOAD_DIR, filename);
        System.out.println("Looking for proof image at: " + filePath.toAbsolutePath());
        if (Files.exists(filePath)) {
            System.out.println("Proof image found: " + filePath.toAbsolutePath());
            return Files.readAllBytes(filePath);
        }
        System.out.println("Proof image not found: " + filePath.toAbsolutePath());
        throw new IOException("Proof image not found: " + filename);
    }

} 