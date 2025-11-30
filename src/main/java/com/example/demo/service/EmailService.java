package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@releaf.com}")
    private String fromEmail;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    public boolean sendPasswordResetEmail(String toEmail, String userName, String resetToken) {
        if (mailSender == null) {
            System.out.println("=== EMAIL SERVICE NOT CONFIGURED ===");
            System.out.println("To: " + toEmail);
            System.out.println("Reset Link: " + baseUrl + "/reset-password?token=" + resetToken);
            System.out.println("=====================================");
            return true; // Return true for demo purposes
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("ReLeaf - Password Reset Request");
            message.setText(buildPasswordResetEmailBody(userName, resetToken));

            mailSender.send(message);
            System.out.println("Password reset email sent to: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private String buildPasswordResetEmailBody(String userName, String resetToken) {
        String resetLink = baseUrl + "/reset-password?token=" + resetToken;
        
        return "Hello " + userName + ",\n\n" +
               "We received a request to reset your password for your ReLeaf account.\n\n" +
               "Click the link below to reset your password:\n" +
               resetLink + "\n\n" +
               "This link will expire in 1 hour.\n\n" +
               "If you didn't request this password reset, please ignore this email.\n\n" +
               "Best regards,\n" +
               "The ReLeaf Team";
    }
}
