<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Greenverse Tasks - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/greenverse-tasks.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/user-header.jsp" %>
    <main class="main-content">
        <div class="page-header">
            <h1>Greenverse Tasks</h1>
        </div>
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-info">
                    <p>Completed Tasks</p>
                    <h3 class="stat-number">${completedTasks}</h3>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-info">
                    <p>Current Task</p>
                    <c:if test="${not empty lastSubmittedTask}">
                        <h3 class="stat-number" style="font-size: 14px; color: #2d5f3f;">
                            ${lastSubmittedTask.task.topic}<br>
                            <span style="font-size: 12px; color: #666;">→ ${fn:toLowerCase(lastSubmittedTask.task.level)} task</span><br>
                            <span style="font-size: 11px; color: #999;">${lastSubmittedTask.task.description}</span>
                        </h3>
                    </c:if>
                    <c:if test="${empty lastSubmittedTask}">
                        <h3 class="stat-number" style="font-size: 14px; color: #999;">No tasks submitted yet</h3>
                    </c:if>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-info">
                    <p>Available Tasks</p>
                    <h3 class="stat-number">${availableTasks.size()}</h3>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-info">
                    <p>Total XP</p>
                    <h3 class="stat-number">${user.xpPoints}</h3>
                </div>
            </div>
        </section>
        <section class="topics-container">
            <c:forEach var="progress" items="${progressList}">
                <div class="topic-card ${progress.topic eq currentTopic.topic ? 'current' : ''} ${!progress.isUnlocked ? 'locked' : ''}">
                    <div class="topic-header">
                        <div class="topic-title">${progress.topic}</div>
                    </div>
                    <div class="topic-content">
                        <div class="difficulty-tabs">
                            <button class="tab active" data-difficulty="easy">Easy</button>
                            <button class="tab" data-difficulty="medium">Medium</button>
                            <button class="tab" data-difficulty="hard">Hard</button>
                        </div>
                        <div class="tasks-grid-container">
                            <div class="tasks-grid active" data-difficulty="easy">
                                <c:forEach var="task" items="${availableTasks}">
                                    <c:if test="${task.topic eq progress.topic and task.level eq 'Easy'}">
                                        <div class="task-card">
                                            <p>${task.description}</p>
                                            <button class="btn">Complete Task</button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div class="tasks-grid" data-difficulty="medium">
                                <c:forEach var="task" items="${availableTasks}">
                                    <c:if test="${task.topic eq progress.topic and task.level eq 'Medium'}">
                                        <div class="task-card">
                                            <p>${task.description}</p>
                                            <button class="btn">Complete Task</button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div class="tasks-grid" data-difficulty="hard">
                                <c:forEach var="task" items="${availableTasks}">
                                    <c:if test="${task.topic eq progress.topic and task.level eq 'Hard'}">
                                        <div class="task-card">
                                            <p>${task.description}</p>
                                            <button class="btn">Complete Task</button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </section>
    </main>
</body>
</html>