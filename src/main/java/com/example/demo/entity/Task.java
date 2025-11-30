package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "tasks")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 100)
    private String topic;

    @NotBlank
    @Size(max = 20)
    private String level; // Easy, Medium, Hard

    @NotBlank
    @Size(max = 500)
    private String description;

    @Column(name = "task_type")
    private String taskType = "GREENVERSE"; // GREENVERSE or FUNLAB

    @Column(name = "category")
    private String category = "GREENVERSE";

    @Column(name = "impact")
    private String impact; // For FunLab tasks

    @Column(name = "proof_type")
    private String proofType; // PHOTO, AUDIO, TEXT, VIDEO for FunLab tasks

    @Column(name = "xp_reward")
    private Integer xpReward = 10; // Default XP for completing a level

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToMany(mappedBy = "completedTasks")
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    private Set<User> completedByUsers = new HashSet<>();

    public Task() {}

    public Task(String topic, String level, String description) {
        this.topic = topic;
        this.level = level;
        this.description = description;
        this.taskType = "GREENVERSE";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Task(String topic, String level, String description, String taskType, String impact, String proofType) {
        this.topic = topic;
        this.level = level;
        this.description = description;
        this.taskType = taskType;
        this.impact = impact;
        this.proofType = proofType;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImpact() {
        return impact;
    }

    public void setImpact(String impact) {
        this.impact = impact;
    }

    public String getProofType() {
        return proofType;
    }

    public void setProofType(String proofType) {
        this.proofType = proofType;
    }

    public Integer getXpReward() {
        return xpReward;
    }

    public void setXpReward(Integer xpReward) {
        this.xpReward = xpReward;
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

    public Set<User> getCompletedByUsers() {
        return completedByUsers;
    }

    public void setCompletedByUsers(Set<User> completedByUsers) {
        this.completedByUsers = completedByUsers;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

