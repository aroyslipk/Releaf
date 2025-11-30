package com.example.demo.repository;

import com.example.demo.entity.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {
    
    Optional<Group> findByGroupName(String groupName);
    
    Boolean existsByGroupName(String groupName);
    
    @Query("SELECT DISTINCT g FROM Group g LEFT JOIN FETCH g.members")
    List<Group> findAllWithMembers();
}

