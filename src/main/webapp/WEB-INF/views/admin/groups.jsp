<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group Management - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>Releaf.R</h1>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/admin/dashboard">Dashboard</a></li>
                    <li><a href="/admin/tasks">Tasks</a></li>
                    <li><a href="/admin/users">Users</a></li>
                    <li><a href="/admin/groups">Groups</a></li>
                    <li><a href="/admin/notices">Notices</a></li>
                    <li><a href="/admin/messages">Messages</a></li>
                    <li><a href="/admin/reports">Reports</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.adminUsername}</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h1 class="page-title">Group Management</h1>
            <a href="/admin/groups/new" class="btn btn-primary">Create New Group</a>
        </div>

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

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Groups (${groups.size()} total)</h2>
            </div>
            
            <c:if test="${empty groups}">
                <p style="text-align: center; color: var(--gray); padding: 2rem;">
                    No groups created yet. <a href="/admin/groups/new">Create your first group</a>
                </p>
            </c:if>

            <c:if test="${not empty groups}">
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2rem; margin-top: 2rem;">
                    <c:forEach var="group" items="${groups}">
                        <div class="card" style="margin-bottom: 0;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                <h3 style="color: var(--dark-green); margin: 0;">${group.groupName}</h3>
                                <span class="xp-badge">${group.members.size()} members</span>
                            </div>
                            
                            <p style="color: var(--gray); margin-bottom: 1.5rem;">
                                <c:choose>
                                    <c:when test="${not empty group.description}">
                                        ${group.description}
                                    </c:when>
                                    <c:otherwise>
                                        No description provided
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <div style="margin-bottom: 1.5rem;">
                                <h4 style="color: var(--dark-green); margin-bottom: 0.5rem;">Members:</h4>
                                <c:choose>
                                    <c:when test="${empty group.members}">
                                        <p style="color: var(--gray); font-style: italic;">No members yet</p>
                                    </c:when>
                                    <c:otherwise>
                                        <ul style="list-style: none; padding: 0;">
                                            <c:forEach var="member" items="${group.members}" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <li style="padding: 0.25rem 0; color: var(--dark-gray);">
                                                        ${member.name} (${member.xpPoints} XP)
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${group.members.size() > 5}">
                                                <li style="color: var(--gray); font-style: italic;">
                                                    ... and ${group.members.size() - 5} more
                                                </li>
                                            </c:if>
                                        </ul>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="display: flex; gap: 0.5rem;">
                                <a href="/admin/groups/edit/${group.id}" class="btn btn-sm btn-secondary">Edit</a>
                                <form method="post" action="/admin/groups/delete/${group.id}" style="display: inline;" 
                                      onsubmit="return confirm('Are you sure you want to delete this group?')">
                                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                </form>
                            </div>

                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--light-green); font-size: 0.9rem; color: var(--gray);">
                                Created: ${group.createdAt.toLocalDate()}
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty groups}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Group Statistics</h2>
                </div>
                <div class="dashboard-grid">
                    <div class="stat-card">
                        <div class="stat-number">${groups.size()}</div>
                        <div class="stat-label">Total Groups</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="totalMembers" value="0" />
                            <c:forEach var="group" items="${groups}">
                                <c:set var="totalMembers" value="${totalMembers + group.members.size()}" />
                            </c:forEach>
                            ${totalMembers}
                        </div>
                        <div class="stat-label">Total Members</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="avgMembers" value="0" />
                            <c:if test="${groups.size() > 0}">
                                <c:set var="totalMembers" value="0" />
                                <c:forEach var="group" items="${groups}">
                                    <c:set var="totalMembers" value="${totalMembers + group.members.size()}" />
                                </c:forEach>
                                <c:set var="avgMembers" value="${totalMembers / groups.size()}" />
                            </c:if>
                            ${String.format("%.1f", avgMembers)}
                        </div>
                        <div class="stat-label">Avg Members/Group</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="largestGroup" value="0" />
                            <c:forEach var="group" items="${groups}">
                                <c:if test="${group.members.size() > largestGroup}">
                                    <c:set var="largestGroup" value="${group.members.size()}" />
                                </c:if>
                            </c:forEach>
                            ${largestGroup}
                        </div>
                        <div class="stat-label">Largest Group</div>
                    </div>
                </div>
            </div>
        </c:if>
    </main>
</body>
</html>

