
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeQuest | Admin Login</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg, #0b1020, #21143d);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: white;
    padding: 20px;
}

.login-card {
    width: 100%;
    max-width: 430px;
    background: #151f37;
    border: 1px solid #39466b;
    border-radius: 20px;
    padding: 40px 30px;
    box-shadow: 0 15px 45px rgba(0,0,0,0.4);
}

.logo {
    text-align: center;
    font-size: 30px;
    font-weight: bold;
    color: #a78bfa;
    margin-bottom: 12px;
}

.icon {
    text-align: center;
    font-size: 48px;
    margin-bottom: 15px;
}

h2 {
    text-align: center;
    margin-bottom: 10px;
}

.subtitle {
    text-align: center;
    color: #aab6d1;
    margin-bottom: 30px;
}

label {
    display: block;
    margin-bottom: 9px;
    color: #dce4f5;
}

input {
    width: 100%;
    padding: 14px;
    margin-bottom: 22px;
    border-radius: 9px;
    border: 1px solid #39466b;
    background: #0b1429;
    color: white;
    font-size: 15px;
    outline: none;
}

input:focus {
    border-color: #a78bfa;
}

button {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, #7c3aed, #a855f7);
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    opacity: 0.9;
}

.error {
    background: #542333;
    color: #ffb4c2;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
    text-align: center;
}

.back {
    display: block;
    text-align: center;
    color: #a78bfa;
    text-decoration: none;
    margin-top: 25px;
}

.back:hover {
    color: white;
}
</style>
</head>

<body>

<div class="login-card">

    <div class="logo">⚡ CodeQuest</div>

    <div class="icon">🛡️</div>

    <h2>Admin Login</h2>

    <p class="subtitle">Sign in to manage CodeQuest</p>

    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin-login"
          method="post">

        <label>Admin Username</label>

        <input type="text"
               name="username"
               placeholder="Enter admin username"
               required>

        <label>Password</label>

        <input type="password"
               name="password"
               placeholder="Enter admin password"
               required>

        <button type="submit">Login as Admin →</button>

    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/login.jsp">
       ← Back to Student Login
    </a>

</div>

</body>
</html>
