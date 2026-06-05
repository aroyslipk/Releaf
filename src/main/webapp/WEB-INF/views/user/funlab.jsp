<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Releaf FunLab - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/funlab.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<style>
/* CRITICAL HEADER FIX - Force logo text to be bold */
.user-header .logo-text {
    font-size: 1.5rem !important;
    font-weight: 700 !important;
    color: #2c3e50 !important;
    -webkit-text-fill-color: #2c3e50 !important;
    background: none !important;
    letter-spacing: 0 !important;
    line-height: 1 !important;
    white-space: nowrap !important;
    flex-shrink: 0 !important;
}
</style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <div class="funlab-header">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; margin-bottom: 1rem;">
                <h1 class="funlab-title"><i class="fas fa-flask" style="margin-right: 12px;"></i>Releaf FunLab</h1>
                <a href="/user/tasks" class="btn-back-tasks"><i class="fas fa-arrow-left"></i> Back to Tasks</a>
            </div>
            <p class="funlab-subtitle">
                Explore weekly fun and creative eco-tasks! All tasks are unlocked from the start.
                Submit photos, audio, or text to earn XP and have fun while helping the planet.
            </p>
        </div>
        <style>
        .btn-back-tasks {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(45, 122, 72, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-back-tasks:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
            background: linear-gradient(135deg, #358856, #3d9960);
            color: white;
        }
        </style>

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
                                        <c:set var="taskStatus" value="${userTask.status.name()}"/>
                                    </c:if>
                                </c:forEach>
                                
                                <c:choose>
                                    <c:when test="${taskStatus eq 'PENDING_REVIEW'}">
                                        <span class="status-badge status-pending">⏳ Pending Review</span>
                                    </c:when>
                                    <c:when test="${taskStatus eq 'REJECTED'}">
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
    </main>

    <!-- Task Submission Modal -->
    <div id="taskModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Submit Task Proof</h2>
                <span class="close" onclick="closeTaskModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="taskDescription"></p>
                <form id="taskForm" method="post" action="/user/funlab/complete-task" enctype="multipart/form-data">
                    <input type="hidden" id="taskId" name="taskId">
                    <div class="form-group">
                        <label for="proofFile">Upload proof file:</label>
                        <input type="file" id="proofFile" name="proofFile" class="form-control" accept="image/*,audio/*,video/*">
                        <div>(Optional: 20 XP with file, 10 XP without)</div>
                    </div>
                    <div class="form-group">
                        <label for="proofText">Or provide text proof:</label>
                        <textarea id="proofText" name="proofText" class="form-control" rows="4" placeholder="Describe your task completion here..."></textarea>
                    </div>
                    <button type="submit" class="btn-submit">Submit for Review</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Script for modal handling
        function openTaskModal(taskId, description, proofType) {
            document.getElementById('taskId').value = taskId;
            document.getElementById('taskDescription').textContent = description;
            document.getElementById('taskModal').style.display = 'block';
        }

        function closeTaskModal() {
            document.getElementById('taskModal').style.display = 'none';
        }
        
        var modal = document.getElementById('taskModal');

        // Get the button that opens the modal
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('task-button')) {
                const taskId = e.target.getAttribute('data-task-id');
                const taskDescription = e.target.getAttribute('data-task-description');
                const proofType = e.target.getAttribute('data-proof-type');
                openTaskModal(taskId, taskDescription, proofType);
            }
        });

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                closeTaskModal();
            }
        }
    </script>
</body>
</html>