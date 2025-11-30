package com.example.demo.repository;

import com.example.demo.entity.GroupMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GroupMessageRepository extends JpaRepository<GroupMessage, Long> {
    List<GroupMessage> findByUserId(Long userId);
    
    @Query("SELECT gm FROM GroupMessage gm WHERE gm.group.id = :groupId ORDER BY gm.createdAt ASC")
    List<GroupMessage> findByGroupIdOrderByCreatedAtAsc(@Param("groupId") Long groupId);
    
    @Query("SELECT gm FROM GroupMessage gm WHERE gm.group.id = :groupId ORDER BY gm.createdAt DESC")
    List<GroupMessage> findTop50ByGroupIdOrderByCreatedAtDesc(@Param("groupId") Long groupId);
}
