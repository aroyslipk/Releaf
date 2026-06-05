<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Account - ReLeaf</title>
    <link rel="stylesheet" href="<c:url value='/css/modern-admin.css'/>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .delete-account-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 60vh;
            text-align: center;
            padding: 2rem;
        }

        .delete-card {
            background: #fff;
            border: 2px solid #dc3545;
            border-radius: 16px;
            max-width: 600px;
            width: 100%;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(220, 53, 69, 0.15);
        }

        .delete-card-header {
            background: #dc3545;
            color: #fff;
            padding: 1.5rem 2rem;
            text-align: center;
        }

        .delete-card-header h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .delete-card-body {
            padding: 2rem;
        }

        .delete-warning-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .delete-warning-title {
            font-family: 'Poppins', sans-serif;
            font-size: 1.2rem;
            font-weight: 600;
            color: #dc3545;
            margin-bottom: 1rem;
        }

        .delete-warning-text {
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #6b7280;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .delete-what-gets-deleted {
            background: #fff8f0;
            border: 1px solid #ffe0a0;
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .delete-what-gets-deleted h4 {
            color: #856404;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            margin: 0 0 0.75rem 0;
        }

        .delete-what-gets-deleted ul {
            color: #856404;
            margin: 0;
            padding-left: 1.5rem;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            line-height: 1.8;
        }

        .delete-form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .delete-form-group label {
            display: block;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .delete-form-group input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #1f2937;
            background: #f9fafb;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .delete-form-group input[type="password"]:focus {
            outline: none;
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.15);
        }

        .delete-form-group .hint-text {
            display: block;
            font-size: 0.8rem;
            color: #9ca3af;
            margin-top: 0.4rem;
        }

        .delete-checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 0.6rem;
            margin-bottom: 2rem;
            cursor: pointer;
        }

        .delete-checkbox-group input[type="checkbox"] {
            margin-top: 0.15rem;
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #dc3545;
        }

        .delete-checkbox-group span {
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            color: #374151;
            line-height: 1.4;
            text-align: left;
        }

        .delete-btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn-cancel {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
            padding: 12px 28px;
            border-radius: 999px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #d1d5db;
            cursor: pointer;
            transition: all 0.3s;
            min-width: 120px;
        }

        .btn-cancel:hover {
            background: #e5e7eb;
            color: #1f2937;
        }

        .btn-delete {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
            padding: 12px 28px;
            border-radius: 999px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            background: #dc3545;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            min-width: 140px;
        }

        .btn-delete:hover {
            background: #c82333;
            box-shadow: 0 4px 16px rgba(220, 53, 69, 0.4);
            transform: translateY(-1px);
        }

        .btn-delete:disabled {
            background: #e5a0a8;
            cursor: not-allowed;
            box-shadow: none;
            transform: none;
        }

        .alert {
            border-radius: 10px;
            padding: 14px 18px;
            margin-bottom: 1.5rem;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            color: #2D7A48;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            margin-top: 1.5rem;
            transition: color 0.3s;
        }

        .back-link:hover {
            color: #1a5c32;
        }

        @media (max-width: 768px) {
            .delete-account-container {
                padding: 1rem;
            }
            .delete-card-header h2 {
                font-size: 1.25rem;
            }
            .delete-card-body {
                padding: 1.5rem 1rem;
            }
            .delete-btn-group {
                flex-direction: column;
            }
            .btn-cancel, .btn-delete {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../common/user-header.jsp" %>

    <main class="main-content">
        <div class="delete-account-container">
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <c:if test="${not empty user}">
                <div class="delete-card">
                    <div class="delete-card-header">
                        <h2>
                            <i class="fas fa-exclamation-triangle"></i>
                            Permanent Account Deletion
                        </h2>
                    </div>
                    <div class="delete-card-body">
                        <div class="delete-warning-icon">🗑️</div>
                        <div class="delete-warning-title">This action cannot be undone</div>
                        <p class="delete-warning-text">
                            You are about to permanently delete your ReLeaf account. This will remove all your data including:
                        </p>

                        <div class="delete-what-gets-deleted">
                            <h4><i class="fas fa-list-ul"></i> What will be deleted:</h4>
                            <ul>
                                <li>Your profile and personal information</li>
                                <li>All completed tasks and achievements</li>
                                <li>Your XP points and rewards</li>
                                <li>Group membership and messages</li>
                                <li>Profile picture and uploaded files</li>
                                <li>All account activity history</li>
                            </ul>
                        </div>

                        <form method="post" action="/user/delete-account" id="deleteAccountForm" onsubmit="return confirmFinalDeletion()">
                            <div class="delete-form-group">
                                <label for="password">
                                    <i class="fas fa-lock"></i> Enter your password to confirm
                                </label>
                                <input type="password" id="password" name="password" class="form-input" required 
                                       placeholder="Your current password" autocomplete="current-password">
                                <span class="hint-text">This is required to verify that you are the account owner.</span>
                            </div>

                            <label class="delete-checkbox-group">
                                <input type="checkbox" id="confirmDelete" required>
                                <span>
                                    I understand that this action is <strong>permanent and cannot be undone</strong>. 
                                    I have backed up any important information I want to keep.
                                </span>
                            </label>

                            <div class="delete-btn-group">
                                <a href="/user/profile" class="btn-cancel">
                                    <i class="fas fa-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn-delete" id="deleteBtn">
                                    <i class="fas fa-trash-alt"></i> Delete Account
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <a href="/user/profile" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Profile
                </a>
            </c:if>

            <c:if test="${empty user}">
                <div style="text-align: center; padding: 3rem;">
                    <h2 style="font-family: 'Poppins', sans-serif; color: #374151;">User information not found</h2>
                    <p style="font-family: 'Poppins', sans-serif; color: #6b7280;">
                        Please <a href="/login" style="color: #2D7A48;">log in again</a>.
                    </p>
                </div>
            </c:if>
        </div>
    </main>

    <script>
        function confirmFinalDeletion() {
            var password = document.getElementById('password').value;
            var confirmCheckbox = document.getElementById('confirmDelete').checked;
            
            if (!password.trim()) {
                alert('Please enter your password to confirm account deletion.');
                return false;
            }
            
            if (!confirmCheckbox) {
                alert('Please check the confirmation box to proceed.');
                return false;
            }
            
            return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.');
        }

        // Disable submit button if checkbox is not checked (visual feedback)
        (function() {
            var confirmCheckbox = document.getElementById('confirmDelete');
            var deleteBtn = document.getElementById('deleteBtn');
            
            function updateBtnState() {
                if (confirmCheckbox.checked) {
                    deleteBtn.disabled = false;
                    deleteBtn.style.opacity = '1';
                } else {
                    deleteBtn.disabled = true;
                    deleteBtn.style.opacity = '0.6';
                }
            }
            
            confirmCheckbox.addEventListener('change', updateBtnState);
            // Initial state
            updateBtnState();
        })();
    </script>
</body>
</html>