package com.example.demo.service;

import com.example.demo.entity.GroupMessage;
import com.example.demo.entity.User;
import com.example.demo.entity.Group;
import com.example.demo.repository.GroupMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class GroupMessageService {

    @Autowired
    private GroupMessageRepository groupMessageRepository;

    public GroupMessage sendMessage(Group group, User user, String messageText) {
        try {
            // Validate inputs
            if (group == null) {
                throw new IllegalArgumentException("Group cannot be null");
            }
            if (user == null) {
                throw new IllegalArgumentException("User cannot be null");
            }
            if (messageText == null || messageText.trim().isEmpty()) {
                throw new IllegalArgumentException("Message text cannot be empty");
            }
            
            GroupMessage message = new GroupMessage(group, user, messageText.trim());
            GroupMessage savedMessage = groupMessageRepository.save(message);
            System.out.println("[GroupMessageService] Message saved: ID=" + savedMessage.getId() + ", Text='" + savedMessage.getMessageText() + "', User=" + user.getName() + ", Group=" + group.getGroupName());
            return savedMessage;
        } catch (Exception e) {
            System.err.println("[GroupMessageService] Error saving message: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public List<GroupMessage> getRecentMessages(Long groupId) {
        try {
            // Get messages in ascending order (oldest to newest for proper display)
            // Limit to 50 most recent messages
            List<GroupMessage> allMessages = groupMessageRepository.findByGroupIdOrderByCreatedAtAsc(groupId);
            System.out.println("[GroupMessageService] Retrieved " + allMessages.size() + " total messages for group " + groupId);
            for (int i = 0; i < allMessages.size(); i++) {
                GroupMessage msg = allMessages.get(i);
                System.out.println("  [" + (i+1) + "] ID=" + msg.getId() + ", Text='" + msg.getMessageText() + "', User=" + (msg.getUser() != null ? msg.getUser().getName() : "NULL"));
            }
            
            // Keep only the last 50 messages
            int start = Math.max(0, allMessages.size() - 50);
            List<GroupMessage> result = allMessages.subList(start, allMessages.size());
            System.out.println("[GroupMessageService] Returning " + result.size() + " messages (limited to 50)");
            return result;
        } catch (Exception e) {
            System.err.println("[GroupMessageService] Error retrieving messages: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public List<GroupMessage> getAllMessages(Long groupId) {
        // Get all messages in ascending order (oldest to newest)
        return groupMessageRepository.findByGroupIdOrderByCreatedAtAsc(groupId);
    }
}
