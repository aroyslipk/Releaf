package com.example.demo.repository;

import com.example.demo.entity.AdminNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminNotificationRepository extends JpaRepository<AdminNotification, Long> {
    
    List<AdminNotification> findByIsReadFalseOrderByCreatedAtDesc();
    
    List<AdminNotification> findAllByOrderByCreatedAtDesc();
    
    long countByIsReadFalse();
}
