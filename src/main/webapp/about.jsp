<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if user is logged in
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
    <title>About Us - ShopCart</title>
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
        
        /* Navigation Bar */
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
        
        /* User Dropdown */
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
        
        .dropdown-btn:hover {
            background: rgba(255,255,255,0.3);
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
            transition: background-color 0.3s;
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
            transition: background-color 0.3s;
        }
        
        .auth-links a:hover {
            background: rgba(255,255,255,0.2);
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
        
        /* About Section */
        .about-section {
            background: white;
            border-radius: 15px;
            padding: 50px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }
        
        .about-section h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .about-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .about-section h3 {
            font-size: 1.5rem;
            color: #444;
            margin: 30px 0 15px;
        }
        
        .about-section p {
            color: #666;
            line-height: 1.8;
            margin-bottom: 20px;
            font-size: 1.1rem;
        }
        
        /* Mission Vision Grid */
        .mission-vision {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin: 40px 0;
        }
        
        .mission-box, .vision-box {
            padding: 30px;
            border-radius: 10px;
            background: #f8f9fa;
            transition: transform 0.3s;
        }
        
        .mission-box:hover, .vision-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.2);
        }
        
        .mission-box h4, .vision-box h4 {
            font-size: 1.5rem;
            color: #667eea;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .mission-box p, .vision-box p {
            color: #666;
            line-height: 1.6;
            margin: 0;
        }
        
        /* Team Grid */
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .team-member {
            text-align: center;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: transform 0.3s;
        }
        
        .team-member:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.2);
        }
        
        .member-icon {
            font-size: 4rem;
            margin-bottom: 15px;
        }
        
        .team-member h4 {
            font-size: 1.3rem;
            color: #333;
            margin-bottom: 5px;
        }
        
        .team-member p {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .team-member .bio {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.6;
        }
        
        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin: 50px 0;
        }
        
        .stat-card {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 10px;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        /* Values Section */
        .values-section {
            background: #f8f9fa;
            padding: 50px;
            border-radius: 10px;
            margin-top: 40px;
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        .value-item {
            text-align: center;
        }
        
        .value-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .value-item h4 {
            font-size: 1.2rem;
            color: #333;
            margin-bottom: 10px;
        }
        
        .value-item p {
            color: #666;
            line-height: 1.6;
        }
        
        /* Footer */
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
        
        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .mission-vision {
                grid-template-columns: 1fr;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .about-section {
                padding: 30px;
            }
        }
    </style>
</head>
<body>

   <!-- Navigation Bar -->
<nav class="navbar">
    <div class="nav-container">
        <div class="nav-logo">
            <a href="Products.jsp">🛍️ShopCart</a>
        </div>
        
        <div class="nav-search">
            <input type="text" placeholder="Search products..." id="searchInput">
            <button class="search-btn" onclick="searchProducts()">🔍Search</button>
        </div>
        
        <div class="nav-menu">
            <a href="Products.jsp" class="active">Home</a>
		 
 			<a href="cart.jsp" class="active cart-icon">
                    🛒 Cart
                    <% if(session.getAttribute("cartCount") != null) { %>
                        <span class="cart-count"><%= session.getAttribute("cartCount") %></span>
                    <% } %>
                </a>
            <a href="Profile.jsp">MyProfile</a>
            <a href="orders.jsp">MyOrders</a>
            <a href="LogoutServlet">Logout</a>
            <span class="user-greeting">👤<%= currentUser.getUsername() %></span>
        </div>
    </div>
</nav>

    <!-- Page Header -->
    <section class="page-header">
        <h1>About Us</h1>
        <p>Discover the story behind ShopCart</p>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        
        <!-- About Section -->
        <div class="about-section">
            <h2>Who We Are</h2>
            <p>Welcome to ShopCart, your number one source for all things shopping. We're dedicated to providing you the very best of products, with an emphasis on quality, customer service, and uniqueness.</p>
            
            <p>Founded in 2024, ShopCart has come a long way from its beginnings. When we first started out, our passion for providing the best shopping experience drove us to start our own business.</p>
            
            <!-- Mission & Vision -->
            <div class="mission-vision">
                <div class="mission-box">
                    <h4>🎯 Our Mission</h4>
                    <p>To provide a seamless and enjoyable shopping experience for customers across India, offering quality products at competitive prices with exceptional customer service.</p>
                </div>
                
                <div class="vision-box">
                    <h4>👁️ Our Vision</h4>
                    <p>To become India's most trusted and preferred online shopping destination, known for reliability, quality, and customer satisfaction.</p>
                </div>
            </div>
            
            <!-- Stats Section -->
            <div class="stats-section">
                <div class="stat-card">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Happy Customers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">500+</div>
                    <div class="stat-label">Products</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Brands</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Support</div>
                </div>
            </div>
            
            <!-- Our Values -->
            <div class="values-section">
                <h3>Our Core Values</h3>
                <div class="values-grid">
                    <div class="value-item">
                        <div class="value-icon">🤝</div>
                        <h4>Integrity</h4>
                        <p>We conduct our business with honesty and transparency</p>
                    </div>
                    <div class="value-item">
                        <div class="value-icon">⭐</div>
                        <h4>Quality</h4>
                        <p>We never compromise on product quality</p>
                    </div>
                    <div class="value-item">
                        <div class="value-icon">💡</div>
                        <h4>Innovation</h4>
                        <p>We continuously improve and innovate</p>
                    </div>
                    <div class="value-item">
                        <div class="value-icon">❤️</div>
                        <h4>Customer First</h4>
                        <p>Our customers are at the heart of everything we do</p>
                    </div>
                </div>
            </div>
            
            <!-- Team Section -->
            <h3 style="margin-top: 50px;">Meet Our Team</h3>
            <div class="team-grid">
                <div class="team-member">
                    <div class="member-icon">👨‍💼</div>
                    <h4>Rajesh Kumar</h4>
                    <p>Founder & CEO</p>
                    <p class="bio">10+ years of experience in e-commerce and retail</p>
                </div>
                <div class="team-member">
                    <div class="member-icon">👩‍💼</div>
                    <h4>Priya Sharma</h4>
                    <p>Head of Operations</p>
                    <p class="bio">Ensuring smooth delivery and customer satisfaction</p>
                </div>
                <div class="team-member">
                    <div class="member-icon">👨‍💻</div>
                    <h4>Amit Patel</h4>
                    <p>Technical Lead</p>
                    <p class="bio">Building secure and user-friendly shopping experience</p>
                </div>
                <div class="team-member">
                    <div class="member-icon">👩‍🎨</div>
                    <h4>Neha Gupta</h4>
                    <p>Customer Support Head</p>
                    <p class="bio">Dedicated to resolving customer queries 24/7</p>
                </div>
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
                    <li><a href="about.jsp" class="active">About Us</a></li>
                    <li><a href="contact.jsp">Contact</a></li>
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

</body>
</html>