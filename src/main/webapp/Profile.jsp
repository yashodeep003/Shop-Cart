<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.UserPojo" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if user is logged in
    HttpSession sessionUser = request.getSession(false);
    if(sessionUser == null || sessionUser.getAttribute("p") == null) {
        response.sendRedirect("signIn.jsp");
        return;
    }
    
    UserPojo currentUser = (UserPojo) sessionUser.getAttribute("p");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - ShopCart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
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
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        .cart-icon {
            position: relative;
        }
        
        .cart-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff6b6b;
            color: white;
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 50%;
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
            transition: background-color 0.3s;
        }
        
        .dropdown-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .dropdown-content {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 200px;
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
        
        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .page-header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        /* Profile Container */
        .profile-container {
            max-width: 1000px;
            margin: -50px auto 50px;
            padding: 0 20px;
            position: relative;
            z-index: 10;
        }
        
        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, #667eea20, #764ba220);
            padding: 40px;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .profile-avatar {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border: 5px solid white;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .profile-avatar span {
            font-size: 4rem;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .profile-header h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }
        
        .profile-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .member-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 5px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            margin-top: 15px;
        }
        
        /* Profile Content */
        .profile-content {
            padding: 40px;
        }
        
        /* Stats Section */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.2);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.95rem;
        }
        
        /* Profile Sections */
        .profile-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 60px;
            height: 2px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }
        
        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .info-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .info-label {
            color: #667eea;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-value {
            font-size: 1.2rem;
            color: #333;
            font-weight: 500;
            word-break: break-word;
        }
        
        /* Security Section */
        .security-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            margin-bottom: 15px;
        }
        
        .security-info h4 {
            color: #333;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .security-info p {
            color: #666;
            font-size: 0.95rem;
        }
        
        .security-badge {
            background: #d4edda;
            color: #155724;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .edit-btn {
            background: none;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 8px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .edit-btn:hover {
            background: #667eea;
            color: white;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #f0f0f0;
            color: #333;
        }
        
        .btn-secondary:hover {
            background: #e0e0e0;
        }
        
        /* Recent Activity */
        .activity-list {
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            background: #f0f4ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #667eea;
        }
        
        .activity-details {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }
        
        .activity-time {
            font-size: 0.85rem;
            color: #999;
        }
        
        .activity-status {
            padding: 3px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .profile-header {
                padding: 30px 20px;
            }
            
            .profile-content {
                padding: 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .security-item {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="Products.jsp">🛍️ ShopCart</a>
            </div>
            
            <div class="nav-menu">
                <a href="Products.jsp">Home</a>
                <a href="Products.jsp">Products</a>
                <a href="cart.jsp" class="cart-icon">
                    🛒 Cart
                    <% 
                    Integer cartCount = (Integer) session.getAttribute("cartCount");
                    if(cartCount != null && cartCount > 0) { 
                    %>
                        <span class="cart-count"><%= cartCount %></span>
                    <% } %>
                </a>
                <a href="orders.jsp">My Orders</a>
                <div class="user-dropdown">
                    <button class="dropdown-btn">
                        👤 <%= currentUser.getUsername() %>
                    </button>
                    <div class="dropdown-content">
                        <a href="profile.jsp" class="active">My Profile</a>
                        <a href="orders.jsp">My Orders</a>
                        <a href="cart.jsp">My Cart</a>
                        <div style="border-top: 1px solid #e0e0e0; margin: 5px 0;"></div>
                        <a href="LogoutServlet" style="color: #ff6b6b;">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <section class="page-header">
        <h1>My Profile</h1>
        <p>Account information </p>
        <br>
    </section>

    <!-- Profile Container -->
    <div class="profile-container">
        <div class="profile-card">
            
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <span><%= currentUser.getUsername().substring(0, 1).toUpperCase() %></span>
                </div>
                <h2><%= currentUser.getUsername() %></h2>
                <p>Member since 2025</p>
                <span class="member-badge">✨ Premium Member</span>
            </div>
            
            
                
                
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer style="background: #333; color: white; margin-top: 50px;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 50px 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 40px;">
            <div>
                <h3 style="margin-bottom: 20px;">ShopCart</h3>
                <p style="color: #ccc;">Your trusted online shopping destination</p>
            </div>
            <div>
                <h4 style="margin-bottom: 20px;">Quick Links</h4>
                <ul style="list-style: none;">
                    <li style="margin-bottom: 10px;"><a href="about.jsp" style="color: #ccc; text-decoration: none;">About Us</a></li>
                    <li style="margin-bottom: 10px;"><a href="contact.jsp" style="color: #ccc; text-decoration: none;">Contact</a></li>
                    <li style="margin-bottom: 10px;"><a href="faq.jsp" style="color: #ccc; text-decoration: none;">FAQs</a></li>
                    <li style="margin-bottom: 10px;"><a href="terms.jsp" style="color: #ccc; text-decoration: none;">Terms & Conditions</a></li>
                </ul>
            </div>
            <div>
                <h4 style="margin-bottom: 20px;">Contact Info</h4>
                <ul style="list-style: none; color: #ccc;">
                    <li style="margin-bottom: 10px;">📧 support@shopcart.com</li>
                    <li style="margin-bottom: 10px;">📞 +91 12345 67890</li>
                    <li style="margin-bottom: 10px;">📍 Mumbai, India</li>
                </ul>
            </div>
        </div>
        <div style="background: #222; text-align: center; padding: 20px; border-top: 1px solid #444;">
            <p style="color: #ccc;">&copy; 2025 ShopCart. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>