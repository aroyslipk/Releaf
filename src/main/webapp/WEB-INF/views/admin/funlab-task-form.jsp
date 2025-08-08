<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FunLab Task Form - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
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
                    <li><a href="/admin/dashboard">Dashboard</a></li>
                    <li><a href="/admin/tasks">Tasks</a></li>
                    <li><a href="/admin/users">Users</a></li>
                    <li><a href="/admin/groups">Groups</a></li>
                    <li><a href="/admin/notices">Notices</a></li>
                    <li><a href="/admin/messages">Messages</a></li>
                    <li><a href="/admin/reports">Reports</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.adminUsername}</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h1 class="page-title">
                <c:choose>
                    <c:when test="${not empty task}">Edit FunLab Task</c:when>
                    <c:otherwise>Create New FunLab Task</c:otherwise>
                </c:choose>
            </h1>
            <a href="/admin/funlab" class="btn btn-secondary">← Back to FunLab</a>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">FunLab Task Details</h2>
            </div>
            <div class="card-body">
                <form method="post" 
                      action="${not empty task ? '/admin/funlab/tasks/update/' : '/admin/funlab/tasks/create'}${not empty task ? task.id : ''}">
                    
                    <div class="form-group">
                        <label for="topic" class="form-label">Topic *</label>
                        <input type="text" id="topic" name="topic" class="form-control" 
                               value="${task.topic}" required maxlength="100">
                        <small class="form-text">The topic/category for this Weekly FunLab task</small>
                    </div>

                    <div class="form-group">
                        <label for="level" class="form-label">Difficulty Level *</label>
                        <select id="level" name="level" class="form-select" required>
                            <option value="">Select Level</option>
                            <option value="Easy" ${task.level == 'Easy' ? 'selected' : ''}>Easy</option>
                            <option value="Medium" ${task.level == 'Medium' ? 'selected' : ''}>Medium</option>
                            <option value="Hard" ${task.level == 'Hard' ? 'selected' : ''}>Hard</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description" class="form-label">Task Description *</label>
                        <textarea id="description" name="description" class="form-control" 
                                  rows="4" required maxlength="500">${task.description}</textarea>
                        <small class="form-text">Describe what the user needs to do to complete this task</small>
                    </div>

                    <div class="form-group">
                        <label for="impact" class="form-label">Environmental Impact *</label>
                        <textarea id="impact" name="impact" class="form-control" 
                                  rows="3" required>${task.impact}</textarea>
                        <small class="form-text">Describe the positive environmental impact of this task</small>
                    </div>

                    <div class="form-group">
                        <label for="proofType" class="form-label">Proof Type *</label>
                        <select id="proofType" name="proofType" class="form-select" required>
                            <option value="">Select Proof Type</option>
                            <option value="PHOTO" ${task.proofType == 'PHOTO' ? 'selected' : ''}>Photo</option>
                            <option value="AUDIO" ${task.proofType == 'AUDIO' ? 'selected' : ''}>Audio</option>
                            <option value="VIDEO" ${task.proofType == 'VIDEO' ? 'selected' : ''}>Video</option>
                            <option value="TEXT" ${task.proofType == 'TEXT' ? 'selected' : ''}>Text</option>
                        </select>
                        <small class="form-text">What type of proof the user should submit</small>
                    </div>

                    <div class="form-group">
                        <label for="xpReward" class="form-label">XP Reward</label>
                        <input type="number" id="xpReward" name="xpReward" class="form-control" 
                               value="${task.xpReward}" min="1" max="100">
                        <small class="form-text">XP points awarded for completing this task (default: 20)</small>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <c:choose>
                                <c:when test="${not empty task}">Update Task</c:when>
                                <c:otherwise>Create Task</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="/admin/funlab" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <style>
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid #e9ecef;
        }
    </style>
</body>
</html> 