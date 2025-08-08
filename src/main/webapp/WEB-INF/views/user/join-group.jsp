<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Groups - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/profile.css">
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
        <h1 class="page-title">Browse Groups</h1>

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

        <c:if test="${not empty warning}">
            <div class="alert alert-warning">
                ${warning}
            </div>
        </c:if>

        <!-- Available Groups -->
        <div class="groups-grid">
            <c:choose>
                <c:when test="${empty availableGroups}">
                    <div class="no-groups-message">
                        <h3>No groups available yet</h3>
                        <p>There are currently no groups to join. Check back later!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="group" items="${availableGroups}">
                <div class="group-card">
                    <div class="group-info">
                        <h3>${group.groupName}</h3>
                        <p class="description">${group.description}</p>
                        <div class="group-stats">
                            <span class="member-count">${group.members.size()} members</span>
                            <c:if test="${group.members.size() > 0}">
                                <span class="avg-xp">
                                    Avg. XP: ${String.format("%.0f", group.members.stream().mapToInt(m -> m.xpPoints).average().orElse(0))}
                                </span>
                            </c:if>
                        </div>
                    </div>
                    <div class="group-actions">
                        <c:choose>
                            <c:when test="${currentUser.group != null && currentUser.group.id == group.id}">
                                <span class="current-group-badge">Current Group</span>
                                <form method="post" action="/user/leave-group" style="display: inline;">
                                    <button type="submit" class="btn btn-danger">Leave Group</button>
                                </form>
                            </c:when>
                            <c:when test="${currentUser.group == null}">
                                <form method="post" action="/user/join-group/${group.id}" style="display: inline;">
                                    <button type="submit" class="btn btn-primary">Join Group</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Already in a different group</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${group.members.size() > 0}">
                        <div class="members-list">
                            <h4>Members</h4>
                            <table class="members-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>XP Points</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="member" items="${group.members}">
                                        <tr>
                                            <td>${member.name}</td>
                                            <td class="xp-cell">${member.xpPoints} XP</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
                                </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="back-link">
            <a href="/user/profile" class="btn btn-secondary">Back to Profile</a>
        </div>
    </main>

    <style>
        .groups-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }

        .group-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .group-info h3 {
            color: var(--dark-green);
            margin: 0 0 0.5rem 0;
        }

        .description {
            color: var(--gray);
            margin-bottom: 1rem;
        }

        .group-stats {
            display: flex;
            justify-content: space-between;
            color: var(--dark-gray);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .group-actions {
            border-top: 1px solid var(--light-green);
            padding-top: 1rem;
            margin-top: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .current-group-badge {
            background: var(--light-green);
            color: var(--dark-green);
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.9rem;
        }

        .members-list {
            margin-top: 1.5rem;
            border-top: 1px solid var(--light-green);
            padding-top: 1rem;
        }

        .members-list h4 {
            color: var(--dark-green);
            margin: 0 0 1rem 0;
        }

        .members-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .members-table th,
        .members-table td {
            padding: 0.5rem;
            text-align: left;
            border-bottom: 1px solid var(--light-green);
        }

        .members-table th {
            color: var(--dark-green);
            font-weight: 600;
        }

        .xp-cell {
            color: var(--primary-green);
            font-weight: 500;
        }

        .back-link {
            margin-top: 2rem;
            text-align: center;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .no-groups-message {
            text-align: center;
            padding: 3rem;
            color: var(--gray);
        }

        .no-groups-message h3 {
            color: var(--dark-green);
            margin-bottom: 1rem;
        }
    </style>
</body>
</html>
