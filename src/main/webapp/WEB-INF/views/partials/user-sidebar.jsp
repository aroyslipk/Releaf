<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="fixed inset-y-0 left-0 z-50 w-64 bg-card border-r border-border px-4">
    <!-- Logo Section -->
    <div class="h-14 flex items-center border-b border-border">
        <img src="/images/logo.png" alt="ReLeaf Logo" class="w-8 h-8">
        <span class="text-lg font-bold text-foreground ml-2">Releaf.R</span>
    </div>

    <!-- Navigation Links -->
    <nav class="py-4 space-y-1">
        <a href="/user/dashboard" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/dashboard') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="layout-dashboard" class="w-5 h-5"></i>
            Dashboard
        </a>
        <a href="/user/tasks" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/tasks') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="check-circle-2" class="w-5 h-5"></i>
            Tasks
        </a>
        <a href="/user/achievements" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/achievements') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="trophy" class="w-5 h-5"></i>
            Achievements
        </a>
        <a href="/user/groups" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/groups') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="users" class="w-5 h-5"></i>
            Groups
        </a>
        <a href="/user/notices" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/notices') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="bell" class="w-5 h-5"></i>
            Notices
            <c:if test="${unreadNotices > 0}">
                <span class="ml-auto bg-primary text-white text-xs font-semibold px-2 py-0.5 rounded-full">${unreadNotices}</span>
            </c:if>
        </a>
        <a href="/user/messages" class="nav-link flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md hover:bg-muted ${pageContext.request.requestURI.contains('/messages') ? 'bg-secondary text-secondary-foreground' : 'text-muted-foreground'}">
            <i data-lucide="mail" class="w-5 h-5"></i>
            Messages
        </a>
    </nav>

    <!-- User Profile Section -->
    <div class="absolute bottom-0 left-0 right-0 p-4 border-t border-border">
        <div class="flex items-center gap-3">
            <c:choose>
                <c:when test="${not empty user.profilePicture}">
                    <img src="<c:url value='/uploads/profile/${user.profilePicture}'/>" alt="User Avatar" class="w-10 h-10 rounded-full border-2 border-primary">
                </c:when>
                <c:otherwise>
                    <img src="https://i.pravatar.cc/40?u=${user.id}" alt="User Avatar" class="w-10 h-10 rounded-full border-2 border-primary">
                </c:otherwise>
            </c:choose>
            <div>
                <p class="font-medium text-sm text-foreground">${user.name}</p>
                <p class="text-xs text-muted-foreground">${user.xpPoints} XP</p>
            </div>
            <a href="/logout" class="ml-auto text-muted-foreground hover:text-foreground">
                <i data-lucide="log-out" class="w-5 h-5"></i>
            </a>
        </div>
    </div>
</aside>

<!-- Initialize Lucide Icons -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        lucide.createIcons();
    });
</script>
