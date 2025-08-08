<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - ReLeaf</title>
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
                <span class="xp-badge">${user.xpPoints} XP</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <h1 class="page-title">My Profile</h1>

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
                        <div class="profile-picture-container">
                            <img id="profileImage" 
                                 src="${empty user.profilePicture ? '/images/default-avatar.png' : '/user-photos/'.concat(user.profilePicture)}" 
                                 alt="Profile Picture"
                                 style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; margin-right: 1.5rem;">
                        </div>
                        <div>
                            <h3 style="color: var(--dark-green); margin: 0 0 0.5rem 0;">${user.name}</h3>
                            <p style="color: var(--gray); margin: 0;">Eco Warrior</p>
                            <span class="xp-badge" style="margin-top: 0.5rem; display: inline-block;">${user.xpPoints} XP</span>
                        </div>
                    </div>
                    
                    <!-- Profile Picture Upload Form -->
                    <div class="profile-picture-upload" style="margin-bottom: 1.5rem; padding: 1rem; border: 2px dashed var(--gray); border-radius: 5px; text-align: center;">
                        <form id="profilePictureForm" method="post" action="/user/profile/upload" enctype="multipart/form-data">
                            <div class="upload-preview" style="margin-bottom: 1rem; display: none;">
                                <img id="imagePreview" src="#" alt="Preview" style="max-width: 200px; max-height: 200px; border-radius: 5px;">
                            </div>
                            <div class="upload-controls">
                                <input type="file" id="pictureInput" name="file" accept="image/jpeg,image/png" style="display: none;">
                                <button type="button" class="btn btn-secondary" onclick="document.getElementById('pictureInput').click()">Choose Picture</button>
                                <button type="submit" class="btn btn-primary" id="uploadButton" style="display: none;">Update Picture</button>
                            </div>
                        </form>
                    </div>

                    <div style="background: var(--light-gray); padding: 1.5rem; border-radius: 5px;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div>
                                <strong style="color: var(--dark-green);">Name:</strong><br>
                                <span style="color: var(--dark-gray);">${user.name}</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Email:</strong><br>
                                <span style="color: var(--dark-gray);">${user.email}</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Member Since:</strong><br>
                                <span style="color: var(--dark-gray);">${user.createdAt.toLocalDate()}</span>
                            </div>
                            <div>
                                <strong style="color: var(--dark-green);">Group:</strong><br>
                                <span style="color: var(--dark-gray);">
                                    <c:choose>
                                        <c:when test="${user.group != null}">
                                            ${user.group.groupName}
                                        </c:when>
                                        <c:otherwise>
                                            Not in a group
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Update Profile -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Update Profile</h2>
                </div>
                <form method="post" action="/user/update-profile">
                    <div class="form-group">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" id="name" name="name" class="form-input" value="${user.name}" required ${user.nameChangesCount >= 3 ? 'disabled' : ''}>
                        <small class="form-text ${user.nameChangesCount >= 3 ? 'text-danger' : 'text-muted'}">
                            ${user.nameChangesCount >= 3 ? 'You have reached the maximum number of name changes' : 'Remaining name changes: '.concat(3 - user.nameChangesCount)}
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input" value="${user.email}" required ${user.emailChangesCount >= 3 ? 'disabled' : ''}>
                        <small class="form-text ${user.emailChangesCount >= 3 ? 'text-danger' : 'text-muted'}">
                            ${user.emailChangesCount >= 3 ? 'You have reached the maximum number of email changes' : 'Remaining email changes: '.concat(3 - user.emailChangesCount)}
                        </small>
                    </div>

                    <button type="submit" class="btn btn-primary" ${user.nameChangesCount >= 3 && user.emailChangesCount >= 3 ? 'disabled' : ''}>Update Profile</button>
                </form>
            </div>
        </div>

        <!-- Statistics Overview -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Your Statistics</h2>
            </div>
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-number">${user.xpPoints}</div>
                    <div class="stat-label">Total XP Points</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${user.completedTasks.size()}</div>
                    <div class="stat-label">Tasks Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${user.unlockedRewards.size()}</div>
                    <div class="stat-label">Rewards Unlocked</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${user.completedTasks.size() > 0}">
                                ${String.format("%.1f", user.xpPoints.doubleValue() / user.completedTasks.size())}
                            </c:when>
                            <c:otherwise>
                                0
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Avg XP per Task</div>
                </div>
            </div>
        </div>

        <!-- Change Password -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Change Password</h2>
            </div>
            <form method="post" action="/user/change-password">
                <div class="form-group">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                </div>

                <button type="submit" class="btn btn-primary">Change Password</button>
            </form>
        </div>

        <!-- Group Management -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Group Management</h2>
            </div>
            <c:choose>
                <c:when test="${user.group != null}">
                    <div style="background: var(--light-green); padding: 1.5rem; border-radius: 5px; margin-bottom: 1.5rem;">
                        <h3 style="color: var(--dark-green); margin: 0 0 1rem 0;">${user.group.groupName}</h3>
                        <p style="color: var(--gray); margin: 0 0 1rem 0;">
                            <c:choose>
                                <c:when test="${not empty user.group.description}">
                                    ${user.group.description}
                                </c:when>
                                <c:otherwise>
                                    No description available
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="color: var(--dark-gray);">
                                <strong>${user.group.members.size()}</strong> members
                            </span>
                            <form method="post" action="/user/leave-group" style="margin: 0;">
                                <button type="submit" class="btn btn-sm btn-danger" 
                                        onclick="return confirm('Are you sure you want to leave this group?')">
                                    Leave Group
                                </button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 2rem 0;">
                        <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;">👥</div>
                        <h3 style="color: var(--gray); margin-bottom: 1rem;">Not in a group</h3>
                        <p style="color: var(--gray); margin-bottom: 2rem;">
                            Join a group to connect with other eco-warriors and participate in group challenges!
                        </p>
                        <a href="/user/join-group" class="btn btn-primary">Browse Groups</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent Activity -->
        <c:if test="${not empty user.completedTasks}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Recent Activity</h2>
                </div>
                <div style="max-height: 400px; overflow-y: auto;">
                    <c:forEach var="task" items="${user.completedTasks}" varStatus="status">
                        <c:if test="${status.index < 10}">
                            <div style="border-bottom: 1px solid var(--light-green); padding: 1rem 0; display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <h4 style="color: var(--dark-green); margin: 0 0 0.5rem 0; font-size: 1rem;">${task.topic}</h4>
                                    <p style="color: var(--gray); margin: 0; font-size: 0.9rem;">
                                        ${task.description.length() > 80 ? task.description.substring(0, 80).concat('...') : task.description}
                                    </p>
                                </div>
                                <div style="text-align: right;">
                                    <span class="task-level ${task.level.toLowerCase()}">${task.level}</span>
                                    <br>
                                    <span class="xp-badge" style="margin-top: 0.5rem; display: inline-block;">${task.xpReward} XP</span>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
                <c:if test="${user.completedTasks.size() > 10}">
                    <div style="text-align: center; padding: 1rem 0; border-top: 1px solid var(--light-green);">
                        <a href="/user/achievements" style="color: var(--primary-green); text-decoration: none;">
                            View all ${user.completedTasks.size()} completed tasks
                        </a>
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- Account Actions -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Account Actions</h2>
            </div>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="/user/dashboard" class="btn btn-secondary">Back to Dashboard</a>
                <a href="/user/tasks" class="btn btn-secondary">Browse Tasks</a>
                <a href="/user/achievements" class="btn btn-secondary">View Achievements</a>
                <a href="/logout" class="btn btn-danger">Logout</a>
            </div>
        </div>

        <!-- Delete Account -->
        <div class="card" style="border: 2px solid #dc3545;">
            <div class="card-header" style="background-color: #dc3545; color: white;">
                <h2 class="card-title">⚠️ Danger Zone</h2>
            </div>
            <div style="padding: 1.5rem;">
                <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 1rem; margin-bottom: 1.5rem;">
                    <h4 style="color: #856404; margin: 0 0 0.5rem 0;">Permanent Account Deletion</h4>
                    <p style="color: #856404; margin: 0; font-size: 0.9rem;">
                        Once you delete your account, there is no going back. All your data, achievements, and progress will be permanently removed.
                    </p>
                </div>
                <a href="/user/delete-account" class="btn btn-danger" 
                   onclick="return confirm('Are you sure you want to proceed to account deletion? This action cannot be undone.')">
                    Delete My Account
                </a>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('pictureInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Show preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('imagePreview');
                    preview.src = e.target.result;
                    document.querySelector('.upload-preview').style.display = 'block';
                    document.getElementById('uploadButton').style.display = 'inline-block';
                };
                reader.readAsDataURL(file);
            }
        });

        // Form submission feedback
        document.getElementById('profilePictureForm').addEventListener('submit', function(e) {
            const submitButton = document.getElementById('uploadButton');
            submitButton.disabled = true;
            submitButton.textContent = 'Uploading...';
        });
    </script>
</body>
</html>
