<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Goodbye - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .goodbye-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
        }
        
        .goodbye-card {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            animation: fadeInUp 0.8s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .goodbye-icon {
            font-size: 5rem;
            margin-bottom: 2rem;
            animation: wave 2s infinite;
        }
        
        @keyframes wave {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(10deg); }
            75% { transform: rotate(-10deg); }
        }
        
        .goodbye-title {
            color: var(--dark-green);
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 300;
        }
        
        .goodbye-message {
            color: var(--gray);
            font-size: 1.2rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }
        
        .goodbye-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-home {
            background: var(--primary-green);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 2px solid var(--primary-green);
        }
        
        .btn-home:hover {
            background: white;
            color: var(--primary-green);
            transform: translateY(-2px);
        }
        
        .btn-register {
            background: transparent;
            color: var(--primary-green);
            padding: 0.75rem 2rem;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 2px solid var(--primary-green);
        }
        
        .btn-register:hover {
            background: var(--primary-green);
            color: white;
            transform: translateY(-2px);
        }
        
        .eco-stats {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin: 2rem 0;
            border-left: 4px solid var(--primary-green);
        }
        
        .eco-stats h3 {
            color: var(--dark-green);
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }
        
        .eco-stats p {
            color: var(--gray);
            margin: 0.5rem 0;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <div class="goodbye-container">
        <div class="goodbye-card">
            <div class="goodbye-icon">🌱</div>
            
            <h1 class="goodbye-title">We're sad to see you go</h1>
            
            <p class="goodbye-message">
                Thank you for being part of ReLeaf. The planet appreciated your efforts, and so did we! 
                Every small action you took made a difference in our collective journey toward a greener future.
            </p>
            
            <div class="eco-stats">
                <h3>🌍 Your Environmental Impact</h3>
                <p>Remember that every eco-friendly choice you made, no matter how small, contributed to:</p>
                <p>• Reducing carbon footprint</p>
                <p>• Promoting sustainable practices</p>
                <p>• Inspiring others to take action</p>
                <p>• Building a community of environmental stewards</p>
            </div>
            
            <p class="goodbye-message">
                Your account has been permanently deleted. If you ever want to rejoin our community 
                and continue making a positive impact on the environment, you're always welcome back!
            </p>
            
            <div class="goodbye-actions">
                <a href="/" class="btn-home">Return to Home</a>
                <a href="/register" class="btn-register">Create New Account</a>
            </div>
        </div>
    </div>
</body>
</html> 