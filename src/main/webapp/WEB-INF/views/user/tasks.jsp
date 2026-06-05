<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Greenverse Tasks - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/tasks.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body class="tasks-page">
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">Greenverse Tasks</h1>
            <p class="page-subtitle">Complete tasks in each topic to earn XP and unlock new challenges.</p>
        </div>

        <div class="topic-accordion">
            <c:forEach var="progress" items="${progressList}">
                <div class="topic-card ${progress.status == 'UNLOCKED' ? 'expanded' : ''}">
                    <div class="topic-header" onclick="toggleTopic(this)">
                        <span class="topic-title">${progress.topicName}</span>
                        <span class="topic-status">${progress.status}</span>
                    </div>
                    <div class="topic-content">
                        <c:if test="${progress.status != 'LOCKED'}">
                            <div class="tasks-grid">
                                <c:forEach var="task" items="${availableTasks}">
                                    <c:if test="${task.topic == progress.topicName}">
                                        <div class="task-card">
                                            <h5>${task.title}</h5>
                                            <p>${task.description}</p>
                                            <button class="btn btn-primary" onclick="openTaskModal(${task.id}, '${task.description}')">
                                                Complete Task
                                            </button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${progress.status == 'LOCKED'}">
                            <p>Complete the previous topics to unlock these tasks.</p>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- Task Completion Modal -->
    <div id="taskModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Complete Task</h2>
                <span class="close" onclick="closeTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="taskDescription"></p>
                <form id="taskForm" method="post" action="/user/complete-task" enctype="multipart/form-data">
                    <input type="hidden" id="taskId" name="taskId">
                    <div class="form-group">
                        <label for="proofImage">Upload Proof</label>
                        <input type="file" id="proofImage" name="proofImage" class="form-control" accept="image/*" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Submit for Review</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleTopic(header) {
            const topicCard = header.closest('.topic-card');
            topicCard.classList.toggle('expanded');
        }

        function openTaskModal(taskId, description) {
            document.getElementById('taskId').value = taskId;
            document.getElementById('taskDescription').innerText = description;
            document.getElementById('taskModal').style.display = 'block';
        }

        function closeTaskModal() {
            document.getElementById('taskModal').style.display = 'none';
        }
    </script>
</body>
</html>