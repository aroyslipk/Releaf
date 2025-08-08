<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background: var(--bg-gradient);
            color: var(--text-color);
        }

        h1 {
            color: #e74c3c;
            margin-bottom: 20px;
        }

        .error-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }

        .error-message {
            font-size: 18px;
            color: #2c3e50;
            margin: 20px 0;
        }

        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--primary-green);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }

        .back-link:hover {
            background-color: var(--secondary-green);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Oops! Something went wrong</h1>
        <div class="error-message">
            ${error}
            <c:if test="${empty error}">
                An unexpected error occurred. Please try again later.
            </c:if>
        </div>
        <a href="/" class="back-link">Go Home</a>
    </div>
</body>
</html>
