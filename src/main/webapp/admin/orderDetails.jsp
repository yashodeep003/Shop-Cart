<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*" %>

<%
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
    
    // Get order ID from request
    String orderIdParam = request.getParameter("id");
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
    
    if(order == null) {
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
    <title>Order Details #<%= order.getOrderId() %> - Admin Panel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: #f5f7fa;
        }
        
        /* Admin Header */
        .admin-header {
            background: linear-gradient(135deg, #1e293b, #0f172a);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .logo h1 {
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        .logo span {
            color: #fbbf24;
        }
        
        .admin-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .admin-badge {
            background: rgba(255,255,255,0.1);
            padding: 8px 20px;
            border-radius: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .logout-btn {
            background: #ef4444;
            color: white;
            padding: 8px 20px;
            border-radius: 40px;
            text-decoration: none;
        }
        
        /* Main Container */
        .main-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 25px;
        }
        
        /* Order Header */
        .order-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .order-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .order-title h2 {
            font-size: 1.8rem;
            color: #1e293b;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 40px;
            font-size: 0.9rem;
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
        
        .status-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
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
        
        /* Customer Section */
        .customer-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .section-title {
            font-size: 1.3rem;
            color: #1e293b;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
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
            border-left: 4px solid #3b82f6;
        }
        
        .detail-label {
            color: #64748b;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .detail-value {
            color: #1e293b;
            font-size: 1.2rem;
            font-weight: 600;
        }
        
        /* Items Section */
        .items-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .items-table th {
            text-align: left;
            padding: 15px;
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .items-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .items-table tr:last-child td {
            border-bottom: none;
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
        
        /* Shipping Section */
        .shipping-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
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
            margin-top: 30px;
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
            background: #3b82f6;
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
            color: #3b82f6;
            text-decoration: none;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .customer-details {
                grid-template-columns: 1fr;
            }
            
            .order-title {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

    <header class="admin-header">
        <div class="header-container">
            <div class="logo">
                <h1>🛍️ Shop<span>Cart</span> Admin</h1>
            </div>
            <div class="admin-info">
                <div class="admin-badge">👑 <%= adminUser %></div>
                <a href="../LogoutServlet" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="main-container">
        
        <!-- Order Header -->
        <div class="order-header">
            <div class="order-title">
                <h2>Order #<%= order.getOrderId() %></h2>
                <span class="status-badge status-<%= order.getOrderStatus().toLowerCase() %>">
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
                    <div class="meta-icon">💰</div>
                    <div class="meta-content">
                        <h4>Total Amount</h4>
                        <p>₹<%= String.format("%,.2f", order.getTotalAmount()) %></p>
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
                    <div class="meta-icon">💵</div>
                    <div class="meta-content">
                        <h4>Payment Status</h4>
                        <p><%= order.getPaymentStatus() %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Customer Information -->
        <div class="customer-section">
            <h3 class="section-title">👤 Customer Information</h3>
            <div class="customer-details">
                <div class="detail-item">
                    <div class="detail-label">Customer Name</div>
                    <div class="detail-value">
                        <%= order.getUserName() != null ? order.getUserName() : "N/A" %>
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="detail-label">Customer ID</div>
                    <div class="detail-value">#<%= order.getUserId() %></div>
                </div>
                
                <div class="detail-item">
                    <div class="detail-label">Phone Number</div>
                    <div class="detail-value">
                        <%= order.getPhone() != null && !order.getPhone().isEmpty() ? order.getPhone() : "N/A" %>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Order Items -->
        <div class="items-section">
            <h3 class="section-title">🛍️ Order Items</h3>
            
            <% if(items.isEmpty()) { %>
                <p style="text-align: center; padding: 40px; color: #64748b;">No items found for this order.</p>
            <% } else { %>
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(OrderItemBean item : items) { %>
                        <tr>
                            <td><strong><%= item.getProductName() %></strong></td>
                            <td>₹<%= String.format("%.2f", item.getPrice()) %></td>
                            <td><%= item.getQuantity() %></td>
                            <td><strong>₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></strong></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
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
            <a href="dashboard.jsp" class="btn btn-primary">Dashboard</a>
        </div>
    </div>

</body>
</html>