// signInValidation.js

// Main validation function for form submission
function validateSignInForm() {
    // Get form values
    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    
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
    var errorElements = ["usernameError", "passwordError"];
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

// Toggle password visibility
function togglePasswordVisibility() {
    var passwordField = document.getElementById("password");
    var toggleIcon = document.getElementById("togglePassword");
    
    if (passwordField.type === "password") {
        passwordField.type = "text";
        toggleIcon.textContent = "👁️";
        toggleIcon.style.opacity = "0.7";
    } else {
        passwordField.type = "password";
        toggleIcon.textContent = "👁️‍🗨️";
        toggleIcon.style.opacity = "1";
    }
}

// Add enter key support
document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById("signinForm");
    if(form) {
        form.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                if (validateSignInForm()) {
                    form.submit();
                }
            }
        });
    }
});