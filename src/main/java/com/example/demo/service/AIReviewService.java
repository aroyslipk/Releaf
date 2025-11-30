package com.example.demo.service;

import com.example.demo.entity.UserTask;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Service
public class AIReviewService {

    /**
     * Analyze task submission using AI
     * Returns a map with analysis results
     */
    public Map<String, Object> analyzeTaskSubmission(UserTask userTask, byte[] imageData) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 1. Check if image is AI-generated
            boolean isAIGenerated = detectAIGeneratedImage(imageData);
            result.put("isAIGenerated", isAIGenerated);
            
            // 2. Check image quality
            Map<String, Object> qualityCheck = checkImageQuality(imageData);
            result.put("quality", qualityCheck);
            
            // 3. Check if image matches task topic
            boolean matchesTopic = checkTopicRelevance(userTask, imageData);
            result.put("matchesTopic", matchesTopic);
            
            // 4. Calculate confidence score (0-100)
            int confidenceScore = calculateConfidenceScore(isAIGenerated, qualityCheck, matchesTopic);
            result.put("confidenceScore", confidenceScore);
            
            // 5. Determine if auto-approval is possible
            boolean autoApprove = shouldAutoApprove(confidenceScore, isAIGenerated, matchesTopic);
            result.put("autoApprove", autoApprove);
            
            // 6. Generate review notes
            String notes = generateReviewNotes(isAIGenerated, qualityCheck, matchesTopic, confidenceScore);
            result.put("notes", notes);
            
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            result.put("autoApprove", false);
        }
        
        return result;
    }

    /**
     * Detect if image is AI-generated, drawn, or animated
     * ENHANCED DETECTION for anime, cartoons, digital art
     */
    private boolean detectAIGeneratedImage(byte[] imageData) throws IOException {
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageData));
        if (image == null) return false;
        
        // Multiple detection methods
        boolean isAnimeOrCartoon = detectAnimeOrCartoon(image);
        boolean hasUniformNoise = checkUniformNoise(image);
        boolean hasArtificialPatterns = checkArtificialPatterns(image);
        boolean hasUnrealisticColors = checkColorDistribution(image);
        boolean hasDigitalArtifacts = detectDigitalArtifacts(image);
        boolean lacksCameraMetadata = true; // Would check EXIF data in production
        
        // STRICT: If ANY strong indicator is present, flag as AI/fake
        if (isAnimeOrCartoon) {
            System.out.println("⚠️ Detected anime/cartoon/digital art");
            return true; // Immediate rejection for anime/cartoon
        }
        
        // If 2 or more other indicators are present, likely AI-generated
        int indicators = 0;
        if (hasUniformNoise) indicators++;
        if (hasArtificialPatterns) indicators++;
        if (hasUnrealisticColors) indicators++;
        if (hasDigitalArtifacts) indicators++;
        
        return indicators >= 2;
    }
    
    /**
     * Detect anime, cartoon, or digital art
     * These should NEVER be accepted for real-world tasks
     */
    private boolean detectAnimeOrCartoon(BufferedImage image) {
        int totalPixels = 0;
        int flatColorRegions = 0;
        int perfectLines = 0;
        int unrealisticSkinTones = 0;
        
        // Sample pixels to detect characteristics of drawn/animated content
        for (int y = 0; y < image.getHeight(); y += 5) {
            for (int x = 0; x < image.getWidth(); x += 5) {
                totalPixels++;
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Check for flat color regions (common in anime/cartoons)
                if (x < image.getWidth() - 5 && y < image.getHeight() - 5) {
                    int nextRgb = image.getRGB(x + 5, y);
                    int nextR = (nextRgb >> 16) & 0xFF;
                    int nextG = (nextRgb >> 8) & 0xFF;
                    int nextB = nextRgb & 0xFF;
                    
                    // Identical or very similar colors (flat shading)
                    if (Math.abs(r - nextR) < 5 && Math.abs(g - nextG) < 5 && Math.abs(b - nextB) < 5) {
                        flatColorRegions++;
                    }
                }
                
                // Check for unrealistic vibrant colors (anime hair, eyes, etc.)
                if ((r > 200 && g < 100 && b < 100) || // Bright red
                    (r < 100 && g < 100 && b > 200) || // Bright blue
                    (r > 200 && g < 150 && b > 200) || // Bright pink/purple
                    (r > 200 && g > 150 && b < 100)) { // Bright orange/yellow
                    unrealisticSkinTones++;
                }
                
                // Check for perfect black outlines (anime style)
                if (r < 30 && g < 30 && b < 30) {
                    perfectLines++;
                }
            }
        }
        
        // Calculate percentages
        double flatColorPercent = (double) flatColorRegions / totalPixels * 100;
        double unrealisticColorPercent = (double) unrealisticSkinTones / totalPixels * 100;
        double blackLinePercent = (double) perfectLines / totalPixels * 100;
        
        // Anime/cartoon indicators:
        // - High flat color regions (>30%)
        // - Unrealistic vibrant colors (>5%)
        // - Strong black outlines (>10%)
        boolean hasAnimeCharacteristics = 
            (flatColorPercent > 30) || 
            (unrealisticColorPercent > 5) || 
            (blackLinePercent > 10 && flatColorPercent > 20);
        
        if (hasAnimeCharacteristics) {
            System.out.println(String.format(
                "Anime/Cartoon detected: Flat=%.1f%%, Vibrant=%.1f%%, Lines=%.1f%%",
                flatColorPercent, unrealisticColorPercent, blackLinePercent
            ));
        }
        
        return hasAnimeCharacteristics;
    }
    
    /**
     * Detect digital artifacts common in AI-generated or heavily edited images
     */
    private boolean detectDigitalArtifacts(BufferedImage image) {
        // Check for compression artifacts, unnatural smoothness, etc.
        int smoothRegions = 0;
        int totalRegions = 0;
        
        for (int y = 0; y < image.getHeight() - 10; y += 10) {
            for (int x = 0; x < image.getWidth() - 10; x += 10) {
                totalRegions++;
                
                // Check if region is unnaturally smooth (no texture variation)
                int minR = 255, maxR = 0, minG = 255, maxG = 0, minB = 255, maxB = 0;
                
                for (int dy = 0; dy < 10; dy++) {
                    for (int dx = 0; dx < 10; dx++) {
                        int rgb = image.getRGB(x + dx, y + dy);
                        int r = (rgb >> 16) & 0xFF;
                        int g = (rgb >> 8) & 0xFF;
                        int b = rgb & 0xFF;
                        
                        minR = Math.min(minR, r);
                        maxR = Math.max(maxR, r);
                        minG = Math.min(minG, g);
                        maxG = Math.max(maxG, g);
                        minB = Math.min(minB, b);
                        maxB = Math.max(maxB, b);
                    }
                }
                
                // If variation is too low, it's unnaturally smooth
                if ((maxR - minR) < 10 && (maxG - minG) < 10 && (maxB - minB) < 10) {
                    smoothRegions++;
                }
            }
        }
        
        double smoothPercent = (double) smoothRegions / totalRegions * 100;
        return smoothPercent > 40; // More than 40% unnaturally smooth
    }

    /**
     * Check image quality metrics
     */
    private Map<String, Object> checkImageQuality(byte[] imageData) throws IOException {
        Map<String, Object> quality = new HashMap<>();
        
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageData));
        if (image == null) {
            quality.put("valid", false);
            return quality;
        }
        
        // Check resolution
        int width = image.getWidth();
        int height = image.getHeight();
        boolean goodResolution = width >= 640 && height >= 480;
        quality.put("resolution", width + "x" + height);
        quality.put("goodResolution", goodResolution);
        
        // Check if image is too dark or too bright
        double brightness = calculateAverageBrightness(image);
        boolean goodBrightness = brightness > 30 && brightness < 225;
        quality.put("brightness", brightness);
        quality.put("goodBrightness", goodBrightness);
        
        // Check if image is blurry
        boolean isSharp = checkSharpness(image);
        quality.put("isSharp", isSharp);
        
        quality.put("valid", true);
        quality.put("overall", goodResolution && goodBrightness && isSharp);
        
        return quality;
    }

    /**
     * Check if image content matches the task topic
     * STRICT MATCHING - Returns false if content doesn't match
     */
    private boolean checkTopicRelevance(UserTask userTask, byte[] imageData) {
        try {
            String taskDescription = userTask.getTask().getDescription().toLowerCase();
            String topic = userTask.getTask().getTopic().toLowerCase();
            
            BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageData));
            if (image == null) return false;
            
            // STRICT CHECKS - Must match task requirements
            
            // Carpool/Transportation tasks - MUST show vehicles or people in cars
            if (taskDescription.contains("carpool") || taskDescription.contains("ride") || 
                taskDescription.contains("transport") || taskDescription.contains("commute")) {
                return checkForVehicleOrPeople(image);
            }
            
            // Plastic-related tasks - MUST show plastic items
            if (topic.contains("plastic") || taskDescription.contains("plastic") || 
                taskDescription.contains("bag") || taskDescription.contains("bottle")) {
                return checkForPlasticContent(image);
            }
            
            // Tree/Plant tasks - MUST show significant green vegetation
            if (topic.contains("tree") || topic.contains("plant") || 
                taskDescription.contains("plant") || taskDescription.contains("garden")) {
                return checkForGreenContent(image);
            }
            
            // Water-related tasks - MUST show water bodies
            if (topic.contains("water") || taskDescription.contains("water") || 
                taskDescription.contains("ocean") || taskDescription.contains("river")) {
                return checkForWaterContent(image);
            }
            
            // Recycling tasks - MUST show recycling bins or sorted waste
            if (taskDescription.contains("recycle") || taskDescription.contains("waste") || 
                taskDescription.contains("compost")) {
                return checkForRecyclingContent(image);
            }
            
            // Energy/Solar tasks - MUST show solar panels or energy equipment
            if (taskDescription.contains("solar") || taskDescription.contains("energy") || 
                taskDescription.contains("panel")) {
                return checkForEnergyContent(image);
            }
            
            // Advocacy/Document tasks - MUST show documents, signs, or text
            if (taskDescription.contains("advocate") || taskDescription.contains("petition") || 
                taskDescription.contains("sign") || taskDescription.contains("document")) {
                return checkForDocumentContent(image);
            }
            
            // Default: REJECT if we can't determine (be strict!)
            // Better to require manual review than auto-approve wrong content
            return false;
            
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Calculate overall confidence score
     * STRICT SCORING - Topic match is critical
     */
    private int calculateConfidenceScore(boolean isAIGenerated, Map<String, Object> quality, boolean matchesTopic) {
        int score = 100;
        
        // CRITICAL: If doesn't match topic, score drops dramatically
        if (!matchesTopic) {
            score -= 60; // Major penalty for wrong content
        }
        
        // Deduct points for AI-generated content
        if (isAIGenerated) {
            score -= 50;
        }
        
        // Deduct points for poor quality
        if (quality.get("valid") != null && (boolean) quality.get("valid")) {
            if (!(boolean) quality.get("goodResolution")) score -= 15;
            if (!(boolean) quality.get("goodBrightness")) score -= 10;
            if (!(boolean) quality.get("isSharp")) score -= 10;
        } else {
            score -= 30;
        }
        
        return Math.max(0, score);
    }

    /**
     * Determine if submission should be auto-approved
     * VERY STRICT CRITERIA
     */
    private boolean shouldAutoApprove(int confidenceScore, boolean isAIGenerated, boolean matchesTopic) {
        // Auto-approve ONLY if ALL conditions are met:
        // 1. NOT AI-generated
        // 2. MUST match topic (strict requirement)
        // 3. Confidence score is VERY high (>= 85)
        // 4. Image quality is good
        
        // If topic doesn't match, NEVER auto-approve
        if (!matchesTopic) {
            return false;
        }
        
        // If AI-generated, NEVER auto-approve
        if (isAIGenerated) {
            return false;
        }
        
        // Only auto-approve with very high confidence
        return confidenceScore >= 85;
    }

    /**
     * Generate human-readable review notes
     */
    private String generateReviewNotes(boolean isAIGenerated, Map<String, Object> quality, 
                                      boolean matchesTopic, int confidenceScore) {
        StringBuilder notes = new StringBuilder();
        
        notes.append("🤖 AI ANALYSIS RESULTS\n");
        notes.append("═══════════════════════\n");
        notes.append("Confidence Score: ").append(confidenceScore).append("%\n\n");
        
        // Authenticity Check
        notes.append("📸 AUTHENTICITY:\n");
        if (isAIGenerated) {
            notes.append("❌ WARNING: Image appears to be AI-generated, anime, cartoon, or digital art\n");
            notes.append("   → This is NOT a real photograph\n");
            notes.append("   → REJECT this submission\n");
        } else {
            notes.append("✅ Image appears to be an authentic photograph\n");
        }
        
        // Quality Check
        if (quality.get("valid") != null && (boolean) quality.get("valid")) {
            notes.append("\n📊 IMAGE QUALITY:\n");
            notes.append("   • Resolution: ").append(quality.get("resolution"));
            notes.append((boolean) quality.get("goodResolution") ? " ✓\n" : " ⚠️ (too low)\n");
            notes.append("   • Brightness: ").append(String.format("%.1f", quality.get("brightness")));
            notes.append((boolean) quality.get("goodBrightness") ? " ✓\n" : " ⚠️ (too dark/bright)\n");
            notes.append("   • Sharpness: ").append((boolean) quality.get("isSharp") ? "Good ✓" : "Blurry ⚠️").append("\n");
        }
        
        // Topic Relevance
        notes.append("\n🎯 CONTENT RELEVANCE:\n");
        if (matchesTopic) {
            notes.append("✅ Content matches task requirements\n");
        } else {
            notes.append("❌ Content DOES NOT match task requirements\n");
            notes.append("   → Wrong subject matter detected\n");
            notes.append("   → REJECT this submission\n");
        }
        
        // Final Recommendation
        notes.append("\n💡 RECOMMENDATION:\n");
        if (isAIGenerated || !matchesTopic) {
            notes.append("❌ REJECT - Invalid submission\n");
            if (isAIGenerated) {
                notes.append("   Reason: Not a real photograph (anime/AI/cartoon)\n");
            }
            if (!matchesTopic) {
                notes.append("   Reason: Content doesn't match task\n");
            }
        } else if (confidenceScore >= 85) {
            notes.append("✅ AUTO-APPROVE - High confidence\n");
        } else if (confidenceScore >= 60) {
            notes.append("⚠️ MANUAL REVIEW REQUIRED - Medium confidence\n");
        } else {
            notes.append("❌ REJECT - Low confidence\n");
        }
        
        return notes.toString();
    }

    // Helper methods for image analysis
    
    private boolean checkUniformNoise(BufferedImage image) {
        // Simplified noise detection
        // Real implementation would use more sophisticated algorithms
        return false; // Placeholder
    }

    private boolean checkArtificialPatterns(BufferedImage image) {
        // Check for repetitive patterns common in AI-generated images
        return false; // Placeholder
    }

    private boolean checkColorDistribution(BufferedImage image) {
        // Check if color distribution is unnatural
        return false; // Placeholder
    }

    private double calculateAverageBrightness(BufferedImage image) {
        long sum = 0;
        int count = 0;
        
        for (int y = 0; y < image.getHeight(); y++) {
            for (int x = 0; x < image.getWidth(); x++) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                sum += (r + g + b) / 3;
                count++;
            }
        }
        
        return count > 0 ? (double) sum / count : 0;
    }

    private boolean checkSharpness(BufferedImage image) {
        // Simplified sharpness check using edge detection
        // Real implementation would use Laplacian or similar algorithms
        return true; // Placeholder - assume sharp for now
    }

    private boolean checkForPlasticContent(BufferedImage image) {
        // Check for plastic-like colors and textures
        // This is a simplified version
        int plasticColorCount = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Check for common plastic colors (white, transparent, colored)
                if ((r > 200 && g > 200 && b > 200) || // White plastic
                    (Math.abs(r - g) < 30 && Math.abs(g - b) < 30)) { // Uniform colors
                    plasticColorCount++;
                }
            }
        }
        
        return plasticColorCount > (totalPixels / 100); // At least 1% plastic-like pixels
    }

    private boolean checkForGreenContent(BufferedImage image) {
        // Check for green colors (plants, trees)
        int greenPixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Check if pixel is greenish
                if (g > r && g > b && g > 80) {
                    greenPixels++;
                }
            }
        }
        
        return greenPixels > (totalPixels / 200); // At least 0.5% green pixels
    }

    private boolean checkForWaterContent(BufferedImage image) {
        // Check for blue/cyan colors (water)
        int bluePixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Check if pixel is blueish/cyan
                if (b > r && (b > g || Math.abs(b - g) < 30)) {
                    bluePixels++;
                }
            }
        }
        
        return bluePixels > (totalPixels / 200); // At least 0.5% blue pixels
    }

    private boolean checkForVehicleOrPeople(BufferedImage image) {
        // Check for vehicles (cars, bikes) or people
        // Look for common vehicle colors and shapes
        int vehicleIndicators = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        // Check for metallic/vehicle colors (gray, black, white, red, blue)
        int metallicPixels = 0;
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Metallic/vehicle colors
                if ((Math.abs(r - g) < 20 && Math.abs(g - b) < 20) || // Gray/metallic
                    (r < 50 && g < 50 && b < 50) || // Black
                    (r > 200 && g > 200 && b > 200)) { // White
                    metallicPixels++;
                }
            }
        }
        
        // Must have significant metallic/vehicle-like content
        // AND should have some human skin tones (people in car)
        boolean hasVehicleColors = metallicPixels > (totalPixels / 100); // At least 1%
        boolean hasPeople = checkForSkinTones(image);
        
        return hasVehicleColors && hasPeople;
    }

    private boolean checkForSkinTones(BufferedImage image) {
        // Check for human skin tones
        int skinPixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Skin tone detection (various ethnicities)
                if (r > 95 && g > 40 && b > 20 &&
                    r > g && r > b &&
                    Math.abs(r - g) > 15 &&
                    r - b > 15) {
                    skinPixels++;
                }
            }
        }
        
        return skinPixels > (totalPixels / 500); // At least 0.2% skin tones
    }

    private boolean checkForRecyclingContent(BufferedImage image) {
        // Check for recycling bins (often blue, green, or have recycling symbols)
        // Look for bins, containers, sorted items
        int binColorPixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Blue or green bins
                if ((b > r + 30 && b > g) || // Blue
                    (g > r + 30 && g > b)) { // Green
                    binColorPixels++;
                }
            }
        }
        
        return binColorPixels > (totalPixels / 150); // At least 0.67%
    }

    private boolean checkForEnergyContent(BufferedImage image) {
        // Check for solar panels (dark blue/black rectangular patterns)
        // or energy equipment
        int darkBluePixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Dark blue/black (solar panels)
                if (b > r && b > g && b < 150) {
                    darkBluePixels++;
                }
            }
        }
        
        return darkBluePixels > (totalPixels / 100); // At least 1%
    }

    private boolean checkForDocumentContent(BufferedImage image) {
        // Check for documents, papers, signs (lots of white/light colors with text)
        int lightPixels = 0;
        int totalPixels = image.getWidth() * image.getHeight();
        
        for (int y = 0; y < image.getHeight(); y += 10) {
            for (int x = 0; x < image.getWidth(); x += 10) {
                int rgb = image.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // White/light paper colors
                if (r > 200 && g > 200 && b > 200) {
                    lightPixels++;
                }
            }
        }
        
        // Documents should have significant white/light areas
        return lightPixels > (totalPixels / 50); // At least 2%
    }
}
