package com.example.demo.service;

import com.example.demo.entity.Notice;
import com.example.demo.repository.NoticeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class NoticeService {

    @Autowired
    private NoticeRepository noticeRepository;

    public List<Notice> getAllNotices() {
        return noticeRepository.findAll();
    }

    public List<Notice> getActiveNotices() {
        return noticeRepository.findByIsActiveTrue();
    }

    public List<Notice> getRecentNotices() {
        return noticeRepository.findByIsActiveTrueOrderByCreatedAtDesc();
    }

    // Method for AdminController - findById
    public Optional<Notice> findById(Long id) {
        return noticeRepository.findById(id);
    }
    
    // Method for AdminController - createNotice with title and content
    public Notice createNotice(String title, String content) {
        Notice notice = new Notice();
        notice.setTitle(title);
        notice.setContent(content);
        notice.setIsActive(true);
        return noticeRepository.save(notice);
    }
    
    // Original createNotice method
    public Notice createNotice(Notice notice) {
        return noticeRepository.save(notice);
    }

    public Notice updateNotice(Notice notice) {
        return noticeRepository.save(notice);
    }

    public void deleteNotice(Long id) {
        noticeRepository.deleteById(id);
    }
    
    // Method for AdminController - toggleNoticeStatus
    public void toggleNoticeStatus(Long id) {
        Optional<Notice> noticeOpt = noticeRepository.findById(id);
        if (noticeOpt.isPresent()) {
            Notice notice = noticeOpt.get();
            notice.setIsActive(!notice.getIsActive());
            noticeRepository.save(notice);
        }
    }
    
    // New method for dashboard statistics
    public int getUnreadNoticesCount() {
        return noticeRepository.countByIsActiveTrue();
    }
    
    // Overloaded method to accept userId parameter
    public int getUnreadNoticesCount(Long userId) {
        // For now, we'll just return the count of active notices
        // In a real application, you might track which users have read which notices
        return noticeRepository.countByIsActiveTrue();
    }
}