
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String savedUsername = "";
    Cookie[] cookies = request.getCookies();

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("cq_username".equals(cookie.getName())) {
                savedUsername = cookie.getValue();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest Login</title>

<style>
body {
    background: #0b1020;
    color: white;
    font-family: Arial;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
}
.login-box {
    background: #171d35;
    padding: 35px;
    width: 350px;
    border-radius: 15px;
}
h2 {
    color: #a78bfa;
    text-align: center;
}
input[type=text], input[type=password] {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    box-sizing: border-box;
    border-radius: 7px;
    border: none;
}
button {
    width: 100%;
    padding: 12px;
    background: #7c3aed;
    color: white;
    border: none;
    border-radius: 7px;
    cursor: pointer;
}
.remember {
    margin: 12px 0;
}
a {
    color: #a78bfa;
}
</style>
</head>

<body>

<div class="login-box">

<h2>CodeQuest Login</h2>

<form action="<%=request.getContextPath()%>/login" method="post">

<label>Username or Email</label>

<input type="text"
       name="usernameOrEmail"
       value="<%=savedUsername%>"
       required>

<label>Password</label>

<input type="password"
       name="password"
       required>

<div class="remember">
<label>
<input type="checkbox" name="rememberMe" value="yes">
Remember Username
</label>
</div>

<button type="submit">Login</button>

</form>

<p style="color:#a78bfa;">
<%=request.getAttribute("error") == null ? "" : request.getAttribute("error")%>
</p>

<p>
<a href="<%=request.getContextPath()%>/register.jsp">
Create Account
</a>
</p>

</div>

</body>
</html>
