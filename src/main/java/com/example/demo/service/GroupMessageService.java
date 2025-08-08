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
        GroupMessage message = new GroupMessage(group, user, messageText);
        return groupMessageRepository.save(message);
    }

    public List<GroupMessage> getRecentMessages(Long groupId) {
        return groupMessageRepository.findTop50ByGroupIdOrderByCreatedAtDesc(groupId);
    }

    public List<GroupMessage> getAllMessages(Long groupId) {
        return groupMessageRepository.findByGroupIdOrderByCreatedAtDesc(groupId);
    }
}
