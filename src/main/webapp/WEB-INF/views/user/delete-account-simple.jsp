<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Account - ReLeaf</title>
</head>
<body>
    <h1>Delete Account</h1>
    
    <c:if test="${not empty error}">
        <div style="color: red;">
            ${error}
        </div>
    </c:if>
    
    <c:if test="${not empty user}">
        <p>Welcome, ${user.name}</p>
        <p>XP Points: ${user.xpPoints != null ? user.xpPoints : 0}</p>
        
        <form method="post" action="/user/delete-account">
            <div>
                <label for="password">Enter your password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div>
                <input type="checkbox" id="confirmDelete" required>
                <label for="confirmDelete">I understand this action cannot be undone</label>
            </div>
            <button type="submit">Delete Account</button>
        </form>
    </c:if>
    
    <c:if test="${empty user}">
        <p>User not found. Please <a href="/login">log in</a>.</p>
    </c:if>
</body>
</html> 