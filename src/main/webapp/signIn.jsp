<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SignIn - ShopCart</title>
<link rel="stylesheet" href="signIn.css">
<script src="signin.js"></script>
<style>
    .admin-note {
        background: #fff3cd;
        color: #856404;
        padding: 12px;
        border-radius: 5px;
        margin-bottom: 20px;
        font-size: 0.95rem;
        text-align: center;
        border-left: 4px solid #ffc107;
        border-right: 4px solid #ffc107;
    }
    
    .admin-note strong {
        color: #856404;
        font-size: 1rem;
    }
    
    .admin-badge {
        background: #ffc107;
        color: #856404;
        padding: 3px 8px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: bold;
        margin-left: 5px;
    }
</style>
</head>
<body>

<form id="signinForm" name="signinForm" action="DataLinker.jsp" onsubmit="return validateSignInForm()" method="post">
    
    <h3>🛍️ ShopCart</h3>
    <h3>Sign In</h3>
    
  
    
    <% if(request.getAttribute("error") != null) { %>
        <div style="color: red; margin-bottom: 10px; padding: 10px; background: #ffeeee; border-radius: 5px;">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <% if(request.getParameter("message") != null) { %>
        <div style="color: green; margin-bottom: 10px; padding: 10px; background: #eeffee; border-radius: 5px;">
            <%= request.getParameter("message") %>
        </div>
    <% } %>
    
    <input type="hidden" name="name" value="signin">
    
    <label>Username</label>
    <input type="text" id="username" name="username" onkeyup="validateUsername()" onblur="validateUsername()" placeholder="Enter username or 'Admin'">
    <div id="usernameError"></div>
    
    <label>Password</label>
    <div style="position: relative;">
        <input type="password" id="password" name="password" onkeyup="validatePassword()" onblur="validatePassword()" style="padding-right: 40px;" placeholder="Enter password">
        <span id="togglePassword" onclick="togglePasswordVisibility()" style="position: absolute; right: 10px; top: 10px; cursor: pointer; user-select: none;">👁️‍🗨️</span>
    </div>
    <div id="passwordError"></div>
    
    <input type="submit" value="Sign In">
        
    <a href="signUp.jsp">New User? Create Account</a>
    <br>
    <a href="forgotPassword.jsp">Forget Password</a>
    
    <hr style="margin: 20px 0 10px 0;">
    <p style="font-size: 0.8rem; color: #999; text-align: center;">
        Admin: Use <strong>Admin</strong> / <strong>Admin123</strong>
    </p>
</form>

</body>
</html>