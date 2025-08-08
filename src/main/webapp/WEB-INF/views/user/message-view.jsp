<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message - ReLeaf</title>
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
        <div class="message-navigation">
            <a href="/user/messages" class="btn btn-secondary">
                ← Back to Messages
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <!-- Message Header -->
            <div class="card">
                <div class="message-header-card">
                    <div class="message-meta">
                        <div class="message-sender-info">
                            <div class="sender-avatar">👤</div>
                            <div class="sender-details">
                                <h2 class="message-subject">${message.subject}</h2>
                                <div class="sender-name">From: <strong>${message.fromUser}</strong></div>
                                <div class="message-date">
                                    Sent on ${message.createdAt.toLocalDate()} at ${message.createdAt.toLocalTime().toString().substring(0, 5)}
                                </div>
                            </div>
                        </div>
                        <div class="message-status">
                            <c:choose>
                                <c:when test="${message.isRead}">
                                    <span class="status-badge read">Read</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge unread">New</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Message Content -->
            <div class="card">
                <div class="message-content">
                    <div class="message-body">
                        ${message.body}
                    </div>
                </div>
            </div>

            <!-- Message Actions -->
            <div class="card">
                <div class="message-actions">
                    <a href="/user/messages" class="btn btn-primary">Back to Inbox</a>
                    <a href="/user/dashboard" class="btn btn-secondary">Go to Dashboard</a>
                </div>
            </div>
        </c:if>

        <!-- Help Section -->
        <div class="card">
            <div style="text-align: center; padding: 2rem 0;">
                <h2 style="color: var(--dark-green); margin-bottom: 1rem;">Need to Contact an Admin?</h2>
                <p style="color: var(--gray); margin-bottom: 2rem; font-size: 1.1rem;">
                    If you have questions or need assistance, please check the notices section or contact the platform administrators.
                </p>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="/user/notices" class="btn btn-primary">View Notices</a>
                    <a href="/user/tasks" class="btn btn-secondary">Browse Tasks</a>
                </div>
            </div>
        </div>
    </main>

    <style>
        .message-navigation {
            margin-bottom: 2rem;
        }

        .message-header-card {
            padding: 0;
        }

        .message-meta {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 2rem;
        }

        .message-sender-info {
            display: flex;
            align-items: flex-start;
            gap: 1.5rem;
        }

        .sender-avatar {
            font-size: 2.5rem;
            background: var(--light-green);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sender-details {
            flex: 1;
        }

        .message-subject {
            color: var(--dark-green);
            margin: 0 0 0.5rem 0;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .sender-name {
            color: var(--dark-gray);
            margin-bottom: 0.25rem;
            font-size: 1.1rem;
        }

        .message-date {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .message-status {
            flex-shrink: 0;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-badge.read {
            background: var(--light-green);
            color: var(--dark-green);
        }

        .status-badge.unread {
            background: var(--primary-green);
            color: white;
        }

        .message-content {
            padding: 2rem;
        }

        .message-body {
            color: var(--dark-gray);
            line-height: 1.8;
            font-size: 1.1rem;
            white-space: pre-wrap;
        }

        .message-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            padding: 1.5rem;
        }

        @media (max-width: 768px) {
            .message-meta {
                flex-direction: column;
                gap: 1rem;
                padding: 1.5rem;
            }

            .message-sender-info {
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 1rem;
            }

            .sender-avatar {
                width: 50px;
                height: 50px;
                font-size: 2rem;
            }

            .message-subject {
                font-size: 1.3rem;
            }

            .message-content {
                padding: 1.5rem;
            }

            .message-body {
                font-size: 1rem;
            }

            .message-actions {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</body>
</html> 