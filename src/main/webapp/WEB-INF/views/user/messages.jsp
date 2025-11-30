<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/messages.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
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
            text-decoration: none;
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
            background: linear-gradient(135deg, #358856, #3d9960);
            color: white;
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
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-envelope" style="margin-right: 12px;"></i>My Messages</h1>

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
                    <div class="no-messages">
                        <div class="no-messages-icon">📬</div>
                        <h3>No messages yet</h3>
                        <p>You haven't received any messages from administrators yet. Check back later!</p>
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
            <div class="card-body" style="text-align: center; padding: 2rem 0;">
                <h2>Need Help?</h2>
                <p>
                    Administrators may send you important messages about your account, tasks, or platform updates.
                    Make sure to check your inbox regularly!
                </p>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="/user/dashboard" class="btn-themed"><i class="fas fa-home"></i> Back to Dashboard</a>
                    <a href="/user/tasks" class="btn-secondary-themed"><i class="fas fa-tasks"></i> Browse Tasks</a>
                </div>
            </div>
        </div>
    </main>

</body>
</html> 