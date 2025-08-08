<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notices - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
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
                    <li><a href="/user/messages">Messages</a></li>
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
        <h1 class="page-title">Platform Notices</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Latest Updates & Announcements</h2>
            </div>
            
            <c:if test="${empty notices}">
                <div style="text-align: center; padding: 3rem 0;">
                    <div style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.5;">📢</div>
                    <h3 style="color: var(--gray); margin-bottom: 1rem;">No notices available</h3>
                    <p style="color: var(--gray);">Check back later for updates and announcements from the ReLeaf team.</p>
                </div>
            </c:if>

            <c:if test="${not empty notices}">
                <div style="margin-top: 2rem;">
                    <c:forEach var="notice" items="${notices}" varStatus="status">
                        <div class="card" style="margin-bottom: 2rem; border-left: 4px solid var(--primary-green);">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                <h3 style="color: var(--dark-green); margin: 0; font-size: 1.3rem;">${notice.title}</h3>
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <span style="background: var(--success); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.8rem;">
                                        Active
                                    </span>
                                    <span style="color: var(--gray); font-size: 0.9rem;">
                                        ${notice.createdAt.toLocalDate()}
                                    </span>
                                </div>
                            </div>
                            
                            <div style="background: var(--light-gray); padding: 1.5rem; border-radius: 5px; margin-bottom: 1rem;">
                                <p style="margin: 0; white-space: pre-wrap; line-height: 1.6; color: var(--dark-gray);">
                                    ${notice.content}
                                </p>
                            </div>

                            <div style="display: flex; justify-content: between; align-items: center; padding-top: 1rem; border-top: 1px solid var(--light-green);">
                                <small style="color: var(--gray);">
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
            <div style="text-align: center; padding: 2rem 0;">
                <h2 style="color: var(--dark-green); margin-bottom: 1rem;">Stay Connected</h2>
                <p style="color: var(--gray); margin-bottom: 2rem; font-size: 1.1rem;">
                    Don't miss important updates! Check this page regularly for the latest news, announcements, and community updates from the ReLeaf team.
                </p>

                <div class="stay-connected-icons" style="margin-bottom: 2rem;">
                    <a href="https://www.facebook.com/releafeco/" target="_blank" rel="noopener noreferrer" title="Follow us on Facebook" style="text-decoration: none; margin: 0 10px;">
                        <i class="fa-brands fa-facebook" style="font-size: 36px; color: #0866FF;"></i>
                    </a>
                    <a href="mailto:releafecobd@gmail.com" title="Email us at releafecobd@gmail.com" style="text-decoration: none; margin: 0 10px;">
                        <i class="fa-solid fa-envelope" style="font-size: 36px; color: #DB4437;"></i>
                    </a>
                </div>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="/user/dashboard" class="btn btn-primary">Back to Dashboard</a>
                    <a href="/user/tasks" class="btn btn-secondary">Browse Tasks</a>
                </div>
            </div>
        </div>

        <!-- Tips Section -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">💡 Tips & Reminders</h2>
            </div>
            <div style="background: var(--light-gray); padding: 1.5rem; border-radius: 5px;">
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="padding: 0.75rem 0; border-bottom: 1px solid var(--light-green); display: flex; align-items: center;">
                        <span style="margin-right: 1rem; font-size: 1.2rem;">📱</span>
                        <span style="color: var(--dark-gray);">Bookmark this page to stay updated with the latest announcements</span>
                    </li>
                    <li style="padding: 0.75rem 0; border-bottom: 1px solid var(--light-green); display: flex; align-items: center;">
                        <span style="margin-right: 1rem; font-size: 1.2rem;">🔔</span>
                        <span style="color: var(--dark-gray);">Check notices regularly for special events and bonus XP opportunities</span>
                    </li>
                    <li style="padding: 0.75rem 0; border-bottom: 1px solid var(--light-green); display: flex; align-items: center;">
                        <span style="margin-right: 1rem; font-size: 1.2rem;">💬</span>
                        <span style="color: var(--dark-gray);">Share feedback about notices through your profile or admin messages</span>
                    </li>
                    <li style="padding: 0.75rem 0; display: flex; align-items: center;">
                        <span style="margin-right: 1rem; font-size: 1.2rem;">🌱</span>
                        <span style="color: var(--dark-gray);">Follow notice guidelines to maximize your eco-friendly impact</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>

