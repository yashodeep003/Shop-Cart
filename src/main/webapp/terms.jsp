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
    <title>Terms & Conditions - ShopCart</title>
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
            max-width: 900px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        /* Terms Container */
        .terms-container {
            background: white;
            border-radius: 15px;
            padding: 50px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .last-updated {
            color: #667eea;
            font-size: 0.95rem;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .terms-section {
            margin-bottom: 40px;
        }
        
        .terms-section h2 {
            font-size: 1.6rem;
            color: #333;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .terms-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .terms-section h3 {
            font-size: 1.2rem;
            color: #444;
            margin: 20px 0 10px;
        }
        
        .terms-section p {
            color: #666;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .terms-section ul, .terms-section ol {
            margin-left: 20px;
            margin-bottom: 20px;
            color: #666;
            line-height: 1.8;
        }
        
        .terms-section li {
            margin-bottom: 8px;
        }
        
        .terms-section .highlight {
            background: #f0f4ff;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            margin: 20px 0;
        }
        
        .terms-section table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        .terms-section th, .terms-section td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .terms-section th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        /* Acceptance Section */
        .acceptance-section {
            margin-top: 40px;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 10px;
            text-align: center;
        }
        
        .acceptance-section p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .accept-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }
        
        .accept-btn:hover {
            transform: translateY(-2px);
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
            .page-header h1 {
                font-size: 2rem;
            }
            
            .terms-container {
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
        <h1>Terms & Conditions</h1>
        <p>Please read these terms carefully before using our services</p>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        
        <div class="terms-container">
            <div class="last-updated">
                Last Updated: March 15, 2024
            </div>
            
            <!-- Introduction -->
            <div class="terms-section">
                <h2>1. Introduction</h2>
                <p>Welcome to ShopCart. By accessing or using our website and services, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, please do not use our services.</p>
                
                <div class="highlight">
                    <p><strong>Important:</strong> These terms constitute a legally binding agreement between you and ShopCart regarding your use of our e-commerce platform.</p>
                </div>
            </div>
            
            <!-- Definitions -->
            <div class="terms-section">
                <h2>2. Definitions</h2>
                <ul>
                    <li><strong>"Platform"</strong> refers to the ShopCart website and mobile application.</li>
                    <li><strong>"User", "You", "Your"</strong> refers to the individual accessing our platform.</li>
                    <li><strong>"Seller"</strong> refers to merchants selling products through our platform.</li>
                    <li><strong>"Products"</strong> refers to items listed for sale on our platform.</li>
                    <li><strong>"Order"</strong> refers to a purchase request made by a user.</li>
                </ul>
            </div>
            
            <!-- Account Registration -->
            <div class="terms-section">
                <h2>3. Account Registration</h2>
                <p>To access certain features, you must register for an account. You agree to:</p>
                <ul>
                    <li>Provide accurate and complete information</li>
                    <li>Maintain the security of your account credentials</li>
                    <li>Promptly update any changes to your information</li>
                    <li>Notify us of any unauthorized account use</li>
                </ul>
                <p>You are responsible for all activities under your account. We reserve the right to suspend or terminate accounts that violate these terms.</p>
            </div>
            
            <!-- Product Listings -->
            <div class="terms-section">
                <h2>4. Product Listings</h2>
                <p>We strive to display accurate product information, but:</p>
                <ul>
                    <li>Product images are for illustration purposes only</li>
                    <li>Colors and specifications may vary slightly</li>
                    <li>Prices are subject to change without notice</li>
                    <li>Availability is not guaranteed until order confirmation</li>
                </ul>
                
                <h3>Product Categories</h3>
                <table>
                    <tr>
                        <th>Category</th>
                        <th>Return Period</th>
                        <th>Warranty</th>
                    </tr>
                    <tr>
                        <td>Electronics</td>
                        <td>15 days</td>
                        <td>1 year</td>
                    </tr>
                    <tr>
                        <td>Clothing</td>
                        <td>30 days</td>
                        <td>No warranty</td>
                    </tr>
                    <tr>
                        <td>Books</td>
                        <td>15 days</td>
                        <td>No warranty</td>
                    </tr>
                </table>
            </div>
            
            <!-- Pricing and Payment -->
            <div class="terms-section">
                <h2>5. Pricing and Payment</h2>
                <p>All prices are in Indian Rupees (₹) and include applicable taxes unless stated otherwise. We accept various payment methods as listed during checkout.</p>
                
                <h3>Payment Terms:</h3>
                <ul>
                    <li>Payment must be received before order processing</li>
                    <li>We use secure third-party payment processors</li>
                    <li>Cash on Delivery (COD) is available for orders under ₹10,000</li>
                    <li>A convenience fee may apply for certain payment methods</li>
                </ul>
            </div>
            
            <!-- Shipping and Delivery -->
            <div class="terms-section">
                <h2>6. Shipping and Delivery</h2>
                <ul>
                    <li>Estimated delivery times are provided at checkout</li>
                    <li>We are not responsible for delays beyond our control</li>
                    <li>Risk of loss passes to you upon delivery</li>
                    <li>International shipping is currently not available</li>
                </ul>
                
                <div class="highlight">
                    <p><strong>Shipping Charges:</strong> Free shipping on orders above ₹500. Standard shipping ₹50 for orders below ₹500.</p>
                </div>
            </div>
            
            <!-- Returns and Refunds -->
            <div class="terms-section">
                <h2>7. Returns and Refunds</h2>
                <p>Our return policy allows returns within 30 days of delivery under the following conditions:</p>
                <ul>
                    <li>Products must be unused and in original packaging</li>
                    <li>Return shipping is borne by the customer for non-defective items</li>
                    <li>Refunds are processed within 7-10 business days</li>
                    <li>Certain items (like hygiene products) cannot be returned</li>
                </ul>
                
                <h3>Refund Process:</h3>
                <ol>
                    <li>Initiate return through your account</li>
                    <li>Pack the item securely with original tags</li>
                    <li>Ship to our returns center</li>
                    <li>Inspection within 2-3 business days</li>
                    <li>Refund credited to original payment method</li>
                </ol>
            </div>
            
            <!-- User Conduct -->
            <div class="terms-section">
                <h2>8. User Conduct</h2>
                <p>You agree not to:</p>
                <ul>
                    <li>Use the platform for any illegal purpose</li>
                    <li>Violate any intellectual property rights</li>
                    <li>Transmit harmful code or malware</li>
                    <li>Attempt to gain unauthorized access</li>
                    <li>Harass or harm other users</li>
                    <li>Post false or misleading reviews</li>
                </ul>
            </div>
            
            <!-- Privacy -->
            <div class="terms-section">
                <h2>9. Privacy Policy</h2>
                <p>Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your personal information. By using our services, you consent to our data practices as described in the Privacy Policy.</p>
            </div>
            
            <!-- Intellectual Property -->
            <div class="terms-section">
                <h2>10. Intellectual Property</h2>
                <p>All content on this platform, including but not limited to logos, text, graphics, images, and software, is the property of ShopCart or its licensors and is protected by copyright and other intellectual property laws.</p>
            </div>
            
            <!-- Limitation of Liability -->
            <div class="terms-section">
                <h2>11. Limitation of Liability</h2>
                <p>To the maximum extent permitted by law, ShopCart shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, or use.</p>
                
                <div class="highlight">
                    <p><strong>Maximum Liability:</strong> In any event, our total liability to you shall not exceed the amount paid by you for the products purchased.</p>
                </div>
            </div>
            
            <!-- Indemnification -->
            <div class="terms-section">
                <h2>12. Indemnification</h2>
                <p>You agree to indemnify and hold harmless ShopCart, its officers, directors, employees, and agents from any claims, damages, losses, and expenses arising out of your use of the platform or violation of these terms.</p>
            </div>
            
            <!-- Termination -->
            <div class="terms-section">
                <h2>13. Termination</h2>
                <p>We may terminate or suspend your access to our platform immediately, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties, or for any other reason.</p>
            </div>
            
            <!-- Governing Law -->
            <div class="terms-section">
                <h2>14. Governing Law</h2>
                <p>These Terms shall be governed by and construed in accordance with the laws of India. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts in Pune, Maharashtra.</p>
            </div>
            
            <!-- Changes to Terms -->
            <div class="terms-section">
                <h2>15. Changes to Terms</h2>
                <p>We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting on the platform. Your continued use of the platform after changes constitutes acceptance of the modified terms.</p>
            </div>
            
            <!-- Contact Information -->
            <div class="terms-section">
                <h2>16. Contact Information</h2>
                <p>If you have any questions about these Terms, please contact us:</p>
                <ul>
                    <li>Email: legal@shopcart.com</li>
                    <li>Phone: +91 12345 67890</li>
                    <li>Address: 123 Tech Park, Cyber City, Pune, Maharashtra 411001</li>
                </ul>
            </div>
            
            <!-- Acceptance -->
            <div class="acceptance-section">
                <p>By using ShopCart, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.</p>
                <button class="accept-btn" onclick="acceptTerms()">I Accept</button>
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
                    <li><a href="terms.jsp" class="active">Terms & Conditions</a></li>
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
        function acceptTerms() {
            alert('Thank you for accepting our Terms & Conditions. You may now continue using ShopCart.');
            window.location.href = '<%= currentUser != null ? "Products.jsp" : "index.jsp" %>';
        }
    </script>

</body>
</html>