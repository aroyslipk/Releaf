package com.example.demo.repository;

import com.example.demo.entity.Notice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoticeRepository extends JpaRepository<Notice, Long> {
    
    List<Notice> findByIsActiveTrue();
    
    List<Notice> findAllByOrderByCreatedAtDesc();
    
    List<Notice> findByIsActiveTrueOrderByCreatedAtDesc();
}

