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
        createReward("Bronze Badge", 90, "Congratulations! You've earned your first Bronze Badge for reaching 90 XP!");
        createReward("Silver Badge", 180, "Amazing! You've earned a Silver Badge for reaching 180 XP!");
        createReward("Gold Badge", 360, "Excellent! You've earned a Gold Badge for completing 4 full topics!");
        createReward("Eco Warrior", 720, "Outstanding! You're now an Eco Warrior with 720 XP!");
        createReward("Planet Protector", 1080, "Incredible! You're a Planet Protector with 1080 XP!");
    }
}

