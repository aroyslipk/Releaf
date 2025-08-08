<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
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
                    <li><a href="/user/messages" class="active">Messages</a></li>
                    <li><a href="/user/profile">Profile</a></li>
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
        <h1 class="page-title">My Messages</h1>

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

        <!-- Messages Overview -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Inbox</h2>
                <c:if test="${unreadCount > 0}">
                    <span class="unread-badge">${unreadCount} unread</span>
                </c:if>
            </div>
            
            <c:choose>
                <c:when test="${empty messages}">
                    <div style="text-align: center; padding: 3rem 0;">
                        <div style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.5;">📬</div>
                        <h3 style="color: var(--gray); margin-bottom: 1rem;">No messages yet</h3>
                        <p style="color: var(--gray);">You haven't received any messages from administrators yet. Check back later!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="messages-list">
                        <c:forEach var="message" items="${messages}">
                            <div class="message-item ${message.isRead ? 'read' : 'unread'}" onclick="window.location.href='/user/messages/${message.id}'">
                                <div class="message-header">
                                    <div class="message-sender">
                                        <strong>${message.fromUser}</strong>
                                        <c:if test="${!message.isRead}">
                                            <span class="unread-indicator">●</span>
                                        </c:if>
                                    </div>
                                    <div class="message-date">
                                        ${message.createdAt.toLocalDate()} at ${message.createdAt.toLocalTime().toString().substring(0, 5)}
                                    </div>
                                </div>
                                <div class="message-subject">
                                    ${message.subject}
                                </div>
                                <div class="message-preview">
                                    ${message.body.length() > 100 ? message.body.substring(0, 100).concat('...') : message.body}
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Help Section -->
        <div class="card">
            <div style="text-align: center; padding: 2rem 0;">
                <h2 style="color: var(--dark-green); margin-bottom: 1rem;">Need Help?</h2>
                <p style="color: var(--gray); margin-bottom: 2rem; font-size: 1.1rem;">
                    Administrators may send you important messages about your account, tasks, or platform updates. 
                    Make sure to check your inbox regularly!
                </p>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="/user/dashboard" class="btn btn-primary">Back to Dashboard</a>
                    <a href="/user/tasks" class="btn btn-secondary">Browse Tasks</a>
                </div>
            </div>
        </div>
    </main>

    <style>
        .unread-badge {
            background: var(--primary-green);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .messages-list {
            margin-top: 1rem;
        }

        .message-item {
            border: 1px solid var(--light-green);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .message-item:hover {
            border-color: var(--primary-green);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .message-item.unread {
            border-left: 4px solid var(--primary-green);
            background: linear-gradient(135deg, #f8fff8 0%, #ffffff 100%);
        }

        .message-item.read {
            border-left: 4px solid var(--light-green);
            opacity: 0.8;
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .message-sender {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--dark-green);
        }

        .unread-indicator {
            color: var(--primary-green);
            font-size: 1.2rem;
            font-weight: bold;
        }

        .message-date {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .message-subject {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }

        .message-preview {
            color: var(--gray);
            font-size: 0.95rem;
            line-height: 1.4;
        }

        @media (max-width: 768px) {
            .message-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
            
            .message-item {
                padding: 1rem;
            }
        }
    </style>
</body>
</html> 