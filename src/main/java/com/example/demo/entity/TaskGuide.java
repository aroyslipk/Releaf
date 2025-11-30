package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "task_guides")
public class TaskGuide {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "task_id", unique = true)
    private Task task;

    @Column(columnDefinition = "TEXT")
    private String videoUrl;

    @Column(length = 255)
    private String videoTitle;

    @ElementCollection
    @CollectionTable(name = "task_guide_steps", joinColumns = @JoinColumn(name = "guide_id"))
    private List<GuideStep> steps = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "task_guide_tips", joinColumns = @JoinColumn(name = "guide_id"))
    @Column(name = "tip", columnDefinition = "TEXT")
    private List<String> tips = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "task_guide_examples", joinColumns = @JoinColumn(name = "guide_id"))
    @Column(name = "image_path")
    private List<String> exampleImages = new ArrayList<>();

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Constructors
    public TaskGuide() {
    }

    public TaskGuide(Task task) {
        this.task = task;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getVideoTitle() {
        return videoTitle;
    }

    public void setVideoTitle(String videoTitle) {
        this.videoTitle = videoTitle;
    }

    public List<GuideStep> getSteps() {
        return steps;
    }

    public void setSteps(List<GuideStep> steps) {
        this.steps = steps;
    }

    public List<String> getTips() {
        return tips;
    }

    public void setTips(List<String> tips) {
        this.tips = tips;
    }

    public List<String> getExampleImages() {
        return exampleImages;
    }

    public void setExampleImages(List<String> exampleImages) {
        this.exampleImages = exampleImages;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Embeddable class for steps
    @Embeddable
    public static class GuideStep {
        @Column(name = "step_order")
        private Integer order;

        @Column(name = "step_title")
        private String title;

        @Column(name = "step_description", columnDefinition = "TEXT")
        private String description;

        public GuideStep() {
        }

        public GuideStep(Integer order, String title, String description) {
            this.order = order;
            this.title = title;
            this.description = description;
        }

        public Integer getOrder() {
            return order;
        }

        public void setOrder(Integer order) {
            this.order = order;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }
    }
}
