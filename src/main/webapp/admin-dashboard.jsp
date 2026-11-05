
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminUsername");

    if (adminName == null) {
        adminName = "Administrator";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CodeQuest | Admin Dashboard</title>

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
}

.sidebar {
    position: fixed;
    width: 240px;
    height: 100vh;
    background: #121a30;
    padding: 30px 20px;
    border-right: 1px solid #293755;
}

.logo {
    color: #a78bfa;
    font-size: 25px;
    font-weight: bold;
    margin-bottom: 45px;
}

.sidebar a {
    display: block;
    color: #b8c2dc;
    text-decoration: none;
    padding: 15px;
    border-radius: 10px;
    margin-bottom: 12px;
}

.sidebar a:hover,
.sidebar a.active {
    background: #28365c;
    color: white;
}

.main {
    margin-left: 240px;
    padding: 40px;
}

.welcome {
    margin-bottom: 35px;
}

.welcome h1 {
    font-size: 30px;
    margin-bottom: 12px;
}

.welcome p {
    color: #aab6d1;
    line-height: 1.6;
}

.admin-badge {
    display: inline-block;
    margin-top: 15px;
    background: #35245c;
    color: #c4b5fd;
    padding: 9px 15px;
    border-radius: 20px;
}

.section-title {
    margin-bottom: 20px;
    font-size: 21px;
}

.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 22px;
}

.card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 16px;
    padding: 28px;
    transition: 0.3s;
}

.card:hover {
    transform: translateY(-5px);
    border-color: #a78bfa;
}

.card-icon {
    font-size: 38px;
    margin-bottom: 18px;
}

.card h3 {
    margin-bottom: 12px;
}

.card p {
    color: #aab6d1;
    line-height: 1.5;
    margin-bottom: 22px;
}

.card a {
    display: inline-block;
    text-decoration: none;
    color: white;
    background: #7542d8;
    padding: 11px 17px;
    border-radius: 8px;
}

.card a:hover {
    background: #925ff0;
}

.info {
    margin-top: 30px;
    padding: 23px;
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 14px;
    color: #b8c2dc;
    line-height: 1.7;
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
        padding: 22px;
    }
}
</style>
</head>

<body>

<div class="sidebar">

    <div class="logo">⚡ CodeQuest</div>

    <a href="<%= request.getContextPath() %>/admin-dashboard.jsp"
       class="active">🏠 Dashboard</a>

    <a href="<%= request.getContextPath() %>/add-question.jsp">
       ➕ Add Question</a>

    <a href="<%= request.getContextPath() %>/view-questions">
       📚 Manage Questions</a>

    <a href="<%= request.getContextPath() %>/admin-logout">
       🚪 Logout</a>

</div>

<div class="main">

    <div class="welcome">

        <h1>Welcome, <%= adminName %>! 👋</h1>

        <p>
            Manage coding missions, create questions, and help students
            improve their programming skills.
        </p>

        <div class="admin-badge">🛡️ Administrator Panel</div>

    </div>

    <h2 class="section-title">Admin Controls</h2>

    <div class="cards">

        <div class="card">

            <div class="card-icon">➕</div>

            <h3>Add New Question</h3>

            <p>
                Create new programming missions with questions,
                multiple-choice answers, difficulty levels, and XP rewards.
            </p>

            <a href="<%= request.getContextPath() %>/add-question.jsp">
                Create Question →
            </a>

        </div>

        <div class="card">

            <div class="card-icon">📚</div>

            <h3>Manage Questions</h3>

            <p>
                View the available programming questions and manage
                the missions stored in the database.
            </p>

            <a href="<%= request.getContextPath() %>/view-questions">
                View Questions →
            </a>

        </div>

    </div>

    <div class="info">

        <h3>💡 Admin Responsibilities</h3>

        <p>
            • Create Java, SQL, and DSA programming missions.<br>
            • Set question difficulty and XP rewards.<br>
            • Review the questions stored in the CodeQuest database.<br>
            • Help maintain the quality of the learning experience.
        </p>

    </div>

</div>

</body>
</html>
