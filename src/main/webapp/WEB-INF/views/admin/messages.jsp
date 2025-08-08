<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - ReLeaf Admin</title>
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
            <h1 class="page-title">Messages</h1>
            <a href="/admin/messages/new" class="btn btn-primary">Send New Message</a>
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

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
            <!-- Received Messages -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Received Messages (${receivedMessages.size()})</h2>
                </div>
                
                <c:if test="${empty receivedMessages}">
                    <p style="text-align: center; color: var(--gray); padding: 2rem;">
                        No messages received yet.
                    </p>
                </c:if>

                <c:if test="${not empty receivedMessages}">
                    <div style="max-height: 600px; overflow-y: auto;">
                        <c:forEach var="message" items="${receivedMessages}">
                            <div style="border-bottom: 1px solid var(--light-green); padding: 1rem 0;">
                                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.5rem;">
                                    <strong style="color: var(--dark-green);">${message.subject}</strong>
                                    <span style="font-size: 0.8rem; color: var(--gray);">
                                        ${message.createdAt.toLocalDate()}
                                    </span>
                                </div>
                                <div style="margin-bottom: 0.5rem;">
                                    <span style="color: var(--gray); font-size: 0.9rem;">From: ${message.fromUser}</span>
                                    <c:if test="${!message.isRead}">
                                        <span style="background: var(--error); color: white; padding: 0.2rem 0.5rem; border-radius: 10px; font-size: 0.7rem; margin-left: 0.5rem;">
                                            NEW
                                        </span>
                                    </c:if>
                                </div>
                                <p style="color: var(--dark-gray); margin: 0; font-size: 0.9rem;">
                                    ${message.body.length() > 100 ? message.body.substring(0, 100).concat('...') : message.body}
                                </p>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- Sent Messages -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Sent Messages (${sentMessages.size()})</h2>
                </div>
                
                <c:if test="${empty sentMessages}">
                    <p style="text-align: center; color: var(--gray); padding: 2rem;">
                        No messages sent yet.
                    </p>
                </c:if>

                <c:if test="${not empty sentMessages}">
                    <div style="max-height: 600px; overflow-y: auto;">
                        <c:forEach var="message" items="${sentMessages}">
                            <div style="border-bottom: 1px solid var(--light-green); padding: 1rem 0;">
                                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.5rem;">
                                    <strong style="color: var(--dark-green);">${message.subject}</strong>
                                    <span style="font-size: 0.8rem; color: var(--gray);">
                                        ${message.createdAt.toLocalDate()}
                                    </span>
                                </div>
                                <div style="margin-bottom: 0.5rem;">
                                    <span style="color: var(--gray); font-size: 0.9rem;">To: ${message.toUser}</span>
                                </div>
                                <p style="color: var(--dark-gray); margin: 0; font-size: 0.9rem;">
                                    ${message.body.length() > 100 ? message.body.substring(0, 100).concat('...') : message.body}
                                </p>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Message Statistics</h2>
            </div>
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-number">${receivedMessages.size()}</div>
                    <div class="stat-label">Received Messages</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${sentMessages.size()}</div>
                    <div class="stat-label">Sent Messages</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="unreadCount" value="0" />
                        <c:forEach var="message" items="${receivedMessages}">
                            <c:if test="${!message.isRead}">
                                <c:set var="unreadCount" value="${unreadCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${unreadCount}
                    </div>
                    <div class="stat-label">Unread Messages</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${receivedMessages.size() + sentMessages.size()}</div>
                    <div class="stat-label">Total Messages</div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>

