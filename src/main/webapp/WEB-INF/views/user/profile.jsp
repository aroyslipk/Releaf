<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/profile.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        /* Enhanced Button Styles - matching groups.jsp */
        .btn-themed {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(45, 122, 72, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
            background: linear-gradient(135deg, #358856, #3d9960);
        }
        .btn-themed:active {
            transform: translateY(0);
        }
        .btn-themed:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .btn-themed i {
            font-size: 0.9rem;
        }

        .btn-danger-themed {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-danger-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(220, 53, 69, 0.35);
            background: linear-gradient(135deg, #c82333, #bd2130);
        }

        .btn-secondary-themed {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-secondary-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(108, 117, 125, 0.35);
            background: linear-gradient(135deg, #5a6268, #545b62);
            color: white;
        }

        .profile-picture-section {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }
        .profile-picture-section .upload-controls {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            align-items: center;
        }
        .upload-preview {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-user-circle" style="margin-right: 12px;"></i>My Profile</h1>

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

        <div class="profile-grid">
            <!-- Profile Information -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Profile Information</h2>
                </div>
                <div class="profile-info-header">
                    <img id="profileImage"
                         src="${empty user.profilePicture ? '/images/default-avatar.png' : '/user-photos/'.concat(user.profilePicture)}"
                         alt="Profile Picture"
                         class="profile-picture">
                    <div>
                        <h3>${user.name}</h3>
                        <p>Eco Warrior</p>
                        <span class="xp-badge">${user.xpPoints} XP</span>
                    </div>
                </div>
                <div class="profile-details">
                    <div>
                        <strong>Name:</strong><br>
                        <span>${user.name}</span>
                    </div>
                    <div>
                        <strong>Email:</strong><br>
                        <span>${user.email}</span>
                    </div>
                    <div>
                        <strong>Member Since:</strong><br>
                        <span>${user.createdAt.toLocalDate()}</span>
                    </div>
                    <div>
                        <strong>Group:</strong><br>
                        <span>
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
                <!-- Profile Picture Upload - moved here -->
                <div class="profile-picture-section" style="padding: 1.5rem;">
                    <form id="profilePictureForm" method="post" action="/user/profile/upload" enctype="multipart/form-data">
                        <div class="upload-preview" style="display: none;">
                            <img id="imagePreview" src="#" alt="Preview" style="max-width: 200px; border-radius: 8px; margin-bottom: 1rem;">
                        </div>
                        <div class="upload-controls">
                            <input type="file" id="pictureInput" name="file" accept="image/jpeg,image/png" style="display: none;">
                            <button type="button" class="btn-themed" onclick="document.getElementById('pictureInput').click()"><i class="fas fa-camera"></i> Choose Picture</button>
                            <button type="submit" class="btn-themed" id="uploadButton" style="display: none;"><i class="fas fa-upload"></i> Update Picture</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Update Profile - now beside Profile Information -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Update Profile</h2>
                </div>
                <div style="padding: 1.5rem;">
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

                        <button type="submit" class="btn-themed" ${user.nameChangesCount >= 3 && user.emailChangesCount >= 3 ? 'disabled' : ''}><i class="fas fa-save"></i> Update Profile</button>
                    </form>
                </div>
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
            <div style="padding: 1.5rem;">
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

                    <button type="submit" class="btn-themed"><i class="fas fa-key"></i> Change Password</button>
                </form>
            </div>
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
            <div style="display: flex; gap: 1rem; flex-wrap: wrap; padding: 1.5rem;">
                <a href="/user/dashboard" class="btn-secondary-themed"><i class="fas fa-home"></i> Back to Dashboard</a>
                <a href="/user/tasks" class="btn-secondary-themed"><i class="fas fa-tasks"></i> Browse Tasks</a>
                <a href="/user/achievements" class="btn-secondary-themed"><i class="fas fa-trophy"></i> View Achievements</a>
                <a href="/logout" class="btn-danger-themed"><i class="fas fa-sign-out-alt"></i> Logout</a>
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
                <a href="/user/delete-account" class="btn-danger-themed" 
                   onclick="return confirm('Are you sure you want to proceed to account deletion? This action cannot be undone.')">
                    <i class="fas fa-trash-alt"></i> Delete My Account
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
