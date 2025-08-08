<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Progressive Tasks - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .progress-tracker {
            background: linear-gradient(135deg, #2d5a27 0%, #4a7c59 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .progress-tracker h3 {
            margin: 0 0 1rem 0;
            font-size: 1.2rem;
            color: #e8f5e8;
        }

        .progress-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .progress-stat {
            text-align: center;
            padding: 0.5rem;
            background: rgba(255,255,255,0.1);
            border-radius: 8px;
        }

        .progress-stat .number {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ffffff;
        }

        .progress-stat .label {
            font-size: 0.8rem;
            color: #e8f5e8;
            margin-top: 0.25rem;
        }

        .topic-container {
            margin-bottom: 1rem;
        }

        .topic-header {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .topic-header:hover {
            background: #e9ecef;
            border-color: #6c757d;
        }

        .topic-header.locked {
            background: #f8f9fa;
            border-color: #dee2e6;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .topic-header.unlocked {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-color: #28a745;
        }

        .topic-header.current {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-color: #ffc107;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }

        .topic-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #495057;
            margin: 0;
        }

        .topic-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .lock-icon {
            font-size: 1.2rem;
            color: #6c757d;
        }

        .unlock-icon {
            font-size: 1.2rem;
            color: #28a745;
        }

        .current-badge {
            background: #28a745;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: auto;
        }

        .topic-content {
            background: white;
            border: 2px solid #e9ecef;
            border-top: none;
            border-radius: 0 0 8px 8px;
            padding: 1.5rem;
            display: none;
        }

        .topic-content.expanded {
            display: block;
        }

        .difficulty-section {
            margin-bottom: 2rem;
        }

        .difficulty-section:last-child {
            margin-bottom: 0;
        }

        .difficulty-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e9ecef;
        }

        .difficulty-title {
            font-size: 1rem;
            font-weight: 600;
            color: #495057;
            margin: 0;
        }

        .difficulty-progress {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .task-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
        }

        .task-card {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            transition: all 0.3s ease;
        }

        .task-card:hover {
            border-color: #28a745;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 0.75rem;
            gap: 0.5rem;
        }

        .task-level {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .task-level.easy {
            background: #d4edda;
            color: #155724;
        }

        .task-level.medium {
            background: #fff3cd;
            color: #856404;
        }

        .task-level.hard {
            background: #f8d7da;
            color: #721c24;
        }

        .task-xp {
            background: #007bff;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .task-description {
            color: #495057;
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .task-status {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .btn-complete {
            background: #28a745;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-complete:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .btn-resubmit {
            background: #007bff;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-resubmit:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .next-topic-highlight {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(255, 193, 7, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0); }
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .modal-header {
            padding: 1.5rem 1.5rem 0 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            color: var(--primary-green);
        }

        .close {
            color: var(--gray);
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: var(--dark-gray);
        }

        .modal-body {
            padding: 1.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark-gray);
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid var(--light-gray);
            border-radius: 4px;
            font-size: 1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-green);
        }
    </style>
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
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h1 class="page-title">Greenverse - Progressive Eco-Friendly Tasks</h1>
            <a href="/user/tasks" class="btn btn-secondary">← Back to Greenverse</a>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>

        <!-- Progress Tracker -->
        <c:if test="${not empty currentTopic}">
            <div class="progress-tracker">
                <h3>Current Topic: ${currentTopic.topic}</h3>
                <div class="progress-stats">
                    <div class="progress-stat">
                        <div class="number">${currentTopic.easyCompleted}/${taskCounts[currentTopic.topic]['easy']}</div>
                        <div class="label">Easy Tasks</div>
                    </div>
                    <div class="progress-stat">
                        <div class="number">${currentTopic.mediumCompleted}/${taskCounts[currentTopic.topic]['medium']}</div>
                        <div class="label">Medium Tasks</div>
                    </div>
                    <div class="progress-stat">
                        <div class="number">${currentTopic.hardCompleted}/${taskCounts[currentTopic.topic]['hard']}</div>
                        <div class="label">Hard Tasks</div>
                    </div>
                    <div class="progress-stat">
                        <div class="number">${currentTopic.easyCompleted + currentTopic.mediumCompleted + currentTopic.hardCompleted}/${taskCounts[currentTopic.topic]['total']}</div>
                        <div class="label">Total Completed</div>
                    </div>
                </div>
                <p style="margin: 0; font-size: 0.9rem; color: #e8f5e8;">
                    Complete 2 Easy tasks to unlock Medium, 2 Medium tasks to unlock Hard, and 1 Hard task to unlock the next topic!
                </p>
            </div>
        </c:if>

        <!-- Topics List -->
        <div class="topics-container">
            <c:forEach var="progress" items="${progressList}" varStatus="status">
                <div class="topic-container">
                    <div class="topic-header ${progress.isUnlocked ? 'unlocked' : 'locked'} ${progress == currentTopic ? 'current' : ''} ${progress == nextTopic ? 'next-topic-highlight' : ''}"
                         onclick="${progress.isUnlocked ? 'toggleTopic(this)' : 'return false'}"
                         data-topic="${progress.topic}">
                        <div class="topic-info">
                            <h3 class="topic-title">${progress.topic}</h3>
                        </div>
                        <div class="topic-status">
                            <c:choose>
                                <c:when test="${progress.isUnlocked}">
                                    <span class="unlock-icon">🔓</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="lock-icon">🔒</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="topic-content" id="content-${progress.topic.replaceAll('[^a-zA-Z0-9]', '-')}">
                        <!-- Easy Tasks -->
                        <c:if test="${progress.easyUnlocked}">
                            <div class="difficulty-section">
                                <div class="difficulty-header">
                                    <h4 class="difficulty-title">Easy Tasks</h4>
                                    <span class="difficulty-progress">${progress.easyCompleted}/${taskCounts[progress.topic]['easy']} completed</span>
                                </div>
                                <div class="task-grid">
                                    <c:forEach var="task" items="${availableTasks}">
                                        <c:if test="${task.topic == progress.topic && task.level == 'Easy'}">
                                            <div class="task-card">
                                                <div class="task-header">
                                                    <span class="task-level easy">Easy</span>
                                                    <span class="task-xp">${task.xpReward} XP</span>
                                                    <c:if test="${lastActiveTaskId == task.id}">
                                                        <span class="current-badge">🟢 Current</span>
                                                    </c:if>
                                                </div>
                                                <p class="task-description">${task.description}</p>
                                                <div class="task-status">
                                                    <c:choose>
                                                        <c:when test="${user.completedTasks.contains(task)}">
                                                            <span class="status-badge status-completed">✓ Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="taskStatus" value=""/>
                                                            <c:forEach var="userTask" items="${userTasks}">
                                                                <c:if test="${userTask.task.id == task.id}">
                                                                    <c:set var="taskStatus" value="${userTask.status}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <c:choose>
                                                                <c:when test="${taskStatus == 'PENDING_REVIEW'}">
                                                                    <span class="status-badge status-pending">⏳ Pending Review</span>
                                                                </c:when>
                                                                <c:when test="${taskStatus == 'REJECTED'}">
                                                                    <button type="button" class="btn-resubmit task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Resubmit Task
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn-complete task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Complete Task
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Medium Tasks -->
                        <c:if test="${progress.mediumUnlocked}">
                            <div class="difficulty-section">
                                <div class="difficulty-header">
                                    <h4 class="difficulty-title">Medium Tasks</h4>
                                    <span class="difficulty-progress">${progress.mediumCompleted}/${taskCounts[progress.topic]['medium']} completed</span>
                                </div>
                                <div class="task-grid">
                                    <c:forEach var="task" items="${availableTasks}">
                                        <c:if test="${task.topic == progress.topic && task.level == 'Medium'}">
                                            <div class="task-card">
                                                <div class="task-header">
                                                    <span class="task-level medium">Medium</span>
                                                    <span class="task-xp">${task.xpReward} XP</span>
                                                    <c:if test="${lastActiveTaskId == task.id}">
                                                        <span class="current-badge">🟢 Current</span>
                                                    </c:if>
                                                </div>
                                                <p class="task-description">${task.description}</p>
                                                <div class="task-status">
                                                    <c:choose>
                                                        <c:when test="${user.completedTasks.contains(task)}">
                                                            <span class="status-badge status-completed">✓ Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="taskStatus" value=""/>
                                                            <c:forEach var="userTask" items="${userTasks}">
                                                                <c:if test="${userTask.task.id == task.id}">
                                                                    <c:set var="taskStatus" value="${userTask.status}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <c:choose>
                                                                <c:when test="${taskStatus == 'PENDING_REVIEW'}">
                                                                    <span class="status-badge status-pending">⏳ Pending Review</span>
                                                                </c:when>
                                                                <c:when test="${taskStatus == 'REJECTED'}">
                                                                    <button type="button" class="btn-resubmit task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Resubmit Task
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn-complete task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Complete Task
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Hard Tasks -->
                        <c:if test="${progress.hardUnlocked}">
                            <div class="difficulty-section">
                                <div class="difficulty-header">
                                    <h4 class="difficulty-title">Hard Tasks</h4>
                                    <span class="difficulty-progress">${progress.hardCompleted}/${taskCounts[progress.topic]['hard']} completed</span>
                                </div>
                                <div class="task-grid">
                                    <c:forEach var="task" items="${availableTasks}">
                                        <c:if test="${task.topic == progress.topic && task.level == 'Hard'}">
                                            <div class="task-card">
                                                <div class="task-header">
                                                    <span class="task-level hard">Hard</span>
                                                    <span class="task-xp">${task.xpReward} XP</span>
                                                    <c:if test="${lastActiveTaskId == task.id}">
                                                        <span class="current-badge">🟢 Current</span>
                                                    </c:if>
                                                </div>
                                                <p class="task-description">${task.description}</p>
                                                <div class="task-status">
                                                    <c:choose>
                                                        <c:when test="${user.completedTasks.contains(task)}">
                                                            <span class="status-badge status-completed">✓ Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="taskStatus" value=""/>
                                                            <c:forEach var="userTask" items="${userTasks}">
                                                                <c:if test="${userTask.task.id == task.id}">
                                                                    <c:set var="taskStatus" value="${userTask.status}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <c:choose>
                                                                <c:when test="${taskStatus == 'PENDING_REVIEW'}">
                                                                    <span class="status-badge status-pending">⏳ Pending Review</span>
                                                                </c:when>
                                                                <c:when test="${taskStatus == 'REJECTED'}">
                                                                    <button type="button" class="btn-resubmit task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Resubmit Task
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn-complete task-button" 
                                                                            data-task-id="${task.id}" data-task-description="${task.description}">
                                                                        Complete Task
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- Task Completion Modal -->
    <div id="taskModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Complete Task</h2>
                <span class="close" onclick="closeTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="taskDescription" style="margin-bottom: 1rem; color: var(--dark-gray);"></p>
                
                <form id="taskForm" method="post" action="/user/complete-task" enctype="multipart/form-data">
                    <input type="hidden" id="taskId" name="taskId">
                    
                    <div class="form-group">
                        <label for="proofImage" class="form-label">Take a photo as proof:</label>
                        <input type="file" id="proofImage" name="proofImage" 
                               accept="image/*" capture="environment" 
                               class="form-control" required>
                        <small style="color: var(--gray); font-size: 0.9rem;">
                            📸 This will open your device camera. Please take a clear photo showing your completed task.
                        </small>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Submit for Review
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleTopic(element) {
            const topicName = element.getAttribute('data-topic');
            const contentId = 'content-' + topicName.replace(/[^a-zA-Z0-9]/g, '-');
            const content = document.getElementById(contentId);
            
            if (content.classList.contains('expanded')) {
                content.classList.remove('expanded');
            } else {
                // Close all other expanded topics
                document.querySelectorAll('.topic-content.expanded').forEach(el => {
                    el.classList.remove('expanded');
                });
                // Open this topic
                content.classList.add('expanded');
            }
        }

        function openTaskModal(taskId, description) {
            document.getElementById('taskId').value = taskId;
            document.getElementById('taskDescription').textContent = description;
            document.getElementById('taskModal').style.display = 'block';
            
            // Reset form
            document.getElementById('taskForm').reset();
        }

        function closeTaskModal() {
            document.getElementById('taskModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('taskModal');
            if (event.target == modal) {
                closeTaskModal();
            }
        }

        // Form validation
        document.getElementById('taskForm').addEventListener('submit', function(e) {
            var fileInput = document.getElementById('proofImage');
            if (!fileInput.files || fileInput.files.length === 0) {
                e.preventDefault();
                alert('Please take a photo as proof before submitting.');
                return false;
            }
        });

        // Handle task button clicks
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('task-button')) {
                const taskId = e.target.getAttribute('data-task-id');
                const taskDescription = e.target.getAttribute('data-task-description');
                openTaskModal(taskId, taskDescription);
            }
        });

        // Auto-expand current topic on page load
        document.addEventListener('DOMContentLoaded', function() {
            const currentTopic = document.querySelector('.topic-header.current');
            if (currentTopic) {
                toggleTopic(currentTopic);
            }
        });
    </script>
</body>
</html> 