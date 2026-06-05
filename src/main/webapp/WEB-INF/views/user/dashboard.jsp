<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
    <div class="dashboard-container">
        <div class="dashboard-main">
            <div class="welcome-banner">
                <h2>Welcome back, ${user.name}!</h2>
                <p>Your journey to a greener planet continues. Keep up the great work!</p>
            </div>

            <div class="progress-overview card">
                <div class="card-header">
                    <h3 class="card-title">Your Progress</h3>
                </div>
                <div class="progress-item">
                    <div class="progress-info">
                        <span class="progress-label">XP Progress to Next Reward</span>
                        <span class="progress-value">${user.xpPoints}/${nextRewardXP} XP</span>
                    </div>
                    <div class="progress-bar-container">
                        <c:set var="progressPercent" value="${nextRewardXP > 0 ? (user.xpPoints * 100.0) / nextRewardXP : 0}" />
                        <div class="progress-bar" style="width: ${progressPercent}%;"></div>
                    </div>
                </div>
            </div>

            <div class="quick-actions card">
                <div class="card-header">
                    <h3 class="card-title">Quick Actions</h3>
                </div>
                <div class="actions-grid">
                    <a href="/user/tasks" class="action-button">
                        <i class="fas fa-tasks"></i>
                        <span>Browse Tasks</span>
                    </a>
                    <a href="/user/groups" class="action-button">
                        <i class="fas fa-users"></i>
                        <span>View Groups</span>
                    </a>
                    <a href="/user/achievements" class="action-button">
                        <i class="fas fa-trophy"></i>
                        <span>View Achievements</span>
                    </a>
                    <a href="/user/notices" class="action-button">
                        <i class="fas fa-bullhorn"></i>
                        <span>Read Notices</span>
                    </a>
                </div>
            </div>

            <c:if test="${not empty notices}">
                <div class="recent-notices card">
                    <div class="card-header">
                        <h3 class="card-title">Recent Notices</h3>
                        <a href="/user/notices" class="view-all-link">View All</a>
                    </div>
                    <div class="notices-list">
                        <c:forEach var="notice" items="${notices}" varStatus="status">
                            <c:if test="${status.index < 3}">
                                <div class="notice-item">
                                    <div class="notice-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <div class="notice-content">
                                        <h4 class="notice-title">${notice.title}</h4>
                                        <p class="notice-preview">${notice.content.length() > 100 ? notice.content.substring(0, 100).concat('...') : notice.content}</p>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="dashboard-sidebar">
            <div class="stats-summary card">
                <div class="card-header">
                    <h3 class="card-title">Your Stats</h3>
                </div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${user.xpPoints}</div>
                        <div class="stat-label">Total XP</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${completedTasksCount}</div>
                        <div class="stat-label">Tasks Done</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${currentRewardLevel}</div>
                        <div class="stat-label">Current Reward</div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty user.unlockedRewards}">
                <div class="recent-achievements card">
                    <div class="card-header">
                        <h3 class="card-title">Recent Achievements</h3>
                        <a href="/user/achievements" class="view-all-link">View All</a>
                    </div>
                    <div class="achievements-list">
                        <c:forEach var="reward" items="${user.unlockedRewards}" varStatus="status">
                            <c:if test="${status.index < 2}">
                                <div class="achievement-item">
                                    <div class="achievement-icon">🏆</div>
                                    <div class="achievement-info">
                                        <h4 class="achievement-title">${reward.type}</h4>
                                        <p class="achievement-desc">${reward.description}</p>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <div class="motivation-quote card">
                <div class="quote-icon">“</div>
                <p class="quote-text">The greatest threat to our planet is the belief that someone else will save it.</p>
                <span class="quote-author">- Robert Swan</span>
            </div>
        </div>
    </div>
</main>
</body>
</html>

