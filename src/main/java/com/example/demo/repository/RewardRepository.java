package com.example.demo.repository;

import com.example.demo.entity.Reward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RewardRepository extends JpaRepository<Reward, Long> {
    
    List<Reward> findByXpRequiredLessThanEqual(Integer xpPoints);
    
    List<Reward> findByType(String type);
    
    @Query("SELECT r FROM Reward r WHERE r.xpRequired <= :xpPoints AND r.id NOT IN " +
           "(SELECT ur.id FROM User u JOIN u.unlockedRewards ur WHERE u.id = :userId)")
    List<Reward> findAvailableRewardsForUser(@Param("xpPoints") Integer xpPoints, @Param("userId") Long userId);
}

