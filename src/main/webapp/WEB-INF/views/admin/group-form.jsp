<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Edit' : 'Create'} Group - ReLeaf Admin</title>
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
        <div class="form-container">
            <h1 class="page-title">${isEdit ? 'Edit' : 'Create'} Group</h1>

            <form action="${isEdit ? '/admin/groups/update/'.concat(group.id) : '/admin/groups/create'}" method="POST" class="form">
                <div class="form-group">
                    <label for="groupName">Group Name:</label>
                    <input type="text" id="groupName" name="groupName" value="${group.groupName}" required>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" rows="4" required>${group.description}</textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Create'} Group</button>
                    <a href="/admin/groups" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
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
            <h1 class="page-title">Create New Group</h1>
            <a href="/admin/groups" class="btn btn-secondary">Back to Groups</a>
        </div>

        <div class="card">
            <form method="post" action="/admin/groups/create">
                <div class="form-group">
                    <label for="groupName" class="form-label">Group Name</label>
                    <input type="text" id="groupName" name="groupName" class="form-input" required 
                           placeholder="Enter group name (e.g., Eco Warriors, Green Team)">
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <textarea id="description" name="description" class="form-textarea" 
                              placeholder="Enter a description for this group (optional)"></textarea>
                </div>

                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn btn-primary">Create Group</button>
                    <a href="/admin/groups" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Group Guidelines</h2>
            </div>
            <div style="color: var(--gray);">
                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Best Practices for Groups</h3>
                <ul style="margin-bottom: 2rem;">
                    <li>Choose descriptive and motivating group names</li>
                    <li>Provide clear descriptions of the group's purpose</li>
                    <li>Consider organizing groups by location, interests, or skill level</li>
                    <li>Groups can help users collaborate on challenges</li>
                    <li>Use groups to foster community and friendly competition</li>
                </ul>

                <h3 style="color: var(--dark-green); margin-bottom: 1rem;">Group Examples</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem;">
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px;">
                        <strong>Eco Warriors</strong><br>
                        <small>For users passionate about environmental activism</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px;">
                        <strong>Green Beginners</strong><br>
                        <small>For new users starting their eco journey</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px;">
                        <strong>City Cleaners</strong><br>
                        <small>For users focused on urban environmental issues</small>
                    </div>
                    <div style="background: var(--light-green); padding: 1rem; border-radius: 5px;">
                        <strong>Climate Champions</strong><br>
                        <small>For users tackling climate change challenges</small>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>

