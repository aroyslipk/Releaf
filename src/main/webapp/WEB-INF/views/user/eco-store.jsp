<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eco Store - ReLeaf</title>
    <link rel="stylesheet" href="<c:url value='/css/modern-admin.css'/>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .eco-store-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 60vh;
            text-align: center;
            padding: 2rem;
        }

        .eco-store-icon {
            font-size: 5rem;
            color: #2D7A48;
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-12px); }
        }

        .eco-store-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.75rem;
        }

        .eco-store-subtitle {
            font-family: 'Poppins', sans-serif;
            font-size: 1.1rem;
            font-weight: 400;
            color: #6b7280;
            margin-bottom: 2rem;
            max-width: 500px;
            line-height: 1.6;
        }

        .eco-store-badge {
            display: inline-block;
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            font-size: 1.3rem;
            font-weight: 600;
            padding: 14px 36px;
            border-radius: 999px;
            box-shadow: 0 6px 20px rgba(45, 122, 72, 0.3);
            letter-spacing: 0.5px;
        }

        .eco-store-features {
            display: flex;
            gap: 2rem;
            margin-top: 3rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .feature-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: transform 0.3s, box-shadow 0.3s;
            min-width: 160px;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }

        .feature-card i {
            font-size: 2rem;
            color: #2D7A48;
            margin-bottom: 0.75rem;
            display: block;
        }

        .feature-card span {
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 500;
            color: #374151;
        }

        @media (max-width: 768px) {
            .eco-store-title {
                font-size: 1.8rem;
            }
            .eco-store-badge {
                font-size: 1.1rem;
                padding: 12px 28px;
            }
            .eco-store-features {
                gap: 1rem;
            }
            .feature-card {
                min-width: 130px;
                padding: 1rem 1.25rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <div class="eco-store-container">
            <div class="eco-store-icon">
                <i class="fas fa-store-alt"></i>
            </div>
            <h1 class="eco-store-title">Eco Store</h1>
            <p class="eco-store-subtitle">
                An eco-friendly marketplace is on its way! Soon you'll be able to redeem your XP for sustainable products and green rewards.
            </p>
            <div class="eco-store-badge">
                Coming Soon
            </div>

            <div class="eco-store-features">
                <div class="feature-card">
                    <i class="fas fa-seedling"></i>
                    <span>Eco Products</span>
                </div>
                <div class="feature-card">
                    <i class="fas fa-coins"></i>
                    <span>XP Redemption</span>
                </div>
                <div class="feature-card">
                    <i class="fas fa-gift"></i>
                    <span>Green Rewards</span>
                </div>
            </div>
        </div>
    </main>
</body>
</html>