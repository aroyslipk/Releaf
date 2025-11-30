<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="currentPath" value="${pageContext.request.requestURI}" />

<header class="user-header">
    <div class="logo-container">
        <img src="<c:url value='/images/releaf-logo.jpg'/>" alt="Releaf Logo" class="logo">
        <span class="logo-text">Releaf</span>
    </div>
    <div class="main-nav">
        <nav>
            <a href="<c:url value='/user/dashboard'/>" class="nav-link ${currentPath == '/user/dashboard' ? 'active' : ''}">Dashboard</a>
            <a href="<c:url value='/user/tasks'/>" class="nav-link ${fn:startsWith(currentPath, '/user/tasks') || fn:startsWith(currentPath, '/user/greenverse') || fn:startsWith(currentPath, '/user/funlab') ? 'active' : ''}">
                <c:choose>
                    <c:when test="${fn:startsWith(currentPath, '/user/tasks') || fn:startsWith(currentPath, '/user/greenverse') || fn:startsWith(currentPath, '/user/funlab')}">
                        <span class="gemini-text">Tasks</span>
                        <span class="shimmer" aria-hidden="true"></span>
                    </c:when>
                    <c:otherwise>Tasks</c:otherwise>
                </c:choose>
            </a>
            <a href="<c:url value='/user/achievements'/>" class="nav-link ${currentPath == '/user/achievements' ? 'active' : ''}">Achievements</a>
            <a href="<c:url value='/user/groups'/>" class="nav-link ${fn:startsWith(currentPath, '/user/groups') ? 'active' : ''}">Groups</a>
            <a href="<c:url value='/user/notices'/>" class="nav-link ${currentPath == '/user/notices' ? 'active' : ''}">Notices</a>
        </nav>
    </div>
    <div class="user-menu">
        <div class="user-info">
            <span class="username">${sessionScope.userName}</span>
            <span class="xp-points">${user.xpPoints} XP</span>
        </div>
        <!-- Notification Bell -->
        <div class="notification-bell" id="notificationBell">
            <a href="<c:url value='/user/messages'/>" class="bell-icon" title="Messages & Notifications">
                <i class="fas fa-bell"></i>
                <span class="notification-badge" id="notificationBadge" style="display: none;">0</span>
            </a>
        </div>
        <div class="profile-dropdown">
            <img src="${empty user.profilePicture ? pageContext.request.contextPath.concat('/images/default-avatar.png') : pageContext.request.contextPath.concat('/user-photos/').concat(user.profilePicture)}" alt="User Avatar" class="avatar">
            <div class="dropdown-content">
                <a href="<c:url value='/user/profile'/>">Profile</a>
                <a href="<c:url value='/user/messages'/>">Messages</a>
                <a href="<c:url value='/logout'/>">Logout</a>
            </div>
        </div>
    </div>
<style>
.notification-bell {
    position: relative;
    margin-right: 1rem;
}
.bell-icon {
    color: #2D7A48;
    font-size: 1.3rem;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(45, 122, 72, 0.1);
}
.bell-icon:hover {
    background: rgba(45, 122, 72, 0.2);
    transform: scale(1.1);
}
.notification-badge {
    position: absolute;
    top: -2px;
    right: -2px;
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
    font-size: 0.65rem;
    font-weight: 700;
    min-width: 18px;
    height: 18px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid white;
    animation: pulse-badge 2s infinite;
}
@keyframes pulse-badge {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); }
}
</style>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Fetch notification count
    fetch('/user/notifications/count')
        .then(response => response.json())
        .then(data => {
            const badge = document.getElementById('notificationBadge');
            if (data.count > 0) {
                badge.textContent = data.count > 99 ? '99+' : data.count;
                badge.style.display = 'flex';
            } else {
                badge.style.display = 'none';
            }
        })
        .catch(err => console.log('Notification check failed'));
});
</script>
</header>