<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header CSS -->
<link rel="stylesheet" href="/css/header.css">
<!-- Page-scoped modern theme (cache-busted to force reload after edits) -->
<link rel="stylesheet" href="/css/modern-theme.css?v=2">

<header class="user-header">
    <!-- Logo -->
    <div class="logo-container">
        <img src="/images/releaf-logo.jpg" alt="Releaf Logo" class="logo">
        <span class="logo-text">Releaf</span>
    </div>

    <!-- Navigation -->
    <nav class="main-nav">
        <a href="/user/dashboard" class="nav-link ${pageContext.request.requestURI eq '/user/dashboard' ? 'active' : ''}">Dashboard</a>
        <a href="/user/tasks" class="nav-link ${pageContext.request.requestURI eq '/user/tasks' ? 'active' : ''}">
            <c:choose>
                <c:when test="${pageContext.request.requestURI eq '/user/tasks'}">
                    <span class="gemini-text">Tasks</span>
                    <span class="shimmer" aria-hidden="true"></span>
                </c:when>
                <c:otherwise>Tasks</c:otherwise>
            </c:choose>
        </a>
        <a href="/user/achievements" class="nav-link ${pageContext.request.requestURI eq '/user/achievements' ? 'active' : ''}">Achievements</a>
        <a href="/user/groups" class="nav-link ${pageContext.request.requestURI eq '/user/groups' ? 'active' : ''}">Groups</a>
        <a href="/user/notices" class="nav-link ${pageContext.request.requestURI eq '/user/notices' ? 'active' : ''}">Notices</a>
    </nav>

    <!-- User Menu -->
    <div class="user-menu">
        <div class="user-info">
            <span class="username">${sessionScope.userName}</span>
            <span class="xp-points">${user.xpPoints} XP</span>
        </div>
        <div class="profile-dropdown">
            <img src="${empty sessionScope.user.profilePicture ? '/images/default-avatar.png' : '/user-photos/'.concat(sessionScope.user.profilePicture)}" alt="User Avatar" class="avatar">
            <div class="dropdown-content">
                <a href="/user/profile">Profile</a>
                <a href="/user/messages">Messages</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</header>
