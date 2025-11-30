<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notices - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/notices.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-bullhorn" style="margin-right: 12px;"></i>Platform Notices</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Latest Updates & Announcements</h2>
            </div>
            
            <c:if test="${empty notices}">
                <div class="no-notices">
                    <div class="no-notices-icon">📢</div>
                    <h3>No notices available</h3>
                    <p>Check back later for updates and announcements from the ReLeaf team.</p>
                </div>
            </c:if>

            <c:if test="${not empty notices}">
                <div>
                    <c:forEach var="notice" items="${notices}">
                        <div class="notice-card">
                            <div class="notice-header">
                                <h3 class="notice-title">${notice.title}</h3>
                                <div class="notice-meta">
                                    <span class="status-badge">Active</span>
                                    <span>${notice.createdAt.toLocalDate()}</span>
                                </div>
                            </div>
                            <div class="notice-content">
                                <p>${notice.content}</p>
                            </div>
                            <div class="notice-footer">
                                <small>
                                    Posted on ${notice.createdAt.toLocalDate()} at ${notice.createdAt.toLocalTime().toString().substring(0, 5)}
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- Stay Connected -->
<div class="card">
            <div class="stay-connected">
                <h2>Stay Connected</h2>
                <p>
                    Don't miss important updates! Check this page regularly for the latest news, announcements, and community updates from the ReLeaf team.
                </p>
                <div class="social-icons">
                    <a href="https://www.facebook.com/releafeco/" target="_blank" rel="noopener noreferrer" title="Follow us on Facebook">
                        <i class="fab fa-facebook"></i>
                    </a>
                    <a href="mailto:releafecobd@gmail.com" title="Email us at releafecobd@gmail.com">
                        <i class="fas fa-envelope"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Tips Section -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">💡 Tips & Reminders</h2>
            </div>
            <ul class="tips-list">
                <li class="tip-item">
                    <span class="tip-icon">📱</span>
                    <span>Bookmark this page to stay updated with the latest announcements</span>
                </li>
                <li class="tip-item">
                    <span class="tip-icon">🔔</span>
                    <span>Check notices regularly for special events and bonus XP opportunities</span>
                </li>
                <li class="tip-item">
                    <span class="tip-icon">💬</span>
                    <span>Share feedback about notices through your profile or admin messages</span>
                </li>
                <li class="tip-item">
                    <span class="tip-icon">🌱</span>
                    <span>Follow notice guidelines to maximize your eco-friendly impact</span>
                </li>
            </ul>
        </div>
    </main>
</body>
</html>

