<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Account - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/profile.css">
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
                    <li><a href="/user/profile" class="active">Profile</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.userName}</span>
                <span class="xp-badge">${user.xpPoints != null ? user.xpPoints : 0} XP</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <c:if test="${empty user}">
            <div style="text-align: center; padding: 2rem;">
                <h2>Error</h2>
                <p>User information not found. Please <a href="/login">log in again</a>.</p>
            </div>
        </c:if>
        
        <c:if test="${not empty user}">
        <div style="max-width: 600px; margin: 0 auto;">
            <h1 class="page-title">Delete Account</h1>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ${error}
                </div>
            </c:if>

            <div class="card" style="border: 2px solid #dc3545;">
                <div class="card-header" style="background-color: #dc3545; color: white;">
                    <h2 class="card-title">⚠️ Permanent Account Deletion</h2>
                </div>
                <div style="padding: 2rem;">
                    <div style="text-align: center; margin-bottom: 2rem;">
                        <div style="font-size: 4rem; margin-bottom: 1rem;">🗑️</div>
                        <h3 style="color: #dc3545; margin-bottom: 1rem;">This action cannot be undone</h3>
                        <p style="color: var(--gray); line-height: 1.6;">
                            You are about to permanently delete your ReLeaf account. This will remove all your data including:
                        </p>
                    </div>

                    <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 1.5rem; margin-bottom: 2rem;">
                        <h4 style="color: #856404; margin: 0 0 1rem 0;">What will be deleted:</h4>
                        <ul style="color: #856404; margin: 0; padding-left: 1.5rem;">
                            <li>Your profile and personal information</li>
                            <li>All completed tasks and achievements</li>
                            <li>Your XP points and rewards</li>
                            <li>Group membership and messages</li>
                            <li>Profile picture and uploaded files</li>
                            <li>All account activity history</li>
                        </ul>
                    </div>

                    <form method="post" action="/user/delete-account" id="deleteAccountForm">
                        <div class="form-group">
                            <label for="password" class="form-label">Enter your password to confirm</label>
                            <input type="password" id="password" name="password" class="form-input" required 
                                   placeholder="Your current password">
                            <small class="form-text text-muted">
                                This is required to verify that you are the account owner.
                            </small>
                        </div>

                        <div class="form-group" style="margin-bottom: 2rem;">
                            <label class="checkbox-label" style="display: flex; align-items: flex-start; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" id="confirmDelete" required style="margin-top: 0.2rem;">
                                <span style="color: var(--dark-gray); line-height: 1.4;">
                                    I understand that this action is <strong>permanent and cannot be undone</strong>. 
                                    I have backed up any important information I want to keep.
                                </span>
                            </label>
                        </div>

                        <div style="display: flex; gap: 1rem; justify-content: center;">
                            <a href="/user/profile" class="btn btn-secondary" style="min-width: 120px;">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-danger" style="min-width: 120px;" 
                                    onclick="return confirmFinalDeletion()">
                                Delete Account
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div style="text-align: center; margin-top: 2rem;">
                <a href="/user/profile" style="color: var(--primary-green); text-decoration: none;">
                    ← Back to Profile
                </a>
            </div>
        </div>
        </c:if>
    </main>

    <script>
        function confirmFinalDeletion() {
            const password = document.getElementById('password').value;
            const confirmCheckbox = document.getElementById('confirmDelete').checked;
            
            if (!password.trim()) {
                alert('Please enter your password to confirm account deletion.');
                return false;
            }
            
            if (!confirmCheckbox) {
                alert('Please check the confirmation box to proceed.');
                return false;
            }
            
            return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.');
        }

        // Disable form submission if checkbox is not checked
        document.getElementById('deleteAccountForm').addEventListener('submit', function(e) {
            const confirmCheckbox = document.getElementById('confirmDelete');
            if (!confirmCheckbox.checked) {
                e.preventDefault();
                alert('Please check the confirmation box to proceed.');
                return false;
            }
        });
    </script>
</body>
</html> 