<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 1rem;
        }
        .error-message {
            color: #666;
            margin-bottom: 2rem;
        }
        .home-link {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        .home-link:hover {
            background-color: #388E3C;
        }
    </style>
</head>
<body class="bg-light">
    <div class="error-container">
        <div class="error-icon">❌</div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">
            ${error != null ? error : 'An unexpected error occurred. Please try again later.'}
        </p>
        <a href="/user/dashboard" class="home-link">Go Home</a>
    </div>
</body>
</html>
