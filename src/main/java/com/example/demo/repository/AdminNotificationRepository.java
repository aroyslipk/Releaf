package com.example.demo.repository;

import com.example.demo.entity.AdminNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminNotificationRepository extends JpaRepository<AdminNotification, Long> {
    
    List<AdminNotification> findByIsReadFalseOrderByCreatedAtDesc();
    
    List<AdminNotification> findAllByOrderByCreatedAtDesc();
    
    long countByIsReadFalse();
    
    @Modifying
    @Query("DELETE FROM AdminNotification an WHERE an.userTask.id IN " +
           "(SELECT ut.id FROM UserTask ut WHERE ut.task.id = :taskId)")
    void deleteByTaskId(@Param("taskId") Long taskId);

    @Modifying
    @Query("DELETE FROM AdminNotification an WHERE an.userTask.id IN " +
           "(SELECT ut.id FROM UserTask ut WHERE ut.user.id = :userId)")
    void deleteByUserId(@Param("userId") Long userId);
}
