package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserTopicProgressRepository;
import com.example.demo.entity.Task;
import com.example.demo.entity.UserTopicProgress;
import java.util.List;

@Component
public class TopicUpdater implements CommandLineRunner {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserTopicProgressRepository userTopicProgressRepository;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Starting topic name update...");
        
        // Update tasks
        List<Task> tasks = taskRepository.findAll();
        for (Task task : tasks) {
            String oldTopic = task.getTopic();
            String newTopic = getNewTopicName(oldTopic);
            if (!oldTopic.equals(newTopic)) {
                task.setTopic(newTopic);
                taskRepository.save(task);
                System.out.println("Updated task: " + oldTopic + " -> " + newTopic);
            }
        }
        
        // Update user topic progress
        List<UserTopicProgress> progressList = userTopicProgressRepository.findAll();
        for (UserTopicProgress progress : progressList) {
            String oldTopic = progress.getTopic();
            String newTopic = getNewTopicName(oldTopic);
            if (!oldTopic.equals(newTopic)) {
                progress.setTopic(newTopic);
                userTopicProgressRepository.save(progress);
                System.out.println("Updated progress: " + oldTopic + " -> " + newTopic);
            }
        }
        
        System.out.println("Topic name update completed!");
    }
    
    private String getNewTopicName(String oldTopic) {
        switch (oldTopic) {
            case "Waste & Plastic Pollution":
                return "Plastronauts";
            case "Air Pollution":
                return "Aether Shield";
            case "Water Pollution & Conservation":
                return "Hydronauts";
            case "Climate Change":
                return "ChronoClimbers";
            case "Deforestation & Biodiversity Loss":
                return "Verdantra";
            case "Soil & Land Degradation":
                return "TerraFixers";
            case "Industrial & Urban Pollution":
                return "SmogSmiths";
            case "Lack of Awareness & Environmental Education":
                return "EcoMentors";
            default:
                return oldTopic;
        }
    }
} 