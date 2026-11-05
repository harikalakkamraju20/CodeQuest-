
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration | CodeQuest</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #090d20, #211344);
            color: white;
            padding: 25px;
        }

        .register-container {
            width: 100%;
            max-width: 440px;
            background: #171a35;
            padding: 35px;
            border-radius: 18px;
            border: 1px solid #7547d8;
            box-shadow: 0 0 30px rgba(133, 80, 255, 0.2);
        }

        .logo {
            text-align: center;
            color: #a78bfa;
            font-size: 30px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        h2 {
            text-align: center;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            color: #aaa8c5;
            margin-bottom: 25px;
            font-size: 14px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 13px;
            margin-bottom: 18px;
            background: #252847;
            border: 1px solid #45476a;
            border-radius: 8px;
            color: white;
            outline: none;
        }

        input:focus {
            border-color: #a78bfa;
        }

        button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(90deg, #7547d8, #a855f7);
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            opacity: 0.9;
        }

        .message {
            padding: 10px;
            margin-bottom: 18px;
            border-radius: 7px;
            background: #492b3d;
            color: #ffb4c4;
            font-size: 14px;
            text-align: center;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #aaa8c5;
            font-size: 14px;
        }

        .login-link a {
            color: #b69aff;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="register-container">

    <div class="logo">⚡ CodeQuest</div>

    <h2>Create Your Account</h2>

    <p class="subtitle">
        Start your programming adventure today!
    </p>

    <%
        String error = (String) request.getAttribute("error");

        if (error != null) {
    %>
        <div class="message">
            <%= error %>
        </div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/register"
          method="post">

        <label>Username</label>
        <input type="text"
               name="username"
               placeholder="Enter your username"
               required>

        <label>Email Address</label>
        <input type="email"
               name="email"
               placeholder="Enter your email"
               required>

        <label>Password</label>
        <input type="password"
               name="password"
               placeholder="Create a password"
               minlength="8"
               required>

        <label>Confirm Password</label>
        <input type="password"
               name="confirmPassword"
               placeholder="Confirm your password"
               minlength="8"
               required>

        <button type="submit">Create Account</button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="login.jsp">Login</a>
    </div>

</div>

</body>
</html>
