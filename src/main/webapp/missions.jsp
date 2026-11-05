
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> missions =
            (List<Map<String, Object>>) request.getAttribute("missions");

    String selectedCategory =
            (String) request.getAttribute("selectedCategory");

    String selectedDifficulty =
            (String) request.getAttribute("selectedDifficulty");

    if (selectedCategory == null) selectedCategory = "";
    if (selectedDifficulty == null) selectedDifficulty = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CodeQuest | Coding Missions</title>

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
    width: 230px;
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
    margin-bottom: 40px;
}

.sidebar a {
    display: block;
    color: #b8c2dc;
    text-decoration: none;
    padding: 15px;
    margin-bottom: 12px;
    border-radius: 10px;
}

.sidebar a:hover,
.sidebar a.active {
    background: #28365c;
    color: white;
}

.main {
    margin-left: 230px;
    padding: 40px;
}

.header {
    margin-bottom: 30px;
}

.header h1 {
    font-size: 30px;
    margin-bottom: 10px;
}

.header p {
    color: #9ca9c7;
}

.filter-box {
    background: #151f37;
    border: 1px solid #293755;
    padding: 22px;
    border-radius: 15px;
    margin-bottom: 30px;
}

.filter-box h3 {
    margin-bottom: 18px;
}

.filters {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

select {
    background: #202d49;
    color: white;
    border: 1px solid #435275;
    padding: 12px;
    border-radius: 8px;
    min-width: 180px;
}

button {
    background: #7653d6;
    color: white;
    border: none;
    padding: 12px 22px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
}

button:hover {
    background: #9275ec;
}

.mission-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 22px;
}

.mission-card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 16px;
    padding: 25px;
}

.mission-card h2 {
    color: #c4b5fd;
    margin: 18px 0 12px;
    font-size: 21px;
}

.description {
    color: #aab6d0;
    line-height: 1.6;
    margin-bottom: 20px;
}

.tags {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.tag {
    background: #30245a;
    color: #c4b5fd;
    padding: 7px 12px;
    border-radius: 20px;
    font-size: 12px;
}

.xp {
    color: #facc15;
    font-weight: bold;
    margin-bottom: 20px;
}

.question-label {
    color: #9ca9c7;
    margin-bottom: 12px;
}

.option {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #202d49;
    border: 1px solid #354563;
    padding: 12px;
    border-radius: 9px;
    margin-bottom: 10px;
    color: #e2e8f0;
    cursor: pointer;
}

.option:hover {
    border-color: #9275ec;
}

.option input {
    accent-color: #9275ec;
}

.submit-btn {
    width: 100%;
    margin-top: 12px;
}

.empty {
    background: #151f37;
    padding: 35px;
    border-radius: 15px;
    color: #b8c2dc;
    text-align: center;
    grid-column: 1 / -1;
}

@media (max-width: 850px) {
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

    .mission-grid {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>

<div class="sidebar">

    <div class="logo">⚡ CodeQuest</div>

    <a href="<%= request.getContextPath() %>/dashboard">
        🏠 Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/missions" class="active">
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

    <div class="header">
        <h1>🎯 Coding Missions</h1>
        <p>Challenge yourself, improve your coding skills and earn XP!</p>
    </div>

    <div class="filter-box">

        <h3>Find Your Challenge</h3>

        <form action="<%= request.getContextPath() %>/missions"
              method="get">

            <div class="filters">

                <select name="category">
                    <option value="">All Categories</option>

                    <option value="Java"
                        <%= "Java".equals(selectedCategory) ? "selected" : "" %>>
                        Java
                    </option>

                    <option value="SQL"
                        <%= "SQL".equals(selectedCategory) ? "selected" : "" %>>
                        SQL
                    </option>

                    <option value="DSA"
                        <%= "DSA".equals(selectedCategory) ? "selected" : "" %>>
                        DSA
                    </option>
                </select>

                <select name="difficulty">
                    <option value="">All Difficulties</option>

                    <option value="Easy"
                        <%= "Easy".equals(selectedDifficulty) ? "selected" : "" %>>
                        Easy
                    </option>

                    <option value="Medium"
                        <%= "Medium".equals(selectedDifficulty) ? "selected" : "" %>>
                        Medium
                    </option>

                    <option value="Hard"
                        <%= "Hard".equals(selectedDifficulty) ? "selected" : "" %>>
                        Hard
                    </option>
                </select>

                <button type="submit">Apply Filters</button>

            </div>
        </form>

    </div>

    <div class="mission-grid">

    <%
        if (missions != null && !missions.isEmpty()) {

            for (Map<String, Object> mission : missions) {

                int missionId = (Integer) mission.get("missionId");
                String title = (String) mission.get("title");
                String description = (String) mission.get("description");
                String category = (String) mission.get("category");
                String difficulty = (String) mission.get("difficulty");
                int xpReward = (Integer) mission.get("xpReward");

                String[] optionNames = {"A", "B", "C", "D"};
                String[] optionValues = {
                    (String) mission.get("choiceA"),
                    (String) mission.get("choiceB"),
                    (String) mission.get("choiceC"),
                    (String) mission.get("choiceD")
                };
    %>

        <div class="mission-card">

            <div class="tags">
                <span class="tag"><%= category %></span>
                <span class="tag"><%= difficulty %></span>
            </div>

            <h2><%= title %></h2>

            <p class="description"><%= description %></p>

            <p class="xp">⭐ Reward: <%= xpReward %> XP</p>

            <p class="question-label">Choose your answer:</p>

            <form action="<%= request.getContextPath() %>/submit-answer"
                  method="post">

                <input type="hidden"
                       name="missionId"
                       value="<%= missionId %>">

                <%
                    for (int i = 0; i < optionValues.length; i++) {
                        if (optionValues[i] != null) {
                %>

                    <label class="option">

                        <input type="radio"
                               name="selectedAnswer"
                               value="<%= optionNames[i] %>"
                               required>

                        <span>
                            <strong><%= optionNames[i] %>.</strong>
                            <%= optionValues[i] %>
                        </span>

                    </label>

                <%
                        }
                    }
                %>

                <button type="submit" class="submit-btn">
                    Submit Answer
                </button>

            </form>

        </div>

    <%
            }

        } else {
    %>

        <div class="empty">
            <h2>No Missions Available</h2>
            <p>There are currently no missions matching your filters.
               Please check again later.</p>
        </div>

    <%
        }
    %>

    </div>

</div>

</body>
</html>
