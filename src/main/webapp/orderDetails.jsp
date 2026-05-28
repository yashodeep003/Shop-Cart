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
    
    // Get order ID from request
    String orderIdParam = request.getParameter("orderId");
    int orderId = 0;
    
    if(orderIdParam != null && !orderIdParam.isEmpty()) {
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch(NumberFormatException e) {
            response.sendRedirect("orders.jsp");
            return;
        }
    } else {
        response.sendRedirect("orders.jsp");
        return;
    }
    
    // Get DAO object
    com.dao.DAOInterface DAOobj = (com.dao.DAOInterface) application.getAttribute("DAOobj");
    
    // Fetch order details
    OrderBean order = null;
    List<OrderItemBean> items = new ArrayList<>();
    
    if(DAOobj != null) {
        order = DAOobj.getOrderById(orderId);
        if(order != null) {
            items = order.getItems();
            if(items == null) items = new ArrayList<>();
        }
    }
    
    // Verify order belongs to current user
    if(order == null || order.getUserId() != currentUser.getUser_id()) {
        response.sendRedirect("orders.jsp");
        return;
    }
    
    // Calculate subtotal
    double subtotal = 0;
    for(OrderItemBean item : items) {
        subtotal += item.getPrice() * item.getQuantity();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - ShopCart</title>
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
        
        /* Main Container */
        .main-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        /* Order Header Card */
        .order-header-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .order-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .order-title h2 {
            font-size: 1.8rem;
            color: #1e293b;
        }
        
        .order-badge {
            padding: 8px 20px;
            border-radius: 40px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-processing {
            background: #cce5ff;
            color: #004085;
        }
        
        .badge-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .order-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .meta-icon {
            width: 50px;
            height: 50px;
            background: #eef2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .meta-content h4 {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .meta-content p {
            color: #1e293b;
            font-weight: 600;
        }
        
        /* ========== PRODUCTS SECTION ========== */
        .products-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 1.3rem;
            color: #1e293b;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Product List - Card Style */
        .product-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .product-card-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
            background: #f8fafc;
            border-radius: 12px;
            border-left: 4px solid #4CAF50;
            transition: transform 0.3s;
        }
        
        .product-card-item:hover {
            transform: translateX(5px);
            background: #f1f5f9;
        }
        
        .product-info {
            flex: 2;
        }
        
        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 5px;
        }
        
        .product-id {
            font-size: 0.85rem;
            color: #64748b;
        }
        
        .product-quantity {
            flex: 1;
            text-align: center;
            color: #475569;
        }
        
        .product-quantity span {
            font-weight: 600;
            color: #4CAF50;
            font-size: 1.1rem;
        }
        
        .product-price {
            flex: 1;
            text-align: right;
            font-weight: 600;
            color: #28a745;
            font-size: 1.1rem;
        }
        
        /* Product Table Style (Alternative) */
        .product-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .product-table th {
            text-align: left;
            padding: 15px;
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .product-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .product-table tr:hover td {
            background: #f8fafc;
        }
        
        /* Price Summary */
        .price-summary {
            background: #f8fafc;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed #e2e8f0;
        }
        
        .price-row:last-child {
            border-bottom: none;
        }
        
        .price-row.total {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1e293b;
            border-top: 2px solid #e2e8f0;
            margin-top: 10px;
            padding-top: 20px;
        }
        
        /* Customer Section */
        .customer-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .customer-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .detail-item {
            padding: 20px;
            background: #f8fafc;
            border-radius: 10px;
            border-left: 4px solid #4CAF50;
        }
        
        .detail-label {
            color: #64748b;
            font-size: 0.85rem;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        
        .detail-value {
            color: #1e293b;
            font-size: 1.2rem;
            font-weight: 600;
        }
        
        /* Shipping Section */
        .shipping-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .address-box {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            line-height: 1.8;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.3s;
        }
        
        .btn-primary {
            background:linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-secondary {
            background: #64748b;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #4CAF50;
            text-decoration: none;
        }
        
        @media (max-width: 768px) {
            .customer-details {
                grid-template-columns: 1fr;
            }
            
            .order-title {
                flex-direction: column;
                text-align: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                text-align: center;
            }
            
            .product-card-item {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .product-quantity, .product-price {
                text-align: center;
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

    <!-- Main Container -->
    <div class="main-container">
        
        <!-- Order Header Card -->
        <div class="order-header-card">
            <div class="order-title">
                <h2>Order #<%= order.getOrderId() %></h2>
                <span class="order-badge badge-<%= order.getOrderStatus().toLowerCase() %>">
                    <%= order.getOrderStatus() %>
                </span>
            </div>
            
            <div class="order-meta">
                <div class="meta-item">
                    <div class="meta-icon">📅</div>
                    <div class="meta-content">
                        <h4>Order Date</h4>
                        <p><%= order.getOrderDate() %></p>
                    </div>
                </div>
                
                <div class="meta-item">
                    <div class="meta-icon">💳</div>
                    <div class="meta-content">
                        <h4>Payment Method</h4>
                        <p><%= order.getPaymentMethod() %></p>
                    </div>
                </div>
                
                <div class="meta-item">
                    <div class="meta-icon">💰</div>
                    <div class="meta-content">
                        <h4>Payment Status</h4>
                        <p><%= order.getPaymentStatus() %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- ========== PRODUCTS PURCHASED SECTION ========== -->
        <div class="products-section">
            <h3 class="section-title">
                <span>🛍️</span> Products Purchased
            </h3>
            
            <% if(items.isEmpty()) { %>
                <div style="text-align: center; padding: 40px; color: #64748b;">
                    No products found for this order.
                </div>
            <% } else { %>
                
                <!-- OPTION 1: Card Style Product Display -->
                <div class="product-list">
                    <% for(OrderItemBean item : items) { %>
                        <div class="product-card-item">
                            <div class="product-info">
                                <div class="product-name">📦 <%= item.getProductName() %></div>
                                <div class="product-id">Product ID: #<%= item.getProductId() %></div>
                            </div>
                            <div class="product-quantity">
                                Quantity: <span><%= item.getQuantity() %></span>
                            </div>
                            <div class="product-price">
                                ₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                
                
                <!-- Price Summary -->
                <div class="price-summary">
                    <div class="price-row">
                        <span>Subtotal</span>
                        <span>₹<%= String.format("%.2f", subtotal) %></span>
                    </div>
                    <div class="price-row">
                        <span>Shipping</span>
                        <span><%= subtotal >= 500 ? "FREE" : "₹50.00" %></span>
                    </div>
                    <div class="price-row">
                        <span>Tax (5%)</span>
                        <span>₹<%= String.format("%.2f", subtotal * 0.05) %></span>
                    </div>
                    <div class="price-row total">
                        <span>Total Amount</span>
                        <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                    </div>
                </div>
            <% } %>
        </div>
        
        <!-- Customer Information -->
        <div class="customer-section">
            <h3 class="section-title">👤 Customer Information</h3>
            <div class="customer-details">
                <div class="detail-item">
                    <div class="detail-label">Customer Name</div>
                    <div class="detail-value"><%= currentUser.getUsername() %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Email Address</div>
                    <div class="detail-value"><%= currentUser.getUsername() %>@example.com</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Phone Number</div>
                    <div class="detail-value"><%= order.getPhone() != null ? order.getPhone() : "N/A" %></div>
                </div>
            </div>
        </div>
        
        <!-- Shipping Address -->
        <div class="shipping-section">
            <h3 class="section-title">🚚 Shipping Address</h3>
            <div class="address-box">
                <%= order.getShippingAddress() != null ? order.getShippingAddress() : "No address provided" %>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="orders.jsp" class="btn btn-secondary">← Back to Orders</a>
            <a href="Products.jsp" class="btn btn-primary">Continue Shopping</a>
            <button onclick="window.print()" class="btn btn-secondary">🖨️ Print</button>
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
                    <li style="margin-bottom: 10px;">📍 Pune, India</li>
                </ul>
            </div>
        </div>
        <div style="background: #222; text-align: center; padding: 20px; border-top: 1px solid #444;">
            <p style="color: #ccc;">&copy; 2025 ShopCart. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>