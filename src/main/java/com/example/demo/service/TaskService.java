package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    private static final List<String> UNWANTED_TOPICS = Arrays.asList("FUNLAB", "funlab");

    private static final List<String[]> DEFAULT_TASKS = Arrays.asList(
        new String[]{"Energy Conservation", "Easy", "Turn off lights when leaving a room for more than 15 minutes"},
        new String[]{"Energy Conservation", "Medium", "Replace all incandescent bulbs with LED alternatives"},
        new String[]{"Energy Conservation", "Hard", "Conduct a full home energy audit and implement top 3 recommendations"},
        new String[]{"Water Conservation", "Easy", "Take a shower under 5 minutes"},
        new String[]{"Water Conservation", "Medium", "Install a low-flow showerhead"},
        new String[]{"Water Conservation", "Hard", "Set up a rainwater collection system for garden use"},
        new String[]{"Waste Reduction", "Easy", "Bring reusable bags to the grocery store"},
        new String[]{"Waste Reduction", "Medium", "Start a compost bin for food scraps"},
        new String[]{"Waste Reduction", "Hard", "Achieve zero-waste for one full week"},
        new String[]{"Sustainable Transport", "Easy", "Walk or cycle for a trip you would normally drive"},
        new String[]{"Sustainable Transport", "Medium", "Use public transport for your commute for one week"},
        new String[]{"Sustainable Transport", "Hard", "Organise a carpool arrangement with colleagues or neighbours"},
        new String[]{"Sustainable Food", "Easy", "Have one meat-free meal today"},
        new String[]{"Sustainable Food", "Medium", "Buy only locally grown produce for one week"},
        new String[]{"Sustainable Food", "Hard", "Grow your own vegetables or herbs for one month"}
    );

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Optional<Task> findById(Long id) {
        return taskRepository.findById(id);
    }

    public Task createTask(String topic, String level, String description) {
        Task task = new Task(topic, level, description);
        task.setTaskType("GREENVERSE");
        task.setCategory("GREENVERSE");
        return taskRepository.save(task);
    }

    public Task createFunLabTask(String topic, String level, String description, String impact, String proofType) {
        Task task = new Task(topic, level, description, "FUNLAB", impact, proofType);
        task.setCategory("FUNLAB");
        return taskRepository.save(task);
    }

    public Task updateTask(Task task) {
        task.setUpdatedAt(LocalDateTime.now());
        return taskRepository.save(task);
    }

    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }

    public List<Task> getFunLabTasks() {
        return taskRepository.findByTaskType("FUNLAB");
    }

    public List<Task> getTasksByTypeAndTopic(String taskType, String topic) {
        return taskRepository.findByTaskTypeAndTopic(taskType, topic);
    }

    public List<Task> getTasksByTypeAndLevel(String taskType, String level) {
        return taskRepository.findByTaskTypeAndLevel(taskType, level);
    }

    public List<String> getTopicsByTaskType(String taskType) {
        return taskRepository.findTopicsByTaskType(taskType);
    }

    public List<String> getLevelsByTaskType(String taskType) {
        return taskRepository.findLevelsByTaskType(taskType);
    }

    public List<String> getAllLevels() {
        return taskRepository.findAllLevels();
    }

    public List<String> getTopicsExcludingUnwanted() {
        return taskRepository.findAllTopics().stream()
            .filter(t -> !UNWANTED_TOPICS.contains(t))
            .collect(Collectors.toList());
    }

    public List<Task> findTasksByCriteria(String topic, String level) {
        if (topic != null && !topic.isEmpty() && level != null && !level.isEmpty()) {
            return taskRepository.findByTopicAndLevelAndTaskType(topic, level, "GREENVERSE");
        } else if (topic != null && !topic.isEmpty()) {
            return taskRepository.findByTopicAndTaskType(topic, "GREENVERSE");
        } else if (level != null && !level.isEmpty()) {
            return taskRepository.findByLevelAndTaskType(level, "GREENVERSE");
        } else {
            return taskRepository.findByTaskType("GREENVERSE");
        }
    }

    public long countTasksByTopicAndLevel(String topic, String level) {
        return taskRepository.countTasksByTopicAndLevel(topic, level);
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

    public void initializeDefaultTasks() {
        long count = taskRepository.countByTaskType("GREENVERSE");
        if (count == 0) {
            for (String[] taskData : DEFAULT_TASKS) {
                Task task = new Task(taskData[0], taskData[1], taskData[2]);
                task.setTaskType("GREENVERSE");
                task.setCategory("GREENVERSE");
                taskRepository.save(task);
            }
        }
    }
}
