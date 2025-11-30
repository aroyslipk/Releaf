package com.example.demo.controller;

import com.example.demo.entity.User;
import com.example.demo.entity.Admin;
import com.example.demo.service.UserService;
import com.example.demo.service.AdminService;
import com.example.demo.service.PasswordResetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.ResponseEntity;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private AdminService adminService;

    @Autowired
    private PasswordResetService passwordResetService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                           @RequestParam(value = "type", required = false) String type,
                           Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid credentials");
        }
        model.addAttribute("loginType", type != null ? type : "user");
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                       @RequestParam String password,
                       @RequestParam(value = "loginType", defaultValue = "user") String loginType,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {

        if ("admin".equals(loginType)) {
            Optional<Admin> adminOpt = adminService.findByUsername(email);
            if (adminOpt.isPresent() && adminService.validatePassword(password, adminOpt.get().getPassword())) {
                session.setAttribute("adminId", adminOpt.get().getId());
                session.setAttribute("adminUsername", adminOpt.get().getUsername());
                session.setAttribute("userType", "admin");
                return "redirect:/admin/dashboard";
            }
        } else {
            Optional<User> userOpt = userService.findByEmail(email);
            if (userOpt.isPresent() && userService.validatePassword(password, userOpt.get().getPassword())) {
                session.setAttribute("userId", userOpt.get().getId());
                session.setAttribute("userName", userOpt.get().getName());
                session.setAttribute("userType", "user");
                return "redirect:/user/dashboard";
            }
        }

        redirectAttributes.addAttribute("error", "true");
        redirectAttributes.addAttribute("type", loginType);
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String firstname,
                          @RequestParam String lastname,
                          @RequestParam String email,
                          @RequestParam String password,
                          @RequestParam String confirmPassword,
                          RedirectAttributes redirectAttributes) {

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            return "redirect:/register";
        }

        try {
            String fullName = firstname + " " + lastname;
            userService.createUser(fullName, email, password);
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // Forgot password endpoint - sends password reset email
    @PostMapping("/forgot-password")
    @ResponseBody
    public ResponseEntity<java.util.Map<String, Object>> forgotPassword(@RequestParam(required = false) String email) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        
        try {
            System.out.println("Forgot password request received for email: " + email);
            
            if (email == null || email.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Please enter an email address.");
                return ResponseEntity.ok(response);
            }
            
            // Use PasswordResetService to handle the reset
            boolean success = passwordResetService.initiatePasswordReset(email.trim());
            
            if (!success) {
                response.put("success", false);
                response.put("message", "No account found with this email address.");
                return ResponseEntity.ok(response);
            }
            
            response.put("success", true);
            response.put("message", "Password reset link has been sent to your email. Please check your inbox and spam folder.");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("Error in forgot password: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "An error occurred. Please try again later.");
            return ResponseEntity.ok(response);
        }
    }

    // Reset password page
    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam String token, Model model) {
        Optional<User> userOpt = passwordResetService.validateToken(token);
        
        if (userOpt.isEmpty()) {
            model.addAttribute("error", "Invalid or expired reset link. Please request a new one.");
            model.addAttribute("invalidToken", true);
        } else {
            model.addAttribute("token", token);
            model.addAttribute("email", userOpt.get().getEmail());
        }
        
        return "reset-password";
    }

    // Process password reset
    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String token,
                               @RequestParam String password,
                               @RequestParam String confirmPassword,
                               RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            return "redirect:/reset-password?token=" + token;
        }

        if (password.length() < 6) {
            redirectAttributes.addFlashAttribute("error", "Password must be at least 6 characters");
            return "redirect:/reset-password?token=" + token;
        }

        boolean success = passwordResetService.resetPassword(token, password);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Password reset successful! Please login with your new password.");
            return "redirect:/login";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid or expired reset link. Please request a new one.");
            return "redirect:/login";
        }
    }
}

