package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserTaskRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.AdminNotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.stream.Collectors;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@Service
@Transactional
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserTaskRepository userTaskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskGuideService taskGuideService;

    @Autowired
    private AdminNotificationRepository adminNotificationRepository;

    /**
     * Finds tasks based on optional topic and level criteria.
     */
    public List<Task> findTasksByCriteria(String topic, String level) {
        try {
            boolean hasTopic = StringUtils.hasText(topic);
            boolean hasLevel = StringUtils.hasText(level);

            List<Task> tasks;
            if (hasTopic && hasLevel) {
                tasks = taskRepository.findByTopicAndLevelAndTaskType(topic, level, "GREENVERSE");
            } else if (hasTopic) {
                tasks = taskRepository.findByTopicAndTaskType(topic, "GREENVERSE");
            } else if (hasLevel) {
                tasks = taskRepository.findByLevelAndTaskType(level, "GREENVERSE");
            } else {
                tasks = taskRepository.findByTaskType("GREENVERSE");
            }

            return tasks != null ? tasks : List.of();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public Task createTask(String topic, String level, String description) {
        Task task = new Task(topic, level, description);

        switch (level) {
            case "Easy":
                task.setXpReward(10);
                break;
            case "Medium":
                task.setXpReward(20);
                break;
            case "Hard":
                task.setXpReward(30);
                break;
            default:
                task.setXpReward(10);
        }

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

    @Transactional
    public void deleteTask(Long id) {
        Optional<Task> task = taskRepository.findById(id);
        if (task.isPresent()) {
            try {
                adminNotificationRepository.deleteByTaskId(id);
            } catch (Exception e) {
                System.out.println("No notifications to delete or error: " + e.getMessage());
            }

            try {
                taskGuideService.deleteGuide(id);
            } catch (Exception e) {
                System.out.println("No guide to delete or error: " + e.getMessage());
            }

            List<User> usersWithCompletedTask = userRepository.findByCompletedTaskId(id);
            for (User user : usersWithCompletedTask) {
                user.getCompletedTasks().remove(task.get());
                userRepository.save(user);
            }

            List<User> usersWithLastActiveTask = userRepository.findAll().stream()
                .filter(user -> user.getLastActiveTaskId() != null && user.getLastActiveTaskId().equals(id))
                .collect(Collectors.toList());
            for (User user : usersWithLastActiveTask) {
                user.setLastActiveTaskId(null);
                userRepository.save(user);
            }

            userTaskRepository.deleteByTaskId(id);
            taskRepository.deleteById(id);
        }
    }

    public List<Task> findTasksNotCompletedByUser(Long userId) {
        return taskRepository.findTasksNotCompletedByUser(userId);
    }

    public Long countTasksByTopicAndLevel(String topic, String level) {
        return taskRepository.countTasksByTopicAndLevel(topic, level);
    }

    public List<String> getTopicsExcludingUnwanted() {
        return taskRepository.findAllTopics().stream()
                .filter(topic -> !topic.equals("nothing") &&
                               !topic.equals("Eco-Puzzle Day") &&
                               !topic.equals("Green Frame of the Day") &&
                               !topic.equals("Voice for Earth (1-Min Audio)"))
                .collect(Collectors.toList());
    }

    public void initializeDefaultTasks() {
        long count = taskRepository.count();
        if (count == 0) {
            createDefaultTasks();
        } else if (count < 72) {
            System.out.println("Found " + count + " tasks. Filling missing default tasks to reach 72...");
            createMissingDefaultTasks();
        }
    }

    private void createMissingDefaultTasks() {
        Set<String> existingTopics = new HashSet<>();
        Map<String, Long> topicCounts = new HashMap<>();

        List<Task> allTasks = taskRepository.findByTaskType("GREENVERSE");
        for (Task t : allTasks) {
            existingTopics.add(t.getTopic());
            topicCounts.merge(t.getTopic(), 1L, Long::sum);
        }

        String[] requiredTopics = {
            "Plastronauts", "Aether Shield", "Hydronauts", "ChronoClimbers",
            "Terra Guardians", "Eco Warriors", "Green Chefs", "Wildlife Defenders"
        };

        boolean needsFullInit = false;
        for (String topic : requiredTopics) {
            Long c = topicCounts.get(topic);
            if (c == null || c < 9) {
                needsFullInit = true;
                System.out.println("Topic '" + topic + "' has " + (c == null ? 0 : c) + " tasks (needs 9). Starting full init...");
                break;
            }
        }

        if (needsFullInit) {
            List<Task> existing = taskRepository.findByTaskType("GREENVERSE");
            System.out.println("Removing " + existing.size() + " old GREENVERSE tasks...");

            for (Task t : existing) {
                List<User> users = userRepository.findByCompletedTaskId(t.getId());
                for (User u : users) {
                    u.getCompletedTasks().remove(t);
                    userRepository.save(u);
                }
                userTaskRepository.deleteByTaskId(t.getId());
            }

            taskRepository.deleteAll(existing);

            System.out.println("Creating all 72 fresh tasks...");
            createDefaultTasks();
            System.out.println("Migration complete! Total tasks now: " + taskRepository.count());
        } else {
            System.out.println("All 72 tasks already present. No migration needed.");
        }
    }

    private void createDefaultTasks() {
        // ================================================================
        // 8 TOPICS x 3 LEVELS x 3 TASKS = 72 TOTAL DEFAULT TASKS
        // ================================================================

        // 1. PLASTRONAUTS
        createTask("Plastronauts", "Easy", "Use a reusable shopping bag for all purchases today.");
        createTask("Plastronauts", "Easy", "Collect and sort plastic bottles at home for recycling.");
        createTask("Plastronauts", "Easy", "Avoid using single-use plastic like straws or cutlery for 24 hours.");
        createTask("Plastronauts", "Medium", "Create a waste separation bin at home (plastic, organic, e-waste).");
        createTask("Plastronauts", "Medium", "Avoid all plastic packaging for a day and document alternatives used.");
        createTask("Plastronauts", "Medium", "Educate a family member about reducing plastic usage and share proof.");
        createTask("Plastronauts", "Hard", "Organize a small plastic cleanup in your neighborhood.");
        createTask("Plastronauts", "Hard", "DIY: Reuse plastic waste to create a functional household item.");
        createTask("Plastronauts", "Hard", "Track your plastic waste for 3 days and reduce it by 50% by day 3.");

        // 2. AETHER SHIELD
        createTask("Aether Shield", "Easy", "Walk or bike instead of driving for short trips today.");
        createTask("Aether Shield", "Easy", "Turn off all unnecessary lights and electronics for 2 hours.");
        createTask("Aether Shield", "Easy", "Plant a small herb or flower in a pot at home.");
        createTask("Aether Shield", "Medium", "Use public transportation for all trips for one full day.");
        createTask("Aether Shield", "Medium", "Create a carpool plan with friends or colleagues for regular trips.");
        createTask("Aether Shield", "Medium", "Monitor and reduce your home's energy consumption for a week.");
        createTask("Aether Shield", "Hard", "Organize a tree planting event in your community.");
        createTask("Aether Shield", "Hard", "Conduct an air quality assessment in your neighborhood.");
        createTask("Aether Shield", "Hard", "Advocate for cleaner transportation options in your area.");

        // 3. HYDRONAUTS
        createTask("Hydronauts", "Easy", "Take shorter showers (under 5 minutes) for a week.");
        createTask("Hydronauts", "Easy", "Fix any leaky faucets or pipes in your home.");
        createTask("Hydronauts", "Easy", "Use a reusable water bottle instead of buying plastic bottles.");
        createTask("Hydronauts", "Medium", "Collect rainwater for watering plants for one week.");
        createTask("Hydronauts", "Medium", "Install a water-saving showerhead or faucet aerator.");
        createTask("Hydronauts", "Medium", "Track your water usage for 3 days and identify waste areas.");
        createTask("Hydronauts", "Hard", "Organize a river or lake cleanup in your community.");
        createTask("Hydronauts", "Hard", "Create a water conservation campaign for your school or workplace.");
        createTask("Hydronauts", "Hard", "Build a simple greywater recycling system for garden use.");

        // 4. CHRONOCLIMBERS
        createTask("ChronoClimbers", "Easy", "Reduce meat consumption for one day per week.");
        createTask("ChronoClimbers", "Easy", "Unplug electronics when not in use for a full day.");
        createTask("ChronoClimbers", "Easy", "Learn about renewable energy sources and share your knowledge.");
        createTask("ChronoClimbers", "Medium", "Calculate your carbon footprint using an online calculator.");
        createTask("ChronoClimbers", "Medium", "Switch to energy-efficient LED bulbs in your home.");
        createTask("ChronoClimbers", "Medium", "Start composting food waste for one week.");
        createTask("ChronoClimbers", "Hard", "Write to local representatives about climate action policies.");
        createTask("ChronoClimbers", "Hard", "Organize a climate awareness workshop in your community.");
        createTask("ChronoClimbers", "Hard", "Go zero-waste for 3 days and document your experience.");

        // 5. TERRA GUARDIANS
        createTask("Terra Guardians", "Easy", "Start a small kitchen garden with herbs or vegetables.");
        createTask("Terra Guardians", "Easy", "Avoid using chemical pesticides in your garden for a week.");
        createTask("Terra Guardians", "Easy", "Learn about composting and start a small compost pile.");
        createTask("Terra Guardians", "Medium", "Plant 5 native trees or plants in your local area.");
        createTask("Terra Guardians", "Medium", "Create a bee-friendly garden with pollinator plants.");
        createTask("Terra Guardians", "Medium", "Test your soil quality and learn about soil health.");
        createTask("Terra Guardians", "Hard", "Start a community garden in your neighborhood.");
        createTask("Terra Guardians", "Hard", "Restore a degraded piece of land with native plants.");
        createTask("Terra Guardians", "Hard", "Create an educational video about soil conservation.");

        // 6. ECO WARRIORS
        createTask("Eco Warriors", "Easy", "Bring your own container for takeout food.");
        createTask("Eco Warriors", "Easy", "Switch to eco-friendly cleaning products at home.");
        createTask("Eco Warriors", "Easy", "Read and share one article about environmental sustainability.");
        createTask("Eco Warriors", "Medium", "Host a clothing swap event with friends or family.");
        createTask("Eco Warriors", "Medium", "Audit your home's energy usage and create a reduction plan.");
        createTask("Eco Warriors", "Medium", "Start using a bamboo toothbrush and bar soap instead of bottled.");
        createTask("Eco Warriors", "Hard", "Organize an eco-fair or sustainability workshop in your area.");
        createTask("Eco Warriors", "Hard", "Mentor 3 people on adopting sustainable lifestyle habits.");
        createTask("Eco Warriors", "Hard", "Create a sustainability challenge for your community (30 days).");

        // 7. GREEN CHEFS
        createTask("Green Chefs", "Easy", "Cook one meal using only locally sourced ingredients.");
        createTask("Green Chefs", "Easy", "Avoid food waste for a full day - use all leftovers creatively.");
        createTask("Green Chefs", "Easy", "Try one plant-based meal if you usually eat meat.");
        createTask("Green Chefs", "Medium", "Visit a local farmers market and buy seasonal produce.");
        createTask("Green Chefs", "Medium", "Make your own bread, yogurt, or cheese from scratch.");
        createTask("Green Chefs", "Medium", "Plan a week of meals to minimize food waste.");
        createTask("Green Chefs", "Hard", "Teach a cooking class about sustainable food practices.");
        createTask("Green Chefs", "Hard", "Create a cookbook of zero-waste recipes and share it.");
        createTask("Green Chefs", "Hard", "Start a community food-sharing or meal-prep program.");

        // 8. WILDLIFE DEFENDERS
        createTask("Wildlife Defenders", "Easy", "Build a small bird feeder or birdhouse for your garden.");
        createTask("Wildlife Defenders", "Easy", "Identify 5 local bird or insect species in your area.");
        createTask("Wildlife Defenders", "Easy", "Avoid using products that harm wildlife (palm oil, etc.).");
        createTask("Wildlife Defenders", "Medium", "Create a wildlife-friendly corner in your garden or balcony.");
        createTask("Wildlife Defenders", "Medium", "Volunteer at a local animal shelter or wildlife rescue.");
        createTask("Wildlife Defenders", "Medium", "Document local biodiversity through photos and share online.");
        createTask("Wildlife Defenders", "Hard", "Organize a habitat restoration project in your area.");
        createTask("Wildlife Defenders", "Hard", "Create an awareness campaign about endangered local species.");
        createTask("Wildlife Defenders", "Hard", "Build a pond or water feature to attract local wildlife.");
    }

    public int getTotalTasksCount() {
        return (int) taskRepository.count();
    }

    public int getCompletedTasksCount(Long userId) {
        return taskRepository.countCompletedTasksByUserId(userId);
    }

    public int getActiveTasksCount(Long userId) {
        return taskRepository.countActiveTasksByUserId(userId);
    }
}
