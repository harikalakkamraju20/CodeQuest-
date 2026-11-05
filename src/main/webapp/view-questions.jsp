
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    List<Map<String, Object>> questions =
        (List<Map<String, Object>>) request.getAttribute("questions");

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CodeQuest | Manage Questions</title>

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

.container {
    width: 92%;
    max-width: 1200px;
    margin: 40px auto;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 30px;
}

.header h1 {
    color: #c4b5fd;
    margin-bottom: 10px;
}

.header p {
    color: #aab6d1;
}

.add-btn {
    display: inline-block;
    background: #7542d8;
    color: white;
    padding: 13px 20px;
    border-radius: 9px;
    text-decoration: none;
}

.add-btn:hover {
    background: #925ff0;
}

.question-card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 14px;
    padding: 25px;
    margin-bottom: 20px;
}

.question-top {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 15px;
}

.question-top h2 {
    font-size: 21px;
    color: #e0d5ff;
}

.badges {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.badge {
    padding: 7px 12px;
    background: #30234e;
    color: #c4b5fd;
    border-radius: 20px;
    font-size: 12px;
}

.description {
    color: #b8c2dc;
    line-height: 1.6;
    margin-bottom: 18px;
}

.options {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}

.option {
    background: #0b1429;
    border: 1px solid #293755;
    padding: 13px;
    border-radius: 8px;
    color: #dce4f5;
}

.xp {
    margin-top: 18px;
    color: #4ade80;
    font-weight: bold;
}

.empty, .error {
    padding: 35px;
    text-align: center;
    border-radius: 12px;
    line-height: 1.6;
}

.empty {
    background: #151f37;
    color: #b8c2dc;
}

.error {
    background: #542333;
    color: #ffb4c2;
}

.back {
    display: inline-block;
    margin-top: 25px;
    color: #a78bfa;
    text-decoration: none;
}

.back:hover {
    color: white;
}

@media (max-width: 600px) {
    .options {
        grid-template-columns: 1fr;
    }

    .question-card {
        padding: 18px;
    }
}
</style>
</head>

<body>

<div class="container">

    <div class="header">

        <div>
            <h1>📚 Manage Questions</h1>
            <p>View all programming missions stored in CodeQuest.</p>
        </div>

        <a class="add-btn"
           href="<%= request.getContextPath() %>/add-question.jsp">
           ➕ Add Question
        </a>

    </div>

    <% if (error != null) { %>

        <div class="error">
            <%= error %>
        </div>

    <% } else if (questions == null) { %>

        <div class="empty">
            Questions have not been loaded. Please open this page
            through the admin dashboard.
        </div>

    <% } else if (questions.isEmpty()) { %>

        <div class="empty">
            <h2>No Questions Available Yet!</h2>
            <p>Start by adding your first programming mission.</p>
        </div>

    <% } else { %>

        <p style="color:#aab6d1; margin-bottom:20px;">
            Total Questions: <%= questions.size() %>
        </p>

        <% for (Map<String, Object> question : questions) { %>

            <div class="question-card">

                <div class="question-top">

                    <h2>
                        #<%= question.get("missionId") %> -
                        <%= question.get("title") %>
                    </h2>

                    <div class="badges">
                        <span class="badge">
                            <%= question.get("category") %>
                        </span>

                        <span class="badge">
                            <%= question.get("difficulty") %>
                        </span>
                    </div>

                </div>

                <p class="description">
                    <%= question.get("description") %>
                </p>

                <div class="options">

                    <div class="option">
                        <strong>A.</strong>
                        <%= question.get("choiceA") %>
                    </div>

                    <div class="option">
                        <strong>B.</strong>
                        <%= question.get("choiceB") %>
                    </div>

                    <div class="option">
                        <strong>C.</strong>
                        <%= question.get("choiceC") %>
                    </div>

                    <div class="option">
                        <strong>D.</strong>
                        <%= question.get("choiceD") %>
                    </div>

                </div>

                <div class="xp">
                    ⭐ XP Reward: <%= question.get("xpReward") %> XP
                </div>

            </div>

        <% } %>

    <% } %>

    <a class="back"
       href="<%= request.getContextPath() %>/admin-dashboard.jsp">
       ← Back to Admin Dashboard
    </a>

</div>

</body>
</html>
