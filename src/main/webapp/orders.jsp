<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*" %>

<%
    // Check if user is logged in
    HttpSession sessionUser = request.getSession(false);
    if(sessionUser == null || sessionUser.getAttribute("p") == null) {
        response.sendRedirect("signIn.jsp");
        return;
    }
    
    UserPojo currentUser = (UserPojo) sessionUser.getAttribute("p");
    
    // Get DAO object
    com.dao.DAOInterface DAOobj = (com.dao.DAOInterface) application.getAttribute("DAOobj");
    
    // ===== DECLARE ALL VARIABLES HERE =====
    List<OrderBean> orders = new ArrayList<>();
    double totalSpent = 0;
    int pendingOrders = 0;
    int deliveredOrders = 0;
    int userId = 0;
    
    if(DAOobj != null) {
        try {
            // Get user ID - Option 1: If UserPojo has getUser_id() method
            // userId = currentUser.getUser_id();
            
            // Option 2: Fetch from database using username (if UserPojo doesn't have user_id)
            // You need to add getUserIdByUsername method in DAO
            userId = DAOobj.getUserIdByUsername(currentUser.getUsername());
            
            System.out.println("Fetching orders for user: " + currentUser.getUsername() + " (ID: " + userId + ")");
            
            // Get orders ONLY for this specific user
            orders = DAOobj.getOrdersByUserId(userId);
            
            // Calculate statistics
            for(OrderBean order : orders) {
                totalSpent += order.getTotalAmount();
                if("DELIVERED".equals(order.getOrderStatus())) {
                    deliveredOrders++;
                } else if("PENDING".equals(order.getOrderStatus()) || "PROCESSING".equals(order.getOrderStatus())) {
                    pendingOrders++;
                }
            }
            
            System.out.println("Found " + orders.size() + " orders for user " + currentUser.getUsername());
            
        } catch(Exception e) {
            System.out.println("Error fetching user orders: " + e.getMessage());
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - ShopCart</title>
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
        
        .nav-menu a:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .user-info {
            background: rgba(255,255,255,0.2);
            padding: 8px 15px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        /* Page Header */
        .page-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 20px;
            text-align: center;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        /* Stats Cards */
        .stats-container {
            max-width: 1200px;
            margin: -30px auto 30px;
            padding: 0 20px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 1.8rem;
            font-weight: bold;
            color: #4CAF50;
        }
        
        .stat-card .label {
            color: #666;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        /* Orders Container */
        .orders-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .order-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .order-id {
            font-size: 1.2rem;
            font-weight: 600;
            color: #4CAF50;
        }
        
        .order-date {
            color: #666;
            font-size: 0.9rem;
        }
        
        .order-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .order-details {
            padding: 15px 0;
        }
        
        .order-items {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-name {
            font-weight: 500;
            color: #333;
        }
        
        .item-price {
            color: #28a745;
            font-weight: 500;
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .order-total {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
        }
        
        .order-total span {
            color: #28a745;
        }
        
        .view-btn {
            padding: 8px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .view-btn:hover {
            background: #2E7D32;
            transform: translateY(-2px);
        }
        
        .empty-orders {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .empty-orders .icon {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ccc;
        }
        
        .empty-orders h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .empty-orders p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .shop-now-btn {
            display: inline-block;
            padding: 12px 30px;
            background: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: background-color 0.3s;
        }
        
        .shop-now-btn:hover {
            background: #2E7D32;
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
            margin-bottom: 10px;
        }
        
        .footer-section ul li a {
            color: #ccc;
            text-decoration: none;
        }
        
        .footer-section ul li a:hover {
            color: #4CAF50;
        }
        
        .footer-bottom {
            background: #222;
            text-align: center;
            padding: 20px;
            border-top: 1px solid #444;
        }
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                text-align: center;
            }
            
            .order-footer {
                flex-direction: column;
                text-align: center;
            }
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
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
                <a href="Products.jsp">Products</a>
                <a href="cart.jsp">Cart</a>
                <a href="orders.jsp" class="active">My Orders</a>
                <a href="profile.jsp">Profile</a>
                <a href="LogoutServlet">Logout</a>
                <span class="user-info">👤 <%= currentUser.getUsername() %></span>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <section class="page-header">
        <h1>My Orders</h1>
        <p>Track and manage your orders</p>
    </section>

    <!-- Statistics Cards -->
    <div class="stats-container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon">📦</div>
                <div class="value"><%= orders.size() %></div>
                <div class="label">Total Orders</div>
            </div>
            <div class="stat-card">
                <div class="icon">💰</div>
                <div class="value">₹<%= String.format("%,.2f", totalSpent) %></div>
                <div class="label">Total Spent</div>
            </div>

            <div class="stat-card">
                <div class="icon">✅</div>
                <div class="value"><%= deliveredOrders %></div>
                <div class="label">Delivered</div>
            </div>
        </div>
    </div>

    <!-- Orders Container -->
    <div class="orders-container">
        <% if(orders.isEmpty()) { %>
            <div class="empty-orders">
                <div class="icon">🛍️</div>
                <h3>No Orders Yet</h3>
                <p>You haven't placed any orders yet. Start shopping now!</p>
                <a href="Products.jsp" class="shop-now-btn">Shop Now</a>
            </div>
        <% } else { %>
            <% for(OrderBean order : orders) { 
                String statusClass = "";
                switch(order.getOrderStatus()) {
                    case "PENDING": statusClass = "status-pending"; break;
                    case "PROCESSING": statusClass = "status-processing"; break;
                    case "SHIPPED": statusClass = "status-shipped"; break;
                    case "DELIVERED": statusClass = "status-delivered"; break;
                    case "CANCELLED": statusClass = "status-cancelled"; break;
                }
            %>
                <div class="order-card">
                    <div class="order-header">
                        <div>
<%--                             <span class="order-id">Order #<%= order.getOrderId() %></span> --%>
                            <span class="order-date">Placed on <%= order.getOrderDate() %></span>
                        </div>
                        <span class="order-status <%= statusClass %>"><%= order.getOrderStatus() %></span>
                    </div>
                    
                    <div class="order-details">
                        <div class="order-items">
                            <% List<OrderItemBean> items = order.getItems(); 
                               if(items != null && !items.isEmpty()) {
                                   for(OrderItemBean item : items) { %>
                                        <div class="order-item">
                                            <span class="item-name"><%= item.getProductName() %> x <%= item.getQuantity() %></span>
                                            <span class="item-price">₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></span>
                                        </div>
                            <%     }
                               } else { %>
                                <div class="order-item">
                                    <span class="item-name">Loading items...</span>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="order-footer">
                            <div class="order-total">
                                Total: <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                            </div>
                            <a href="orderDetails.jsp?orderId=<%= order.getOrderId() %>" class="view-btn">View Details</a>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>
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
            <p>&copy; 2025 ShopCart. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>