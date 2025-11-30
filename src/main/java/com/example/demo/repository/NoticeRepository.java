package com.example.demo.repository;

import com.example.demo.entity.Notice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoticeRepository extends JpaRepository<Notice, Long> {
    
    List<Notice> findByIsActiveTrue();
    
    List<Notice> findAllByOrderByCreatedAtDesc();
    
    List<Notice> findByIsActiveTrueOrderByCreatedAtDesc();
    
    // New method for dashboard statistics
    @Query("SELECT COUNT(n) FROM Notice n WHERE n.isActive = true")
    int countByIsActiveTrue();
}