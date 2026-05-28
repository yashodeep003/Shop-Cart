<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if(sessionUser == null || sessionUser.getAttribute("p") == null) {
        response.sendRedirect("signIn.jsp");
        return;
    }
    
    UserPojo currentUser = (UserPojo) sessionUser.getAttribute("p");
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    
    if(cart == null) {
        cart = new HashMap<>();
    }
    
    double totalAmount = 0.0;
    for(CartItem item : cart.values()) {
        totalAmount += item.getSubtotal();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - ShopCart</title>
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
        }
        
        /* Cart Container */
        .cart-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .cart-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        /* Cart Items */
        .cart-items {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .cart-header {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr;
            padding: 15px 0;
            border-bottom: 2px solid #e0e0e0;
            font-weight: 600;
            color: #333;
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .item-image {
            width: 80px;
            height: 80px;
            background: #f0f0f0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }
        
        .item-details h3 {
            font-size: 1.1rem;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-details p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #e0e0e0;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .quantity-btn:hover {
            background: #f0f0f0;
        }
        
        .quantity-input {
            width: 50px;
            text-align: center;
            padding: 5px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
        }
        
        .item-price, .item-total {
            font-weight: 600;
            color: #28a745;
        }
        
        .remove-btn {
            color: #ff6b6b;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
        }
        
        /* Cart Summary */
        .cart-summary {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            height: fit-content;
        }
        
        .cart-summary h2 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            color: #666;
        }
        
        .summary-row.total {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            border-top: 2px solid #e0e0e0;
            margin-top: 15px;
            padding-top: 20px;
        }
        
        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            margin: 20px 0;
            transition: transform 0.3s;
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
        }
        
        .continue-shopping {
            display: block;
            text-align: center;
            color: #667eea;
            text-decoration: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px;
        }
        
        .empty-cart h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 20px;
        }
        
        .empty-cart p {
            color: #666;
            margin-bottom: 30px;
        }
        
        .shop-now-btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .cart-grid {
                grid-template-columns: 1fr;
            }
            
            .cart-header {
                display: none;
            }
            
            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .item-info {
                flex-direction: column;
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
        <h1>Shopping Cart</h1>
    </section>

    <!-- Cart Container -->
    <div class="cart-container">
        <% if(cart.isEmpty()) { %>
            <div class="empty-cart">
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added any items to your cart yet.</p>
                <a href="Products.jsp" class="shop-now-btn">Continue Shopping</a>
            </div>
        <% } else { %>
            <div class="cart-grid">
            
                <!-- Cart Items -->
                <div class="cart-items">
                    <div class="cart-header">
                        <div>Product</div>
                        <div>Price</div>
                        <div>Quantity</div>
                        <div>Total</div>
                    </div>
                    
                    <% for(CartItem item : cart.values()) { 
                        double price = 0.0;
                        try {
                            price = Double.parseDouble(item.getProduct().getP_Price());
                        } catch(NumberFormatException e) {}
                    %>
                    <div class="cart-item">
                        <div class="item-info">
                            <div class="item-image">📦</div>
                            <div class="item-details">
                                <h3><%= item.getProduct().getP_Name() %></h3>
                                <p>ID: #<%= item.getProduct().getP_ID() %></p>
                            </div>
                        </div>
                        
                        <div class="item-price">₹<%= String.format("%.2f", price) %></div>
                        
                        <div class="item-quantity">
                            <form action="UpdateCartServlet" method="post" style="display: flex; gap: 5px;">
                                <input type="hidden" name="productId" value="<%= item.getProduct().getP_ID() %>">
                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                       min="1" max="<%= item.getProduct().getP_Quantity() %>" class="quantity-input">
                                <button type="submit" class="quantity-btn">✓</button>
                            </form>
                        </div>
                        
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span class="item-total">₹<%= String.format("%.2f", item.getSubtotal()) %></span>
                            <form action="RemoveFromCartServlet" method="post">
                                <input type="hidden" name="productId" value="<%= item.getProduct().getP_ID() %>">
                                <button type="submit" class="remove-btn" title="Remove">🗑️Remove</button>
                            </form>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Cart Summary -->
                <div class="cart-summary">
                    <h2>Order Summary</h2>
                    
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<%= String.format("%.2f", totalAmount) %></span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span><%= totalAmount >= 500 ? "FREE" : "₹50" %></span>
                    </div>
                    
                    <% double shippingCharge = totalAmount >= 500 ? 0 : 50; %>
                    
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>₹<%= String.format("%.2f", totalAmount + shippingCharge) %></span>
                    </div>
                    
                    <form action="checkout.jsp" method="get">
                        <button type="submit" class="checkout-btn">Proceed to Checkout</button>
                    </form>
                    
                    <a href="Products.jsp" class="continue-shopping">← Continue Shopping</a>
                </div>
            </div>
        <% } %>
    </div>

</body>
</html>