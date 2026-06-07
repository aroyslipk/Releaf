package com.example.demo.service;

import com.example.demo.entity.UserTopicProgress;
import com.example.demo.entity.User;
import com.example.demo.entity.Task;
import com.example.demo.repository.UserTopicProgressRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.cache.annotation.CacheEvict;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserTopicProgressService {

    @Autowired
    private UserTopicProgressRepository userTopicProgressRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    // Define the topic order — must match task topic names in the database
    private static final List<String> TOPIC_ORDER = List.of(
        "Energy Conservation",
        "Water Conservation",
        "Waste Reduction",
        "Sustainable Transport",
        "Sustainable Food",
        "Clean Energy",
        "Air Quality",
        "Community Action"
    );

    // Unlocking requirements
    private static final int EASY_TASKS_REQUIRED_FOR_MEDIUM = 3;
    private static final int MEDIUM_TASKS_REQUIRED_FOR_HARD = 2;
    private static final int HARD_TASKS_REQUIRED_FOR_NEXT_TOPIC = 1;

    public void initializeUserProgress(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }

        User user = userOpt.get();
        
        // Check if user already has progress initialized
        List<UserTopicProgress> existingProgress = userTopicProgressRepository.findByUserIdOrderByTopicOrder(userId);
        
        // Detect stale/mismatched topic names and wipe them so we re-initialize
        if (!existingProgress.isEmpty()) {
            boolean mismatch = existingProgress.stream()
                .anyMatch(p -> !TOPIC_ORDER.contains(p.getTopic()));
            if (!mismatch) {
                return; // Already initialized with correct topics
            }
            // Delete stale records so we can re-initialize with correct topic names
            for (UserTopicProgress old : existingProgress) {
                userTopicProgressRepository.deleteById(old.getId());
            }
        }

        // Initialize progress for all topics
        for (int i = 0; i < TOPIC_ORDER.size(); i++) {
            String topic = TOPIC_ORDER.get(i);
            UserTopicProgress progress = new UserTopicProgress(user, topic, i + 1);
            
            // First two topics are unlocked by default
            if (i < 2) {
                progress.setIsUnlocked(true);
                progress.setEasyUnlocked(true);
            }
            
            userTopicProgressRepository.save(progress);
        }
    }

    public List<UserTopicProgress> getUserTopicProgress(Long userId) {
        return userTopicProgressRepository.findByUserIdOrderByTopicOrder(userId);
    }

    public Map<String, Object> getTopicProgressData(Long userId) {
        List<UserTopicProgress> progressList = getUserTopicProgress(userId);
        Map<String, Object> result = new HashMap<>();
        
        // Find current active topic and next topic
        UserTopicProgress currentTopic = null;
        UserTopicProgress nextTopic = null;
        
        // Get task counts for each topic from the database (not hardcoded)
        Map<String, Map<String, Integer>> taskCounts = new HashMap<>();
        for (String topic : TOPIC_ORDER) {
            Map<String, Integer> counts = new HashMap<>();
            
            // Query actual task counts from database
            long easyCount = taskRepository.countByTopicAndLevelAndTaskType(topic, "Easy", "GREENVERSE");
            long mediumCount = taskRepository.countByTopicAndLevelAndTaskType(topic, "Medium", "GREENVERSE");
            long hardCount = taskRepository.countByTopicAndLevelAndTaskType(topic, "Hard", "GREENVERSE");
            
            counts.put("easy", (int) easyCount);
            counts.put("medium", (int) mediumCount);
            counts.put("hard", (int) hardCount);
            counts.put("total", (int) (easyCount + mediumCount + hardCount));
            taskCounts.put(topic, counts);
        }
        result.put("taskCounts", taskCounts);
        
        // Find current topic: the most recently updated topic that has at least one completed task
        UserTopicProgress mostRecentlyUpdated = null;
        for (UserTopicProgress progress : progressList) {
            int totalCompleted = progress.getEasyCompleted() + progress.getMediumCompleted() + progress.getHardCompleted();
            if (totalCompleted > 0) {
                if (mostRecentlyUpdated == null || progress.getUpdatedAt().isAfter(mostRecentlyUpdated.getUpdatedAt())) {
                    mostRecentlyUpdated = progress;
                }
            }
        }
        currentTopic = mostRecentlyUpdated;
        
        // If no topic has been started yet, use the first unlocked topic
        if (currentTopic == null && !progressList.isEmpty()) {
            currentTopic = progressList.stream()
                .filter(UserTopicProgress::getIsUnlocked)
                .findFirst()
                .orElse(progressList.get(0));
        }
        
        // Find next topic (if current topic is fully completed, next unlocked topic)
        if (currentTopic != null) {
            int currentIndex = progressList.indexOf(currentTopic);
            if (currentIndex + 1 < progressList.size()) {
                nextTopic = progressList.get(currentIndex + 1);
            }
        }
        
        result.put("progressList", progressList);
        result.put("currentTopic", currentTopic);
        result.put("nextTopic", nextTopic);
        result.put("topicOrder", TOPIC_ORDER);
        
        return result;
    }

    @CacheEvict(value = "userTopicProgress", allEntries = true)
    public void updateTaskCompletion(Long userId, String taskTopic, String taskLevel) {
        Optional<UserTopicProgress> progressOpt = userTopicProgressRepository.findByUserIdAndTopic(userId, taskTopic);
        if (progressOpt.isEmpty()) {
            throw new RuntimeException("Topic progress not found for user");
        }

        UserTopicProgress progress = progressOpt.get();
        
        // Update completion count based on task level
        switch (taskLevel.toLowerCase()) {
            case "easy":
                progress.setEasyCompleted(progress.getEasyCompleted() + 1);
                break;
            case "medium":
                progress.setMediumCompleted(progress.getMediumCompleted() + 1);
                break;
            case "hard":
                progress.setHardCompleted(progress.getHardCompleted() + 1);
                break;
        }

        // IMPORTANT: Explicitly set updatedAt to current time so this topic becomes "current"
        progress.setUpdatedAt(java.time.LocalDateTime.now());

        // Check unlocking logic
        checkAndUpdateUnlocks(progress);
        
        userTopicProgressRepository.save(progress);
    }

    private void checkAndUpdateUnlocks(UserTopicProgress progress) {
        boolean changed = false;

        // Check if Medium should be unlocked
        if (!progress.getMediumUnlocked() && progress.getEasyCompleted() >= EASY_TASKS_REQUIRED_FOR_MEDIUM) {
            progress.setMediumUnlocked(true);
            changed = true;
        }

        // Check if Hard should be unlocked
        if (!progress.getHardUnlocked() && progress.getMediumCompleted() >= MEDIUM_TASKS_REQUIRED_FOR_HARD) {
            progress.setHardUnlocked(true);
            changed = true;
        }

        // Check if next topic should be unlocked
        if (progress.getHardCompleted() >= HARD_TASKS_REQUIRED_FOR_NEXT_TOPIC) {
            Optional<UserTopicProgress> nextTopicProgress = userTopicProgressRepository
                .findByUserIdAndTopicOrder(progress.getUser().getId(), progress.getTopicOrder() + 1);
            
            if (nextTopicProgress.isPresent()) {
                UserTopicProgress nextTopic = nextTopicProgress.get();
                if (!nextTopic.getIsUnlocked()) {
                    nextTopic.setIsUnlocked(true);
                    nextTopic.setEasyUnlocked(true);
                    userTopicProgressRepository.save(nextTopic);
                }
            }
        }

        if (changed) {
            userTopicProgressRepository.save(progress);
        }
    }

    private boolean isTopicFullyCompleted(UserTopicProgress progress, Map<String, Integer> taskCounts) {
        // A topic is considered fully completed when the user has completed all available tasks
        return progress.getEasyCompleted() >= 3 &&
               progress.getMediumCompleted() >= 3 &&
               progress.getHardCompleted() >= 3;
    }

    @SuppressWarnings("unused")
    private boolean isTopicCompleted(UserTopicProgress progress) {
        // A topic is considered completed when all difficulty levels are unlocked
        // and the user has completed at least one task from each level
        return progress.getEasyUnlocked() && progress.getMediumUnlocked() && progress.getHardUnlocked() &&
               progress.getEasyCompleted() > 0 && progress.getMediumCompleted() > 0 && progress.getHardCompleted() > 0;
    }

    public List<Task> getAvailableTasksForUser(Long userId) {
        List<UserTopicProgress> progressList = getUserTopicProgress(userId);
        List<Task> availableTasks = new ArrayList<>();

        for (UserTopicProgress progress : progressList) {
            if (!progress.getIsUnlocked()) {
                continue; // Skip locked topics
            }

            // Get tasks for each unlocked difficulty level
            if (progress.getEasyUnlocked()) {
                List<Task> easyTasks = taskRepository.findByTopicAndLevel(progress.getTopic(), "Easy");
                availableTasks.addAll(easyTasks);
            }

            if (progress.getMediumUnlocked()) {
                List<Task> mediumTasks = taskRepository.findByTopicAndLevel(progress.getTopic(), "Medium");
                availableTasks.addAll(mediumTasks);
            }

            if (progress.getHardUnlocked()) {
                List<Task> hardTasks = taskRepository.findByTopicAndLevel(progress.getTopic(), "Hard");
                availableTasks.addAll(hardTasks);
            }
        }

        return availableTasks;
    }
    
    /**
     * Get INCOMPLETE available tasks for user (excludes completed tasks)
     * This is used for dashboard "Available Tasks" count
     */
    public List<Task> getIncompleteAvailableTasksForUser(Long userId) {
        List<Task> allAvailableTasks = getAvailableTasksForUser(userId);
        
        // Get user's completed tasks
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return allAvailableTasks;
        }
        
        User user = userOpt.get();
        Set<Task> completedTasks = user.getCompletedTasks();
        
        // Filter out completed tasks
        return allAvailableTasks.stream()
                .filter(task -> !completedTasks.contains(task))
                .collect(Collectors.toList());
    }

    public boolean isTaskAvailableForUser(Long userId, Long taskId) {
        Optional<Task> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isEmpty()) {
            return false;
        }

        Task task = taskOpt.get();
        Optional<UserTopicProgress> progressOpt = userTopicProgressRepository.findByUserIdAndTopic(userId, task.getTopic());
        
        if (progressOpt.isEmpty()) {
            return false;
        }

        UserTopicProgress progress = progressOpt.get();
        
        if (!progress.getIsUnlocked()) {
            return false;
        }

        // Check if the difficulty level is unlocked
        switch (task.getLevel().toLowerCase()) {
            case "easy":
                return progress.getEasyUnlocked();
            case "medium":
                return progress.getMediumUnlocked();
            case "hard":
                return progress.getHardUnlocked();
            default:
                return false;
        }
    }
} 