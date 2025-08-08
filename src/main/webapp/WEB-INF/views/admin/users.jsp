<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
        <h1 class="page-title">User Management</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Registered Users (${users.size()} total)</h2>
                <div class="search-box">
                    <form action="/admin/users" method="GET" class="search-form">
                        <input type="text" name="searchName" placeholder="Search by name..." value="${param.searchName}" class="search-input search-input-lg">
                        <button type="submit" class="search-button search-button-lg">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>
            </div>
            
            <c:if test="${empty users}">
                <p style="text-align: center; color: var(--gray); padding: 2rem;">
                    No users registered yet.
                </p>
            </c:if>

            <c:if test="${not empty users}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>XP Points</th>
                            <th>Completed Tasks</th>
                            <th>Group</th>
                            <th>Joined Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="xp-badge">${user.xpPoints} XP</span>
                                </td>
                                <td>${user.completedTasks.size()}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.group != null}">
                                            ${user.group.groupName}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--gray);">No Group</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.createdAt.toLocalDate()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">User Statistics</h2>
            </div>
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-number">${users.size()}</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="totalXP" value="0" />
                        <c:forEach var="user" items="${users}">
                            <c:set var="totalXP" value="${totalXP + user.xpPoints}" />
                        </c:forEach>
                        ${totalXP}
                    </div>
                    <div class="stat-label">Total XP Earned</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="totalCompleted" value="0" />
                        <c:forEach var="user" items="${users}">
                            <c:set var="totalCompleted" value="${totalCompleted + user.completedTasks.size()}" />
                        </c:forEach>
                        ${totalCompleted}
                    </div>
                    <div class="stat-label">Tasks Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="usersWithGroups" value="0" />
                        <c:forEach var="user" items="${users}">
                            <c:if test="${user.group != null}">
                                <c:set var="usersWithGroups" value="${usersWithGroups + 1}" />
                            </c:if>
                        </c:forEach>
                        ${usersWithGroups}
                    </div>
                    <div class="stat-label">Users in Groups</div>
                </div>
            </div>
        </div>

        <c:if test="${not empty users}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Top Performers</h2>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Name</th>
                            <th>XP Points</th>
                            <th>Completed Tasks</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}" varStatus="status" begin="0" end="9">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}">🥇</c:when>
                                        <c:when test="${status.index == 1}">🥈</c:when>
                                        <c:when test="${status.index == 2}">🥉</c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.name}</td>
                                <td>
                                    <span class="xp-badge">${user.xpPoints} XP</span>
                                </td>
                                <td>${user.completedTasks.size()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </main>
</body>
</html>

