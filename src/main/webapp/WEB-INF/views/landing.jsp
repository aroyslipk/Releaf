<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🌱 Releaf - Turn Green Habits Into Rewards</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #ffffff;
            color: #1a1a1a;
            overflow-x: hidden;
        }

        /* Navigation */
        nav {
            position: fixed;
            top: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            z-index: 1000;
            box-shadow: 0 2px 20px rgba(0,0,0,0.05);
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .logo {
            font-size: 1.6rem;
            font-weight: 900;
            background: linear-gradient(135deg, #10b981, #059669);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: #374151;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: #10b981;
        }

        /* Mobile hamburger button */
        .hamburger-btn {
            display: none;
            background: none;
            border: none;
            font-size: 1.8rem;
            cursor: pointer;
            color: #374151;
            padding: 4px;
            line-height: 1;
            z-index: 1001;
        }

        .cta-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.8rem 1.8rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
            transition: all 0.3s;
            white-space: nowrap;
        }

        .cta-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(16, 185, 129, 0.5);
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            position: relative;
            padding-top: 100px;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.2), transparent);
            top: -200px;
            right: -200px;
            animation: pulse 8s ease-in-out infinite;
        }

        .hero::after {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(5, 150, 105, 0.15), transparent);
            bottom: -150px;
            left: -150px;
            animation: pulse 10s ease-in-out infinite reverse;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.2); opacity: 0.8; }
        }

        .hero-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 3rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 5rem;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .hero-text h1 {
            font-size: 4.5rem;
            font-weight: 900;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            color: #047857;
        }

        .hero-text h1 .highlight {
            background: linear-gradient(135deg, #10b981, #059669);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-text p {
            font-size: 1.3rem;
            color: #4b5563;
            margin-bottom: 2.5rem;
            line-height: 1.7;
        }

        .hero-buttons {
            display: flex;
            gap: 1.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 1.2rem 3rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.7rem;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(16, 185, 129, 0.5);
        }

        .btn-secondary {
            background: white;
            color: #059669;
            padding: 1.2rem 3rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            border: 2px solid #10b981;
            transition: all 0.3s;
        }

        .btn-secondary:hover {
            background: #f0fdf4;
            transform: translateY(-3px);
        }

        .hero-visual {
            position: relative;
        }

        .hero-card {
            background: white;
            border-radius: 30px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            text-align: center;
        }

        .hero-card-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
        }

        .hero-card h3 {
            font-size: 2rem;
            color: #047857;
            margin-bottom: 1rem;
        }

        .hero-card p {
            color: #6b7280;
            font-size: 1.1rem;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 2rem;
        }

        .stat-box {
            background: linear-gradient(135deg, #10b981, #059669);
            padding: 1.5rem;
            border-radius: 20px;
            color: white;
            text-align: center;
        }

        .stat-box h4 {
            font-size: 2.5rem;
            font-weight: 900;
            margin-bottom: 0.3rem;
        }

        .stat-box p {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        /* Features Section */
        .features {
            padding: 8rem 3rem;
            background: white;
        }

        .features-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 5rem;
        }

        .section-header h2 {
            font-size: 3.5rem;
            font-weight: 900;
            color: #047857;
            margin-bottom: 1rem;
        }

        .section-header p {
            font-size: 1.3rem;
            color: #6b7280;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 3rem;
        }

        .feature-box {
            background: linear-gradient(135deg, #f0fdf4, #ecfdf5);
            padding: 3rem;
            border-radius: 25px;
            transition: all 0.4s;
            border: 2px solid transparent;
        }

        .feature-box:hover {
            transform: translateY(-10px);
            border-color: #10b981;
            box-shadow: 0 20px 50px rgba(16, 185, 129, 0.2);
        }

        .feature-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
        }

        .feature-box h3 {
            font-size: 1.6rem;
            color: #047857;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .feature-box p {
            color: #6b7280;
            line-height: 1.7;
            font-size: 1.05rem;
        }

        /* How It Works */
        .how-it-works {
            padding: 8rem 3rem;
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
        }

        .steps-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .steps-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 2.5rem;
            margin-top: 4rem;
        }

        .step-box {
            background: white;
            padding: 2.5rem;
            border-radius: 25px;
            text-align: center;
            position: relative;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            transition: all 0.3s;
        }

        .step-box:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(16, 185, 129, 0.2);
        }

        .step-number {
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #10b981, #059669);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 900;
            font-size: 1.3rem;
        }

        .step-icon {
            font-size: 3.5rem;
            margin: 2rem 0 1.5rem;
        }

        .step-box h3 {
            font-size: 1.4rem;
            color: #047857;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .step-box p {
            color: #6b7280;
            line-height: 1.6;
        }

        /* CTA Section */
        .cta-section {
            padding: 8rem 3rem;
            background: linear-gradient(135deg, #047857, #10b981);
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .cta-section::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(255,255,255,0.1), transparent);
            top: -200px;
            right: -200px;
        }

        .cta-content {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .cta-content h2 {
            font-size: 3.5rem;
            font-weight: 900;
            margin-bottom: 1.5rem;
        }

        .cta-content p {
            font-size: 1.4rem;
            margin-bottom: 3rem;
            opacity: 0.95;
        }

        .cta-content .btn-primary {
            background: white;
            color: #047857;
            font-size: 1.2rem;
            padding: 1.3rem 3.5rem;
        }

        .cta-content .btn-primary:hover {
            background: #f0fdf4;
        }

        /* Footer */
        footer {
            background: #1f2937;
            color: #9ca3af;
            padding: 3rem 3rem 2rem;
            text-align: center;
        }

        footer p {
            font-size: 1rem;
        }

        /* ============================================
           FULL RESPONSIVE BREAKPOINTS
           ============================================ */

        @media (max-width: 1024px) {
            .nav-container {
                padding: 1rem 1.5rem;
            }
            .hero-content {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            .hero-text h1 {
                font-size: 3.2rem;
            }
            .hero-text p {
                font-size: 1.1rem;
            }
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .steps-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .features {
                padding: 4rem 2rem;
            }
            .how-it-works {
                padding: 4rem 2rem;
            }
            .cta-section {
                padding: 4rem 2rem;
            }
            .section-header h2 {
                font-size: 2.5rem;
            }
            .hero-content {
                padding: 0 1.5rem;
            }
            .hero {
                padding-top: 80px;
            }
            .hero-card {
                padding: 2rem;
            }
            .stats-row {
                gap: 1rem;
            }
        }

        @media (max-width: 768px) {
            /* Mobile nav */
            nav {
                padding: 0;
            }
            .nav-container {
                padding: 0.75rem 1rem;
            }
            .logo {
                font-size: 1.3rem;
            }
            .nav-links {
                display: none;
                position: fixed;
                top: 70px;
                left: 0;
                width: 100%;
                background: rgba(255, 255, 255, 0.99);
                flex-direction: column;
                padding: 1rem;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                gap: 0.5rem;
                z-index: 999;
            }
            .nav-links.open {
                display: flex;
            }
            .nav-links a {
                padding: 12px 16px;
                display: block;
                text-align: center;
                border-radius: 10px;
                font-size: 1rem;
            }
            .nav-links a:hover {
                background: #f0fdf4;
            }
            .nav-links .cta-mobile {
                background: linear-gradient(135deg, #10b981, #059669);
                color: white !important;
                border-radius: 50px;
                margin-top: 8px;
            }
            .hamburger-btn {
                display: block;
            }
            .desktop-cta {
                display: none;
            }
            /* Hero */
            .hero {
                min-height: auto;
                padding: 100px 1rem 4rem;
            }
            .hero-text h1 {
                font-size: 2.2rem;
                line-height: 1.2;
            }
            .hero-text p {
                font-size: 1rem;
                line-height: 1.5;
            }
            .hero-buttons {
                flex-direction: column;
                gap: 1rem;
            }
            .btn-primary,
            .btn-secondary {
                width: 100%;
                justify-content: center;
                padding: 1rem 2rem;
                font-size: 1rem;
            }
            .hero-content {
                padding: 0;
                gap: 2rem;
            }
            .hero-card {
                padding: 1.5rem;
                border-radius: 20px;
            }
            .hero-card-icon {
                font-size: 3rem;
                margin-bottom: 1rem;
            }
            .hero-card h3 {
                font-size: 1.4rem;
            }
            .hero-card p {
                font-size: 0.9rem;
            }
            .stat-box h4 {
                font-size: 1.8rem;
            }
            .stat-box p {
                font-size: 0.75rem;
            }
            .stat-box {
                padding: 1rem;
            }
            .stats-row {
                grid-template-columns: repeat(3, 1fr);
                gap: 0.75rem;
            }
            /* Features */
            .features {
                padding: 3rem 1rem;
            }
            .section-header {
                margin-bottom: 2rem;
            }
            .section-header h2 {
                font-size: 2rem;
            }
            .section-header p {
                font-size: 1rem;
            }
            .features-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .feature-box {
                padding: 1.5rem;
                border-radius: 16px;
            }
            .feature-icon {
                font-size: 2.5rem;
                margin-bottom: 0.75rem;
            }
            .feature-box h3 {
                font-size: 1.2rem;
            }
            .feature-box p {
                font-size: 0.9rem;
            }
            /* Steps */
            .how-it-works {
                padding: 3rem 1rem;
            }
            .steps-grid {
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
                margin-top: 2rem;
            }
            .step-box {
                padding: 1.5rem;
                border-radius: 16px;
            }
            .step-number {
                width: 36px;
                height: 36px;
                font-size: 1rem;
                top: -15px;
            }
            .step-icon {
                font-size: 2rem;
                margin: 1.5rem 0 1rem;
            }
            .step-box h3 {
                font-size: 1.1rem;
            }
            .step-box p {
                font-size: 0.85rem;
            }
            /* CTA */
            .cta-section {
                padding: 3rem 1rem;
            }
            .cta-content h2 {
                font-size: 2rem;
            }
            .cta-content p {
                font-size: 1rem;
                margin-bottom: 1.5rem;
            }
            .cta-content .btn-primary {
                font-size: 1rem;
                padding: 1rem 2rem;
            }
            /* Footer */
            footer {
                padding: 2rem 1rem;
            }
        }

        @media (max-width: 480px) {
            .hero-text h1 {
                font-size: 1.8rem;
            }
            .hero-text p {
                font-size: 0.9rem;
            }
            .hero {
                padding: 90px 0.75rem 3rem;
            }
            .hero-card {
                padding: 1.25rem;
            }
            .stats-row {
                grid-template-columns: repeat(3, 1fr);
                gap: 0.5rem;
            }
            .stat-box h4 {
                font-size: 1.5rem;
            }
            .stat-box p {
                font-size: 0.7rem;
            }
            .stat-box {
                padding: 0.75rem;
            }
            .section-header h2 {
                font-size: 1.6rem;
            }
            .section-header p {
                font-size: 0.85rem;
            }
            .steps-grid {
                grid-template-columns: 1fr;
                gap: 1.25rem;
            }
            .feature-box {
                padding: 1.25rem;
            }
            .cta-content h2 {
                font-size: 1.6rem;
            }
            .cta-content p {
                font-size: 0.9rem;
            }
            .btn-primary,
            .btn-secondary {
                padding: 0.9rem 1.5rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav>
        <div class="nav-container">
            <div class="logo">
                🌱 Releaf
            </div>
            <button class="hamburger-btn" id="hamburgerBtn" aria-label="Menu" aria-expanded="false">☰</button>
            <ul class="nav-links" id="mobileNavLinks">
                <li><a href="#features">Features</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#join">Join Now</a></li>
                <li><a href="${pageContext.request.contextPath}/login" class="cta-mobile">Get Started</a></li>
            </ul>
            <a href="${pageContext.request.contextPath}/login" class="cta-btn desktop-cta">Get Started</a>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-text">
                <h1>Turn Your <span class="highlight">Green Habits</span> Into Rewards</h1>
                <p>Join thousands of eco-warriors making real environmental impact. Complete challenges, earn points, unlock achievements, and help save the planet—one task at a time.</p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/register" class="btn-primary">
                        🚀 Start Your Journey
                    </a>
                    <a href="#how-it-works" class="btn-secondary">
                        Learn More
                    </a>
                </div>
            </div>
            <div class="hero-visual">
                <div class="hero-card">
                    <div class="hero-card-icon">🌍</div>
                    <h3>Make Real Impact</h3>
                    <p>Track your environmental footprint and see the difference you're making</p>
                    <div class="stats-row">
                        <div class="stat-box">
                            <h4>10K+</h4>
                            <p>Users</p>
                        </div>
                        <div class="stat-box">
                            <h4>50K+</h4>
                            <p>Tasks Done</p>
                        </div>
                        <div class="stat-box">
                            <h4>1M+</h4>
                            <p>Points Earned</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features">
        <div class="features-container">
            <div class="section-header">
                <h2>Powerful Features</h2>
                <p>Everything you need to build sustainable habits</p>
            </div>
            <div class="features-grid">
                <div class="feature-box">
                    <div class="feature-icon">📊</div>
                    <h3>Track Your Progress</h3>
                    <p>Monitor your eco-score, streaks, and environmental impact with detailed analytics and insights.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🎯</div>
                    <h3>Daily Challenges</h3>
                    <p>Complete fun eco-challenges tailored to your lifestyle and earn rewards for every achievement.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🏆</div>
                    <h3>Earn Badges</h3>
                    <p>Unlock exclusive badges and climb the leaderboard as you complete more environmental tasks.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">👥</div>
                    <h3>Join Community</h3>
                    <p>Connect with like-minded eco-warriors and share your journey towards sustainability.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🗺️</div>
                    <h3>Interactive Map</h3>
                    <p>Navigate through topics and unlock new challenges as you progress on your eco-journey.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">📱</div>
                    <h3>Mobile Friendly</h3>
                    <p>Access your eco-journey anytime, anywhere with our fully responsive design.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section id="how-it-works" class="how-it-works">
        <div class="steps-container">
            <div class="section-header">
                <h2>How It Works</h2>
                <p>Get started in 4 simple steps</p>
            </div>
            <div class="steps-grid">
                <div class="step-box">
                    <div class="step-number">1</div>
                    <div class="step-icon">✍️</div>
                    <h3>Sign Up</h3>
                    <p>Create your free account and set your environmental goals</p>
                </div>
                <div class="step-box">
                    <div class="step-number">2</div>
                    <div class="step-icon">✅</div>
                    <h3>Complete Tasks</h3>
                    <p>Choose from hundreds of eco-challenges and start making impact</p>
                </div>
                <div class="step-box">
                    <div class="step-number">3</div>
                    <div class="step-icon">⭐</div>
                    <h3>Earn Points</h3>
                    <p>Collect EcoPoints and unlock exclusive badges and rewards</p>
                </div>
                <div class="step-box">
                    <div class="step-number">4</div>
                    <div class="step-icon">🌟</div>
                    <h3>Level Up</h3>
                    <p>Track your progress and inspire others to join the movement</p>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section id="join" class="cta-section">
        <div class="cta-content">
            <h2>Ready to Make a Difference?</h2>
            <p>Join 10,000+ eco-warriors and start your journey towards a sustainable future today.</p>
            <a href="${pageContext.request.contextPath}/register" class="btn-primary">
                🌱 Join the Movement
            </a>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <p>© 2025 Releaf. Making the world greener, one task at a time. 🌍</p>
    </footer>

    <script>
        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });

        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const nav = document.querySelector('nav');
            if (window.scrollY > 50) {
                nav.style.boxShadow = '0 4px 30px rgba(0,0,0,0.1)';
            } else {
                nav.style.boxShadow = '0 2px 20px rgba(0,0,0,0.05)';
            }
        });

        // Mobile hamburger menu
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const mobileNavLinks = document.getElementById('mobileNavLinks');
        let menuOpen = false;

        hamburgerBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            menuOpen = !menuOpen;
            if (menuOpen) {
                mobileNavLinks.classList.add('open');
                hamburgerBtn.textContent = '✕';
                hamburgerBtn.setAttribute('aria-expanded', 'true');
                document.body.style.overflow = 'hidden';
            } else {
                mobileNavLinks.classList.remove('open');
                hamburgerBtn.textContent = '☰';
                hamburgerBtn.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
            }
        });

        // Close menu when a link is clicked
        mobileNavLinks.querySelectorAll('a').forEach(function(link) {
            link.addEventListener('click', function() {
                mobileNavLinks.classList.remove('open');
                hamburgerBtn.textContent = '☰';
                hamburgerBtn.setAttribute('aria-expanded', 'false');
                menuOpen = false;
                document.body.style.overflow = '';
            });
        });
    </script>
</body>
</html>
