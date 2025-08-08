package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserTaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.stream.Collectors;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;
import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;

@Service
@Transactional
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    // ############ START: ADDED NEW METHOD ############
    /**
     * Finds tasks based on optional topic and level criteria.
     * This method handles all filtering logic.
     */
    public List<Task> findTasksByCriteria(String topic, String level) {
        boolean hasTopic = StringUtils.hasText(topic);
        boolean hasLevel = StringUtils.hasText(level);
        
        List<Task> tasks;
        if (hasTopic && hasLevel) {
            tasks = taskRepository.findByTopicAndLevel(topic, level);
        } else if (hasTopic) {
            tasks = taskRepository.findByTopic(topic);
        } else if (hasLevel) {
            tasks = taskRepository.findByLevel(level);
        } else {
            tasks = taskRepository.findAll();
        }
        
        // Filter out FUNLAB tasks
        return tasks.stream()
                   .filter(task -> !"FUNLAB".equals(task.getTaskType()))
                   .collect(Collectors.toList());
    }
    // ############ END: ADDED NEW METHOD ############
    
    public Task createTask(String topic, String level, String description) {
        Task task = new Task(topic, level, description);
        return taskRepository.save(task);
    }

    public Task createFunLabTask(String topic, String level, String description, String impact, String proofType) {
        Task task = new Task(topic, level, description, "FUNLAB", impact, proofType);
        return taskRepository.save(task);
    }

    public Optional<Task> findById(Long id) {
        return taskRepository.findById(id);
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public List<Task> getTasksByTopic(String topic) {
        return taskRepository.findByTopic(topic);
    }

    public List<Task> getTasksByLevel(String level) {
        return taskRepository.findByLevel(level);
    }

    public List<Task> getTasksByTopicAndLevel(String topic, String level) {
        return taskRepository.findByTopicAndLevel(topic, level);
    }

    public List<Task> getTasksByType(String taskType) {
        return taskRepository.findByTaskType(taskType);
    }

    public List<Task> getFunLabTasks() {
        return taskRepository.findByTaskType("FUNLAB");
    }

    public List<Task> getGreenverseTasks() {
        return taskRepository.findByTaskType("GREENVERSE");
    }

    public List<Task> getTasksByTypeAndTopic(String taskType, String topic) {
        return taskRepository.findByTaskTypeAndTopic(taskType, topic);
    }

    public List<Task> getTasksByTypeAndLevel(String taskType, String level) {
        return taskRepository.findByTaskTypeAndLevel(taskType, level);
    }

    public List<Task> getTasksByTypeNotCompletedByUser(String taskType, Long userId) {
        return taskRepository.findTasksByTypeNotCompletedByUser(taskType, userId);
    }

    public List<String> getAllTopics() {
        return taskRepository.findAllTopics();
    }

    public List<String> getTopicsByTaskType(String taskType) {
        return taskRepository.findTopicsByTaskType(taskType);
    }

    public List<String> getAllLevels() {
        return taskRepository.findAllLevels();
    }

    public List<String> getLevelsByTaskType(String taskType) {
        return taskRepository.findLevelsByTaskType(taskType);
    }

    public void updateTask(Task task) {
        taskRepository.save(task);
    }

    @Autowired
    private UserTaskRepository userTaskRepository;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public void deleteTask(Long id) {
        Optional<Task> task = taskRepository.findById(id);
        if (task.isPresent()) {
            // First, remove this task from all users' completed tasks
            List<User> usersWithCompletedTask = userRepository.findAll().stream()
                .filter(user -> user.getCompletedTasks().contains(task.get()))
                .collect(Collectors.toList());
            
            for (User user : usersWithCompletedTask) {
                user.getCompletedTasks().remove(task.get());
                userRepository.save(user);
            }
            
            // Clear any users' last active task if it's the task being deleted
            List<User> usersWithLastActiveTask = userRepository.findAll().stream()
                .filter(user -> user.getLastActiveTaskId() != null && user.getLastActiveTaskId().equals(id))
                .collect(Collectors.toList());
            
            for (User user : usersWithLastActiveTask) {
                user.setLastActiveTaskId(null);
                userRepository.save(user);
            }
            
            // Then delete all related user_tasks entries
            userTaskRepository.deleteByTaskId(id);
            
            // Finally delete the task itself
            taskRepository.deleteById(id);
        }
    }

    public List<Task> findTasksNotCompletedByUser(Long userId) {
        return taskRepository.findTasksNotCompletedByUser(userId);
    }

    public Long countTasksByTopicAndLevel(String topic, String level) {
        return taskRepository.countTasksByTopicAndLevel(topic, level);
    }
    
    // Method to get topics excluding unwanted ones
    public List<String> getTopicsExcludingUnwanted() {
        return taskRepository.findAllTopics().stream()
                .filter(topic -> !topic.equals("nothing") && 
                               !topic.equals("Eco-Puzzle Day") && 
                               !topic.equals("Green Frame of the Day") && 
                               !topic.equals("Voice for Earth (1-Min Audio)"))
                .collect(Collectors.toList());
    }

    public void initializeDefaultTasks() {
        if (taskRepository.count() == 0) {
            // Initialize with some default tasks from the PDF
            createDefaultTasks();
        }
    }

    private void createDefaultTasks() {
        // Plastronauts - Easy Level
        createTask("Plastronauts", "Easy", "Use a reusable shopping bag for all purchases today.");
        createTask("Plastronauts", "Easy", "Collect and sort plastic bottles at home for recycling.");
        createTask("Plastronauts", "Easy", "Avoid using single-use plastic like straws or cutlery for 24 hours.");

        // Plastronauts - Medium Level
        createTask("Plastronauts", "Medium", "Create a waste separation bin at home (plastic, organic, e-waste).");
        createTask("Plastronauts", "Medium", "Avoid all plastic packaging for a day and document alternatives used.");
        createTask("Plastronauts", "Medium", "Educate a family member about reducing plastic usage and share proof.");

        // Plastronauts - Hard Level
        createTask("Plastronauts", "Hard", "Organize a small plastic cleanup in your neighborhood.");
        createTask("Plastronauts", "Hard", "DIY: Reuse plastic waste to create a functional household item.");
        createTask("Plastronauts", "Hard", "Track your plastic waste for 3 days and reduce it by 50% by day 3.");

        // Aether Shield - Easy Level
        createTask("Aether Shield", "Easy", "Walk or bike instead of driving for short trips today.");
        createTask("Aether Shield", "Easy", "Turn off all unnecessary lights and electronics for 2 hours.");
        createTask("Aether Shield", "Easy", "Plant a small herb or flower in a pot at home.");

        // Aether Shield - Medium Level
        createTask("Aether Shield", "Medium", "Use public transportation for all trips for one full day.");
        createTask("Aether Shield", "Medium", "Create a carpool plan with friends or colleagues for regular trips.");
        createTask("Aether Shield", "Medium", "Monitor and reduce your home's energy consumption for a week.");

        // Aether Shield - Hard Level
        createTask("Aether Shield", "Hard", "Organize a tree planting event in your community.");
        createTask("Aether Shield", "Hard", "Conduct an air quality assessment in your neighborhood.");
        createTask("Aether Shield", "Hard", "Advocate for cleaner transportation options in your area.");

        // Add more tasks for other topics...
        // Hydronauts
        createTask("Hydronauts", "Easy", "Take shorter showers (under 5 minutes) for a week.");
        createTask("Hydronauts", "Easy", "Fix any leaky faucets or pipes in your home.");
        createTask("Hydronauts", "Easy", "Use a reusable water bottle instead of buying plastic bottles.");

        // ChronoClimbers
        createTask("ChronoClimbers", "Easy", "Reduce meat consumption for one day per week.");
        createTask("ChronoClimbers", "Easy", "Unplug electronics when not in use for a full day.");
        createTask("ChronoClimbers", "Easy", "Learn about renewable energy sources and share your knowledge.");

        // Continue with other topics...
    }
}