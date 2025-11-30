package com.example.demo.repository;

import com.example.demo.entity.TaskGuide;
import com.example.demo.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TaskGuideRepository extends JpaRepository<TaskGuide, Long> {
    
    Optional<TaskGuide> findByTask(Task task);
    
    Optional<TaskGuide> findByTaskId(Long taskId);
    
    boolean existsByTaskId(Long taskId);
    
    void deleteByTaskId(Long taskId);
}
