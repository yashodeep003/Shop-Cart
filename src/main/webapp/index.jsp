<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.daoImpl.*, com.dao.* , com.beans.*, java.util.*, java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>




<%


// Get DAO object from application context (set by ControllerServlet)
DAOInterface DAOobj = (DAOInterface) application.getAttribute("DAOobj");

// If DAOobj is still null, try to get it from session or create with connection
if(DAOobj == null) {
    // Try to get connection from application context
    Connection con = (Connection) application.getAttribute("DBCon");
    
    if(con != null) {
        // Create new DAO and set connection
        DAOobj = new com.daoImpl.DAO();
        ((com.daoImpl.DAO)DAOobj).setCon(con);
        // Store it back in application context
        application.setAttribute("DAOobj", DAOobj);
        System.out.println("Created new DAO object and set connection");
    } else {
        // If no connection, show error
        %>
        <div style="max-width: 600px; margin: 100px auto; padding: 30px; background: #f8d7da; color: #721c24; border-radius: 10px; text-align: center;">
            <h2>Database Connection Error</h2>
            <p>Unable to connect to the database. Please try again later.</p>
            <p>Technical details: Database connection not available in application context</p>
            <a href="signIn.jsp" style="display: inline-block; margin-top: 20px; padding: 10px 30px; background: #721c24; color: white; text-decoration: none; border-radius: 5px;">Go to Login</a>
        </div>
        <%
        return;
    }
}

// Get products
List<ProductBean> products = null;
try {
    products = DAOobj.getAllProducts();
} catch(Exception e) {
    System.out.println("Error fetching products: " + e.getMessage());
    e.printStackTrace();
}

if(products == null) {
    products = new ArrayList<ProductBean>();
}

// Debug: Check images directory
try {
    String imagePath = application.getRealPath("/images");
    System.out.println("Images directory absolute path: " + imagePath);
    
    java.io.File imagesDir = new java.io.File(imagePath);
    if(imagesDir.exists()) {
        String[] files = imagesDir.list();
        System.out.println("Files in images directory:");
        if(files != null) {
            for(String file : files) {
                System.out.println("  - " + file);
            }
        }
    } else {
        System.out.println("Images directory does not exist! Creating...");
        imagesDir.mkdirs();
    }
} catch(Exception e) {
    System.out.println("Error checking images directory: " + e.getMessage());
}
%>



<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - ShopCart</title>
<!--     <link rel="stylesheet" type="text/css" href="Product.css"> -->
	<link rel="stylesheet" type="text/css" href="index.css"> 
    
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="nav-container">
        <div class="nav-logo">
            <a href="index.jsp">🛍️ShopCart</a>
        </div>
        
        <div class="nav-search">
            <input type="text" placeholder="Search products..." id="searchInput">
            <button class="search-btn" onclick="searchProducts()">🔍Search</button>
        </div>
        
        <div class="nav-menu">
            <a href="index.jsp" class="active">Home</a>
            <a href="signIn.jsp">Cart</a>
            <a href="signIn.jsp">MyProfile</a>
            <a href="signIn.jsp">MyOrders</a>
            <a href="signIn.jsp">LogIn</a>
            <span class="user-greeting">👤</span>
        </div>
    </div>
</nav>

    <!-- Hero Section -->
    <section class="heroo">
        <div class="hero-containerr">
            <h1>Welcome to ShopCart</h1>
            <p>Discover amazing products at the best prices</p>
            
            <div class="search-boxx">
                <input type="text" id="searchInput2" placeholder="Search products..." onkeyup="searchProducts2()">
                <button  class="search-btnn" onclick="searchProducts2()"  >Search </button>
            </div>
        </div>
    </section>

<!-- Products Section -->
<section class="products">
    <div class="products-header">
        <h2>Available Products</h2>
        <span class="product-count"><%= products.size() %> products found</span>
    </div>
    
    <% if(products.isEmpty()) { %>
        <div class="no-products">
            <p>No products available at the moment.</p>
        </div>
    <% } else { %>
        <div class="product-grid" id="productGrid">
            <% for (ProductBean product : products) { 
                // Convert quantity to int for comparison
                int quantity = 0;
                String quantityStr = product.getP_Quantity();
                if(quantityStr != null && !quantityStr.trim().isEmpty()) {
                    try {
                        quantity = Integer.parseInt(quantityStr);
                    } catch(NumberFormatException e) {
                        quantity = 0;
                    }
                }
                
                // Convert price to double for formatting
                double price = 0.0;
                String priceStr = product.getP_Price();
                if(priceStr != null && !priceStr.trim().isEmpty()) {
                    try {
                        price = Double.parseDouble(priceStr);
                    } catch(NumberFormatException e) {
                        price = 0.0;
                    }
                }
                
                // Check if image exists
                String imageName = product.getP_Image();
                boolean hasImage = imageName != null && !imageName.trim().isEmpty() && !"null".equals(imageName);
            %>
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <% if(hasImage) { %>
                            <img src="${pageContext.request.contextPath}/images/<%= imageName %>" 
                                 alt="<%= product.getP_Name() %>" 
                                 class="product-image"
                                 onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div class=\'image-placeholder\'><span class=\'product-icon\'>📱</span></div>';">
                        <% } else { %>
                            <div class="image-placeholder">
                                <span class="product-icon">📱</span>
                            </div>
                        <% } %>
                        
                        <% if(quantity <= 5 && quantity > 0) { %>
                            <span class="stock-badge low-stock">Only <%= quantity %> left!</span>
                        <% } else if(quantity == 0) { %>
                            <span class="stock-badge out-of-stock">Out of Stock</span>
                        <% } %>
                    </div>
                    
                    <div class="product-info">
                        <h3 class="product-title"><%= product.getP_Name() %></h3>
                        
                        <div class="product-details">
                            <span class="product-id">ID: #<%= product.getP_ID() %></span>
                            <span class="product-quantity">Stock: <%= quantity %></span>
                        </div>
                        
                        <div class="product-price-section">
                            <span class="product-price">₹<%= String.format("%.2f", price) %></span>
                            
                            <% if(quantity > 0) { %>
                                <form action="AddToCartServlet" method="post" class="add-to-cart-form">
                                    <input type="hidden" name="productId" value="<%= product.getP_ID() %>">
                                    <input type="hidden" name="quantity" value="1">
                                   
                                    <a href="signIn.jsp">Add to Cart</a>
                                    <br>
                                    <a href="signIn.jsp">Buy Now</a>
                                   
                                     
                                </form>
                            <% } else { %>
                                <button class="out-of-stock-btn" disabled>Out of Stock</button>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</section>


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
                <h4>Contact Info :</h4>
                <ul>
                    <li>📧 support@shopCart.com</li>
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