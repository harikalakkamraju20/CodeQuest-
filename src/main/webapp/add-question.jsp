
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CodeQuest | Add Question</title>

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
    width: 90%;
    max-width: 850px;
    margin: 40px auto;
}

.header {
    margin-bottom: 25px;
}

.header h1 {
    color: #c4b5fd;
    margin-bottom: 10px;
}

.header p {
    color: #aab6d1;
    line-height: 1.5;
}

.form-card {
    background: #151f37;
    border: 1px solid #293755;
    border-radius: 16px;
    padding: 30px;
}

label {
    display: block;
    margin: 18px 0 9px;
    color: #dce4f5;
    font-weight: bold;
}

input, textarea, select {
    width: 100%;
    padding: 13px;
    border: 1px solid #39466b;
    border-radius: 8px;
    background: #0b1429;
    color: white;
    font-size: 15px;
    outline: none;
}

input:focus, textarea:focus, select:focus {
    border-color: #a78bfa;
}

textarea {
    resize: vertical;
    min-height: 100px;
}

select option {
    background: #151f37;
}

.section-title {
    margin-top: 28px;
    padding-bottom: 12px;
    border-bottom: 1px solid #354563;
    color: #a78bfa;
}

.choices {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 20px;
}

button {
    width: 100%;
    margin-top: 30px;
    padding: 15px;
    background: linear-gradient(90deg, #7c3aed, #a855f7);
    color: white;
    border: none;
    border-radius: 9px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    opacity: 0.9;
}

.message {
    padding: 13px;
    margin-bottom: 18px;
    border-radius: 8px;
    text-align: center;
}

.error {
    background: #542333;
    color: #ffb4c2;
}

.success {
    background: #174b38;
    color: #9af0c5;
}

.back {
    display: inline-block;
    margin-top: 22px;
    color: #a78bfa;
    text-decoration: none;
}

.back:hover {
    color: white;
}

@media (max-width: 600px) {
    .choices {
        grid-template-columns: 1fr;
    }

    .form-card {
        padding: 20px;
    }
}
</style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>➕ Add New Question</h1>
        <p>Create a new programming mission for CodeQuest students.</p>
    </div>

    <div class="form-card">

        <% if (error != null) { %>
            <div class="message error"><%= error %></div>
        <% } %>

        <% if ("added".equals(success)) { %>
            <div class="message success">
                Question added successfully!
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/add-question"
              method="post">

            <h3 class="section-title">Question Details</h3>

            <label>Question Title</label>
            <input type="text" name="title"
                   placeholder="Enter question title" required>

            <label>Question Description</label>
            <textarea name="description"
                      placeholder="Write your programming question here..."
                      required></textarea>

            <label>Category</label>
            <select name="category" required>
                <option value="">Select Category</option>
                <option value="Java">Java</option>
                <option value="SQL">SQL</option>
                <option value="DSA">DSA</option>
            </select>

            <label>Difficulty</label>
            <select name="difficulty" required>
                <option value="">Select Difficulty</option>
                <option value="Easy">Easy</option>
                <option value="Medium">Medium</option>
                <option value="Hard">Hard</option>
            </select>

            <h3 class="section-title">Multiple Choice Answers</h3>

            <div class="choices">

                <div>
                    <label>Option A</label>
                    <input type="text" name="choiceA"
                           placeholder="Enter option A" required>
                </div>

                <div>
                    <label>Option B</label>
                    <input type="text" name="choiceB"
                           placeholder="Enter option B" required>
                </div>

                <div>
                    <label>Option C</label>
                    <input type="text" name="choiceC"
                           placeholder="Enter option C" required>
                </div>

                <div>
                    <label>Option D</label>
                    <input type="text" name="choiceD"
                           placeholder="Enter option D" required>
                </div>

            </div>

            <h3 class="section-title">Correct Answer and Reward</h3>

            <label>Correct Answer</label>
            <select name="correctAnswer" required>
                <option value="">Select Correct Answer</option>
                <option value="A">Option A</option>
                <option value="B">Option B</option>
                <option value="C">Option C</option>
                <option value="D">Option D</option>
            </select>

            <label>XP Reward</label>
            <input type="number" name="xpReward"
                   min="1" max="10000"
                   placeholder="Example: 20" required>

            <button type="submit">➕ Add Question</button>

        </form>

        <a class="back"
           href="<%= request.getContextPath() %>/admin-dashboard.jsp">
           ← Back to Admin Dashboard
        </a>

    </div>

</div>

</body>
</html>
