<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>ReLeaf</h1>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/user/dashboard">Dashboard</a></li>
                    <li><a href="/user/tasks">Tasks</a></li>
                    <li><a href="/user/achievements">Achievements</a></li>
                    <li><a href="/user/notices">Notices</a></li>
                    <li><a href="/user/groups">Groups</a></li>
                    <li><a href="/user/messages">Messages</a></li>
                    <li><a href="/user/profile">Profile</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.userName}</span>
                <span class="xp-badge">${user.xpPoints} XP</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <h1 class="page-title">Welcome back, ${user.name}!</h1>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-number">${user.xpPoints}</div>
                <div class="stat-label">Total XP Points</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${completedTasksCount}</div>
                <div class="stat-label">Tasks Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${user.unlockedRewards.size()}</div>
                <div class="stat-label">Rewards Unlocked</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${user.group != null}">
                            ${user.group.groupName}
                        </c:when>
                        <c:otherwise>
                            None
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Current Group</div>
            </div>
        </div>

        <!-- Progress Overview -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Your Progress</h2>
            </div>
            <div style="margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                    <span style="color: var(--dark-green); font-weight: 500;">XP Progress to Next Reward</span>
                    <span style="color: var(--gray);">${user.xpPoints}/90 XP</span>
                </div>
                <div class="progress">
                    <div class="progress-bar" style="width: '${(user.xpPoints % 90) * 100 / 90}%';"></div>
                </div>
                <p style="color: var(--gray); font-size: 0.9rem; margin-top: 0.5rem;">
                    ${90 - (user.xpPoints % 90)} XP needed for your next reward!
                </p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem;">
                <div style="text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">🌱</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Eco Warrior</h3>
                    <p style="color: var(--gray); font-size: 0.9rem;">Keep completing tasks to make a difference!</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">🎯</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Goal Focused</h3>
                    <p style="color: var(--gray); font-size: 0.9rem;">Every action counts towards a greener planet</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">🌍</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Global Impact</h3>
                    <p style="color: var(--gray); font-size: 0.9rem;">Join millions making environmental change</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Quick Actions</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <a href="/user/tasks" class="btn btn-primary">Browse Tasks</a>
                <a href="/user/tasks?level=Easy" class="btn btn-secondary">Easy Tasks</a>
                <a href="/user/achievements" class="btn btn-secondary">View Achievements</a>
                <a href="/user/notices" class="btn btn-secondary">Read Notices</a>
            </div>
        </div>

        <!-- Recent Notices -->
        <c:if test="${not empty notices}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Recent Notices</h2>
                    <a href="/user/notices" style="color: var(--primary-green); text-decoration: none;">View All</a>
                </div>
                <div>
                    <c:forEach var="notice" items="${notices}">
                        <div style="border-bottom: 1px solid var(--light-green); padding: 1rem 0;">
                            <h3 style="color: var(--dark-green); margin: 0 0 0.5rem 0; font-size: 1.1rem;">${notice.title}</h3>
                            <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">
                                ${notice.content.length() > 150 ? notice.content.substring(0, 150).concat('...') : notice.content}
                            </p>
                            <small style="color: var(--gray);">${notice.createdAt.toLocalDate()}</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Recent Achievements -->
<c:if test="${not empty user.unlockedRewards}">
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">Recent Achievements</h2>
            <a href="/user/achievements" style="color: var(--primary-green); text-decoration: none;">View All</a>
        </div>
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 1rem;">
            <c:forEach var="reward" items="${user.unlockedRewards}" varStatus="status">
                <c:if test="${status.index < 3}">
                    <div style="background: linear-gradient(135deg, var(--primary-green), var(--secondary-green)); color: white; padding: 1.5rem; border-radius: 10px; text-align: center;">
                        <div style="font-size: 2rem; margin-bottom: 0.5rem;">🏆</div>
                        
                        <h3 style="margin: 0 0 0.5rem 0; color: rgba(255, 255, 255, 0.95); text-shadow: 1px 1px 3px rgba(0,0,0,0.3);">
                            ${reward.type}
                        </h3>
                        
                        <p style="margin: 0; font-size: 0.9rem; color: rgba(255, 255, 255, 0.85);">
                            ${reward.description}
                        </p>

                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</c:if>

        <!-- Motivational Section -->
        <div class="card">
            <div style="text-align: center; padding: 2rem 0;">
                <h2 style="color: var(--dark-green); margin-bottom: 1rem;">Ready for Your Next Challenge?</h2>
                <p style="color: var(--gray); margin-bottom: 2rem; font-size: 1.1rem;">
                    Every small action contributes to a bigger environmental impact. Start your next eco-friendly task today!
                </p>
                <a href="/user/tasks" class="btn btn-primary" style="font-size: 1.1rem; padding: 1rem 2rem;">
                    Explore Tasks
                </a>
            </div>
        </div>
    </main>
</body>
</html>

