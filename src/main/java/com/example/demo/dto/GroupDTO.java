package com.example.demo.dto;

import com.example.demo.entity.Group;
import com.example.demo.entity.User;
import java.util.List;

public class GroupDTO {
    private Group group;
    private Integer avgXp;
    private List<User> topMembers;
    
    public GroupDTO(Group group) {
        this.group = group;
    }
    
    public Group getGroup() {
        return group;
    }
    
    public void setGroup(Group group) {
        this.group = group;
    }
    
    public Integer getAvgXp() {
        return avgXp;
    }
    
    public void setAvgXp(Integer avgXp) {
        this.avgXp = avgXp;
    }
    
    public List<User> getTopMembers() {
        return topMembers;
    }
    
    public void setTopMembers(List<User> topMembers) {
        this.topMembers = topMembers;
    }
    
    // Delegate methods to the underlying group
    public Long getId() {
        return group.getId();
    }
    
    public String getGroupName() {
        return group.getGroupName();
    }
    
    public String getDescription() {
        return group.getDescription();
    }
    
    public java.util.Set<User> getMembers() {
        return group.getMembers();
    }
} 