<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Greenverse Task Management - ReLeaf Admin</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .greenverse-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        .greenverse-card {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #60a5fa 100%);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            max-width: 600px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .greenverse-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .greenverse-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 60px rgba(0,0,0,0.15);
        }

        .greenverse-card:hover .greenverse-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .greenverse-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            color: #ffffff;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .greenverse-title {
            font-size: 2.5rem;
            font-weight: bold;
            color: #ffffff;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .greenverse-subtitle {
            font-size: 1.2rem;
            color: #e0f2fe;
            margin-bottom: 2rem;
            position: relative;
            z-index: 1;
            line-height: 1.6;
        }

        .greenverse-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
            position: relative;
            z-index: 1;
        }

        .stat-item {
            background: rgba(255,255,255,0.15);
            padding: 1rem;
            border-radius: 12px;
            backdrop-filter: blur(10px);
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ffffff;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #e0f2fe;
            margin-top: 0.25rem;
        }

        .enter-button {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            color: #1e3a8a;
            border: none;
            padding: 1rem 2rem;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
            text-decoration: none;
            display: inline-block;
        }

        .enter-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            text-decoration: none;
            color: #1e3a8a;
        }

        .back-link {
            position: absolute;
            top: 2rem;
            left: 2rem;
            color: #6c757d;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #1e3a8a;
            text-decoration: none;
        }

        .admin-badge {
            background: rgba(255,255,255,0.2);
            color: #ffffff;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        @media (max-width: 768px) {
            .greenverse-card {
                padding: 2rem;
                margin: 1rem;
            }
            
            .greenverse-title {
                font-size: 2rem;
            }
            
            .greenverse-stats {
                grid-template-columns: 1fr;
            }
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
                    <li><a href="/admin/tasks" class="active">Tasks</a></li>
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
        <a href="/admin/dashboard" class="back-link">← Back to Dashboard</a>
        
        <div class="greenverse-container">
            <div class="greenverse-card" onclick="window.location.href='/admin/greenverse/tasks'">
                <div class="admin-badge">Admin Panel</div>
                <div class="greenverse-icon">⚙️</div>
                <h1 class="greenverse-title">Greenverse Task Management</h1>
                <p class="greenverse-subtitle">
                    Manage all sustainability tasks across 8 progressive topics. 
                    Create, edit, and monitor task completion for the entire community.
                </p>
                
                <div class="greenverse-stats">
                    <div class="stat-item">
                        <span class="stat-number">8</span>
                        <span class="stat-label">Topics</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">3</span>
                        <span class="stat-label">Difficulty Levels</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">∞</span>
                        <span class="stat-label">Possibilities</span>
                    </div>
                </div>
                
                <div class="enter-button">
                    Manage Tasks →
                </div>
            </div>
        </div>
    </main>

    <script>
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            const card = document.querySelector('.greenverse-card');
            
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html> 