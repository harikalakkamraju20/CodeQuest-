
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    Integer awardedXP = (Integer) request.getAttribute("awardedXP");

    if (isCorrect == null || awardedXP == null) {
        response.sendRedirect(request.getContextPath() + "/missions");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CodeQuest | Mission Result</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: #0b1020;
    color: white;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
}

.result-card {
    width: 100%;
    max-width: 520px;
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 20px;
    padding: 45px 30px;
    text-align: center;
}

.result-icon {
    font-size: 75px;
    margin-bottom: 20px;
}

.result-card h1 {
    font-size: 30px;
    margin-bottom: 15px;
}

.success h1 {
    color: #4ade80;
}

.failure h1 {
    color: #fb7185;
}

.message {
    color: #b8c2dc;
    font-size: 16px;
    line-height: 1.7;
    margin-bottom: 25px;
}

.xp-box {
    background: #202d49;
    border-radius: 14px;
    padding: 22px;
    margin-bottom: 30px;
}

.xp-box p {
    color: #9ca9c7;
    margin-bottom: 10px;
}

.xp-box h2 {
    font-size: 32px;
    color: #facc15;
}

.buttons {
    display: flex;
    justify-content: center;
    gap: 12px;
    flex-wrap: wrap;
}

.buttons a {
    display: inline-block;
    padding: 13px 20px;
    border-radius: 9px;
    text-decoration: none;
    font-weight: bold;
}

.primary {
    background: #7653d6;
    color: white;
}

.secondary {
    background: #293755;
    color: white;
}

.primary:hover {
    background: #9275ec;
}

.secondary:hover {
    background: #3a4c70;
}

.footer {
    margin-top: 30px;
    color: #7785a5;
    font-size: 13px;
}

</style>
</head>

<body>

<div class="result-card <%= isCorrect ? "success" : "failure" %>">

    <% if (isCorrect) { %>

        <div class="result-icon">🎉</div>

        <h1>Excellent Work!</h1>

        <p class="message">
            Congratulations! You selected the correct answer.
            Keep learning and complete more coding missions.
        </p>

    <% } else { %>

        <div class="result-icon">💪</div>

        <h1>Keep Practicing!</h1>

        <p class="message">
            Your answer was incorrect this time.
            Don't give up! Continue learning and improve
            your programming skills.
        </p>

    <% } %>

    <div class="xp-box">

        <p>XP Earned</p>

        <h2>+<%= awardedXP %> XP</h2>

    </div>

    <div class="buttons">

        <a class="primary"
           href="<%= request.getContextPath() %>/missions">
            Try More Missions
        </a>

        <a class="secondary"
           href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

    </div>

    <div class="footer">
        ⚡ CodeQuest – Learn, Practice and Level Up!
    </div>

</div>

</body>
</html>
