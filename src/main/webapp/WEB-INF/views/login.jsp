<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body {
            background: url('/images/background-landscape.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
        }
        .login-main {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        .login-main::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('/images/background-landscape.jpg') no-repeat center center fixed;
            background-size: cover;
            filter: blur(8px);
            opacity: 0.7;
        }
        .login-card-modern {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px 0 rgba(46, 82, 61, 0.15);
            padding: 3rem 2.5rem;
            max-width: 400px;
            width: 100%;
            text-align: center;
            position: relative;
            z-index: 2;
        }
        .login-logo-modern img {
            height: 80px;
            margin-bottom: 1.5rem;
        }
        .login-title-modern {
            font-size: 2rem;
            font-weight: 700;
            color: #2d7a48;
            margin-bottom: 0.5rem;
        }
        .login-subtitle-modern {
            color: #388e3c;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }
        .login-tabs {
            display: flex;
            margin-bottom: 2rem;
            border-radius: 5px;
            overflow: hidden;
        }
        .login-tab {
            flex: 1;
            padding: 0.75rem;
            background-color: #e8f5e9;
            color: #2d7a48;
            text-align: center;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .login-tab.active {
            background-color: #2d7a48;
            color: #fff;
        }
        .login-form-modern {
            margin-top: 1.5rem;
        }
        .login-form-modern .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }
        .login-form-modern .form-label {
            color: #2d7a48;
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: block;
        }
        .login-form-modern .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1.5px solid #b2dfdb;
            border-radius: 8px;
            font-size: 1rem;
            margin-top: 0.25rem;
        }
        .login-form-modern .btn-primary {
            width: 100%;
            background: #2d7a48;
            color: #fff;
            padding: 0.9rem;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            border: none;
            margin-top: 0.5rem;
            transition: background 0.2s;
        }
        .login-form-modern .btn-primary:hover {
            background: #358856;
        }
        .login-footer-modern {
            margin-top: 2rem;
            color: #4a5568;
        }
        .login-footer-modern a {
            color: #2d7a48;
            text-decoration: none;
            font-weight: 500;
        }
        .login-footer-modern a:hover {
            text-decoration: underline;
        }
        @media (max-width: 600px) {
            .login-card-modern {
                padding: 2rem 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-main">
        <div class="login-card-modern">
            <div class="login-logo-modern">
                <img src="/images/logo.png" alt="ReLeaf Logo">
            </div>
            <div class="login-title-modern">Welcome Back</div>
            <div class="login-subtitle-modern">Sign in to your ReLeaf account</div>
            <div class="login-tabs">
                <div class="login-tab ${loginType == 'admin' ? 'active' : ''}" onclick="switchTab('admin')">Admin Login</div>
                <div class="login-tab ${loginType != 'admin' ? 'active' : ''}" onclick="switchTab('user')">User Login</div>
            </div>
            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin-bottom: 1rem;">${error}</div>
            </c:if>
            <form action="/login" method="post" class="login-form-modern">
                <input type="hidden" name="loginType" id="loginType" value="${loginType != null ? loginType : 'user'}">
                <div class="form-group">
                    <label for="email" class="form-label"><span id="emailLabel">${loginType == 'admin' ? 'Username' : 'Email'}</span></label>
                    <input type="text" id="email" name="email" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            <div class="login-footer-modern" id="loginFooter">
                <c:if test="${loginType != 'admin'}">
                    <p>Don't have an account? <a href="/register">Register here</a></p>
                </c:if>
                <c:if test="${loginType == 'admin'}">
                    <p>Manually provisioned</p>
                </c:if>
            </div>
        </div>
    </div>
    <script>
        function switchTab(type) {
            document.getElementById('loginType').value = type;
            // Update active tab
            const tabs = document.querySelectorAll('.login-tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            // Update email label
            const emailLabel = document.getElementById('emailLabel');
            emailLabel.textContent = type === 'admin' ? 'Username' : 'Email';
            // Update footer
            const footer = document.getElementById('loginFooter');
            if (type === 'admin') {
                footer.innerHTML = '<p>Manually provisioned</p>';
            } else {
                footer.innerHTML = '<p>Don\'t have an account? <a href="/register">Register here</a></p>';
            }
        }
    </script>
</body>
</html>

