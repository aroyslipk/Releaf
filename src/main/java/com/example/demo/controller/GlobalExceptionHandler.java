package com.example.demo.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.transaction.UnexpectedRollbackException;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UnexpectedRollbackException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleUnexpectedRollback(
            UnexpectedRollbackException ex, 
            HttpServletRequest request) {
        
        System.err.println("=== UnexpectedRollbackException ===");
        System.err.println("URI: " + request.getRequestURI());
        ex.printStackTrace();
        
        // Check if this is an AJAX request
        String contentType = request.getHeader("Accept");
        String xRequestedWith = request.getHeader("X-Requested-With");
        
        if ((contentType != null && contentType.contains("application/json")) || 
            "XMLHttpRequest".equals(xRequestedWith)) {
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Transaction failed. Please try again.");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
        }
        
        // For non-AJAX requests, let Spring handle it normally
        throw ex;
    }

    @ExceptionHandler(RuntimeException.class)
    public Object handleRuntimeException(
            RuntimeException ex, 
            HttpServletRequest request) {
        
        System.err.println("=== RuntimeException ===");
        System.err.println("URI: " + request.getRequestURI());
        System.err.println("Message: " + ex.getMessage());
        ex.printStackTrace();
        
        // Check if this is an AJAX request expecting JSON
        String contentType = request.getHeader("Accept");
        String xRequestedWith = request.getHeader("X-Requested-With");
        
        if ((contentType != null && contentType.contains("application/json")) || 
            "XMLHttpRequest".equals(xRequestedWith) ||
            request.getRequestURI().contains("/complete-task")) {
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
        }
        
        // For non-AJAX requests, return error view with details
        ModelAndView mav = new ModelAndView("error");
        mav.addObject("error", ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred");
        return mav;
    }
    
    @ExceptionHandler(Exception.class)
    public Object handleException(
            Exception ex, 
            HttpServletRequest request) {
        
        System.err.println("=== Exception ===");
        System.err.println("URI: " + request.getRequestURI());
        System.err.println("Type: " + ex.getClass().getName());
        System.err.println("Message: " + ex.getMessage());
        ex.printStackTrace();
        
        // Check if this is an AJAX request expecting JSON
        String contentType = request.getHeader("Accept");
        String xRequestedWith = request.getHeader("X-Requested-With");
        
        if ((contentType != null && contentType.contains("application/json")) || 
            "XMLHttpRequest".equals(xRequestedWith)) {
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
        }
        
        // For non-AJAX requests, return error view with details
        ModelAndView mav = new ModelAndView("error");
        mav.addObject("error", ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred");
        return mav;
    }
}
