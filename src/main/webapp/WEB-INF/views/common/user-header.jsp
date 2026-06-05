<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="currentPath" value="${pageContext.request.requestURI}" />

<style>
/* CRITICAL HEADER FIX - Inline styles with maximum specificity to override all other CSS */
body .user-header,
.user-header {
    background: #fff !important;
    color: #333 !important;
    padding: 12px 30px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08) !important;
    position: sticky !important;
    top: 0 !important;
    z-index: 1000 !important;
    border-bottom: 1px solid #e0e0e0 !important;
    width: 100% !important;
    box-sizing: border-box !important;
    gap: 20px !important;
}

.user-header .logo-container {
    display: flex !important;
    align-items: center !important;
    flex-shrink: 0 !important;
    min-width: 120px !important;
}

.user-header .logo {
    height: 40px !important;
    width: 40px !important;
    border-radius: 50% !important;
    margin-right: 12px !important;
    object-fit: cover !important;
    flex-shrink: 0 !important;
}

.user-header .logo-text {
    font-size: 1.5rem !important;
    font-weight: 700 !important;
    color: #2c3e50 !important;
    -webkit-text-fill-color: #2c3e50 !important;
    background: none !important;
    letter-spacing: 0 !important;
    line-height: 1 !important;
    white-space: nowrap !important;
    flex-shrink: 0 !important;
}

.user-header .main-nav {
    display: flex !important;
    gap: 4px !important;
    background: #F7FAFC !important;
    border: 1px solid #e0e0e0 !important;
    border-radius: 999px !important;
    padding: 6px !important;
    flex-shrink: 0 !important;
    min-width: 500px !important;
    max-width: 600px !important;
    justify-content: center !important;
}

.user-header .main-nav nav {
    display: flex !important;
    gap: 2px !important;
    flex-wrap: nowrap !important;
}

.user-header .nav-link {
    color: #358856 !important;
    text-decoration: none !important;
    padding: 10px 18px !important;
    border-radius: 999px !important;
    transition: background-color 0.3s, color 0.3s !important;
    font-weight: 500 !important;
    font-size: 0.95rem !important;
    white-space: nowrap !important;
    display: inline-block !important;
    background: transparent !important;
    position: static !important;
    -webkit-text-fill-color: #358856 !important;
    border: none !important;
}

.user-header .nav-link::after,
.user-header .nav-link::before {
    display: none !important;
}

.user-header .nav-link:hover {
    background-color: #e8f5e9 !important;
    color: #4CAF50 !important;
    -webkit-text-fill-color: #4CAF50 !important;
}

.user-header .nav-link.active {
    background-color: #4CAF50 !important;
    color: #fff !important;
    -webkit-text-fill-color: #fff !important;
    box-shadow: 0 4px 12px rgba(76, 175, 80, 0.4) !important;
    font-weight: 600 !important;
}

.user-header .user-menu {
    display: flex !important;
    align-items: center !important;
    gap: 16px !important;
    flex-shrink: 0 !important;
    background: #F7FAFC !important;
    border: 1px solid #e0e0e0 !important;
    border-radius: 999px !important;
    padding: 6px 12px 6px 6px !important;
    min-width: 200px !important;
    max-width: 300px !important;
}

.user-header .user-info {
    display: flex !important;
    align-items: center !important;
    gap: 10px !important;
    background: transparent !important;
    padding: 0 !important;
    border: none !important;
}

.user-header .username {
    font-weight: 600 !important;
    font-size: 0.9rem !important;
    color: #2d3748 !important;
    -webkit-text-fill-color: #2d3748 !important;
    background: none !important;
    padding: 0 !important;
}

.user-header .xp-points {
    background-color: #e8f5e9 !important;
    color: #388e3c !important;
    padding: 4px 12px !important;
    border-radius: 15px !important;
    font-size: 0.85rem !important;
    font-weight: 600 !important;
    white-space: nowrap !important;
    -webkit-text-fill-color: #388e3c !important;
}

.user-header .avatar {
    height: 36px !important;
    width: 36px !important;
    border-radius: 50% !important;
    cursor: pointer !important;
    border: 2px solid #e0e0e0 !important;
    object-fit: cover !important;
    flex-shrink: 0 !important;
}

/* Responsive */
@media (max-width: 1200px) {
    .user-header .main-nav {
        min-width: 450px !important;
        max-width: 500px !important;
    }
    .user-header .user-menu {
        min-width: 180px !important;
    }
}

@media (max-width: 992px) {
    .user-header {
        padding: 10px 20px !important;
        gap: 15px !important;
    }
    .user-header .main-nav {
        min-width: 400px !important;
        max-width: 450px !important;
        padding: 4px !important;
    }
    .user-header .nav-link {
        padding: 8px 14px !important;
        font-size: 0.9rem !important;
    }
    .user-header .user-menu {
        min-width: 160px !important;
    }
    .user-header .logo-text {
        font-size: 1.3rem !important;
    }
}

@media (max-width: 768px) {
    .user-header {
        flex-wrap: wrap !important;
        justify-content: center !important;
        padding: 10px !important;
        gap: 10px !important;
    }
    .user-header .logo-container {
        order: 1 !important;
        min-width: auto !important;
    }
    .user-header .user-menu {
        order: 2 !important;
        min-width: auto !important;
        max-width: none !important;
    }
    .user-header .main-nav {
        order: 3 !important;
        width: 100% !important;
        min-width: 100% !important;
        max-width: 100% !important;
        justify-content: space-around !important;
    }
    .user-header .nav-link {
        padding: 8px 12px !important;
        font-size: 0.85rem !important;
    }
    .user-header .user-info {
        display: none !important;
    }
}
</style>

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
            <a href="<c:url value='/user/eco-store'/>" class="nav-link ${currentPath == '/user/eco-store' ? 'active' : ''}">Eco Store</a>
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