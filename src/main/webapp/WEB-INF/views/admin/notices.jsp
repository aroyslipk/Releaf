<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notice Management - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            padding: 1rem;
        }
        .stat-card {
            background: var(--primary-green, #4a7862);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: white;
            margin-bottom: 0.75rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        .stat-label {
            color: rgba(255,255,255,0.9);
            font-size: 1rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .active-notice { 
            border-left: 4px solid var(--primary-green); 
        }
        .inactive-notice { 
            border-left: 4px solid var(--gray); 
        }
    </style>
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
            <h1 class="page-title">Notice Management</h1>
            <a href="/admin/notices/new" class="btn btn-primary">Create New Notice</a>
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
                <h2 class="card-title">All Notices (${notices.size()} total)</h2>
            </div>
            
            <c:if test="${empty notices}">
                <p style="text-align: center; color: var(--gray); padding: 2rem;">
                    No notices created yet. <a href="/admin/notices/new">Create your first notice</a>
                </p>
            </c:if>
            <c:if test="${not empty notices}">
                <div style="margin-top: 2rem;">
                    <c:forEach var="notice" items="${notices}">
                        <div class="card ${notice.isActive ? 'active-notice' : 'inactive-notice'}" style="margin-bottom: 1.5rem;"> 
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                <div style="flex: 1;">
                                    <h3 style="color: var(--dark-green); margin: 0 0 0.5rem 0;">${notice.title}</h3>
                                    <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1rem;">
                                        <span class="${notice.isActive ? 'badge-success' : 'badge-inactive'}" style="color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.8rem;">
                                            ${notice.isActive ? 'Active' : 'Inactive'}
                                        </span>
                                        <span style="color: var(--gray); font-size: 0.9rem;">
                                            Created: ${notice.createdAt.toLocalDate()}
                                        </span>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 0.5rem;">
                                    <form method="post" action="/admin/notices/toggle/${notice.id}" style="display: inline;">
                                        <button type="submit" class="btn btn-sm ${notice.isActive ? 'btn-warning' : 'btn-success'}">
                                            ${notice.isActive ? 'Deactivate' : 'Activate'}
                                        </button>
                                    </form>
                                    <a href="/admin/notices/edit/${notice.id}" class="btn btn-sm btn-secondary">Edit</a>
                                    <form method="post" action="/admin/notices/delete/${notice.id}" style="display: inline;" 
                                          onsubmit="return confirm('Are you sure you want to delete this notice?')">
                                        <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                    </form>
                                </div>
                            </div>
                            
                            <div style="background: var(--light-gray); padding: 1rem; border-radius: 5px;">
                                <p style="margin: 0; white-space: pre-wrap;">${notice.content}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty notices}">
            <%@ page import="com.example.demo.entity.Notice" %>
            <%@ page import="java.time.LocalDate" %>
            <%@ page import="java.util.List" %>
            <%
                int totalNotices = 0;
                int activeNotices = 0;
                int inactiveNotices = 0;
                LocalDate latestDate = null;
                
                List<Notice> noticesList = (List<Notice>) request.getAttribute("notices");
                if (noticesList != null) {
                    totalNotices = noticesList.size();
                    for (Notice notice : noticesList) {
                        if (notice.getIsActive()) {
                            activeNotices++;
                        } else {
                            inactiveNotices++;
                        }
                        LocalDate date = notice.getCreatedAt().toLocalDate();
                        if (latestDate == null || date.isAfter(latestDate)) {
                            latestDate = date;
                        }
                    }
                }
            %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Notice Statistics</h2>
                </div>
                <div class="dashboard-grid">
                    <div class="stat-card">
                        <div class="stat-number"><%= totalNotices %></div>
                        <div class="stat-label">Total Notices</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= activeNotices %></div>
                        <div class="stat-label">Active Notices</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= inactiveNotices %></div>
                        <div class="stat-label">Inactive Notices</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= (latestDate != null) ? latestDate.toString() : "N/A" %></div>
                        <div class="stat-label">Latest Notice</div>
                    </div>
                </div>
            </div>
        </c:if>
    </main>
</body>
</html>

