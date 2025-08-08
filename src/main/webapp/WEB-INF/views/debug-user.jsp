<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debug User - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div style="padding: 2rem; max-width: 800px; margin: 0 auto;">
        <h1>Debug User Information</h1>
        
        <div style="background: #f8f9fa; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
            <h3>Session Information:</h3>
            <p><strong>User ID:</strong> ${userId}</p>
            <p><strong>User Name:</strong> ${userName}</p>
            <p><strong>User Email:</strong> ${userEmail}</p>
            <p><strong>XP Points:</strong> ${userXpPoints}</p>
            <p><strong>Profile Picture:</strong> ${userProfilePicture}</p>
        </div>
        
        <c:if test="${not empty error}">
            <div style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                <h3>Error:</h3>
                <p>${error}</p>
            </div>
        </c:if>
        
        <div style="margin-top: 2rem;">
            <a href="/user/profile" style="background: #007bff; color: white; padding: 0.5rem 1rem; text-decoration: none; border-radius: 3px;">Back to Profile</a>
            <a href="/user/delete-account" style="background: #dc3545; color: white; padding: 0.5rem 1rem; text-decoration: none; border-radius: 3px; margin-left: 1rem;">Try Delete Account</a>
        </div>
    </div>
</body>
</html> 