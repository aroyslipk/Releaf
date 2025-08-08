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
import java.util.List;
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

    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/proofs";

    public UserTask submitTaskWithProof(Long userId, Long taskId, MultipartFile proofImage) throws IOException {
        // Check if user and task exist
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Task> taskOpt = taskRepository.findById(taskId);

        if (userOpt.isEmpty() || taskOpt.isEmpty()) {
            throw new RuntimeException("User or Task not found");
        }

        User user = userOpt.get();
        Task task = taskOpt.get();

        // Check if user already has a pending or approved submission for this task
        Optional<UserTask> existingSubmission = userTaskRepository.findByUserIdAndTaskId(userId, taskId);
        if (existingSubmission.isPresent()) {
            UserTask existing = existingSubmission.get();
            if (existing.getStatus() == UserTask.TaskStatus.PENDING_REVIEW) {
                throw new RuntimeException("You already have a pending submission for this task");
            }
            if (existing.getStatus() == UserTask.TaskStatus.APPROVED) {
                throw new RuntimeException("You have already completed this task");
            }
        }

        // Save the proof image
        String imageFileName = saveProofImage(proofImage, userId, taskId);

        // Create new UserTask submission
        UserTask userTask = new UserTask(user, task);
        userTask.setProofImage(imageFileName);
        userTask.setStatus(UserTask.TaskStatus.PENDING_REVIEW);

        // Update user's last active task
        user.setLastActiveTaskId(taskId);
        userRepository.save(user);

        return userTaskRepository.save(userTask);
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
        return userTaskRepository.findByUserIdAndTaskId(userId, taskId);
    }

    public long getPendingReviewCount() {
        return userTaskRepository.findByStatus(UserTask.TaskStatus.PENDING_REVIEW).size();
    }

    public long getUserTaskCountByStatus(Long userId, UserTask.TaskStatus status) {
        return userTaskRepository.countByUserIdAndStatus(userId, status);
    }

    private String saveProofImage(MultipartFile file, Long userId, Long taskId) throws IOException {
        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null ? 
            originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
        String filename = userId + "_" + taskId + "_" + UUID.randomUUID().toString() + extension;

        // Save file
        Path filePath = uploadPath.resolve(filename);
        Files.copy(file.getInputStream(), filePath);

        return filename;
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