<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .dashboard {
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
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
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            padding: 1rem;
        }
        .header {
            background: var(--header-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.15);
            padding: 1rem;
            margin-bottom: 2rem;
            color: var(--white);
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        .logo {
            display: flex;
            align-items: center;
        }
        .logo h1 {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--white);
            letter-spacing: 0.5px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
            font-family: 'Segoe UI', sans-serif;
        }
        .logo img {
            height: 40px;
        }
        .nav-menu {
            display: flex;
            gap: 2rem;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .nav-menu a {
            text-decoration: none;
            color: var(--white);
            font-weight: 500;
            transition: background 0.2s;
        }
        .nav-menu a:hover {
            background: rgba(255,255,255,0.2);
            color: var(--white);
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .logout-btn {
            padding: 0.5rem 1rem;
            background: #f44336;
            color: white;
            border-radius: 4px;
            text-decoration: none;
        }
        .page-title {
            text-align: center;
            color: #358856;
            margin: 2rem 0;
            font-size: 2rem;
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
        <h1 class="page-title">Platform Statistics</h1>
        
        <div class="dashboard">
            <div class="stat-card">
                <div class="stat-label">Total Users</div>
                <div class="stat-number">${totalUsers}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Tasks</div>
                <div class="stat-number">${totalTasks}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Completed Tasks</div>
                <div class="stat-number">${completedTasks}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Active Tasks</div>
                <div class="stat-number">${activeTasks}</div>
            </div>
        </div>

        <!-- Environmental Impact -->
        <div style="max-width: 1200px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h2 style="color: #358856; margin-bottom: 2rem; text-align: center;">Environmental Impact</h2>
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 2rem;">
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🌱</div>
                    <h3 style="color: #358856; margin-bottom: 0.5rem;">Eco Actions</h3>
                    <p style="color: #666;">${completedTasks} tasks completed</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🌍</div>
                    <h3 style="color: #358856; margin-bottom: 0.5rem;">Global Impact</h3>
                    <p style="color: #666;">Making change worldwide</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">👥</div>
                    <h3 style="color: #358856; margin-bottom: 0.5rem;">Community</h3>
                    <p style="color: #666;">${totalUsers} eco-warriors</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">📈</div>
                    <h3 style="color: #358856; margin-bottom: 0.5rem;">Progress</h3>
                    <p style="color: #666;">Growing impact daily</p>
                </div>
            </div>
        </div>

        <!-- Export Section -->
        <div style="max-width: 1200px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h2 style="color: #358856; margin-bottom: 2rem; text-align: center;">Export Reports</h2>
            <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <a href="/admin/export/users" class="export-btn" style="background: #358856; color: white; padding: 0.75rem 1.5rem; border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem;">
                    <span style="font-size: 1.2rem;">📊</span> Export User Data
                </a>
                <a href="/admin/export/tasks" class="export-btn" style="background: #358856; color: white; padding: 0.75rem 1.5rem; border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem;">
                    <span style="font-size: 1.2rem;">📋</span> Export Task Data
                </a>
                <a href="/admin/export/groups" class="export-btn" style="background: #358856; color: white; padding: 0.75rem 1.5rem; border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem;">
                    <span style="font-size: 1.2rem;">👥</span> Export Group Data
                </a>
                <a href="/admin/export/summary" class="export-btn" style="background: #358856; color: white; padding: 0.75rem 1.5rem; border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem;">
                    <span style="font-size: 1.2rem;">📑</span> Export Summary Report
                </a>
            </div>
            <p style="color: #666; margin-top: 1rem; text-align: center; font-size: 0.9rem;">
                Export functionality will generate CSV files with the selected data for further analysis.
            </p>
        </div>
    </main>

    <script>
        // Helper function for file downloads
        async function downloadReport(url) {
            try {
                const response = await fetch(url);
                if (!response.ok) throw new Error('Export failed');
                
                const blob = await response.blob();
                const filename = response.headers.get('content-disposition')?.split('filename=')[1] || 'report.csv';
                
                const link = document.createElement('a');
                link.href = URL.createObjectURL(blob);
                link.download = filename;
                link.click();
                URL.revokeObjectURL(link.href);
            } catch (error) {
                alert('Failed to export data. Please try again.');
            }
        }

        // Add click handlers to export buttons
        document.querySelectorAll('.export-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                downloadReport(btn.href);
            });
        });
    </script>
</body>
</html>
