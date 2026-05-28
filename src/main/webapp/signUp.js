// signUpValidation.js

// Main validation function for form submission
function validateSignUpForm() {
    // Get form values
    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var securityQuestion = document.getElementById("securityQuestion").value;
    var answer = document.getElementById("answer").value;
    
    // Reset error messages
    clearErrors();
    
    // Validation flags
    var isValid = true;
    
    // Username validation
    if (username == null || username.trim() == "") {
        showError("usernameError", "Username must be filled");
        isValid = false;
    }
    
    // Password validation (minimum 8 characters)
    if (password == null || password.trim() == "") {
        showError("passwordError", "Password must be filled");
        isValid = false;
    } else if (password.length < 8) {
        showError("passwordError", "Password must be at least 8 characters long");
        isValid = false;
    }
    
    // Security question validation
    if (securityQuestion == null || securityQuestion == "") {
        showError("questionError", "Please select a security question");
        isValid = false;
    }
    
    // Answer validation
    if (answer == null || answer.trim() == "") {
        showError("answerError", "Answer must be filled");
        isValid = false;
    }
    
    return isValid;
}

// Function to show error messages
function showError(elementId, message) {
    var element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = message;
        element.style.color = "#dc3545";
        element.style.fontSize = "0.8rem";
        element.style.marginTop = "5px";
        element.style.marginBottom = "10px";
    }
}

// Function to clear all error messages
function clearErrors() {
    var errorElements = ["usernameError", "passwordError", "questionError", "answerError"];
    for(var i = 0; i < errorElements.length; i++) {
        var element = document.getElementById(errorElements[i]);
        if(element) {
            element.innerHTML = "";
        }
    }
}

// Real-time field validation
function validateUsername() {
    var username = document.getElementById("username").value;
    if(username.trim() == "") {
        showError("usernameError", "Username must be filled");
    } else {
        document.getElementById("usernameError").innerHTML = "";
    }
}

function validatePassword() {
    var password = document.getElementById("password").value;
    if(password.length < 8 && password.length > 0) {
        showError("passwordError", "Password must be at least 8 characters");
    } else if(password.trim() == "") {
        showError("passwordError", "Password must be filled");
    } else {
        document.getElementById("passwordError").innerHTML = "";
    }
}

function validateAnswer() {
    var answer = document.getElementById("answer").value;
    if(answer.trim() == "") {
        showError("answerError", "Answer must be filled");
    } else {
        document.getElementById("answerError").innerHTML = "";
    }
}

function validateQuestion() {
    var question = document.getElementById("securityQuestion").value;
    if (question == null || question == "") {
        showError("questionError", "Please select a security question");
    } else {
        document.getElementById("questionError").innerHTML = "";
    }
}