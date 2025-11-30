<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Releaf</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow-x: hidden;
            overflow-y: auto;
            padding: 2rem 1rem;
        }

        body::before {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.2), transparent);
            top: -200px;
            right: -200px;
            animation: pulse 8s ease-in-out infinite;
        }

        body::after {
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

        .login-container {
            background: white;
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            padding: 2.5rem;
            max-width: 450px;
            width: 100%;
            margin: auto;
            position: relative;
            z-index: 1;
        }

        .logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-text {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, #10b981, #059669);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .logo-subtitle {
            color: #6b7280;
            font-size: 1.1rem;
        }

        .tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            background: #f3f4f6;
            padding: 0.5rem;
            border-radius: 15px;
        }

        .tab {
            flex: 1;
            padding: 0.8rem;
            text-align: center;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            color: #6b7280;
            transition: all 0.3s;
        }

        .tab.active {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #374151;
        }

        .form-input {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        .form-input:focus {
            outline: none;
            border-color: #10b981;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #6b7280;
            cursor: pointer;
        }

        .checkbox-label input {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .forgot-link {
            color: #10b981;
            text-decoration: none;
            font-weight: 600;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }

        .btn-submit {
            width: 100%;
            padding: 1.1rem;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .footer-text {
            text-align: center;
            margin-top: 2rem;
            color: #6b7280;
        }

        .footer-text a {
            color: #10b981;
            text-decoration: none;
            font-weight: 600;
        }

        .footer-text a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .login-container {
                padding: 1.5rem;
                margin: 0;
                border-radius: 20px;
            }

            .logo-text {
                font-size: 2rem;
            }

            .form-group {
                margin-bottom: 1.2rem;
            }

            .form-input {
                padding: 0.9rem;
            }
        }

        @media (max-height: 700px) {
            body {
                padding: 1rem;
            }

            .login-container {
                padding: 1.5rem;
            }

            .logo {
                margin-bottom: 1.5rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <div class="logo-text">🌱 Releaf</div>
            <div class="logo-subtitle">Welcome back!</div>
        </div>

        <div class="tabs">
            <div class="tab ${loginType == 'admin' ? 'active' : ''}" onclick="switchTab('admin')">
                Admin
            </div>
            <div class="tab ${loginType != 'admin' ? 'active' : ''}" onclick="switchTab('user')">
                User
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="loginType" id="loginType" value="${loginType != null ? loginType : 'user'}">
            
            <div class="form-group">
                <label class="form-label" id="emailLabel">${loginType == 'admin' ? 'Username' : 'Email'}</label>
                <input type="text" name="email" class="form-input" 
                       placeholder="${loginType == 'admin' ? 'Enter your username' : 'Enter your email'}" required>
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-input" 
                       placeholder="Enter your password" required>
            </div>

            <div class="form-options">
                <label class="checkbox-label">
                    <input type="checkbox" name="remember">
                    <span>Remember me</span>
                </label>
                <a href="#" class="forgot-link" id="forgotLink" onclick="showForgotPassword(event)">Forgot password?</a>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <div class="footer-text" id="footerText">
            <c:if test="${loginType != 'admin'}">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign up</a>
            </c:if>
            <c:if test="${loginType == 'admin'}">
                Admin access only
            </c:if>
        </div>
    </div>

    <!-- Forgot Password Modal -->
    <div id="forgotModal" class="forgot-modal" style="display: none;">
        <div class="forgot-modal-content">
            <span class="close-modal" onclick="closeForgotModal()">&times;</span>
            <h2 style="color: #10b981; margin-bottom: 1rem;">🔑 Reset Password</h2>
            <p style="color: #6b7280; margin-bottom: 1.5rem;">Enter your email address and we'll send you a link to reset your password.</p>
            <form id="forgotForm" onsubmit="submitForgotPassword(event)">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" id="resetEmail" class="form-input" placeholder="Enter your registered email" required>
                </div>
                <button type="submit" class="btn-submit" id="resetBtn">Send Reset Link</button>
            </form>
            <div id="resetMessage" style="margin-top: 1rem; display: none;"></div>
        </div>
    </div>

    <style>
        .forgot-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .forgot-modal-content {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            max-width: 400px;
            width: 90%;
            position: relative;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
        }
        .close-modal {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6b7280;
        }
        .close-modal:hover {
            color: #374151;
        }
        .reset-success {
            background: #d1fae5;
            color: #065f46;
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
        }
        .reset-error {
            background: #fee2e2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
        }
    </style>

    <script>
        function switchTab(type) {
            document.getElementById('loginType').value = type;
            
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            const emailLabel = document.getElementById('emailLabel');
            const emailInput = document.querySelector('input[name="email"]');
            const footerText = document.getElementById('footerText');
            const forgotLink = document.getElementById('forgotLink');
            
            if (type === 'admin') {
                emailLabel.textContent = 'Username';
                emailInput.placeholder = 'Enter your username';
                footerText.innerHTML = 'Admin access only';
                forgotLink.style.display = 'none';
            } else {
                emailLabel.textContent = 'Email';
                emailInput.placeholder = 'Enter your email';
                footerText.innerHTML = 'Don\'t have an account? <a href="${pageContext.request.contextPath}/register">Sign up</a>';
                forgotLink.style.display = 'inline';
            }
        }

        function showForgotPassword(event) {
            event.preventDefault();
            const loginType = document.getElementById('loginType').value;
            if (loginType === 'admin') return;
            document.getElementById('forgotModal').style.display = 'flex';
        }

        function closeForgotModal() {
            document.getElementById('forgotModal').style.display = 'none';
            document.getElementById('resetMessage').style.display = 'none';
            document.getElementById('resetEmail').value = '';
        }

        function submitForgotPassword(event) {
            event.preventDefault();
            const email = document.getElementById('resetEmail').value;
            const btn = document.getElementById('resetBtn');
            const msgDiv = document.getElementById('resetMessage');
            
            console.log('Submitting forgot password for:', email);
            
            btn.disabled = true;
            btn.textContent = 'Sending...';
            
            fetch('${pageContext.request.contextPath}/forgot-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                msgDiv.style.display = 'block';
                if (data.success) {
                    msgDiv.className = 'reset-success';
                    msgDiv.innerHTML = '✅ ' + data.message;
                    document.getElementById('forgotForm').style.display = 'none';
                } else {
                    msgDiv.className = 'reset-error';
                    msgDiv.innerHTML = '❌ ' + data.message;
                    btn.disabled = false;
                    btn.textContent = 'Send Reset Link';
                }
            })
            .catch(err => {
                console.error('Fetch error:', err);
                msgDiv.style.display = 'block';
                msgDiv.className = 'reset-error';
                msgDiv.innerHTML = '❌ Something went wrong. Please try again.';
                btn.disabled = false;
                btn.textContent = 'Send Reset Link';
            });
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('forgotModal');
            if (event.target === modal) {
                closeForgotModal();
            }
        }

        // Initialize forgot link visibility based on current tab
        document.addEventListener('DOMContentLoaded', function() {
            const loginType = document.getElementById('loginType').value;
            const forgotLink = document.getElementById('forgotLink');
            if (loginType === 'admin') {
                forgotLink.style.display = 'none';
            }
        });
    </script>
</body>
</html>
