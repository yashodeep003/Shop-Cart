<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password</title>
<link rel="stylesheet" href="signIn.css">
<script src="forgotPassword.js"></script>
</head>
<body>

<form id="forgotPasswordForm" name="forgotPasswordForm" action="DataLinker.jsp" onsubmit="return validateForgotPasswordForm()" method="post">
    <h3>Reset Password</h3>
    
    <input type="hidden" name="name" value="forgotpassword">
    
    <label>Username</label>
    <input type="text" id="username" name="username" onkeyup="validateUsername()" onblur="validateUsername()">
    <div id="usernameError"></div>
    
    <label>Security Question</label>
    <select id="securityQuestion" name="question" onchange="validateQuestion()">
        <option value="">Select a question</option>
        <option value="Fav Color">Favorite Color</option>
        <option value="Fav Car">Favorite Car</option>
        <option value="School Name">School Name</option>
    </select>
    <div id="questionError"></div>
    
    <label>Your Answer</label>
    <input type="text" id="answer" name="answer" onkeyup="validateAnswer()" onblur="validateAnswer()">
    <div id="answerError"></div>
    
    <label>New Password</label>
    <div style="position: relative;">
        <input type="password" id="newPassword" name="newPassword" onkeyup="validateNewPassword()" onblur="validateNewPassword()" style="padding-right: 40px;">
        <span id="toggleNewPassword" onclick="toggleNewPasswordVisibility()" style="position: absolute; right: 10px; top: 10px; cursor: pointer; user-select: none;">👁️‍🗨️</span>
    </div>
    <div id="newPasswordError"></div>
    
    <label>Confirm New Password</label>
    <div style="position: relative;">
        <input type="password" id="confirmPassword" name="confirmPassword" onkeyup="validateConfirmPassword()" onblur="validateConfirmPassword()" style="padding-right: 40px;">
        <span id="toggleConfirmPassword" onclick="toggleConfirmPasswordVisibility()" style="position: absolute; right: 10px; top: 10px; cursor: pointer; user-select: none;">👁️‍🗨️</span>
    </div>
    <div id="confirmPasswordError"></div>
    
    <input type="submit" value="Reset Password">
    
    <br>
    <a href="signIn.jsp">Back to Sign In</a>
</form>

</body>
</html>