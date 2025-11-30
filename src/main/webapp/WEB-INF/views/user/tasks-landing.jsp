<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tasks - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .tasks-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            width: 100%;
        }

        .task-card {
            background: linear-gradient(135deg, #2d5a27 0%, #4a7c59 50%, #6b8e6b 100%);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .task-card.funlab {
            background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 50%, #a569bd 100%);
        }

        .task-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 60px rgba(0,0,0,0.15);
        }

        .task-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .task-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .task-subtitle {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
            opacity: 0.9;
        }

        .task-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-item {
            background: rgba(255,255,255,0.15);
            padding: 1rem;
            border-radius: 12px;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .stat-label {
            font-size: 0.9rem;
            margin-top: 0.25rem;
            opacity: 0.8;
        }

        .enter-button {
            background: white;
            color: #2d5a27;
            border: none;
            padding: 1rem 2rem;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .task-card.funlab .enter-button {
            color: #8e44ad;
        }

        .enter-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        @media (max-width: 768px) {
            .cards-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .task-card {
                padding: 2rem;
                margin: 1rem;
            }
            
            .task-title {
                font-size: 2rem;
            }
            
            .task-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/user-header.jsp" %>

    <main class="main-content">
        
        <div class="tasks-container">
            <div class="cards-grid">
                <!-- Greenverse Card -->
                <div class="task-card" onclick="window.location.href='/user/greenverse?view=tasks'">
                    <div class="task-icon">🌱</div>
                    <h1 class="task-title">Greenverse</h1>
                    <p class="task-subtitle">
                        Embark on your sustainability journey through 8 progressive topics. 
                        Complete tasks, earn XP, and make a real impact on our planet.
                    </p>
                    
                    <div class="task-stats">
                        <div class="stat-item">
                            <span class="stat-number">${completedTasksCount}</span>
                            <span class="stat-label">Tasks Completed</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">8</span>
                            <span class="stat-label">Topics Available</span>
                        </div>
                    </div>
                    
                    <div class="enter-button">
                        Enter Greenverse →
                    </div>
                </div>

                <!-- FunLab Card -->
                <div class="task-card funlab" onclick="window.location.href='/user/funlab'">
                    <div class="task-icon">🧪</div>
                    <h1 class="task-title">Releaf FunLab</h1>
                    <p class="task-subtitle">
                        Explore Weekly fun and creative eco-tasks! All tasks are unlocked from the start. 
                        Submit photos, audio, or text to earn XP and have fun while helping the planet.
                    </p>
                    
                    <div class="task-stats">
                        <div class="stat-item">
                            <span class="stat-number">Weekly</span>
                            <span class="stat-label">Fun Tasks</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">20</span>
                            <span class="stat-label">XP per Task</span>
                        </div>
                    </div>
                    
                    <div class="enter-button">
                        Enter FunLab →
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.task-card');
            
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px) scale(1.02)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });
        });
    </script>
</body>
</html>