package com.example.demo.repository;

import com.example.demo.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    
    List<Task> findByTopic(String topic);
    
    List<Task> findByLevel(String level);
    
    List<Task> findByTopicAndLevel(String topic, String level);
    
    List<Task> findByTaskType(String taskType);
    
    List<Task> findByTaskTypeAndTopic(String taskType, String topic);
    
    List<Task> findByTaskTypeAndLevel(String taskType, String level);
    
    @Query("SELECT DISTINCT t.topic FROM Task t")
    List<String> findAllTopics();
    
    @Query("SELECT DISTINCT t.topic FROM Task t WHERE t.taskType = :taskType")
    List<String> findTopicsByTaskType(@Param("taskType") String taskType);
    
    @Query("SELECT DISTINCT t.level FROM Task t")
    List<String> findAllLevels();
    
    @Query("SELECT DISTINCT t.level FROM Task t WHERE t.taskType = :taskType")
    List<String> findLevelsByTaskType(@Param("taskType") String taskType);
    
    @Query("SELECT t FROM Task t WHERE t.id NOT IN " +
           "(SELECT ct.id FROM User u JOIN u.completedTasks ct WHERE u.id = :userId)")
    List<Task> findTasksNotCompletedByUser(@Param("userId") Long userId);
    
    @Query("SELECT t FROM Task t WHERE t.taskType = :taskType AND t.id NOT IN " +
           "(SELECT ct.id FROM User u JOIN u.completedTasks ct WHERE u.id = :userId)")
    List<Task> findTasksByTypeNotCompletedByUser(@Param("taskType") String taskType, @Param("userId") Long userId);
    
    @Query("SELECT COUNT(t) FROM Task t WHERE t.topic = :topic AND t.level = :level")
    Long countTasksByTopicAndLevel(@Param("topic") String topic, @Param("level") String level);
}

