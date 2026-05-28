<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionUser = request.getSession(false);
    UserPojo currentUser = null;
    if(sessionUser != null && sessionUser.getAttribute("p") != null) {
        currentUser = (UserPojo) sessionUser.getAttribute("p");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - ShopCart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: #f5f5f5;
        }
        
        /* Navigation Bar (same as about.jsp) */
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-logo a {
            color: white;
            text-decoration: none;
            font-size: 1.8rem;
            font-weight: bold;
        }
        
        .nav-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 20px;
            transition: background-color 0.3s;
        }
        
        .nav-menu a:hover, .nav-menu a.active {
            background: rgba(255,255,255,0.2);
        }
        
        .user-dropdown {
            position: relative;
        }
        
        .dropdown-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 8px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .dropdown-content {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 180px;
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            display: none;
            z-index: 1000;
            margin-top: 10px;
        }
        
        .user-dropdown:hover .dropdown-content {
            display: block;
        }
        
        .dropdown-content a {
            color: #333;
            padding: 12px 20px;
            text-decoration: none;
            display: block;
        }
        
        .dropdown-content a:hover {
            background: #f5f5f5;
            color: #667eea;
        }
        
        .auth-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .auth-links a {
            color: white;
            text-decoration: none;
            padding: 8px 20px;
            border-radius: 25px;
        }
        
        .auth-links .register {
            background: rgba(255,255,255,0.2);
        }
        
        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 20px;
            text-align: center;
        }
        
        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 10px;
        }
        
        .page-header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        /* Main Content */
        .main-content {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        /* Contact Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            margin-bottom: 50px;
        }
        
        /* Contact Info Cards */
        .contact-info {
            background: white;
            border-radius: 15px;
            padding: 40px 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .contact-info h2 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .contact-info h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 25px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: transform 0.3s;
        }
        
        .info-item:hover {
            transform: translateX(5px);
        }
        
        .info-icon {
            font-size: 2rem;
            min-width: 50px;
        }
        
        .info-content h3 {
            font-size: 1.2rem;
            color: #333;
            margin-bottom: 5px;
        }
        
        .info-content p {
            color: #666;
            line-height: 1.6;
        }
        
        /* Contact Form */
        .contact-form-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .contact-form-container h2 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .contact-form-container h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            width: 100%;
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        /* Map Section */
        .map-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-top: 30px;
        }
        
        .map-section h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
        }
        
        .map-container {
            height: 400px;
            background: #f0f0f0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #666;
            border: 2px dashed #ccc;
        }
        
        /* Business Hours */
        .hours-section {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .hours-section h3 {
            font-size: 1.3rem;
            color: #333;
            margin-bottom: 15px;
        }
        
        .hours-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .hours-item {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            background: white;
            border-radius: 5px;
        }
        
        .hours-item .day {
            font-weight: 600;
            color: #333;
        }
        
        .hours-item .time {
            color: #667eea;
        }
        
        /* Success Message */
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }
        
        /* Footer (same as about.jsp) */
        .footer {
            background: #333;
            color: white;
            margin-top: 50px;
        }
        
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 50px 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
        }
        
        .footer-section h3 {
            font-size: 1.5rem;
            margin-bottom: 20px;
        }
        
        .footer-section h4 {
            font-size: 1.2rem;
            margin-bottom: 20px;
        }
        
        .footer-section ul {
            list-style: none;
            padding: 0;
        }
        
        .footer-section ul li {
            margin-bottom: 12px;
        }
        
        .footer-section ul li a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-section ul li a:hover {
            color: #667eea;
        }
        
        .footer-bottom {
            background: #222;
            text-align: center;
            padding: 20px;
            border-top: 1px solid #444;
        }
        
        @media (max-width: 768px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="<%= currentUser != null ? "Products.jsp" : "index.jsp" %>">🛍️ ShopCart</a>
            </div>
            
            <div class="nav-menu">
                <a href="<%= currentUser != null ? "Products.jsp" : "index.jsp" %>">Home</a>
                <% if(currentUser != null) { %>
                    <a href="Products.jsp">Products</a>
                    <a href="Cart.jsp">🛒 Cart</a>
                    <div class="user-dropdown">
                        <button class="dropdown-btn">
                            👤 <%= currentUser.getUsername() %>
                        </button>
                        <div class="dropdown-content">
                            <a href="profile.jsp">My Profile</a>
                            <a href="orders.jsp">My Orders</a>
                            <a href="LogoutServlet">Logout</a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="auth-links">
                        <a href="signIn.jsp">Login</a>
                        <a href="signUp.jsp" class="register">Register</a>
                    </div>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <section class="page-header">
        <h1>Contact Us</h1>
        <p>We're here to help you 24/7</p>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        
        <!-- Success Message (hidden by default) -->
        <div class="success-message" id="successMessage">
            Thank you for contacting us! We'll get back to you soon.
        </div>
        
        <!-- Contact Grid -->
        <div class="contact-grid">
            <!-- Contact Information -->
            <div class="contact-info">
                <h2>Get in Touch</h2>
                
                <div class="info-item">
                    <div class="info-icon">📍</div>
                    <div class="info-content">
                        <h3>Visit Us</h3>
                        <p>123 Tech Park, Cyber City<br>Pune, Maharashtra 411001<br>India</p>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">📞</div>
                    <div class="info-content">
                        <h3>Call Us</h3>
                        <p>Toll Free: +91 12345 67890<br>Support: +91 98765 43210</p>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">✉️</div>
                    <div class="info-content">
                        <h3>Email Us</h3>
                        <p>support@shopcart.com<br>careers@shopcart.com</p>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">💬</div>
                    <div class="info-content">
                        <h3>Live Chat</h3>
                        <p>Available 24/7<br>Average response: 2 minutes</p>
                    </div>
                </div>
                
                <!-- Business Hours -->
                <div class="hours-section">
                    <h3>Business Hours</h3>
                    <div class="hours-grid">
                        <div class="hours-item">
                            <span class="day">Mon - Fri</span>
                            <span class="time">9:00 AM - 8:00 PM</span>
                        </div>
                        <div class="hours-item">
                            <span class="day">Saturday</span>
                            <span class="time">10:00 AM - 6:00 PM</span>
                        </div>
                        <div class="hours-item">
                            <span class="day">Sunday</span>
                            <span class="time">10:00 AM - 4:00 PM</span>
                        </div>
                        <div class="hours-item">
                            <span class="day">24/7 Support</span>
                            <span class="time">Email & Chat</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Contact Form -->
            <div class="contact-form-container">
                <h2>Send us a Message</h2>
                
                <form action="ContactServlet" method="post" onsubmit="return showSuccessMessage(event)">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name *</label>
                            <input type="text" id="firstName" name="firstName" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="lastName">Last Name *</label>
                            <input type="text" id="lastName" name="lastName" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Subject *</label>
                        <select id="subject" name="subject" required>
                            <option value="">Select a subject</option>
                            <option value="general">General Inquiry</option>
                            <option value="support">Technical Support</option>
                            <option value="billing">Billing Question</option>
                            <option value="feedback">Feedback</option>
                            <option value="complaint">Complaint</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Message *</label>
                        <textarea id="message" name="message" required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="subscribe" value="yes">
                            Subscribe to our newsletter
                        </label>
                    </div>
                    
                    <button type="submit" class="submit-btn">Send Message</button>
                </form>
            </div>
        </div>
        
        <!-- Map Section -->
        <div class="map-section">
            <h3>Find Us Here</h3>
            <div class="map-container">
                🗺️ Map integration would be here
                <!-- You can integrate Google Maps or any other map service -->
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>ShopCart</h3>
                <p>Your trusted online shopping destination</p>
            </div>
            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="contact.jsp" class="active">Contact</a></li>
                    <li><a href="faq.jsp">FAQs</a></li>
                    <li><a href="terms.jsp">Terms & Conditions</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Contact Info</h4>
                <ul>
                    <li>📧 support@shopcart.com</li>
                    <li>📞 +91 12345 67890</li>
                    <li>📍 Pune, India</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 ShopCart. All rights reserved.</p>
        </div>
    </footer>

    <script>
        function showSuccessMessage(event) {
            event.preventDefault();
            document.getElementById('successMessage').style.display = 'block';
            setTimeout(function() {
                document.getElementById('successMessage').style.display = 'none';
            }, 5000);
            return false;
        }
    </script>

</body>
</html>