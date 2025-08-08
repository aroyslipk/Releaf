<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Releaf FunLab - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .funlab-container {
            padding: 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
        }

        .funlab-header {
            text-align: center;
            margin-bottom: 3rem;
            background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 50%, #a569bd 100%);
            color: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .funlab-title {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .funlab-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            line-height: 1.6;
        }

        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .task-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 3px solid transparent;
        }

        .task-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }

        .task-level {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
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
            background: #8e44ad;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .task-description {
            color: #495057;
            margin-bottom: 1rem;
            line-height: 1.6;
            font-size: 1rem;
        }

        .task-impact {
            background: #e8f4fd;
            border-left: 4px solid #8e44ad;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 0 8px 8px 0;
        }

        .impact-label {
            font-weight: 600;
            color: #8e44ad;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            text-transform: uppercase;
        }

        .impact-text {
            color: #495057;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .proof-type {
            background: #f8f9fa;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #6c757d;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .task-status {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1.5rem;
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

        .btn-submit {
            background: #8e44ad;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background: #7d3c98;
            transform: translateY(-2px);
        }

        .btn-resubmit {
            background: #007bff;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-resubmit:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }

        .back-link {
            position: absolute;
            top: 2rem;
            left: 2rem;
            color: #6c757d;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #8e44ad;
            text-decoration: none;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: center;
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
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }

        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            opacity: 0.8;
        }

        .close:hover {
            opacity: 1;
        }

        .modal-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #495057;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #8e44ad;
        }

        .form-textarea {
            min-height: 100px;
            resize: vertical;
        }

        .file-input-info {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }

        .submit-btn {
            background: #8e44ad;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .submit-btn:hover {
            background: #7d3c98;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .tasks-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .funlab-title {
                font-size: 2rem;
            }
            
            .task-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>Releaf.R</h1>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/user/dashboard">Dashboard</a></li>
                    <li><a href="/user/tasks" class="active">Tasks</a></li>
                    <li><a href="/user/achievements">Achievements</a></li>
                    <li><a href="/user/groups">Groups</a></li>
                    <li><a href="/user/notices">Notices</a></li>
                    <li><a href="/user/messages">Messages</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${user.name}</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <a href="/user/tasks" class="back-link">← Back to Tasks</a>
        
        <div class="funlab-container">
            <div class="funlab-header">
                <h1 class="funlab-title">🧪 Releaf FunLab</h1>
                <p class="funlab-subtitle">
                    Explore Weekly fun and creative eco-tasks! All tasks are unlocked from the start.
                    Submit photos, audio, or text to earn XP and have fun while helping the planet.
                </p>
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

            <div class="tasks-grid">
                <c:forEach var="task" items="${funlabTasks}">
                    <div class="task-card">
                        <div class="task-header">
                            <span class="task-level ${task.level.toLowerCase()}">${task.level}</span>
                            <span class="task-xp">${task.xpReward} XP</span>
                        </div>
                        
                        <p class="task-description">${task.description}</p>
                        
                        <div class="task-impact">
                            <div class="impact-label">Impact</div>
                            <div class="impact-text">${task.impact}</div>
                        </div>
                        
                        <div class="proof-type">
                            📎 Proof: ${task.proofType}
                        </div>
                        
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
                                                    data-task-id="${task.id}" 
                                                    data-task-description="${task.description}"
                                                    data-proof-type="${task.proofType}">
                                                Resubmit Task
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-submit task-button" 
                                                    data-task-id="${task.id}" 
                                                    data-task-description="${task.description}"
                                                    data-proof-type="${task.proofType}">
                                                Submit Proof
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>

    <!-- Task Submission Modal -->
    <div id="taskModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Submit Task Proof</h2>
                <span class="close" onclick="closeTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="taskDescription" style="margin-bottom: 1.5rem; color: #495057; line-height: 1.6;"></p>
                
                <form id="taskForm" method="post" action="/user/funlab/complete-task" enctype="multipart/form-data">
                    <input type="hidden" id="taskId" name="taskId">
                    
                    <div class="form-group">
                        <label for="proofFile" class="form-label">Upload proof file:</label>
                        <input type="file" id="proofFile" name="proofFile" 
                               class="form-control" accept="image/*,audio/*,video/*">
                        <div class="file-input-info">
                            📸 Upload a photo, audio, or video file for bonus XP (20 XP with file, 10 XP without)
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="proofText" class="form-label">Or provide text proof:</label>
                        <textarea id="proofText" name="proofText" 
                                  class="form-control form-textarea" 
                                  placeholder="Describe how you completed this task..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="submit-btn">
                            Submit for Review
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function openTaskModal(taskId, description, proofType) {
            document.getElementById('taskId').value = taskId;
            document.getElementById('taskDescription').textContent = description;
            document.getElementById('taskModal').style.display = 'block';
            
            // Reset form
            document.getElementById('taskForm').reset();
            
            // Update file input accept attribute based on proof type
            const fileInput = document.getElementById('proofFile');
            if (proofType === 'AUDIO') {
                fileInput.accept = 'audio/*';
            } else if (proofType === 'VIDEO') {
                fileInput.accept = 'video/*';
            } else {
                fileInput.accept = 'image/*,audio/*,video/*';
            }
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

        // Handle task button clicks
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('task-button')) {
                const taskId = e.target.getAttribute('data-task-id');
                const taskDescription = e.target.getAttribute('data-task-description');
                const proofType = e.target.getAttribute('data-proof-type');
                openTaskModal(taskId, taskDescription, proofType);
            }
        });
    </script>
</body>
</html> 