<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ReLeaf</title>
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
                    <li><a href="/admin/task-reviews">Task Reviews</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.adminUsername}</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <h1 class="page-title">Admin Dashboard</h1>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalTasks}</div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalGroups}</div>
                <div class="stat-label">Total Groups</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalNotices}</div>
                <div class="stat-label">Total Notices</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Quick Actions</h2>
            </div>
            <div class="quick-actions-container">
                <a href="/admin/tasks/new" class="btn btn-primary">Add New Task</a>
                <a href="/admin/groups/new" class="btn btn-primary">Create Group</a>
                <a href="/admin/notices/new" class="btn btn-primary">Post Notice</a>
                <a href="/admin/messages/new" class="btn btn-primary">Send Message</a>
                <a href="/admin/users" class="btn btn-secondary">Manage Users</a>
                <a href="/admin/reports" class="btn btn-secondary">View Reports</a>
                <a href="/admin/task-reviews" class="btn btn-secondary">Review Tasks</a>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">System Overview</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                <div>
                    <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Platform Features</h3>
                    <ul style="list-style: none; padding: 0;">
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            ✅ User Registration & Authentication
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            ✅ Task Management System
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            ✅ XP & Reward Tracking
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            ✅ Group Management
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            ✅ Notice & Messaging System
                        </li>
                    </ul>
                </div>
                <div>
                    <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Environmental Topics</h3>
                    <ul style="list-style: none; padding: 0;">
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🗑️ Plastronauts
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🌬️ Aether Shield
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            💧 Hydronauts
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🌡️ ChronoClimbers
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🌳 Verdantra
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🌱 TerraFixers
                        </li>
                        <li style="padding: 0.5rem 0; border-bottom: 1px solid var(--light-green);">
                            🏭 SmogSmiths
                        </li>
                        <li style="padding: 0.5rem 0;">
                            📚 EcoMentors
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</body>
</html>

