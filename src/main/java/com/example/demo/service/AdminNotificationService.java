package com.example.demo.service;

import com.example.demo.entity.AdminNotification;
import com.example.demo.entity.UserTask;
import com.example.demo.repository.AdminNotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class AdminNotificationService {

    @Autowired
    private AdminNotificationRepository notificationRepository;

    public AdminNotification createTaskReviewNotification(UserTask userTask, String aiAnalysis) {
        String title = "Manual Review Required";
        String message = String.format(
            "Task submission from user %s requires manual review.\n\n" +
            "Task: %s\n" +
            "Topic: %s\n" +
            "Level: %s\n\n" +
            "%s",
            userTask.getUser().getName(),
            userTask.getTask().getDescription(),
            userTask.getTask().getTopic(),
            userTask.getTask().getLevel(),
            aiAnalysis
        );
        
        AdminNotification notification = new AdminNotification(
            title, 
            message, 
            "TASK_REVIEW", 
            userTask
        );
        
        return notificationRepository.save(notification);
    }

    public List<AdminNotification> getUnreadNotifications() {
        return notificationRepository.findByIsReadFalseOrderByCreatedAtDesc();
    }

    public List<AdminNotification> getAllNotifications() {
        return notificationRepository.findAllByOrderByCreatedAtDesc();
    }

    public long getUnreadCount() {
        return notificationRepository.countByIsReadFalse();
    }

    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(notification -> {
            notification.setRead(true);
            notification.setReadAt(LocalDateTime.now());
            notificationRepository.save(notification);
        });
    }

    public void markAllAsRead() {
        List<AdminNotification> unread = getUnreadNotifications();
        unread.forEach(notification -> {
            notification.setRead(true);
            notification.setReadAt(LocalDateTime.now());
        });
        notificationRepository.saveAll(unread);
    }
}
