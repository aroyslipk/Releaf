package com.example.demo.repository;

import com.example.demo.entity.UserTask;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.lang.NonNull;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserTaskRepository extends JpaRepository<UserTask, Long> {
    
    @Cacheable("userTasks")
    List<UserTask> findByUserId(Long userId);
    
    @Cacheable("userTasks")
    List<UserTask> findByUserIdAndStatus(Long userId, UserTask.TaskStatus status);
    
    @Cacheable("userTasks")
    List<UserTask> findByStatus(UserTask.TaskStatus status);
    
    @Cacheable("userTasks")
    Optional<UserTask> findByUserIdAndTaskId(Long userId, Long taskId);
    
    @Cacheable("userTasks")
    @Query("SELECT ut FROM UserTask ut WHERE ut.user.id = :userId AND ut.task.id = :taskId AND ut.status = :status")
    Optional<UserTask> findByUserIdAndTaskIdAndStatus(@Param("userId") Long userId, 
                                                     @Param("taskId") Long taskId, 
                                                     @Param("status") UserTask.TaskStatus status);
    
    @Cacheable("userTasks")
    @Query("SELECT COUNT(ut) FROM UserTask ut WHERE ut.user.id = :userId AND ut.status = :status")
    long countByUserIdAndStatus(@Param("userId") Long userId, @Param("status") UserTask.TaskStatus status);
    
    @Cacheable("userTasks")
    @Query("SELECT ut FROM UserTask ut WHERE ut.status = 'PENDING_REVIEW' ORDER BY ut.submittedAt DESC")
    List<UserTask> findPendingReviewTasks();
    
    @Override
    @CachePut(value = "userTasks", key = "#result.id")
    @NonNull
    <S extends UserTask> S save(@NonNull S entity);

    @Override
    @CacheEvict(value = "userTasks", key = "#entity.id")
    void delete(@NonNull UserTask entity);

    @Modifying
    @CacheEvict(value = "userTasks", allEntries = true)
    @Query("DELETE FROM UserTask ut WHERE ut.task.id = :taskId")
    void deleteByTaskId(@Param("taskId") Long taskId);
} 