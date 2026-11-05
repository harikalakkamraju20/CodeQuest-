
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) request.getAttribute("username");
    Integer xp = (Integer) request.getAttribute("xp");
    Integer level = (Integer) request.getAttribute("level");
    Integer completedMissions = (Integer) request.getAttribute("completedMissions");
    Integer progress = (Integer) request.getAttribute("progress");

    if (username == null) username = (String) session.getAttribute("username");
    if (xp == null) xp = 0;
    if (level == null) level = 1;
    if (completedMissions == null) completedMissions = 0;
    if (progress == null) progress = 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeQuest | Student Dashboard</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: #0b1020;
    color: #ffffff;
    min-height: 100vh;
}

.sidebar {
    width: 240px;
    height: 100vh;
    position: fixed;
    background: #121a30;
    padding: 30px 20px;
    border-right: 1px solid #283451;
}

.logo {
    font-size: 25px;
    font-weight: bold;
    color: #a78bfa;
    margin-bottom: 45px;
}

.sidebar a {
    display: block;
    text-decoration: none;
    color: #b8c2dc;
    padding: 15px;
    margin-bottom: 12px;
    border-radius: 10px;
    transition: 0.3s;
}

.sidebar a:hover,
.sidebar a.active {
    background: #28365c;
    color: #ffffff;
}

.main {
    margin-left: 240px;
    padding: 40px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 40px;
    gap: 15px;
}

.topbar h1 {
    font-size: 28px;
}

.topbar p {
    color: #9ca9c7;
    margin-top: 8px;
}

.level-badge {
    background: #30245a;
    color: #c4b5fd;
    padding: 12px 20px;
    border-radius: 25px;
    font-weight: bold;
}

.welcome {
    background: linear-gradient(120deg, #39236c, #174b65);
    padding: 35px;
    border-radius: 18px;
    margin-bottom: 30px;
}

.welcome h2 {
    font-size: 26px;
    margin-bottom: 12px;
}

.welcome p {
    color: #e0e7ff;
    line-height: 1.6;
}

.stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 30px;
}

.card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 15px;
    padding: 25px;
}

.card .label {
    color: #9ca9c7;
    font-size: 14px;
    margin-bottom: 15px;
}

.card h2 {
    font-size: 30px;
    color: #a78bfa;
}

.progress-card {
    margin-bottom: 30px;
}

.progress-card h3 {
    margin-bottom: 18px;
}

.progress-info {
    display: flex;
    justify-content: space-between;
    color: #b8c2dc;
    margin-bottom: 12px;
    font-size: 14px;
}

.progress-bar {
    background: #293755;
    height: 12px;
    border-radius: 20px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    width: <%= progress %>%;
    background: linear-gradient(90deg, #8b5cf6, #22d3ee);
    border-radius: 20px;
}

.actions {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.action-card h3 {
    margin-bottom: 12px;
}

.action-card p {
    color: #9ca9c7;
    line-height: 1.6;
    margin-bottom: 20px;
}

.action-card a {
    display: inline-block;
    text-decoration: none;
    background: #7653d6;
    color: white;
    padding: 11px 20px;
    border-radius: 8px;
}

.action-card a:hover {
    background: #9275ec;
}

@media (max-width: 800px) {
    .sidebar {
        position: relative;
        width: 100%;
        height: auto;
    }

    .logo {
        margin-bottom: 15px;
    }

    .sidebar a {
        display: inline-block;
        padding: 10px;
    }

    .main {
        margin-left: 0;
        padding: 20px;
    }

    .stats {
        grid-template-columns: 1fr;
    }

    .actions {
        grid-template-columns: 1fr;
    }

    .topbar {
        align-items: flex-start;
        flex-direction: column;
    }
}
</style>
</head>

<body>

<div class="sidebar">

    <div class="logo">⚡ CodeQuest</div>

    <a href="<%= request.getContextPath() %>/dashboard" class="active">
        🏠 Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/missions">
        🎯 Missions
    </a>

    <a href="<%= request.getContextPath() %>/leaderboard.jsp">
        🏆 Leaderboard
    </a>

    <a href="<%= request.getContextPath() %>/logout">
        🚪 Logout
    </a>

</div>

<div class="main">

    <div class="topbar">
        <div>
            <h1>Student Dashboard</h1>
            <p>Your coding journey starts here!</p>
        </div>

        <div class="level-badge">
            ⭐ Level <%= level %>
        </div>
    </div>

    <div class="welcome">
        <h2>Welcome back, <%= username %>! 👋</h2>
        <p>
            Keep learning, complete coding missions, earn XP
            and become a coding champion.
        </p>
    </div>

    <div class="stats">

        <div class="card">
            <div class="label">⭐ Total Experience Points</div>
            <h2><%= xp %> XP</h2>
        </div>

        <div class="card">
            <div class="label">🏆 Current Level</div>
            <h2><%= level %></h2>
        </div>

        <div class="card">
            <div class="label">🎯 Completed Missions</div>
            <h2><%= completedMissions %></h2>
        </div>

    </div>

    <div class="card progress-card">
        <h3>🚀 Your Level Progress</h3>

        <div class="progress-info">
            <span>Progress to next level</span>
            <span><%= progress %> / 100 XP</span>
        </div>

        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>
    </div>

    <div class="actions">

        <div class="card action-card">
            <h3>🎯 Coding Missions</h3>
            <p>
                Challenge yourself with Java, SQL and DSA
                programming questions.
            </p>
            <a href="<%= request.getContextPath() %>/missions">
                Explore Missions
            </a>
        </div>

        <div class="card action-card">
            <h3>🏆 Leaderboard</h3>
            <p>
                Check your ranking and see how you compare
                with other coding learners.
            </p>
            <a href="<%= request.getContextPath() %>/leaderboard.jsp">
                View Leaderboard
            </a>
        </div>

    </div>

</div>

</body>
</html>
