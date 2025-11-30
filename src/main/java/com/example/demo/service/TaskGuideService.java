package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.TaskGuide;
import com.example.demo.repository.TaskGuideRepository;
import com.example.demo.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class TaskGuideService {

    @Autowired
    private TaskGuideRepository taskGuideRepository;

    @Autowired
    private TaskRepository taskRepository;

    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/guide-examples/";

    public Optional<TaskGuide> getGuideByTaskId(Long taskId) {
        return taskGuideRepository.findByTaskId(taskId);
    }

    public TaskGuide saveOrUpdateGuide(Long taskId, 
                                       List<String> stepTitles, 
                                       List<String> stepDescriptions,
                                       String videoUrl, 
                                       String videoTitle,
                                       List<String> tips,
                                       List<MultipartFile> exampleImages) throws IOException {
        
        Optional<Task> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isEmpty()) {
            throw new RuntimeException("Task not found with ID: " + taskId);
        }

        Task task = taskOpt.get();
        
        // Get existing guide or create new one
        TaskGuide guide = taskGuideRepository.findByTaskId(taskId)
                .orElse(new TaskGuide(task));

        // Update steps
        if (stepTitles != null && !stepTitles.isEmpty()) {
            List<TaskGuide.GuideStep> steps = new ArrayList<>();
            for (int i = 0; i < stepTitles.size(); i++) {
                if (stepTitles.get(i) != null && !stepTitles.get(i).trim().isEmpty()) {
                    String description = (stepDescriptions != null && i < stepDescriptions.size()) 
                            ? stepDescriptions.get(i) : "";
                    steps.add(new TaskGuide.GuideStep(i + 1, stepTitles.get(i), description));
                }
            }
            guide.setSteps(steps);
        }

        // Update video
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            guide.setVideoUrl(videoUrl);
            guide.setVideoTitle(videoTitle);
        }

        // Update tips
        if (tips != null && !tips.isEmpty()) {
            List<String> filteredTips = new ArrayList<>();
            for (String tip : tips) {
                if (tip != null && !tip.trim().isEmpty()) {
                    filteredTips.add(tip);
                }
            }
            guide.setTips(filteredTips);
        }

        // Handle example images
        if (exampleImages != null && !exampleImages.isEmpty()) {
            List<String> imagePaths = new ArrayList<>();
            
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            for (MultipartFile file : exampleImages) {
                if (!file.isEmpty()) {
                    String originalFilename = file.getOriginalFilename();
                    String fileExtension = originalFilename != null && originalFilename.contains(".") 
                            ? originalFilename.substring(originalFilename.lastIndexOf("."))
                            : ".jpg";
                    String filename = "guide_" + taskId + "_" + UUID.randomUUID().toString() + fileExtension;
                    
                    Path filePath = uploadPath.resolve(filename);
                    Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    imagePaths.add(filename);
                }
            }
            
            if (!imagePaths.isEmpty()) {
                guide.setExampleImages(imagePaths);
            }
        }

        return taskGuideRepository.save(guide);
    }

    public void deleteGuide(Long taskId) {
        taskGuideRepository.deleteByTaskId(taskId);
    }

    public boolean hasGuide(Long taskId) {
        return taskGuideRepository.existsByTaskId(taskId);
    }

    public byte[] getExampleImage(String filename) throws IOException {
        Path filePath = Paths.get(UPLOAD_DIR).resolve(filename);
        if (Files.exists(filePath)) {
            return Files.readAllBytes(filePath);
        }
        throw new IOException("Image not found: " + filename);
    }
}
