<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Greenverse Tasks - ReLeaf</title>
    
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="<c:url value='/css/modern-admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/greenverse-tasks.css'/>">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/user-header.jsp" %>

    <main class="main-content">
        <div class="page-header">
            <h1>Greenverse Tasks</h1>
            <p class="page-subtitle">Complete tasks, earn XP, and help save the planet!</p>
        </div>

        <!-- Stats Section -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>${completedTasks}</h3>
                    <p>Tasks Completed</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-spinner"></i>
                </div>
                <div class="stat-info">
                    <h3>${activeTasks}</h3>
                    <p>Active Tasks</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div class="stat-info">
                    <h3>${unreadNotices}</h3>
                    <p>Unread Notices</p>
                </div>
            </div>
        </section>

        <!-- Progress Section -->
        <section class="progress-section">
            <h2>Your Progress</h2>
            <c:if test="${not empty currentTopic}">
                <p>Current Topic: <strong>${currentTopic.topic.topicName}</strong></p>
                <div class="progress-bar">
                    <c:set var="progressPercent" value="${currentTopic.totalTasks > 0 ? (currentTopic.completedTasks * 100) / currentTopic.totalTasks : 0}" />
                    <fmt:formatNumber value="${progressPercent}" maxFractionDigits="0" var="progressPercentFormatted"/>
                    <div class="progress-fill" style="width: ${progressPercentFormatted}%;"></div>
                </div>
                <p>${progressPercentFormatted}% Complete</p>
            </c:if>
            <p>Next Topic Unlocks: <strong>${not empty nextTopic ? nextTopic.topic.topicName : 'All topics unlocked!'}</strong></p>
        </section>

        <!-- Available Tasks -->
        <section class="tasks-section">
            <h2>Available Tasks</h2>
            
            <div class="task-list">
                <c:forEach var="task" items="${availableTasks}" varStatus="loop">
                    <div class="task-item ${lastActiveTaskId == task.id ? 'current' : ''}">
                        <div class="task-icon">
                            <c:choose>
                                <c:when test="${task.topic == 'Water Conservation'}"><i class="fas fa-tint"></i></c:when>
                                <c:when test="${task.topic == 'Energy Efficiency'}"><i class="fas fa-bolt"></i></c:when>
                                <c:when test="${task.topic == 'Waste Reduction'}"><i class="fas fa-recycle"></i></c:when>
                                <c:otherwise><i class="fas fa-leaf"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="task-content">
                            <h3>${task.title}</h3>
                            <p>${task.description}</p>
                            <span class="task-level">${task.level}</span>
                        </div>
                        <div class="task-actions">
                            <span class="task-xp">+${task.xpReward} XP</span>
                            <form action="<c:url value='/user/complete-task'/>" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="taskId" value="${task.id}">
                                <label for="proofImage-${task.id}" class="task-submit-btn">
                                    <i class="fas fa-arrow-right"></i>
                                </label>
                                <input type="file" name="proofImage" id="proofImage-${task.id}" class="hidden" required onchange="this.form.submit()">
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </main>

    <script>
        // Add some simple animations
        document.addEventListener('DOMContentLoaded', function() {
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>