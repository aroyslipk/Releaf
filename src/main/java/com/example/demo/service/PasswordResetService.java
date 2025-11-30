package com.example.demo.service;

import com.example.demo.entity.PasswordResetToken;
import com.example.demo.entity.User;
import com.example.demo.repository.PasswordResetTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class PasswordResetService {

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    public boolean initiatePasswordReset(String email) {
        Optional<User> userOpt = userService.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        
        // Invalidate any existing tokens for this user
        Optional<PasswordResetToken> existingToken = tokenRepository.findByUserAndUsedFalse(user);
        existingToken.ifPresent(token -> {
            token.setUsed(true);
            tokenRepository.save(token);
        });

        // Generate new token
        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = new PasswordResetToken(token, user);
        tokenRepository.save(resetToken);

        // Send email
        return emailService.sendPasswordResetEmail(user.getEmail(), user.getName(), token);
    }

    public Optional<User> validateToken(String token) {
        Optional<PasswordResetToken> tokenOpt = tokenRepository.findByToken(token);
        
        if (tokenOpt.isEmpty()) {
            return Optional.empty();
        }

        PasswordResetToken resetToken = tokenOpt.get();
        
        if (resetToken.isUsed() || resetToken.isExpired()) {
            return Optional.empty();
        }

        return Optional.of(resetToken.getUser());
    }

    public boolean resetPassword(String token, String newPassword) {
        Optional<PasswordResetToken> tokenOpt = tokenRepository.findByToken(token);
        
        if (tokenOpt.isEmpty()) {
            return false;
        }

        PasswordResetToken resetToken = tokenOpt.get();
        
        if (resetToken.isUsed() || resetToken.isExpired()) {
            return false;
        }

        // Update password
        User user = resetToken.getUser();
        userService.updatePassword(user.getId(), newPassword);

        // Mark token as used
        resetToken.setUsed(true);
        tokenRepository.save(resetToken);

        return true;
    }
}
