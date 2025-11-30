<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Releaf</title>
</head>
<body>
    <%@ include file="common/user-header.jsp" %>

    <div class="main-content">
        <div class="welcome-banner">
            <h2>Welcome back, ${user.username}!</h2>
            <p>Track your progress, complete tasks, and make a positive impact on the environment.</p>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Quick Actions</h3>
            </div>
            <div class="actions-grid">
                <a href="/tasks/new" class="action-button">
                    <i class="bi bi-plus-circle"></i>
                    <span>Start New Task</span>
                </a>
                <a href="/groups/join" class="action-button">
                    <i class="bi bi-people-fill"></i>
                    <span>Join a Group</span>
                </a>
                <a href="/achievements" class="action-button">
                    <i class="bi bi-award"></i>
                    <span>View Achievements</span>
                </a>
                <a href="/profile" class="action-button">
                    <i class="bi bi-person-badge"></i>
                    <span>Update Profile</span>
                </a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${taskCount}</div>
                <div class="stat-label">Tasks Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${user.experiencePoints}</div>
                <div class="stat-label">Total XP</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${achievementCount}</div>
                <div class="stat-label">Achievements</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${groupCount}</div>
                <div class="stat-label">Groups Joined</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Recent Activity</h3>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty recentActivities}">
                        <p>No recent activities to show.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-list">
                            <c:forEach items="${recentActivities}" var="activity">
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="bi ${activity.type == 'TASK' ? 'bi-check-circle' : 
                                                     activity.type == 'ACHIEVEMENT' ? 'bi-trophy' : 
                                                     activity.type == 'GROUP' ? 'bi-people' : 'bi-star'}"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">${activity.title}</div>
                                        <div class="activity-time">${activity.timestamp}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
