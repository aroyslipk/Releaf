package com.example.demo.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_topic_progress")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class UserTopicProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "topic", nullable = false)
    private String topic;

    @Column(name = "topic_order", nullable = false)
    private Integer topicOrder;

    @Column(name = "is_unlocked", nullable = false)
    private Boolean isUnlocked = false;

    @Column(name = "easy_completed", nullable = false)
    private Integer easyCompleted = 0;

    @Column(name = "medium_completed", nullable = false)
    private Integer mediumCompleted = 0;

    @Column(name = "hard_completed", nullable = false)
    private Integer hardCompleted = 0;

    @Column(name = "easy_unlocked", nullable = false)
    private Boolean easyUnlocked = false;

    @Column(name = "medium_unlocked", nullable = false)
    private Boolean mediumUnlocked = false;

    @Column(name = "hard_unlocked", nullable = false)
    private Boolean hardUnlocked = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public UserTopicProgress() {}

    public UserTopicProgress(User user, String topic, Integer topicOrder) {
        this.user = user;
        this.topic = topic;
        this.topicOrder = topicOrder;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public Integer getTopicOrder() {
        return topicOrder;
    }

    public void setTopicOrder(Integer topicOrder) {
        this.topicOrder = topicOrder;
    }

    public Boolean getIsUnlocked() {
        return isUnlocked;
    }

    public void setIsUnlocked(Boolean isUnlocked) {
        this.isUnlocked = isUnlocked;
    }

    public Integer getEasyCompleted() {
        return easyCompleted;
    }

    public void setEasyCompleted(Integer easyCompleted) {
        this.easyCompleted = easyCompleted;
    }

    public Integer getMediumCompleted() {
        return mediumCompleted;
    }

    public void setMediumCompleted(Integer mediumCompleted) {
        this.mediumCompleted = mediumCompleted;
    }

    public Integer getHardCompleted() {
        return hardCompleted;
    }

    public void setHardCompleted(Integer hardCompleted) {
        this.hardCompleted = hardCompleted;
    }

    public Boolean getEasyUnlocked() {
        return easyUnlocked;
    }

    public void setEasyUnlocked(Boolean easyUnlocked) {
        this.easyUnlocked = easyUnlocked;
    }

    public Boolean getMediumUnlocked() {
        return mediumUnlocked;
    }

    public void setMediumUnlocked(Boolean mediumUnlocked) {
        this.mediumUnlocked = mediumUnlocked;
    }

    public Boolean getHardUnlocked() {
        return hardUnlocked;
    }

    public void setHardUnlocked(Boolean hardUnlocked) {
        this.hardUnlocked = hardUnlocked;
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