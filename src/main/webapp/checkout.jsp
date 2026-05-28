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
    
    // Get cart from session
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    
    if(cart == null || cart.isEmpty()) {
        response.sendRedirect("Products.jsp");
        return;
    }
    
    // Calculate totals
    double subtotal = 0.0;
    for(CartItem item : cart.values()) {
        subtotal += item.getSubtotal();
    }
    
    double shippingCharge = subtotal >= 500 ? 0 : 50;
    double tax = subtotal * 0.05;
    double total = subtotal + shippingCharge + tax;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - ShopCart</title>
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
            font-size: 3rem;
            margin-bottom: 10px;
        }
        
        .page-header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        /* Checkout Container */
        .checkout-container {
            max-width: 1200px;
            margin: -40px auto 50px;
            padding: 0 20px;
            position: relative;
            z-index: 10;
        }
        
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 30px;
        }
        
        /* Order Summary Card */
        .order-summary {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        
        .summary-title {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .summary-items {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
            padding-right: 10px;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
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
            font-size: 0.9rem;
            color: #666;
        }
        
        .item-price {
            font-weight: 600;
            color: #28a745;
            font-size: 1.1rem;
        }
        
        .price-breakdown {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            color: #666;
            border-bottom: 1px dashed #e0e0e0;
        }
        
        .price-row:last-child {
            border-bottom: none;
        }
        
        .price-row.total {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            border-top: 2px solid #e0e0e0;
            margin-top: 10px;
            padding-top: 20px;
        }
        
        /* Checkout Form */
        .checkout-form {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        
        .form-title {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .form-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .section-header h3 {
            font-size: 1.2rem;
            color: #444;
        }
        
        .section-icon {
            width: 35px;
            height: 35px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group input:hover,
        .form-group textarea:hover,
        .form-group select:hover {
            border-color: #999;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        /* Proceed Button */
        .proceed-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .proceed-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .proceed-btn:active {
            transform: translateY(0);
        }
        
        .proceed-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        /* Back Link */
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .back-link:hover {
            color: #764ba2;
            text-decoration: underline;
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
        
        @media (max-width: 968px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
            
            .order-summary {
                position: static;
            }
        }
        
        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 2.5rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .nav-container {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }
            
            .nav-menu {
                flex-wrap: wrap;
                justify-content: center;
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
                <span class="user-info">
                    👤 <%= currentUser.getUsername() %>
                </span>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <section class="page-header">
        <h1>Checkout</h1>
        <p>Complete your purchase</p>
    </section>

    <!-- Checkout Container -->
    <div class="checkout-container">
        <div class="checkout-grid">
            
            <!-- Order Summary Column -->
            <div class="order-summary">
                <h2 class="summary-title">
                    <span>📋</span> Order Summary
                </h2>
                
                <div class="summary-items">
                    <% for(CartItem item : cart.values()) { 
                        double price = 0.0;
                        try {
                            price = Double.parseDouble(item.getProduct().getP_Price());
                        } catch(NumberFormatException e) {}
                    %>
                    <div class="summary-item">
                        <div class="item-details">
                            <div class="item-name"><%= item.getProduct().getP_Name() %></div>
                            <div class="item-meta">Qty: <%= item.getQuantity() %></div>
                        </div>
                        <div class="item-price">₹<%= String.format("%.2f", price * item.getQuantity()) %></div>
                    </div>
                    <% } %>
                </div>
                
                <div class="price-breakdown">
                    <div class="price-row">
                        <span>Subtotal</span>
                        <span>₹<%= String.format("%.2f", subtotal) %></span>
                    </div>
                    <div class="price-row">
                        <span>Shipping</span>
                        <span><%= shippingCharge == 0 ? "FREE" : "₹" + String.format("%.2f", shippingCharge) %></span>
                    </div>
                    <div class="price-row">
                        <span>Tax (5%)</span>
                        <span>₹<%= String.format("%.2f", tax) %></span>
                    </div>
                    <div class="price-row total">
                        <span>Total</span>
                        <span>₹<%= String.format("%.2f", total) %></span>
                    </div>
                </div>
            </div>
            
            <!-- Checkout Form Column - Only Personal Details and Shipping Address -->
            <div class="checkout-form">
                <h2 class="form-title">
                    <span>✏️</span> Shipping Information
                </h2>
                
                <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post" id="checkoutForm">
                    
                    <!-- Personal Details Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">👤</div>
                            <h3>Personal Details</h3>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">First Name *</label>
                                <input type="text" id="firstName" name="firstName" 
                                       value="<%= currentUser.getUsername() %>" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="lastName">Last Name *</label>
                                <input type="text" id="lastName" name="lastName" placeholder="Enter last name" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email Address *</label>
                                <input type="email" id="email" name="email" 
                                       value="<%= currentUser.getUsername() %>@example.com" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">Phone Number *</label>
                                <input type="tel" id="phone" name="phone" placeholder="9876543210" required>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Shipping Address Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">🏠</div>
                            <h3>Shipping Address</h3>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Street Address *</label>
                            <input type="text" id="address" name="address" placeholder="123 Main Street" required>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="city">City *</label>
                                <input type="text" id="city" name="city" placeholder="Mumbai" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="state">State *</label>
                                <input type="text" id="state" name="state" placeholder="Maharashtra" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="pincode">Pin Code *</label>
                                <input type="text" id="pincode" name="pincode" placeholder="400001" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="country">Country *</label>
                                <select id="country" name="country" required>
                                    <option value="">Select Country</option>
                                    <option value="India" selected>India</option>
                                    <option value="USA">USA</option>
                                    <option value="UK">UK</option>
                                    <option value="Canada">Canada</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hidden Fields -->
                    <input type="hidden" name="totalAmount" value="<%= total %>">
                    <input type="hidden" name="subtotal" value="<%= subtotal %>">
                    <input type="hidden" name="shippingCharge" value="<%= shippingCharge %>">
                    <input type="hidden" name="tax" value="<%= tax %>">
                    
                    <!-- Proceed to Payment Button -->
                    <button type="submit" class="proceed-btn" onclick="return validateForm()">
                        <span>🔒</span> Proceed to Payment • ₹<%= String.format("%.2f", total) %>
                    </button>
                    
                    <a href="cart.jsp" class="back-link">← Return to Cart</a>
                </form>
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
            <p>&copy; 2026 ShopCart. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript -->
<script>
    function validateForm() {
        let firstName = document.getElementById('firstName').value.trim();
        let lastName = document.getElementById('lastName').value.trim();
        let phone = document.getElementById('phone').value.trim();
        let address = document.getElementById('address').value.trim();
        let city = document.getElementById('city').value.trim();
        let pincode = document.getElementById('pincode').value.trim();
        
        if(!firstName) {
            alert('Please enter your first name');
            return false;
        }
        
        if(!lastName) {
            alert('Please enter your last name');
            return false;
        }
        
        let phoneRegex = /^[0-9]{10}$/;
        if(!phoneRegex.test(phone)) {
            alert('Please enter a valid 10-digit phone number');
            return false;
        }
        
        if(!address) {
            alert('Please enter your address');
            return false;
        }
        
        if(!city) {
            alert('Please enter your city');
            return false;
        }
        
        let pincodeRegex = /^[0-9]{6}$/;
        if(!pincodeRegex.test(pincode)) {
            alert('Please enter a valid 6-digit pin code');
            return false;
        }
        
       
        
        // Log that form is being submitted
        console.log('Form validation passed, submitting form...');
        
        // Return true to allow form submission
        return true;
    }
    
    // Add this to ensure form submission is not blocked
    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        console.log('Form submit event triggered');
        console.log('Action URL:', this.action);
        console.log('Method:', this.method);
        
        // Let the form submit normally
        return true;
    });
    
    // Debug - check if form action is correct
    console.log('Form action:', document.getElementById('checkoutForm').action);
</script>

</body>
</html>