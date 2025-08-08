<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${task != null ? 'Edit' : 'Add'} Task - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>ReLeaf Admin</h1>
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
            <h1 class="page-title">${task != null ? 'Edit' : 'Add'} Task</h1>
            <a href="/admin/greenverse/tasks" class="btn btn-secondary">Back to Tasks</a>
        </div>

        <div class="card">
            <form method="post" action="${task != null ? '/admin/greenverse/tasks/update/'.concat(task.id) : '/admin/greenverse/tasks/create'}">
                <div class="form-group">
                    <label for="topic" class="form-label">Topic</label>
                    <select id="topic" name="topic" class="form-select" required>
                        <option value="">Select Topic</option>
                        <option value="Plastronauts" ${task != null && task.topic == 'Plastronauts' ? 'selected' : ''}>
                            Plastronauts
                        </option>
                        <option value="Aether Shield" ${task != null && task.topic == 'Aether Shield' ? 'selected' : ''}>
                            Aether Shield
                        </option>
                        <option value="Hydronauts" ${task != null && task.topic == 'Hydronauts' ? 'selected' : ''}>
                            Hydronauts
                        </option>
                        <option value="ChronoClimbers" ${task != null && task.topic == 'ChronoClimbers' ? 'selected' : ''}>
                            ChronoClimbers
                        </option>
                        <option value="Verdantra" ${task != null && task.topic == 'Verdantra' ? 'selected' : ''}>
                            Verdantra
                        </option>
                        <option value="TerraFixers" ${task != null && task.topic == 'TerraFixers' ? 'selected' : ''}>
                            TerraFixers
                        </option>
                        <option value="SmogSmiths" ${task != null && task.topic == 'SmogSmiths' ? 'selected' : ''}>
                            SmogSmiths
                        </option>
                        <option value="EcoMentors" ${task != null && task.topic == 'EcoMentors' ? 'selected' : ''}>
                            EcoMentors
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="level" class="form-label">Difficulty Level</label>
                    <select id="level" name="level" class="form-select" required>
                        <option value="">Select Level</option>
                        <option value="Easy" ${task != null && task.level == 'Easy' ? 'selected' : ''}>Easy</option>
                        <option value="Medium" ${task != null && task.level == 'Medium' ? 'selected' : ''}>Medium</option>
                        <option value="Hard" ${task != null && task.level == 'Hard' ? 'selected' : ''}>Hard</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Task Description</label>
                    <textarea id="description" name="description" class="form-textarea" required 
                              placeholder="Enter a clear and actionable task description...">${task != null ? task.description : ''}</textarea>
                </div>

                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn btn-primary">
                        ${task != null ? 'Update' : 'Create'} Task
                    </button>
                    <a href="/admin/greenverse/tasks" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Task Guidelines</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem;">
                <div>
                    <h3 style="color: var(--primary-green); margin-bottom: 1rem;">Easy Level</h3>
                    <ul style="color: var(--gray);">
                        <li>Simple daily actions</li>
                        <li>Requires minimal time/effort</li>
                        <li>Can be done at home</li>
                        <li>No special equipment needed</li>
                    </ul>
                </div>
                <div>
                    <h3 style="color: var(--warning); margin-bottom: 1rem;">Medium Level</h3>
                    <ul style="color: var(--gray);">
                        <li>Requires planning or preparation</li>
                        <li>May involve others</li>
                        <li>Takes more time/effort</li>
                        <li>Some research may be needed</li>
                    </ul>
                </div>
                <div>
                    <h3 style="color: var(--error); margin-bottom: 1rem;">Hard Level</h3>
                    <ul style="color: var(--gray);">
                        <li>Community involvement</li>
                        <li>Significant time commitment</li>
                        <li>May require coordination</li>
                        <li>Long-term impact focus</li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</body>
</html>

