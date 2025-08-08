package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.entity.Task;
import com.example.demo.entity.Reward;
import com.example.demo.entity.Group;
import com.example.demo.entity.UserTask;
import com.example.demo.entity.UserTopicProgress;
import com.example.demo.entity.GroupMessage;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.RewardRepository;
import com.example.demo.repository.GroupRepository;
import com.example.demo.repository.UserTaskRepository;
import com.example.demo.repository.UserTopicProgressRepository;
import com.example.demo.repository.GroupMessageRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.StringUtils;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private RewardRepository rewardRepository;

    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private UserTaskRepository userTaskRepository;

    @Autowired
    private UserTopicProgressRepository userTopicProgressRepository;

    @Autowired
    private GroupMessageRepository groupMessageRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${file.upload-dir}")
    private String uploadDir;

    public User createUser(String name, String email, String password) {
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email is already taken!");
        }

        User user = new User(name, email, passwordEncoder.encode(password));
        return userRepository.save(user);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findById(Long id) {
        return userRepository.findByIdWithCompletedTasks(id);
    }

    public List<User> getAllUsers() {
        return userRepository.findAllWithDetails();
    }

    public List<User> getUsersByGroup(Long groupId) {
        return userRepository.findByGroupId(groupId);
    }

    public User updateUser(User user) {
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    public User completeTask(Long userId, Long taskId) {
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Task> taskOpt = taskRepository.findById(taskId);

        if (userOpt.isPresent() && taskOpt.isPresent()) {
            User user = userOpt.get();
            Task task = taskOpt.get();

            // Check if task is already completed
            if (!user.getCompletedTasks().contains(task)) {
                user.getCompletedTasks().add(task);
                user.setXpPoints(user.getXpPoints() + task.getXpReward());

                // Check for new rewards
                checkAndUnlockRewards(user);

                return userRepository.save(user);
            }
        }
        return null;
    }

    private void checkAndUnlockRewards(User user) {
        List<Reward> availableRewards = rewardRepository.findAvailableRewardsForUser(
            user.getXpPoints(), user.getId());
        
        for (Reward reward : availableRewards) {
            user.getUnlockedRewards().add(reward);
        }
    }

    public List<User> getLeaderboard() {
        return userRepository.findAllOrderByXpPointsDesc();
    }

    public Long getCompletedTasksCount(Long userId) {
        return userRepository.countCompletedTasksByUserId(userId);
    }

    public boolean validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    public List<User> findUsersByNameContaining(String name) {
        return userRepository.findByNameEqualsIgnoreCase(name);
    }

    // === Profile picture upload logic ===
    public void updateUserProfilePicture(Long userId, MultipartFile file) throws IOException {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        // Get original file name and extension
        String originalFilenameRaw = file.getOriginalFilename();
        if (originalFilenameRaw == null || originalFilenameRaw.isEmpty()) {
            throw new RuntimeException("Invalid file name");
        }

        String originalFilename = StringUtils.cleanPath(originalFilenameRaw);
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        
        // Validate file extension
        if (!fileExtension.equals(".jpg") && !fileExtension.equals(".jpeg") && !fileExtension.equals(".png")) {
            throw new RuntimeException("Only JPG and PNG files are allowed");
        }

        // Create unique filename using timestamp to prevent conflicts
        String uniqueFilename = userId + "_" + System.currentTimeMillis() + fileExtension;

        // Get the absolute path for the upload directory
        Path uploadPath = Paths.get(uploadDir).toAbsolutePath();

        // Create directories if they don't exist
        Files.createDirectories(uploadPath);

        // Delete old profile picture if it exists
        if (user.getProfilePicture() != null) {
            try {
                Files.deleteIfExists(uploadPath.resolve(user.getProfilePicture()));
            } catch (IOException e) {
                // Log but don't throw - we still want to save the new picture
                e.printStackTrace();
            }
        }

        // Copy file to destination
        Path filePath = uploadPath.resolve(uniqueFilename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Update user profile picture field
        user.setProfilePicture(uniqueFilename);
        userRepository.save(user);
    }

    public boolean canUpdateName(User user) {
        return user.getNameChangesCount() < 3;
    }

    public boolean canUpdateEmail(User user) {
        return user.getEmailChangesCount() < 3;
    }

    public User updateUserProfile(User user, String newName, String newEmail) {
        boolean nameUpdated = false;
        boolean emailUpdated = false;

        // Initialize counters if they are null
        if (user.getNameChangesCount() == null) {
            user.setNameChangesCount(0);
        }
        if (user.getEmailChangesCount() == null) {
            user.setEmailChangesCount(0);
        }

        try {
            if (!user.getName().equals(newName)) {
                if (!canUpdateName(user)) {
                    throw new RuntimeException("You have reached the maximum number of name changes (3)");
                }
                user.setName(newName);
                user.setNameChangesCount(user.getNameChangesCount() + 1);
                nameUpdated = true;
            }

            if (!user.getEmail().equals(newEmail)) {
                if (!canUpdateEmail(user)) {
                    throw new RuntimeException("You have reached the maximum number of email changes (3)");
                }
                user.setEmail(newEmail);
                user.setEmailChangesCount(user.getEmailChangesCount() + 1);
                emailUpdated = true;
            }

            if (nameUpdated || emailUpdated) {
                user.setUpdatedAt(LocalDateTime.now());
                return userRepository.save(user);
            }

            return user;
        } catch (Exception e) {
            throw new RuntimeException("Failed to update profile: " + e.getMessage());
        }
    }

    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        if (!validatePassword(currentPassword, user.getPassword())) {
            throw new RuntimeException("Current password is incorrect");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    public void joinGroup(Long userId, Long groupId) {
        try {
            // Validate input parameters
            if (userId == null || groupId == null) {
                throw new RuntimeException("User ID and Group ID cannot be null");
            }

            // Find user with proper error handling
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Check if user is already in a group
            if (user.getGroup() != null) {
                // Check if user is trying to join the same group they're already in
                if (user.getGroup().getId().equals(groupId)) {
                    throw new RuntimeException("You are already a member of this group.");
                } else {
                    throw new RuntimeException("You are already in a group. Please leave your current group first.");
                }
            }
            
            // Additional check: Verify user is not already a member of the target group
            // This handles edge cases where the user object might not be fully loaded
            Boolean alreadyMember = userRepository.existsByUserIdAndGroupId(userId, groupId);
            if (Boolean.TRUE.equals(alreadyMember)) {
                throw new RuntimeException("You are already a member of this group.");
            }

            // Find group with proper error handling
            Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new RuntimeException("Group not found"));

            // Additional validation: Check if group is active/valid
            if (group.getGroupName() == null || group.getGroupName().trim().isEmpty()) {
                throw new RuntimeException("Invalid group data");
            }

            // Set the group relationship
            user.setGroup(group);
            user.setUpdatedAt(LocalDateTime.now());
            
            // Save the user with the new group relationship
            userRepository.save(user);
            
        } catch (RuntimeException e) {
            // Re-throw runtime exceptions as they contain user-friendly messages
            throw e;
        } catch (Exception e) {
            // Log unexpected errors and throw a generic message
            System.err.println("Error joining group: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("An unexpected error occurred while joining the group. Please try again.");
        }
    }

    public void leaveGroup(Long userId) {
        try {
            // Validate input parameters
            if (userId == null) {
                throw new RuntimeException("User ID cannot be null");
            }

            // Find user with proper error handling
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

            // Check if user is in a group
            if (user.getGroup() == null) {
                throw new RuntimeException("You are not in any group");
            }

            // Clear the group relationship
            user.setGroup(null);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
            
        } catch (RuntimeException e) {
            // Re-throw runtime exceptions as they contain user-friendly messages
            throw e;
        } catch (Exception e) {
            // Log unexpected errors and throw a generic message
            System.err.println("Error leaving group: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("An unexpected error occurred while leaving the group. Please try again.");
        }
    }

    /**
     * Check if a user can join a specific group
     * @param userId The user ID
     * @param groupId The group ID
     * @return true if user can join, false otherwise
     */
    public boolean canJoinGroup(Long userId, Long groupId) {
        try {
            if (userId == null || groupId == null) {
                return false;
            }

            User user = userRepository.findById(userId).orElse(null);
            if (user == null) {
                return false;
            }

            // Check if user is already in a group
            if (user.getGroup() != null) {
                return false;
            }

            // Check if group exists
            Group group = groupRepository.findById(groupId).orElse(null);
            if (group == null) {
                return false;
            }

            // Check if user is already a member of this group
            Boolean alreadyMember = userRepository.existsByUserIdAndGroupId(userId, groupId);
            if (Boolean.TRUE.equals(alreadyMember)) {
                return false;
            }

            return true;
        } catch (Exception e) {
            System.err.println("Error checking if user can join group: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete user account after password confirmation
     * @param userId The user ID
     * @param password The user's current password for confirmation
     * @throws RuntimeException if password is incorrect or user not found
     */
    public void deleteAccount(Long userId, String password) {
        try {
            System.err.println("UserService.deleteAccount called with userId: " + userId);
            
            // Validate input parameters
            if (userId == null || password == null || password.trim().isEmpty()) {
                throw new RuntimeException("User ID and password are required");
            }

            // Find user with proper error handling
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            System.err.println("User found: " + user.getName() + " (ID: " + user.getId() + ")");

            // Validate password
            if (!validatePassword(password, user.getPassword())) {
                System.err.println("Password validation failed for user: " + user.getName());
                throw new RuntimeException("Incorrect password. Account not deleted.");
            }
            
            System.err.println("Password validation successful for user: " + user.getName());

            // Delete user profile picture if exists
            if (user.getProfilePicture() != null) {
                try {
                    Path uploadPath = Paths.get(uploadDir).toAbsolutePath();
                    Files.deleteIfExists(uploadPath.resolve(user.getProfilePicture()));
                    System.err.println("Profile picture deleted: " + user.getProfilePicture());
                } catch (IOException e) {
                    // Log but don't throw - we still want to delete the user
                    System.err.println("Failed to delete profile picture: " + e.getMessage());
                }
            }

            // Clear user relationships before deletion to avoid foreign key constraint violations
            System.err.println("Clearing user relationships...");
            
            // Delete UserTask records
            List<UserTask> userTasks = userTaskRepository.findByUserId(userId);
            if (!userTasks.isEmpty()) {
                userTaskRepository.deleteAll(userTasks);
                System.err.println("Deleted " + userTasks.size() + " UserTask records");
            }
            
            // Delete UserTopicProgress records
            List<UserTopicProgress> userTopicProgresses = userTopicProgressRepository.findByUserId(userId);
            if (!userTopicProgresses.isEmpty()) {
                userTopicProgressRepository.deleteAll(userTopicProgresses);
                System.err.println("Deleted " + userTopicProgresses.size() + " UserTopicProgress records");
            }
            
            // Delete GroupMessage records
            List<GroupMessage> groupMessages = groupMessageRepository.findByUserId(userId);
            if (!groupMessages.isEmpty()) {
                groupMessageRepository.deleteAll(groupMessages);
                System.err.println("Deleted " + groupMessages.size() + " GroupMessage records");
            }
            
            // Clear completed tasks relationship
            if (user.getCompletedTasks() != null) {
                user.getCompletedTasks().clear();
            }
            
            // Clear unlocked rewards relationship
            if (user.getUnlockedRewards() != null) {
                user.getUnlockedRewards().clear();
            }
            
            // Clear group relationship
            user.setGroup(null);
            
            // Save the user with cleared relationships
            userRepository.save(user);
            System.err.println("User relationships cleared");

            // Delete the user from database
            System.err.println("Deleting user from database: " + user.getName());
            userRepository.deleteById(userId);
            System.err.println("User deleted successfully from database");
            
        } catch (RuntimeException e) {
            // Re-throw runtime exceptions as they contain user-friendly messages
            System.err.println("RuntimeException in deleteAccount: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            // Log unexpected errors and throw a generic message
            System.err.println("Error deleting account: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("An unexpected error occurred while deleting your account. Please try again.");
        }
    }
}
