<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReLeaf - Gamify Your Green Life</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #2d3748;
        }

        /* Header */
        .header {
            background: #fff;
            padding: 1rem 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d7a48;
        }

        .logo img {
            width: 30px;
            height: 30px;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
            margin: 0;
            padding: 0;
        }

        .nav-menu a {
            color: #4a5568;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-menu a:hover {
            color: #2d7a48;
        }

        .header-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn-signin {
            background: #fff;
            color: #2d7a48;
            border: 1px solid #2d7a48;
            padding: 0.5rem 1.5rem;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-signin:hover {
            background: #2d7a48;
            color: #fff;
        }

        /* Hero Section */
        .hero {
            background: url('/images/background-landscape.jpg') no-repeat center center;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('/images/background-landscape.jpg') no-repeat center center;
            background-size: cover;
            filter: blur(8px);
            opacity: 0.7;
        }

        .hero-content {
            text-align: center;
            max-width: 600px;
            padding: 2rem;
            position: relative;
            z-index: 2;
        }

        .hero-logo {
            width: 80px;
            height: 80px;
            background: #fff;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .hero-logo img {
            width: 50px;
            height: 50px;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            color: #2d7a48;
            margin-bottom: 0.5rem;
        }

        .hero-subtitle {
            font-size: 1.5rem;
            color: #388e3c;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .hero-description {
            font-size: 1.1rem;
            color: #4a5568;
            margin-bottom: 2.5rem;
            line-height: 1.7;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: #2d7a48;
            color: #fff;
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary:hover {
            background: #358856;
            transform: translateY(-2px);
        }

        /* Sections */
        .section {
            padding: 5rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d7a48;
            margin-bottom: 3rem;
        }

        /* How It Works */
        .how-it-works {
            background: #fff;
        }

        .steps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .step-card {
            background: #fff;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .step-card:hover {
            transform: translateY(-5px);
        }

        .step-icon {
            width: 60px;
            height: 60px;
            background: #e8f5e9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }

        .step-number {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2d7a48;
            margin-bottom: 0.5rem;
        }

        .step-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2d7a48;
            margin-bottom: 1rem;
        }

        .step-description {
            color: #4a5568;
            line-height: 1.6;
        }

        /* Features */
        .features {
            background: #f7fafc;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background: #fff;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: #e8f5e9;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }

        .feature-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2d7a48;
            margin-bottom: 1rem;
        }

        .feature-description {
            color: #4a5568;
            line-height: 1.6;
        }

        /* Join Section */
        .join-section {
            background: #2d7a48;
            color: #fff;
            text-align: center;
        }

        .join-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .join-description {
            font-size: 1.2rem;
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        .btn-join {
            background: #388e3c;
            color: #fff;
            padding: 1rem 2.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-join:hover {
            background: #4caf50;
            transform: translateY(-2px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.2rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-primary, .btn-join {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf">
                <span>Releaf</span>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="#how-it-works">How It Works</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="#join">Join Us</a></li>
                </ul>
            </nav>
            <div class="header-buttons">
                <a href="/login" class="btn-signin">Sign In</a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-logo">
                <img src="/images/logo.png" alt="ReLeaf">
            </div>
            <h1 class="hero-title">Releaf</h1>
            <h2 class="hero-subtitle">Gamify Your Green Life</h2>
            <p class="hero-description">
                Transform your daily routine into an exciting eco-adventure. Track sustainable habits, earn EcoPoints, unlock achievements, and join a community of environmental champions making a real difference for our planet.
            </p>
            <div class="hero-buttons">
                <a href="/login" class="btn-primary">
                    <span>►</span> Start Your Journey
                </a>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="section how-it-works">
        <h2 class="section-title">How It Works</h2>
        <div class="steps-grid">
            <div class="step-card">
                <div class="step-icon">👤</div>
                <div class="step-number">1. Sign Up</div>
                <div class="step-title">Create your eco-warrior profile</div>
                <div class="step-description">Create your eco-warrior profile and set your environmental goals</div>
            </div>
            <div class="step-card">
                <div class="step-icon">✅</div>
                <div class="step-number">2. Complete Tasks</div>
                <div class="step-title">Choose from daily eco-challenges</div>
                <div class="step-description">Choose from daily eco-challenges and build sustainable habits</div>
            </div>
            <div class="step-card">
                <div class="step-icon">🏆</div>
                <div class="step-number">3. Earn Rewards</div>
                <div class="step-title">Gain EcoPoints and unlock badges</div>
                <div class="step-description">Gain EcoPoints, unlock badges, and climb the leaderboard</div>
            </div>
            <div class="step-card">
                <div class="step-icon">🌍</div>
                <div class="step-number">4. Make Impact</div>
                <div class="step-title">Track your environmental impact</div>
                <div class="step-description">Track your environmental impact and inspire others</div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="section features">
        <h2 class="section-title">Features</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <div class="feature-title">EcoScore Tracking</div>
                <div class="feature-description">Monitor your environmental impact with our comprehensive scoring system</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📅</div>
                <div class="feature-title">Habit Tracker</div>
                <div class="feature-description">Build lasting eco-friendly habits with daily challenges and reminders</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🗺️</div>
                <div class="feature-title">Game Map</div>
                <div class="feature-description">Navigate your eco-journey through an interactive progress map</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">👥</div>
                <div class="feature-title">Community</div>
                <div class="feature-description">Connect with like-minded eco-warriors and share your achievements</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🏅</div>
                <div class="feature-title">Achievements</div>
                <div class="feature-description">Unlock badges and rewards as you complete environmental challenges</div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📱</div>
                <div class="feature-title">Mobile Ready</div>
                <div class="feature-description">Access your eco-journey anywhere with our responsive design</div>
            </div>
        </div>
    </section>

    <!-- Join Section -->
    <section id="join" class="section join-section">
        <h2 class="join-title">Join the Green Revolution</h2>
        <p class="join-description">
            Be part of a growing community of environmental champions making a real difference. Start your eco-journey today and help create a sustainable future for our planet.
        </p>
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-number">10K+</div>
                <div class="stat-label">ECO WARRIORS</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">50K+</div>
                <div class="stat-label">TASKS COMPLETED</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">1M+</div>
                <div class="stat-label">ECOPOINTS EARNED</div>
            </div>
        </div>
        <a href="/login" class="btn-join">
            <span>🌱</span> Join Now
        </a>
    </section>
</body>
</html>

