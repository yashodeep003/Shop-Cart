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
    
    // Get order from session (set by ProcessPaymentServlet)
    OrderBean order = (OrderBean) session.getAttribute("lastOrder");
    
    // If no order in session, generate a sample order for display
    if(order == null) {
        order = new OrderBean();
        order.setOrderId(1001);
        order.setOrderDate(new java.util.Date().toString());
        order.setTotalAmount(1250.00);
        order.setPaymentMethod("Credit Card");
        order.setPaymentStatus("COMPLETED");
        order.setOrderStatus("PROCESSING");
        order.setShippingAddress("123 Main Street, Andheri East, Mumbai - 400001, India");
        order.setPhone("9876543210");
        
       
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - ShopCart</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .confirmation-container {
            max-width: 700px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            overflow: hidden;
            animation: slideInUp 0.6s ease;
        }
        
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Success Header */
        .success-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .success-header::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .success-header::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .checkmark-circle {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 3rem;
            color: #28a745;
            animation: pulse 1.5s infinite;
            position: relative;
            z-index: 2;
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(255,255,255,0.7);
            }
            50% {
                transform: scale(1.1);
                box-shadow: 0 0 20px 10px rgba(255,255,255,0.3);
            }
        }
        
        .success-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
        }
        
        .success-header p {
            font-size: 1.2rem;
            opacity: 0.95;
            position: relative;
            z-index: 2;
        }
        
        .order-number {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 50px;
            margin-top: 15px;
            font-size: 1rem;
            font-weight: 600;
            position: relative;
            z-index: 2;
            backdrop-filter: blur(5px);
        }
        
        /* Confirmation Body */
        .confirmation-body {
            padding: 40px;
        }
        
        /* Order Info Cards */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            transition: transform 0.3s;
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .info-icon {
            font-size: 1.8rem;
            margin-bottom: 10px;
        }
        
        .info-label {
            color: #666;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
        }
        
        .info-value.small {
            font-size: 1rem;
        }
        
        .payment-status {
            color: #28a745;
            background: #d4edda;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 0.9rem;
            display: inline-block;
        }
        
        .order-status {
            color: #ff9800;
            background: #fff3cd;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 0.9rem;
            display: inline-block;
        }
        
        /* Order Items */
        .order-items-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .order-items-section h3 {
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.3rem;
        }
        
        .order-items-section h3 span {
            background: #667eea;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }
        
        .items-list {
            margin-bottom: 20px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-meta {
            display: flex;
            gap: 15px;
            color: #666;
            font-size: 0.9rem;
        }
        
        .item-price {
            font-weight: 600;
            color: #28a745;
            font-size: 1.1rem;
        }
        
        .item-total {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        
        /* Price Breakdown */
        .price-breakdown {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            color: #666;
        }
        
        .price-row.total {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            border-top: 2px solid #e0e0e0;
            margin-top: 10px;
            padding-top: 20px;
        }
        
        /* Shipping Address */
        .shipping-section {
            background: #e3f2fd;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border-left: 4px solid #2196f3;
        }
        
        .shipping-section h3 {
            color: #1976d2;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .shipping-details {
            line-height: 1.8;
            color: #555;
        }
        
        .shipping-details strong {
            color: #333;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-width: 200px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }
        
        .btn-secondary {
            background: #f0f0f0;
            color: #333;
        }
        
        .btn-secondary:hover {
            background: #e0e0e0;
            transform: translateY(-3px);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }
        
        /* Print Button */
        .print-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-left: auto;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .confirmation-body {
                padding: 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .success-header h1 {
                font-size: 2rem;
            }
        }
        
        /* Print styles */
        @media print {
            .action-buttons, .print-btn, .navbar, footer {
                display: none;
            }
            
            .confirmation-container {
                box-shadow: none;
                border: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>

    <div class="confirmation-container">
        <!-- Success Header -->
        <div class="success-header">
            <div class="checkmark-circle">✓</div>
            <h1>Order Confirmed!</h1>
            <p>Thank you for your purchase, <%= currentUser.getUsername() %>!</p>
            <div class="order-number">Order #<%= order.getOrderId() %></div>
        </div>
        
        <!-- Confirmation Body -->
        <div class="confirmation-body">
            
            <!-- Order Info Grid -->
            <div class="info-grid">
                <div class="info-card">
                    <div class="info-icon">📅</div>
                    <div class="info-label">Order Date</div>
                    <div class="info-value"><%= order.getOrderDate() %></div>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">💳</div>
                    <div class="info-label">Payment Method</div>
                    <div class="info-value"><%= order.getPaymentMethod() %></div>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">💰</div>
                    <div class="info-label">Payment Status</div>
                    <div class="info-value">
                        <span class="payment-status"><%= order.getPaymentStatus() %></span>
                    </div>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">📦</div>
                    <div class="info-label">Order Status</div>
                    <div class="info-value">
                        <span class="order-status"><%= order.getOrderStatus() %></span>
                    </div>
                </div>
            </div>
            
            <!-- Order Items -->
            <div class="order-items-section">
                <h3>
                    <span>📋</span>
                    Order Summary
                </h3>
                
                <div class="items-list">
                    <% 
                    double subtotal = 0;
                    for(OrderItemBean item : order.getItems()) { 
                        subtotal += item.getPrice() * item.getQuantity();
                    %>
                    <div class="order-item">
                        <div class="item-details">
                            <div class="item-name"><%= item.getProductName() %></div>
                            <div class="item-meta">
                                <span>Quantity: <%= item.getQuantity() %></span>
                                <span>Price: ₹<%= String.format("%.2f", item.getPrice()) %></span>
                            </div>
                        </div>
                        <div class="item-total">
                            ₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Price Breakdown -->
                <div class="price-breakdown">
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
                <h3>🚚 Shipping Address</h3>
                <div class="shipping-details">
                    <strong><%= currentUser.getUsername() %></strong><br>
                    <%= order.getShippingAddress() %><br>
                    <strong>Phone:</strong> <%= order.getPhone() %>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="orders.jsp" class="btn btn-primary">📋 View My Orders</a>
                <a href="Products.jsp" class="btn btn-success">🛍️ Continue Shopping</a>
                <button onclick="window.print()" class="btn btn-secondary">🖨️ Print Receipt</button>
            </div>
            
           
            
            <!-- Track Order Link -->
            <div style="text-align: center; margin-top: 20px;">
                <a href="orders.jsp" style="color: #667eea; text-decoration: none; font-weight: 500;">
                    Track Your Order →
                </a>
            </div>
        </div>
    </div>

   

</body>
</html>