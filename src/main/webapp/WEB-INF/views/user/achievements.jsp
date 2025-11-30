<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achievements - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/achievements.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .btn-themed {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(45, 122, 72, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
            background: linear-gradient(135deg, #358856, #3d9960);
            color: white;
        }
        .btn-secondary-themed {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-secondary-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(108, 117, 125, 0.35);
            background: linear-gradient(135deg, #5a6268, #545b62);
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-trophy" style="margin-right: 12px;"></i>Your Achievements</h1>

        <!-- Progress Overview -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Progress Overview</h2>
            </div>
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
                    <div class="stat-number">${unlockedRewardsCount}</div>
                    <div class="stat-label">Rewards Unlocked</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${progressPercentage}%</div>
                    <div class="stat-label">Overall Progress</div>
                </div>
            </div>
        </div>

        <!-- XP Progress -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">XP Progress</h2>
            </div>
            <div class="progress-section">
                <div class="progress-header">
                    <span class="progress-title">Progress to Next Reward (${currentRewardLevel} → ${nextRewardXP} XP)</span>
                    <span class="progress-text">${user.xpPoints}/${nextRewardXP} XP</span>
                </div>
                <div class="progress">
                    <div class="progress-bar" style="width: ${xpPercentage}%"></div>
                </div>
                <p class="xp-info">
                    ${nextRewardXP - user.xpPoints} XP needed for your next reward!
                </p>
            </div>

            <div class="achievement-grid">
                <div class="achievement-card ${user.xpPoints >= 90 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🥉</div>
                    <strong>Bronze</strong><br>
                    <small>90 XP</small>
                </div>
                <div class="achievement-card ${user.xpPoints >= 180 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🥈</div>
                    <strong>Silver</strong><br>
                    <small>180 XP</small>
                </div>
                <div class="achievement-card ${user.xpPoints >= 360 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🥇</div>
                    <strong>Gold</strong><br>
                    <small>360 XP</small>
                </div>
                <div class="achievement-card ${user.xpPoints >= 720 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🏆</div>
                    <strong>Champion</strong><br>
                    <small>720 XP</small>
                </div>
            </div>
        </div>

        <!-- Unlocked Rewards -->
        <c:if test="${not empty unlockedRewardsList}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Unlocked Rewards</h2>
                </div>
                <div class="reward-grid">
                    <c:forEach var="reward" items="${unlockedRewardsList}">
                        <div class="reward-card">
                            <div class="reward-icon">${reward.icon}</div>
                            <h3 class="reward-title">${reward.type}</h3>
                            <p class="reward-description">${reward.description}</p>
                            <div class="reward-requirement">
                                <small>Required: ${reward.xpRequired} XP</small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Task Completion by Topic -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Task Completion by Topic</h2>
            </div>
            <div class="topic-completion-grid">
                <c:set var="topics" value="Plastronauts,Aether Shield,Hydronauts,ChronoClimbers,Verdantra,TerraFixers,SmogSmiths,EcoMentors" />
                <c:forEach var="topic" items="${topics.split(',')}">
                    <div class="topic-card">
                        <h3 class="topic-title">${topic}</h3>
                        <c:set var="topicCompletedCount" value="0" />
                        <c:forEach var="completedTask" items="${user.completedTasks}">
                            <c:if test="${completedTask.topic == topic}">
                                <c:set var="topicCompletedCount" value="${topicCompletedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        <div class="topic-progress">
                            <span class="topic-label">Completed Tasks</span>
                            <span class="topic-count">${topicCompletedCount}/9</span>
                        </div>
                        <div class="progress">
                            <c:set var="topicProgress" value="${topicCompletedCount * 100 / 9}" />
                            <div class="progress-bar" style="width: ${topicProgress}%"></div>
                        </div>
                        <c:if test="${topicCompletedCount == 9}">
                            <div class="topic-completion">
                                <span class="completion-badge">
                                    ✓ Topic Completed!
                                </span>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Achievement Milestones -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Achievement Milestones</h2>
            </div>
            <div class="milestone-grid">
                <div class="milestone-card" data-completed="${completedTasksCount >= 1}">
                    <div class="milestone-icon">${completedTasksCount >= 1 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">First Steps</h3>
                    <p class="milestone-description">Complete your first task</p>
                </div>
                <div class="milestone-card" data-completed="${completedTasksCount >= 5}">
                    <div class="milestone-icon">${completedTasksCount >= 5 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">Getting Started</h3>
                    <p class="milestone-description">Complete 5 tasks</p>
                </div>
                <div class="milestone-card" data-completed="${completedTasksCount >= 10}">
                    <div class="milestone-icon">${completedTasksCount >= 10 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">Eco Enthusiast</h3>
                    <p class="milestone-description">Complete 10 tasks</p>
                </div>
                <div class="milestone-card" data-completed="${completedTasksCount >= 25}">
                    <div class="milestone-icon">${completedTasksCount >= 25 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">Eco Warrior</h3>
                    <p class="milestone-description">Complete 25 tasks</p>
                </div>
                <div class="milestone-card" data-completed="${completedTasksCount >= 50}">
                    <div class="milestone-icon">${completedTasksCount >= 50 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">Planet Protector</h3>
                    <p class="milestone-description">Complete 50 tasks</p>
                </div>
                <div class="milestone-card" data-completed="${completedTasksCount >= 72}">
                    <div class="milestone-icon">${completedTasksCount >= 72 ? '✅' : '⏳'}</div>
                    <h3 class="milestone-title">Eco Master</h3>
                    <p class="milestone-description">Complete all 72 tasks</p>
                </div>
            </div>
        </div>

        <!-- Motivational Section -->
        <div class="card">
            <div class="motivational-section">
                <h2 class="motivational-title">Keep Making a Difference!</h2>
                <p class="motivational-text">
                    Every task you complete brings us closer to a more sustainable future. Your actions inspire others and create real environmental impact.
                </p>
                <div class="button-container">
                    <a href="/user/tasks" class="btn-themed"><i class="fas fa-tasks"></i> Continue Tasks</a>
                    <a href="/user/dashboard" class="btn-secondary-themed"><i class="fas fa-home"></i> Back to Dashboard</a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>