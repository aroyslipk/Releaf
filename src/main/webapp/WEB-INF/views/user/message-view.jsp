<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message - ReLeaf</title>
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

        .message-view-header {
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid #e2e8f0;
        }
        .message-sender-info {
            display: flex;
            align-items: flex-start;
            gap: 1.25rem;
        }
        .sender-avatar {
            font-size: 2rem;
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            color: #2D7A48;
        }
        .message-subject {
            color: #2D7A48;
            margin: 0 0 0.5rem 0;
            font-size: 1.35rem;
            font-weight: 600;
        }
        .sender-name {
            color: #2d3748;
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }
        .message-date {
            color: #718096;
            font-size: 0.875rem;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-badge.read {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2D7A48;
            border: 1px solid #2D7A48;
        }
        .status-badge.unread {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
        }
        .message-body-content {
            padding: 2rem;
            color: #2d3748;
            line-height: 1.8;
            font-size: 1.05rem;
            white-space: pre-wrap;
            background: #fafbfc;
            border-radius: 0 0 12px 12px;
        }
        .message-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            padding: 1.5rem;
            flex-wrap: wrap;
        }
        @media (max-width: 768px) {
            .message-view-header {
                flex-direction: column;
                gap: 1rem;
            }
            .message-sender-info {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .message-subject {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-envelope-open-text" style="margin-right: 12px;"></i>View Message</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <!-- Message Card -->
            <div class="card">
                <div class="message-view-header">
                    <div class="message-sender-info">
                        <div class="sender-avatar"><i class="fas fa-user"></i></div>
                        <div class="sender-details">
                            <h2 class="message-subject">${message.subject}</h2>
                            <div class="sender-name">From: <strong>${message.fromUser}</strong></div>
                            <div class="message-date">
                                <i class="fas fa-clock"></i> Sent on ${message.createdAt.toLocalDate()} at ${message.createdAt.toLocalTime().toString().substring(0, 5)}
                            </div>
                        </div>
                    </div>
                    <div class="message-status">
                        <c:choose>
                            <c:when test="${message.isRead}">
                                <span class="status-badge read"><i class="fas fa-check"></i> Read</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge unread"><i class="fas fa-envelope"></i> New</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="message-body-content">
                    ${message.body}
                </div>
            </div>

            <!-- Message Actions -->
            <div class="card">
                <div class="message-actions">
                    <a href="/user/messages" class="btn-themed"><i class="fas fa-inbox"></i> Back to Inbox</a>
                    <a href="/user/dashboard" class="btn-secondary-themed"><i class="fas fa-home"></i> Go to Dashboard</a>
                </div>
            </div>
        </c:if>
    </main>
</body>
</html>