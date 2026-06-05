package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.TaskGuide;
import com.example.demo.repository.TaskGuideRepository;
import com.example.demo.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class TaskGuideService {

    @Autowired
    private TaskGuideRepository taskGuideRepository;

    @Autowired
    private TaskRepository taskRepository;

    public Optional<TaskGuide> getGuideByTaskId(Long taskId) {
        return taskGuideRepository.findByTaskId(taskId);
    }

    /**
     * Returns guide data as a plain Map (fully resolved within transaction).
     */
    public Map<String, Object> getGuideDataAsMap(Long taskId) {
        Optional<TaskGuide> guideOpt = taskGuideRepository.findByTaskId(taskId);
        if (guideOpt.isEmpty()) {
            return null;
        }

        TaskGuide guide = guideOpt.get();
        Map<String, Object> guideData = new HashMap<>();
        guideData.put("notes", guide.getNotes() != null ? guide.getNotes() : "");
        return guideData;
    }

    public TaskGuide saveOrUpdateGuide(Long taskId, String notes) {
        Optional<Task> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isEmpty()) {
            throw new RuntimeException("Task not found with ID: " + taskId);
        }

        Task task = taskOpt.get();

        // Get existing guide or create new one
        TaskGuide guide = taskGuideRepository.findByTaskId(taskId)
                .orElse(new TaskGuide(task));

        // Update notes
        guide.setNotes(notes != null ? notes.trim() : "");

        return taskGuideRepository.save(guide);
    }

    public void deleteGuide(Long taskId) {
        taskGuideRepository.deleteByTaskId(taskId);
    }

    public boolean hasGuide(Long taskId) {
        return taskGuideRepository.existsByTaskId(taskId);
    }
}