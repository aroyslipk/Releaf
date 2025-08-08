package com.example.demo.service;

import com.example.demo.entity.Group;
import com.example.demo.entity.User;
import com.example.demo.repository.GroupRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class GroupService {

    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private UserRepository userRepository;

    public Group createGroup(String groupName, String description) {
        if (groupRepository.existsByGroupName(groupName)) {
            throw new RuntimeException("Group name is already taken!");
        }

        Group group = new Group(groupName, description);
        return groupRepository.save(group);
    }

    public Optional<Group> findById(Long id) {
        return groupRepository.findById(id);
    }

    public Optional<Group> findByGroupName(String groupName) {
        return groupRepository.findByGroupName(groupName);
    }

    public List<Group> getAllGroups() {
        return groupRepository.findAll();
    }
    
    public List<Group> getAllGroupsWithMembers() {
        return groupRepository.findAllWithMembers();
    }

    public Group updateGroup(Group group) {
        return groupRepository.save(group);
    }

    public void deleteGroup(Long id) {
        // Remove group association from users before deleting
        Optional<Group> groupOpt = groupRepository.findById(id);
        if (groupOpt.isPresent()) {
            Group group = groupOpt.get();
            for (User user : group.getMembers()) {
                user.setGroup(null);
                userRepository.save(user);
            }
        }
        groupRepository.deleteById(id);
    }

    public Group addUserToGroup(Long groupId, Long userId) {
        Optional<Group> groupOpt = groupRepository.findById(groupId);
        Optional<User> userOpt = userRepository.findById(userId);

        if (groupOpt.isPresent() && userOpt.isPresent()) {
            Group group = groupOpt.get();
            User user = userOpt.get();
            
            user.setGroup(group);
            userRepository.save(user);
            
            return groupRepository.findById(groupId).get();
        }
        return null;
    }

    public Group removeUserFromGroup(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            Group group = user.getGroup();
            user.setGroup(null);
            userRepository.save(user);
            return group;
        }
        return null;
    }

    public List<User> getGroupMembers(Long groupId) {
        return userRepository.findByGroupId(groupId);
    }
}

