
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.codequest.DBConnection" %>

<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int rank = 0;
    boolean hasStudents = false;

    String sql =
        "SELECT u.user_id, u.username, u.xp, u.level, " +
        "(SELECT COUNT(*) FROM mission_submissions ms " +
        "WHERE ms.user_id = u.user_id AND ms.is_correct = TRUE) " +
        "AS completed_missions " +
        "FROM users u ORDER BY u.xp DESC, u.username ASC";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeQuest | Leaderboard</title>

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

.leaderboard-card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 16px;
    padding: 25px;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 650px;
}

th {
    color: #a78bfa;
    text-align: left;
    padding: 18px 12px;
    border-bottom: 1px solid #354563;
}

td {
    padding: 18px 12px;
    border-bottom: 1px solid #293755;
    color: #dce4f5;
}

tr:hover td {
    background: #202d49;
}

.rank {
    color: #facc15;
    font-weight: bold;
}

.xp {
    color: #4ade80;
    font-weight: bold;
}

.top-player {
    background: #242d4a;
}

.empty {
    text-align: center;
    padding: 40px;
    color: #b8c2dc;
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
}
</style>
</head>

<body>

<div class="sidebar">

    <div class="logo">⚡ CodeQuest</div>

    <a href="<%= request.getContextPath() %>/dashboard">
        🏠 Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/missions">
        🎯 Missions
    </a>

    <a href="<%= request.getContextPath() %>/leaderboard.jsp"
       class="active">
        🏆 Leaderboard
    </a>

    <a href="<%= request.getContextPath() %>/logout">
        🚪 Logout
    </a>

</div>

<div class="main">

    <div class="header">
        <h1>🏆 Leaderboard</h1>
        <p>See who's leading the CodeQuest coding journey!</p>
    </div>

    <div class="leaderboard-card">

        <table>

            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Student</th>
                    <th>Level</th>
                    <th>Completed Missions</th>
                    <th>Total XP</th>
                </tr>
            </thead>

            <tbody>

            <%
                try (Connection connection = DBConnection.getConnection();
                     PreparedStatement statement =
                         connection.prepareStatement(sql);
                     ResultSet result = statement.executeQuery()) {

                    while (result.next()) {

                        hasStudents = true;
                        rank++;

                        String username = result.getString("username");
                        int level = result.getInt("level");
                        int completed = result.getInt("completed_missions");
                        int xp = result.getInt("xp");

                        String medal = "";

                        if (rank == 1) medal = "🥇";
                        else if (rank == 2) medal = "🥈";
                        else if (rank == 3) medal = "🥉";
            %>

                <tr class="<%= rank <= 3 ? "top-player" : "" %>">

                    <td class="rank">
                        <%= medal.isEmpty() ? rank : medal %>
                    </td>

                    <td><%= username %></td>

                    <td>Level <%= level %></td>

                    <td><%= completed %></td>

                    <td class="xp"><%= xp %> XP</td>

                </tr>

            <%
                    }

                } catch (Exception e) {
                    application.log("Leaderboard loading failed", e);
            %>

                <tr>
                    <td colspan="5" class="empty">
                        Unable to load the leaderboard.
                        Please try again later.
                    </td>
                </tr>

            <%
                }

                if (!hasStudents) {
            %>

                <tr>
                    <td colspan="5" class="empty">
                        <h3>No Students Yet!</h3>
                        <p>Be the first student to join CodeQuest.</p>
                    </td>
                </tr>

            <%
                }
            %>

            </tbody>

        </table>

    </div>

</div>

</body>
</html>
