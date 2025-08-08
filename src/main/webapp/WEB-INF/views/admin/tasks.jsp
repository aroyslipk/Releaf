<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management - ReLeaf Admin</title>
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
            <h1 class="page-title">Greenverse Task Management</h1>
            <div style="display: flex; gap: 1rem;">
                <a href="/admin/tasks" class="btn btn-secondary">← Back to Greenverse</a>
                <a href="/admin/greenverse/tasks/new" class="btn btn-primary">Add New Task</a>
            </div>
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

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Filter Tasks</h2>
            </div>
            <form method="get" action="/admin/greenverse/tasks" style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <div class="form-group" style="margin-bottom: 0;">
                    <select name="topic" class="form-select" style="width: auto;">
                        <option value="">All Topics</option>
                        <c:forEach var="topic" items="${topics}">
                            <option value="${topic}" ${selectedTopic == topic ? 'selected' : ''}>${topic}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <select name="level" class="form-select" style="width: auto;">
                        <option value="">All Levels</option>
                        <c:forEach var="level" items="${levels}">
                            <option value="${level}" ${selectedLevel == level ? 'selected' : ''}>${level}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-secondary">Filter</button>
                <a href="/admin/greenverse/tasks" class="btn btn-secondary">Clear</a>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Tasks (${tasks.size()} total)</h2>
            </div>
            
            <c:if test="${empty tasks}">
                <p style="text-align: center; color: var(--gray); padding: 2rem;">
                    No tasks found. <a href="/admin/greenverse/tasks/new">Create your first task</a>
                </p>
            </c:if>

            <c:if test="${not empty tasks}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Topic</th>
                            <th>Level</th>
                            <th>Description</th>
                            <th>XP Reward</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="task" items="${tasks}">
                            <tr>
                                <td>${task.id}</td>
                                <td>${task.topic}</td>
                                <td>
                                    <span class="task-level ${task.level.toLowerCase()}">${task.level}</span>
                                </td>
                                <td style="max-width: 300px;">${task.description}</td>
                                <td>
                                    <span class="xp-badge">${task.xpReward} XP</span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <a href="/admin/greenverse/tasks/edit/${task.id}" class="btn btn-sm btn-secondary">Edit</a>
                                        <form method="post" action="/admin/greenverse/tasks/delete/${task.id}" style="display: inline;" 
                                              onsubmit="return confirm('Are you sure you want to delete this task?')">
                                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </main>
</body>
</html>

