package com.example.demo.repository;

import com.example.demo.entity.UserTopicProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.lang.NonNull;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserTopicProgressRepository extends JpaRepository<UserTopicProgress, Long> {
    
    @Cacheable("userTopicProgress")
    List<UserTopicProgress> findByUserId(Long userId);
    
    @Cacheable("userTopicProgress")
    List<UserTopicProgress> findByUserIdOrderByTopicOrder(Long userId);
    
    @Cacheable("userTopicProgress")
    Optional<UserTopicProgress> findByUserIdAndTopic(Long userId, String topic);
    
    @Cacheable("userTopicProgress")
    @Query("SELECT utp FROM UserTopicProgress utp WHERE utp.user.id = :userId AND utp.isUnlocked = true ORDER BY utp.topicOrder")
    List<UserTopicProgress> findUnlockedTopicsByUserId(@Param("userId") Long userId);
    
    @Cacheable("userTopicProgress")
    @Query("SELECT utp FROM UserTopicProgress utp WHERE utp.user.id = :userId AND utp.topicOrder = :topicOrder")
    Optional<UserTopicProgress> findByUserIdAndTopicOrder(@Param("userId") Long userId, @Param("topicOrder") Integer topicOrder);
    
    @CacheEvict(value = "userTopicProgress", allEntries = true)
    @Override
    <S extends UserTopicProgress> @NonNull S save(@NonNull S entity);
    
    @CacheEvict(value = "userTopicProgress", allEntries = true)
    @Override
    void deleteById(@NonNull Long id);
} 