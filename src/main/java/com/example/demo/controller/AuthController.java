package com.example.demo.controller;

import com.example.demo.entity.User;
import com.example.demo.entity.Admin;
import com.example.demo.service.UserService;
import com.example.demo.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private AdminService adminService;

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
    public String register(@RequestParam String name,
                          @RequestParam String email,
                          @RequestParam String password,
                          @RequestParam String confirmPassword,
                          RedirectAttributes redirectAttributes) {

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            return "redirect:/register";
        }

        try {
            userService.createUser(name, email, password);
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

    // Removed conflicting dashboard mapping - UserController and AdminController handle their respective dashboards
}

