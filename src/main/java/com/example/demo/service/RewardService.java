package com.example.demo.service;

import com.example.demo.entity.Reward;
import com.example.demo.repository.RewardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class RewardService {

    @Autowired
    private RewardRepository rewardRepository;

    public Reward createReward(String type, Integer xpRequired, String description) {
        Reward reward = new Reward(type, xpRequired, description);
        return rewardRepository.save(reward);
    }

    public Optional<Reward> findById(Long id) {
        return rewardRepository.findById(id);
    }

    public List<Reward> getAllRewards() {
        return rewardRepository.findAll();
    }

    public List<Reward> getRewardsByType(String type) {
        return rewardRepository.findByType(type);
    }

    public List<Reward> getAvailableRewards(Integer xpPoints) {
        return rewardRepository.findByXpRequiredLessThanEqual(xpPoints);
    }

    public List<Reward> getAvailableRewardsForUser(Integer xpPoints, Long userId) {
        return rewardRepository.findAvailableRewardsForUser(xpPoints, userId);
    }

    public Reward updateReward(Reward reward) {
        return rewardRepository.save(reward);
    }

    public void deleteReward(Long id) {
        rewardRepository.deleteById(id);
    }

    public void initializeDefaultRewards() {
        if (rewardRepository.count() == 0) {
            createDefaultRewards();
        }
    }

    private void createDefaultRewards() {
        // Create default rewards
        createReward("Bronze", 90, "Congratulations! You've earned your first Bronze Badge for reaching 90 XP!");
        createReward("Silver", 180, "Amazing! You've earned a Silver Badge for reaching 180 XP!");
        createReward("Gold", 360, "Excellent! You've earned a Gold Badge for completing 4 full topics!");
        createReward("Champion", 720, "Outstanding! You're now a Champion with 720 XP!");
        createReward("Planet Protector", 1080, "Incredible! You're a Planet Protector with 1080 XP!");
    }

    public String getCurrentRewardLevel(Integer xpPoints) {
        if (xpPoints == null || xpPoints < 90) return "Beginner";
        if (xpPoints < 180) return "Bronze";
        if (xpPoints < 360) return "Silver";
        if (xpPoints < 720) return "Gold";
        if (xpPoints < 1080) return "Champion";
        return "Planet Protector";
    }

    public Integer getNextRewardXP(Integer xpPoints) {
        if (xpPoints == null || xpPoints < 90) return 90;
        if (xpPoints < 180) return 180;
        if (xpPoints < 360) return 360;
        if (xpPoints < 720) return 720;
        if (xpPoints < 1080) return 1080;
        return 1080; // Max level
    }

    public Integer getCurrentLevelXP(Integer xpPoints) {
        if (xpPoints == null || xpPoints < 90) return 0;
        if (xpPoints < 180) return 90;
        if (xpPoints < 360) return 180;
        if (xpPoints < 720) return 360;
        if (xpPoints < 1080) return 720;
        return 1080;
    }

    public int getUnlockedRewardsCount(Integer xpPoints) {
        if (xpPoints == null) return 0;
        int count = 0;
        if (xpPoints >= 90) count++;   // Bronze
        if (xpPoints >= 180) count++;  // Silver  
        if (xpPoints >= 360) count++;  // Gold
        if (xpPoints >= 720) count++;  // Champion
        if (xpPoints >= 1080) count++; // Planet Protector
        return count;
    }

    public java.util.List<java.util.Map<String, Object>> getUnlockedRewardsList(Integer xpPoints) {
        java.util.List<java.util.Map<String, Object>> rewards = new java.util.ArrayList<>();
        
        if (xpPoints >= 90) {
            java.util.Map<String, Object> bronze = new java.util.HashMap<>();
            bronze.put("type", "Bronze");
            bronze.put("description", "Congratulations! You've earned your first Bronze Badge for reaching 90 XP!");
            bronze.put("xpRequired", 90);
            bronze.put("icon", "🥉");
            rewards.add(bronze);
        }
        
        if (xpPoints >= 180) {
            java.util.Map<String, Object> silver = new java.util.HashMap<>();
            silver.put("type", "Silver");
            silver.put("description", "Amazing! You've earned a Silver Badge for reaching 180 XP!");
            silver.put("xpRequired", 180);
            silver.put("icon", "🥈");
            rewards.add(silver);
        }
        
        if (xpPoints >= 360) {
            java.util.Map<String, Object> gold = new java.util.HashMap<>();
            gold.put("type", "Gold");
            gold.put("description", "Excellent! You've earned a Gold Badge for completing 4 full topics!");
            gold.put("xpRequired", 360);
            gold.put("icon", "🥇");
            rewards.add(gold);
        }
        
        if (xpPoints >= 720) {
            java.util.Map<String, Object> champion = new java.util.HashMap<>();
            champion.put("type", "Champion");
            champion.put("description", "Outstanding! You're now a Champion with 720 XP!");
            champion.put("xpRequired", 720);
            champion.put("icon", "🏆");
            rewards.add(champion);
        }
        
        if (xpPoints >= 1080) {
            java.util.Map<String, Object> protector = new java.util.HashMap<>();
            protector.put("type", "Planet Protector");
            protector.put("description", "Incredible! You're a Planet Protector with 1080 XP!");
            protector.put("xpRequired", 1080);
            protector.put("icon", "🌍");
            rewards.add(protector);
        }
        
        return rewards;
    }
}

