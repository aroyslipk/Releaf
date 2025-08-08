package com.example.demo.repository;

import com.example.demo.entity.GroupMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GroupMessageRepository extends JpaRepository<GroupMessage, Long> {
    List<GroupMessage> findByUserId(Long userId);
    List<GroupMessage> findByGroupIdOrderByCreatedAtDesc(Long groupId);
    List<GroupMessage> findTop50ByGroupIdOrderByCreatedAtDesc(Long groupId);
}
