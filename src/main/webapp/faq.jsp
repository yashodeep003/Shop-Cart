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
    <title>FAQs - ShopCart</title>
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
            max-width: 1000px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        /* Search Section */
        .faq-search {
            background: white;
            border-radius: 50px;
            padding: 5px;
            display: flex;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .faq-search input {
            flex: 1;
            padding: 15px 25px;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            outline: none;
        }
        
        .faq-search button {
            padding: 15px 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: transform 0.3s;
        }
        
        .faq-search button:hover {
            transform: scale(1.05);
        }
        
        /* Categories */
        .faq-categories {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        
        .category-btn {
            padding: 10px 25px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        
        .category-btn:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .category-btn.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-color: transparent;
        }
        
        /* FAQ Accordion */
        .faq-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .faq-section h2 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .faq-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .faq-item {
            border-bottom: 1px solid #e0e0e0;
            margin-bottom: 15px;
        }
        
        .faq-question {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.3s;
            margin-bottom: 10px;
        }
        
        .faq-question:hover {
            background: #f0f0f0;
        }
        
        .faq-question h3 {
            font-size: 1.1rem;
            color: #333;
            font-weight: 500;
        }
        
        .faq-question .icon {
            font-size: 1.5rem;
            color: #667eea;
            transition: transform 0.3s;
        }
        
        .faq-question.active .icon {
            transform: rotate(45deg);
        }
        
        .faq-answer {
            padding: 0 20px 20px;
            color: #666;
            line-height: 1.8;
            display: none;
        }
        
        .faq-answer.show {
            display: block;
        }
        
        .faq-answer p {
            margin-bottom: 10px;
        }
        
        .faq-answer ul {
            margin-left: 20px;
            margin-bottom: 10px;
        }
        
        .faq-answer li {
            margin-bottom: 5px;
        }
        
        /* Still Have Questions */
        .help-section {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px;
            padding: 50px;
            text-align: center;
            margin-top: 40px;
        }
        
        .help-section h2 {
            font-size: 2rem;
            margin-bottom: 15px;
        }
        
        .help-section p {
            font-size: 1.1rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        
        .help-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .help-btn {
            padding: 15px 30px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: transform 0.3s;
        }
        
        .help-btn:hover {
            transform: translateY(-3px);
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
            
            .faq-search {
                flex-direction: column;
                border-radius: 15px;
            }
            
            .faq-search button {
                border-radius: 15px;
            }
            
            .help-buttons {
                flex-direction: column;
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
        <h1>Frequently Asked Questions</h1>
        <p>Find answers to common questions</p>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        
        <!-- Search Bar -->
        <div class="faq-search">
            <input type="text" id="faqSearch" placeholder="Search FAQs...">
            <button onclick="searchFAQs()">Search</button>
        </div>
        
        <!-- Categories -->
        <div class="faq-categories">
            <button class="category-btn active" onclick="filterCategory('all')">All</button>
            <button class="category-btn" onclick="filterCategory('orders')">Orders</button>
            <button class="category-btn" onclick="filterCategory('shipping')">Shipping</button>
            <button class="category-btn" onclick="filterCategory('returns')">Returns</button>
            <button class="category-btn" onclick="filterCategory('payment')">Payment</button>
            <button class="category-btn" onclick="filterCategory('account')">Account</button>
        </div>
        
        <!-- Orders FAQ Section -->
        <div class="faq-section" data-category="orders">
            <h2>Orders & Purchases</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How do I place an order?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Placing an order is easy:</p>
                    <ul>
                        <li>Browse products and add items to your cart</li>
                        <li>Review your cart and proceed to checkout</li>
                        <li>Enter shipping and payment information</li>
                        <li>Confirm your order</li>
                    </ul>
                    <p>You'll receive an order confirmation email once your order is placed.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>Can I modify or cancel my order?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>You can modify or cancel your order within 1 hour of placing it. After that, orders are processed and cannot be changed. Contact our support team immediately for assistance.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How can I track my order?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Once your order ships, you'll receive a tracking number via email. You can also track your order by logging into your account and visiting the "My Orders" section.</p>
                </div>
            </div>
        </div>
        
        <!-- Shipping FAQ Section -->
        <div class="faq-section" data-category="shipping">
            <h2>Shipping & Delivery</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>What are your shipping options?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>We offer several shipping options:</p>
                    <ul>
                        <li>Standard Shipping (3-5 business days) - Free on orders over ₹500</li>
                        <li>Express Shipping (1-2 business days) - ₹100 flat rate</li>
                        <li>Same Day Delivery (available in select cities) - ₹200</li>
                    </ul>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>Do you ship internationally?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Currently, we ship only within India. We're working on expanding our shipping to international locations soon!</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How much does shipping cost?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Shipping is free on all orders above ₹500. For orders below ₹500, standard shipping costs ₹50.</p>
                </div>
            </div>
        </div>
        
        <!-- Returns FAQ Section -->
        <div class="faq-section" data-category="returns">
            <h2>Returns & Refunds</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>What is your return policy?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>We offer a 30-day return policy on most items. Products must be unused and in original packaging. Some items like hygiene products cannot be returned.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How do I initiate a return?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>To initiate a return:</p>
                    <ul>
                        <li>Log into your account and go to "My Orders"</li>
                        <li>Select the order and click "Return Items"</li>
                        <li>Choose items to return and reason</li>
                        <li>Print the return label and ship the items</li>
                    </ul>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>When will I get my refund?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Refunds are processed within 5-7 business days after we receive and inspect the returned item. The amount will be credited to your original payment method.</p>
                </div>
            </div>
        </div>
        
        <!-- Payment FAQ Section -->
        <div class="faq-section" data-category="payment">
            <h2>Payment Methods</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>What payment methods do you accept?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>We accept:</p>
                    <ul>
                        <li>Credit/Debit Cards (Visa, MasterCard, RuPay)</li>
                        <li>UPI (Google Pay, PhonePe, Paytm)</li>
                        <li>Net Banking</li>
                        <li>Wallets (Paytm, Amazon Pay)</li>
                        <li>Cash on Delivery (COD)</li>
                    </ul>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>Is it safe to use my credit card?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Yes! We use industry-standard encryption and secure payment gateways. Your payment information is never stored on our servers.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>What is Cash on Delivery (COD)?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>COD allows you to pay cash when your order is delivered. A small fee of ₹30 applies to COD orders. Maximum COD order value is ₹10,000.</p>
                </div>
            </div>
        </div>
        
        <!-- Account FAQ Section -->
        <div class="faq-section" data-category="account">
            <h2>Account Management</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How do I create an account?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Click on "Register" in the top menu. Fill in your details including name, email, and password. Verify your email address to activate your account.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>I forgot my password. What should I do?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Click on "Forgot Password" on the login page. Enter your email address and we'll send you instructions to reset your password.</p>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>How do I update my profile information?</h3>
                    <span class="icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Log into your account and go to "My Profile". You can update your personal information, change your password, and manage address book there.</p>
                </div>
            </div>
        </div>
        
        <!-- Still Have Questions -->
        <div class="help-section">
            <h2>Still Have Questions?</h2>
            <p>Can't find the answer you're looking for? We're here to help!</p>
            <div class="help-buttons">
                <a href="contact.jsp" class="help-btn">📧 Contact Us</a>
                <a href="#" class="help-btn">💬 Live Chat</a>
                <a href="tel:+911234567890" class="help-btn">📞 Call Us</a>
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
                    <li><a href="faq.jsp" class="active">FAQs</a></li>
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

    <script>
        function toggleAnswer(element) {
            element.classList.toggle('active');
            const answer = element.nextElementSibling;
            answer.classList.toggle('show');
            
            const icon = element.querySelector('.icon');
            if(icon.textContent === '+') {
                icon.textContent = '−';
            } else {
                icon.textContent = '+';
            }
        }
        
        function filterCategory(category) {
            const sections = document.querySelectorAll('.faq-section');
            const buttons = document.querySelectorAll('.category-btn');
            
            buttons.forEach(btn => {
                if(btn.textContent.toLowerCase().includes(category)) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
            
            sections.forEach(section => {
                if(category === 'all') {
                    section.style.display = 'block';
                } else {
                    if(section.getAttribute('data-category') === category) {
                        section.style.display = 'block';
                    } else {
                        section.style.display = 'none';
                    }
                }
            });
        }
        
        function searchFAQs() {
            const searchTerm = document.getElementById('faqSearch').value.toLowerCase();
            const questions = document.querySelectorAll('.faq-question h3');
            
            questions.forEach(question => {
                const faqItem = question.closest('.faq-item');
                const section = faqItem.closest('.faq-section');
                
                if(question.textContent.toLowerCase().includes(searchTerm)) {
                    faqItem.style.display = 'block';
                    section.style.display = 'block';
                } else {
                    faqItem.style.display = 'none';
                }
            });
        }
    </script>

</body>
</html>