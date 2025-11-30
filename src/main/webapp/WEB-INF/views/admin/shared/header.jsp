<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Admin Dashboard - ReLeaf</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/admin-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="wrapper">
    <!-- Sidebar -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <div class="releaf-brand">
                <img src="/images/releaf-logo.jpg" alt="Releaf Logo" class="releaf-logo">
                <div class="releaf-text">
                    <span class="releaf-title">Releaf</span>
                    <span class="releaf-subtitle">Admin Panel</span>
                </div>
            </div>
        </div>

        <ul class="list-unstyled components">
            <li>
                <a href="/admin/dashboard"><i class="bi bi-grid-fill"></i> Dashboard</a>
            </li>
            <li>
                <a href="/admin/tasks"><i class="bi bi-list-task"></i> Tasks</a>
            </li>
            <li>
                <a href="/admin/users"><i class="bi bi-people-fill"></i> Users</a>
            </li>
            <li>
                <a href="/admin/groups"><i class="bi bi-person-bounding-box"></i> Groups</a>
            </li>
            <li>
                <a href="/admin/notices"><i class="bi bi-exclamation-triangle-fill"></i> Notices</a>
            </li>
            <li>
                <a href="/admin/messages"><i class="bi bi-chat-dots-fill"></i> Messages</a>
            </li>
            <li>
                <a href="/admin/reports"><i class="bi bi-bar-chart-line-fill"></i> Reports</a>
            </li>
            <li>
                <a href="/admin/task-reviews"><i class="bi bi-check-circle-fill"></i> Task Reviews</a>
            </li>
        </ul>
    </nav>

    <!-- Page Content -->
    <div id="content">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="nav navbar-nav ms-auto admin-user-box">
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="#">Welcome, ${sessionScope.adminUsername}</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="/logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const sidebarLinks = document.querySelectorAll('#sidebar ul.components li a');

        sidebarLinks.forEach(link => {
            // Remove any existing active classes
            link.parentElement.classList.remove('active');

            // Check if the link's href matches the current path
            if (link.getAttribute('href') === currentPath) {
                link.parentElement.classList.add('active');
            }
        });
    });
</script>
</body>
</html>