package com.example.demo.service;

import com.example.demo.entity.Message;
import com.example.demo.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MessageService {

    @Autowired
    private MessageRepository messageRepository;

    public Message sendMessage(String fromUser, String toUser, String subject, String body) {
        Message message = new Message(fromUser, toUser, subject, body);
        return messageRepository.save(message);
    }

    public Optional<Message> findById(Long id) {
        return messageRepository.findById(id);
    }

    public List<Message> getAllMessages() {
        return messageRepository.findAll();
    }

    public List<Message> getReceivedMessages(String toUser) {
        return messageRepository.findByToUserOrderByCreatedAtDesc(toUser);
    }

    public List<Message> getSentMessages(String fromUser) {
        return messageRepository.findByFromUserOrderByCreatedAtDesc(fromUser);
    }

    public List<Message> getUnreadMessages(String toUser) {
        return messageRepository.findByToUserAndIsReadFalse(toUser);
    }

    public Message markAsRead(Long messageId) {
        Optional<Message> messageOpt = messageRepository.findById(messageId);
        if (messageOpt.isPresent()) {
            Message message = messageOpt.get();
            message.setIsRead(true);
            return messageRepository.save(message);
        }
        return null;
    }

    public void deleteMessage(Long id) {
        messageRepository.deleteById(id);
    }

    public long getUnreadMessageCount(String toUser) {
        return messageRepository.findByToUserAndIsReadFalse(toUser).size();
    }
}

