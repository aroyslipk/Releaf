<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Edit' : 'Create New'} Notice - ReLeaf Admin</title>
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
            <h1 class="page-title">${isEdit ? 'Edit' : 'Create New'} Notice</h1>
            <a href="/admin/notices" class="btn btn-secondary">Back to Notices</a>
        </div>

        <div class="card">
            <form action="${isEdit ? '/admin/notices/update/'.concat(notice.id) : '/admin/notices/create'}" method="POST">
                <div class="form-group">
                    <label for="title">Notice Title</label>
                    <input type="text" 
                           id="title" 
                           name="title" 
                           value="${notice.title}"
                           required 
                           placeholder="Enter a clear and descriptive title">
                </div>

                <div class="form-group">
                    <label for="content">Notice Content</label>
                    <textarea id="content" 
                              name="content" 
                              rows="6" 
                              required 
                              placeholder="Enter the full content of your notice...">${notice.content}</textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Create'} Notice</button>
                    <a href="/admin/notices" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Notice Guidelines</h2>
            </div>
            <div style="color: var(--gray);">
                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Best Practices</h3>
                <ul style="margin-bottom: 2rem;">
                    <li>Use clear, concise titles that summarize the notice</li>
                    <li>Write content that is easy to understand for all users</li>
                    <li>Include relevant dates, deadlines, or time-sensitive information</li>
                    <li>Keep notices positive and motivating</li>
                    <li>Use proper formatting for better readability</li>
                </ul>

                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Notice Examples</h3>
                <div style="display: flex; flex-direction: row; gap: 1rem; flex-wrap: nowrap; overflow-x: auto;">
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; min-width: 250px;">
                        <strong>🌍 Earth Day Challenge</strong><br>
                        <small>Announcing special Earth Day challenges with bonus XP rewards!</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; min-width: 250px;">
                        <strong>🏆 Monthly Leaderboard</strong><br>
                        <small>Congratulations to this month's top eco warriors!</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; min-width: 250px;">
                        <strong>🔧 System Maintenance</strong><br>
                        <small>Scheduled maintenance window and expected downtime.</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; min-width: 250px;">
                        <strong>📚 New Features</strong><br>
                        <small>Introducing new features and improvements to the platform.</small>
                    </div>
                </div>

                <h3 style="color: var(--dark-green); margin: 2rem 0 1rem 0;">Formatting Tips</h3>
                <ul>
                    <li>Use line breaks to separate paragraphs</li>
                    <li>Include emojis to make notices more engaging</li>
                    <li>Bold important information using **text**</li>
                    <li>Use bullet points for lists</li>
                    <li>Include contact information if users need to respond</li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>

