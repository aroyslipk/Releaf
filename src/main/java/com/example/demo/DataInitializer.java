package com.example.demo;

import com.example.demo.entity.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private AdminRepository adminRepository;
    
    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private GroupRepository groupRepository;
    
    @Autowired
    private NoticeRepository noticeRepository;
    
    @Autowired
    private RewardRepository rewardRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Create admin user if not exists
        if (adminRepository.count() == 0) {
            Admin admin = new Admin();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setCreatedAt(LocalDateTime.now());
            admin.setUpdatedAt(LocalDateTime.now());
            adminRepository.save(admin);
            System.out.println("Admin user created: username=admin, password=admin123");
        }
        
        if (!adminRepository.existsByUsername("admin2")) {
            Admin admin2 = new Admin();
            admin2.setUsername("admin2");
            admin2.setPassword(passwordEncoder.encode("admin456"));
            admin2.setCreatedAt(LocalDateTime.now());
            admin2.setUpdatedAt(LocalDateTime.now());
            adminRepository.save(admin2);
            System.out.println("Second admin created: username=admin2, password=admin456");
        }


        // Create sample groups if not exists
        if (groupRepository.count() == 0) {
            Group ecoWarriors = new Group();
            ecoWarriors.setGroupName("Eco Warriors");
            ecoWarriors.setDescription("Passionate environmental activists working together for change");
            ecoWarriors.setCreatedAt(LocalDateTime.now());
            groupRepository.save(ecoWarriors);

            Group greenBeginners = new Group();
            greenBeginners.setGroupName("Green Beginners");
            greenBeginners.setDescription("New users starting their eco-friendly journey");
            greenBeginners.setCreatedAt(LocalDateTime.now());
            groupRepository.save(greenBeginners);

            Group climateChampions = new Group();
            climateChampions.setGroupName("Climate Champions");
            climateChampions.setDescription("Focused on tackling climate change challenges");
            climateChampions.setCreatedAt(LocalDateTime.now());
            groupRepository.save(climateChampions);
        }

        // Create sample tasks if not exists
        if (taskRepository.count() == 0) {
            createSampleTasks();
        }

        // Create sample notices if not exists
        if (noticeRepository.count() == 0) {
            Notice welcome = new Notice();
            welcome.setTitle("Welcome to ReLeaf!");
            welcome.setContent("Welcome to our eco-friendly community! We're excited to have you join us in making a positive impact on the environment. Start by exploring our challenges and earning your first XP points!");
            welcome.setIsActive(true);
            welcome.setCreatedAt(LocalDateTime.now());
            noticeRepository.save(welcome);

            Notice earthDay = new Notice();
            earthDay.setTitle("Earth Day Challenge 2024");
            earthDay.setContent("Join our special Earth Day challenge! Complete any 5 tasks this week to earn bonus XP and unlock exclusive rewards. Every action counts towards a greener planet!");
            earthDay.setIsActive(true);
            earthDay.setCreatedAt(LocalDateTime.now());
            noticeRepository.save(earthDay);
        }

        // Create sample rewards if not exists
        if (rewardRepository.count() == 0) {
            Reward bronze = new Reward();
            bronze.setType("Bronze Eco Badge");
            bronze.setDescription("Congratulations on earning your first 90 XP! You're on your way to becoming an eco warrior.");
            bronze.setXpRequired(90);
            rewardRepository.save(bronze);

            Reward silver = new Reward();
            silver.setType("Silver Eco Badge");
            silver.setDescription("Amazing progress! You've earned 180 XP and are making a real difference.");
            silver.setXpRequired(180);
            rewardRepository.save(silver);

            Reward gold = new Reward();
            gold.setType("Gold Eco Badge");
            gold.setDescription("Outstanding commitment! 360 XP shows your dedication to environmental causes.");
            gold.setXpRequired(360);
            rewardRepository.save(gold);

            Reward champion = new Reward();
            champion.setType("Eco Champion");
            champion.setDescription("You're a true environmental champion with 720 XP! Thank you for leading by example.");
            champion.setXpRequired(720);
            rewardRepository.save(champion);
        }
    }

    private void createSampleTasks() {
        String[] topics = {
            "Plastronauts",
            "Aether Shield", 
            "Hydronauts",
            "ChronoClimbers",
            "Verdantra",
            "TerraFixers",
            "SmogSmiths",
            "EcoMentors"
        };

        String[] levels = {"Easy", "Medium", "Hard"};

        // Sample task descriptions for each topic and level
        String[][][] taskDescriptions = {
            // Plastronauts
            {
                {"Use a reusable water bottle for a week", "Bring your own shopping bags to the store", "Separate recyclables from regular trash"},
                {"Organize a neighborhood cleanup event", "Start composting organic waste at home", "Reduce single-use plastics in your daily routine"},
                {"Launch a community recycling program", "Advocate for plastic bag bans in local stores", "Create educational content about waste reduction"}
            },
            // Aether Shield
            {
                {"Walk or bike instead of driving for short trips", "Use public transportation for one week", "Plant a tree in your yard or community"},
                {"Carpool with colleagues for a month", "Switch to energy-efficient appliances", "Advocate for clean air policies in your community"},
                {"Organize a car-free day in your neighborhood", "Install solar panels or renewable energy", "Lead a campaign for electric vehicle adoption"}
            },
            // Hydronauts
            {
                {"Take shorter showers to conserve water", "Fix any leaky faucets in your home", "Use eco-friendly cleaning products"},
                {"Install water-saving devices in your home", "Participate in a local river cleanup", "Start rainwater harvesting"},
                {"Organize a watershed protection initiative", "Advocate for water quality regulations", "Create a community water conservation program"}
            },
            // ChronoClimbers
            {
                {"Reduce meat consumption for a week", "Switch to LED light bulbs", "Unplug electronics when not in use"},
                {"Calculate and reduce your carbon footprint", "Support renewable energy initiatives", "Start a home energy audit"},
                {"Advocate for climate action policies", "Organize a community climate summit", "Lead carbon neutrality initiatives"}
            },
            // Verdantra
            {
                {"Create a small garden with native plants", "Support sustainable forestry products", "Learn about local wildlife species"},
                {"Participate in a tree planting event", "Create habitat for local wildlife", "Support conservation organizations"},
                {"Organize forest conservation campaigns", "Advocate for protected area expansion", "Lead biodiversity monitoring projects"}
            },
            // TerraFixers
            {
                {"Start a small herb garden", "Learn about soil conservation", "Avoid using chemical fertilizers"},
                {"Practice crop rotation in your garden", "Participate in land restoration projects", "Promote organic farming methods"},
                {"Organize soil health workshops", "Lead sustainable agriculture initiatives", "Advocate for land protection policies"}
            },
            // SmogSmiths
            {
                {"Report pollution incidents to authorities", "Choose products from eco-friendly companies", "Reduce noise pollution in your area"},
                {"Advocate for cleaner industrial practices", "Support green building initiatives", "Promote sustainable urban planning"},
                {"Organize industrial pollution monitoring", "Lead green city initiatives", "Campaign for stricter pollution regulations"}
            },
            // EcoMentors
            {
                {"Share environmental tips on social media", "Teach a friend about recycling", "Read about environmental issues"},
                {"Organize an environmental awareness event", "Create educational materials", "Mentor others in eco-friendly practices"},
                {"Develop environmental education programs", "Lead community awareness campaigns", "Create lasting educational initiatives"}
            }
        };

        for (int topicIndex = 0; topicIndex < topics.length; topicIndex++) {
            for (int levelIndex = 0; levelIndex < levels.length; levelIndex++) {
                for (int taskIndex = 0; taskIndex < 3; taskIndex++) {
                    Task task = new Task();
                    task.setTopic(topics[topicIndex]);
                    task.setLevel(levels[levelIndex]);
                    task.setDescription(taskDescriptions[topicIndex][levelIndex][taskIndex]);
                    
                    // Set XP reward based on level
                    switch (levels[levelIndex]) {
                        case "Easy":
                            task.setXpReward(10);
                            break;
                        case "Medium":
                            task.setXpReward(20);
                            break;
                        case "Hard":
                            task.setXpReward(30);
                            break;
                    }
                    
                    taskRepository.save(task);
                }
            }
        }
        
        System.out.println("Created 72 sample tasks across 8 topics and 3 difficulty levels");
    }
}

