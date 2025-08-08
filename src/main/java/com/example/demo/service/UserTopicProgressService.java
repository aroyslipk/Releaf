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

@Service
@Transactional
public class UserTopicProgressService {

    @Autowired
    private UserTopicProgressRepository userTopicProgressRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    // Define the topic order
    private static final List<String> TOPIC_ORDER = List.of(
        "Plastronauts",
        "Aether Shield", 
        "Hydronauts",
        "ChronoClimbers",
        "Verdantra",
        "TerraFixers",
        "SmogSmiths",
        "EcoMentors"
    );

    // Unlocking requirements
    private static final int EASY_TASKS_REQUIRED_FOR_MEDIUM = 2;
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
        if (!existingProgress.isEmpty()) {
            return; // Already initialized
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
        
        // Get task counts for each topic
        Map<String, Map<String, Integer>> taskCounts = new HashMap<>();
        for (String topic : TOPIC_ORDER) {
            Map<String, Integer> counts = new HashMap<>();
            counts.put("easy", 3); // Fixed count of 3 tasks per difficulty
            counts.put("medium", 3);
            counts.put("hard", 3);
            counts.put("total", 9); // Total of 9 tasks per topic
            taskCounts.put(topic, counts);
        }
        result.put("taskCounts", taskCounts);
        
        // Find the most recently active topic that isn't completed
        for (UserTopicProgress progress : progressList) {
            if (progress.getIsUnlocked()) {
                Map<String, Integer> counts = taskCounts.get(progress.getTopic());
                if (counts != null && !isTopicFullyCompleted(progress, counts)) {
                    currentTopic = progress;
                    // Don't break here - we want the last incomplete topic
                }
            }
        }
        
        // If no current topic was found, use the first unlocked topic
        if (currentTopic == null && !progressList.isEmpty()) {
            currentTopic = progressList.stream()
                .filter(UserTopicProgress::getIsUnlocked)
                .findFirst()
                .orElse(progressList.get(0));
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
        return progress.getEasyCompleted() >= taskCounts.get("easy") &&
               progress.getMediumCompleted() >= taskCounts.get("medium") &&
               progress.getHardCompleted() >= taskCounts.get("hard");
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