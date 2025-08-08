<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - ReLeaf Admin</title>
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
        <h1 class="page-title">Admin Profile</h1>

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

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
            <!-- Profile Information -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Profile Information</h2>
                </div>
                <div style="padding: 1rem 0;">
                    <div style="display: flex; align-items: center; margin-bottom: 2rem;">
                        <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary-green), var(--secondary-green)); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem; font-weight: bold; margin-right: 1.5rem;">
                            ${admin.username.substring(0, 1).toUpperCase()}
                        </div>
                        <div>
                            <h3 style="color: var(--dark-green); margin: 0 0 0.5rem 0;">${admin.username}</h3>
                            <p style="color: var(--gray); margin: 0;">Administrator</p>
                        </div>
                    </div>
                    
                    <div style="background: var(--light-gray); padding: 1.5rem; border-radius: 5px;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div>
                                <strong style="color: var(--dark-green);">Username:</strong><br>
                                <span style="color: var(--dark-gray);">${admin.username}</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Role:</strong><br>
                                <span style="color: var(--dark-gray);">System Administrator</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Account Created:</strong><br>
                                <span style="color: var(--dark-gray);">${admin.createdAt.toLocalDate()}</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Last Updated:</strong><br>
                                <span style="color: var(--dark-gray);">${admin.updatedAt.toLocalDate()}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Change Password -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Change Password</h2>
                </div>
                <form method="post" action="/admin/change-password">
                    <div class="form-group">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-input" required 
                               placeholder="Enter new password">
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required 
                               placeholder="Confirm new password">
                    </div>

                    <button type="submit" class="btn btn-primary">Change Password</button>
                </form>
            </div>
        </div>

        <!-- Admin Privileges -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Administrator Privileges</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
                <div style="background: var(--light-green); padding: 1.5rem; border-radius: 5px; text-align: center;">
                    <div style="font-size: 2rem; margin-bottom: 0.5rem;">📋</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Task Management</h3>
                    <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">Create, edit, and delete eco-friendly tasks</p>
                </div>
                <div style="background: var(--light-green); padding: 1.5rem; border-radius: 5px; text-align: center;">
                    <div style="font-size: 2rem; margin-bottom: 0.5rem;">👥</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">User Management</h3>
                    <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">View and manage user accounts and groups</p>
                </div>
                <div style="background: var(--light-green); padding: 1.5rem; border-radius: 5px; text-align: center;">
                    <div style="font-size: 2rem; margin-bottom: 0.5rem;">📢</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Communications</h3>
                    <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">Send notices and messages to users</p>
                </div>
                <div style="background: var(--light-green); padding: 1.5rem; border-radius: 5px; text-align: center;">
                    <div style="font-size: 2rem; margin-bottom: 0.5rem;">📊</div>
                    <h3 style="color: var(--dark-green); margin-bottom: 0.5rem;">Analytics</h3>
                    <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">Access platform reports and statistics</p>
                </div>
            </div>
        </div>

        <!-- Security Information -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Security & Best Practices</h2>
            </div>
            <div style="color: var(--gray);">
                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Account Security</h3>
                <ul style="margin-bottom: 2rem;">
                    <li>Use a strong, unique password for your admin account</li>
                    <li>Change your password regularly (recommended every 90 days)</li>
                    <li>Never share your admin credentials with others</li>
                    <li>Log out when finished with admin tasks</li>
                    <li>Monitor user activity for any suspicious behavior</li>
                </ul>

                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Platform Management</h3>
                <ul>
                    <li>Regularly review and update task content for accuracy</li>
                    <li>Monitor user engagement and platform statistics</li>
                    <li>Respond promptly to user messages and concerns</li>
                    <li>Keep notices current and relevant</li>
                    <li>Backup important data and configurations</li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>

