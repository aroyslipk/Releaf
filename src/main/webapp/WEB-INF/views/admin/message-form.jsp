<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Message - ReLeaf Admin</title>
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
            <h1 class="page-title">Send New Message</h1>
            <a href="/admin/messages" class="btn btn-secondary">Back to Messages</a>
        </div>

        <div class="card">
            <form method="post" action="/admin/messages/send">
                <div class="form-group">
                    <label for="toUser" class="form-label">Recipient</label>
                    <select id="toUser" name="toUser" class="form-select" required>
                        <option value="">Select a user</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.name}">${user.name} (${user.email})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" id="subject" name="subject" class="form-input" required 
                           placeholder="Enter message subject">
                </div>

                <div class="form-group">
                    <label for="body" class="form-label">Message</label>
                    <textarea id="body" name="body" class="form-textarea" required 
                              placeholder="Enter your message..." style="min-height: 200px;"></textarea>
                </div>

                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn btn-primary">Send Message</button>
                    <a href="/admin/messages" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Message Templates</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1rem;">
                <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; cursor: pointer;" 
                     onclick="fillTemplate('Welcome to ReLeaf!', 'Welcome to our eco-friendly community! We\'re excited to have you join us in making a positive impact on the environment. Start by exploring our challenges and earning your first XP points!')">
                    <strong>Welcome Message</strong><br>
                    <small>For new users joining the platform</small>
                </div>
                <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; cursor: pointer;" 
                     onclick="fillTemplate('Congratulations on Your Achievement!', 'Congratulations on reaching a new milestone! Your dedication to environmental causes is inspiring. Keep up the great work and continue making a difference!')">
                    <strong>Achievement Congratulations</strong><br>
                    <small>For users who reach milestones</small>
                </div>
                <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; cursor: pointer;" 
                     onclick="fillTemplate('New Challenges Available', 'We\'ve added new exciting challenges to the platform! Check out the latest tasks and continue your eco-friendly journey. Every action counts towards a better planet!')">
                    <strong>New Challenges</strong><br>
                    <small>Announcing new tasks or features</small>
                </div>
                <div style="background: var(--light-green); padding: 1rem; border-radius: 5px; cursor: pointer;" 
                     onclick="fillTemplate('Monthly Newsletter', 'Here\'s your monthly update from ReLeaf! This month we\'ve seen amazing progress from our community. Thank you for being part of the change!')">
                    <strong>Newsletter</strong><br>
                    <small>Monthly updates and news</small>
                </div>
            </div>
            <p style="color: var(--gray); margin-top: 1rem; font-size: 0.9rem;">
                Click on any template above to auto-fill the subject and message fields.
            </p>
        </div>
    </main>

    <script>
        function fillTemplate(subject, body) {
            document.getElementById('subject').value = subject;
            document.getElementById('body').value = body;
        }
    </script>
</body>
</html>

