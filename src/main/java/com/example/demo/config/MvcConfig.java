package com.example.demo.config; // Or your actual package

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull; // <-- ADD THIS IMPORT
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) { // <-- ADD @NonNull HERE
        registry.addResourceHandler("/user-photos/**")
                .addResourceLocations("file:" + uploadDir);
    }
}