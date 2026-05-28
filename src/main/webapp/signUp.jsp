<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SignUp </title>
<script src="signUp.js"></script>
<link rel="stylesheet" type="text/css" href="signUp.css">
</head>
<body>
<form name="signupForm" action="DataLinker.jsp" onsubmit="return validateSignUpForm()" method="post"  >

	<h3>ShopFirst</h3>
   	<h3>SignUp</h3>
   	<br>
	<input type="hidden" name="name" value="signup"> 
    <label>Username</label>
    <input type="text" id="username" name="username" onkeyup="validateUsername()" onblur="validateUsername()">
    <div id="usernameError"></div>
    
    <label>Password</label>
    <input type="password" id="password" name="password" onkeyup="validatePassword()" onblur="validatePassword()">
    <div id="passwordError"></div>
    
    <label>Security Question</label>
    <select id="securityQuestion" name="question" onchange="validateQuestion()">
        <option value="">Select a question</option>
        <option value="Fav Color">Favorite Color</option>
        <option value="Fav Car">Favorite Car</option>
        <option value="School Name">School Name</option>
    </select>
    <div id="questionError"></div>
    
    <label>Your Ans:</label>
    <input type="text" id="answer" name="answer" onkeyup="validateAnswer()" onblur="validateAnswer()">
    <div id="answerError"></div>
    
    <input type="submit" value="Sign Up">
    
    <br>
    <a href="signIn.jsp">Already have an Account? Log In</a>
</form>
</body>
</html>