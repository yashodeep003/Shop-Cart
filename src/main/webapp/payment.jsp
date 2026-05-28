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
    
    // Get payment data from session (stored by CheckoutServlet)
    Map<String, String[]> paymentData = (Map<String, String[]>) session.getAttribute("paymentData");
    
    if(paymentData == null) {
        System.out.println("ERROR: paymentData is null in session - redirecting to checkout");
        response.sendRedirect("checkout.jsp");
        return;
    }
    
    // Extract values with null checks
    String[] totalAmountArr = paymentData.get("totalAmount");
    String totalAmount = (totalAmountArr != null && totalAmountArr.length > 0) ? totalAmountArr[0] : "0";
    
    String[] paymentMethodArr = paymentData.get("paymentMethod");
    String paymentMethod = (paymentMethodArr != null && paymentMethodArr.length > 0) ? paymentMethodArr[0] : "card";
    
    String[] firstNameArr = paymentData.get("firstName");
    String firstName = (firstNameArr != null && firstNameArr.length > 0) ? firstNameArr[0] : "";
    
    String[] lastNameArr = paymentData.get("lastName");
    String lastName = (lastNameArr != null && lastNameArr.length > 0) ? lastNameArr[0] : "";
    
    String[] emailArr = paymentData.get("email");
    String email = (emailArr != null && emailArr.length > 0) ? emailArr[0] : "";
    
    String[] phoneArr = paymentData.get("phone");
    String phone = (phoneArr != null && phoneArr.length > 0) ? phoneArr[0] : "";
    
    String[] addressArr = paymentData.get("address");
    String address = (addressArr != null && addressArr.length > 0) ? addressArr[0] : "";
    
    String[] cityArr = paymentData.get("city");
    String city = (cityArr != null && cityArr.length > 0) ? cityArr[0] : "";
    
    String[] stateArr = paymentData.get("state");
    String state = (stateArr != null && stateArr.length > 0) ? stateArr[0] : "";
    
    String[] pincodeArr = paymentData.get("pincode");
    String pincode = (pincodeArr != null && pincodeArr.length > 0) ? pincodeArr[0] : "";
    
    String[] countryArr = paymentData.get("country");
    String country = (countryArr != null && countryArr.length > 0) ? countryArr[0] : "India";
    
    // Calculate totals for display
    double total = Double.parseDouble(totalAmount);
    double subtotal = total / 1.05; 
    double tax = total - subtotal;
    double shippingCharge = subtotal >= 500 ? 0 : 50;
    
    // Debug prints
    System.out.println("=== PAYMENT.JSP LOADED ===");
    System.out.println("totalAmount: " + totalAmount);
    System.out.println("paymentMethod: " + paymentMethod);
    System.out.println("firstName: " + firstName);
    System.out.println("email: " + email);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - ShopCart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .payment-container {
            max-width: 550px;
            width: 100%;
            background: white;
            border-radius: 24px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .payment-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 35px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .payment-header::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .payment-header::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .payment-header h1 {
            font-size: 2.2rem;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
        }
        
        .payment-header .amount {
            font-size: 2.8rem;
            font-weight: bold;
            position: relative;
            z-index: 2;
        }
        
        .payment-header .amount::before {
            content: '₹';
            font-size: 1.8rem;
            margin-right: 5px;
            opacity: 0.9;
        }
        
        .secure-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 40px;
            font-size: 0.9rem;
            margin-top: 15px;
            position: relative;
            z-index: 2;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .payment-body {
            padding: 35px 30px;
        }
        
        /* Error Message */
        .error-message {
            background: #fef2f2;
            color: #991b1b;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 4px solid #ef4444;
            font-weight: 500;
            animation: slideIn 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Success Message */
        .success-message {
            background: #ecfdf5;
            color: #065f46;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 4px solid #10b981;
            font-weight: 500;
            animation: slideIn 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Order Summary Card */
        .order-summary-card {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #e2e8f0;
        }
        
        .summary-title {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .summary-details {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            color: #475569;
            font-size: 0.95rem;
            padding: 5px 0;
        }
        
        .summary-row.total {
            font-weight: 700;
            color: #1e293b;
            font-size: 1.2rem;
            border-top: 2px dashed #cbd5e1;
            margin-top: 8px;
            padding-top: 12px;
        }
        
        .summary-highlight {
            background: white;
            border-radius: 12px;
            padding: 15px;
            margin-top: 15px;
            border: 1px solid #e2e8f0;
        }
        
        .summary-highlight-item {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        
        .highlight-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea20, #764ba220);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .highlight-content h4 {
            color: #1e293b;
            font-size: 0.9rem;
            margin-bottom: 3px;
        }
        
        .highlight-content p {
            color: #64748b;
            font-size: 0.85rem;
        }
        
        /* Payment Method Tabs */
        .payment-method-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            background: #f8fafc;
            padding: 8px;
            border-radius: 50px;
            border: 1px solid #e2e8f0;
        }
        
        .tab {
            flex: 1;
            text-align: center;
            padding: 12px 10px;
            cursor: pointer;
            border-radius: 40px;
            transition: all 0.3s;
            font-weight: 600;
            color: #64748b;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .tab:hover {
            background: white;
            color: #334155;
        }
        
        .tab.active {
            background: white;
            color: #667eea;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        
        /* Payment Forms */
        .payment-form {
            display: none;
        }
        
        .payment-form.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1e293b;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s;
            background: white;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-group input:hover,
        .form-group select:hover {
            border-color: #94a3b8;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .card-icons {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        
        .card-icon {
            width: 50px;
            height: 30px;
            background: #f1f5f9;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            color: #475569;
            border: 1px solid #cbd5e1;
            font-weight: 600;
        }
        
        .pay-button {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            margin: 25px 0 20px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }
        
        .pay-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
        }
        
        .pay-button:active {
            transform: translateY(0);
        }
        
        .pay-button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }
        
        .secure-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
            color: #64748b;
            font-size: 0.9rem;
            padding: 15px;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        
        .back-link {
            display: block;
            text-align: center;
            color: #64748b;
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.3s;
            padding: 15px 10px 5px;
        }
        
        .back-link:hover {
            color: #667eea;
            text-decoration: underline;
        }
        
        /* COD Info Box */
        .cod-info {
            text-align: center;
            padding: 30px 20px;
            background: #f8fafc;
            border-radius: 16px;
            margin-bottom: 20px;
            border: 2px dashed #cbd5e1;
        }
        
        .cod-info .icon {
            font-size: 3.5rem;
            margin-bottom: 15px;
        }
        
        .cod-info h3 {
            color: #1e293b;
            margin-bottom: 10px;
            font-size: 1.3rem;
        }
        
        .cod-info p {
            color: #64748b;
            margin-bottom: 8px;
        }
        
        .cod-info .charge {
            background: #fef3c7;
            color: #92400e;
            padding: 8px 15px;
            border-radius: 30px;
            display: inline-block;
            margin-top: 10px;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .payment-body {
                padding: 25px 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .payment-method-tabs {
                flex-direction: column;
                border-radius: 20px;
            }
            
            .payment-header h1 {
                font-size: 1.8rem;
            }
            
            .payment-header .amount {
                font-size: 2.2rem;
            }
        }
    </style>
</head>
<body>

    <div class="payment-container">
        <div class="payment-header">
            <h1>Complete Payment</h1>
            <div class="amount"><%= String.format("%,.2f", total) %></div>
            <div class="secure-badge">
                <span>🔒</span> Secured by SSL
            </div>
        </div>
        
        <div class="payment-body">
            
            <!-- Error Messages -->
            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <span>❌</span>
                    <% if("amountmissing".equals(request.getParameter("error"))) { %>
                        Payment amount is missing. Please try again.
                    <% } else if("orderfailed".equals(request.getParameter("error"))) { %>
                        Failed to process order. Please try again.
                    <% } else if("systemerror".equals(request.getParameter("error"))) { %>
                        System error. Please try again later.
                    <% } else if("exception".equals(request.getParameter("error"))) { %>
                        An error occurred. Please try again.
                    <% } %>
                </div>
            <% } %>
            
            <!-- Success Message -->
            <% if(request.getParameter("success") != null) { %>
                <div class="success-message">
                    <span>✅</span> Payment processed successfully!
                </div>
            <% } %>
            
            <!-- Order Summary Card -->
            <div class="order-summary-card">
                <div class="summary-title">
                    <span>🛍️</span> Order Summary
                </div>
                <div class="summary-details">
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<%= String.format("%,.2f", subtotal) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span><%= shippingCharge == 0 ? "FREE" : "₹" + String.format("%.2f", shippingCharge) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Tax (5%)</span>
                        <span>₹<%= String.format("%,.2f", tax) %></span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>₹<%= String.format("%,.2f", total) %></span>
                    </div>
                </div>
                
                <div class="summary-highlight">
                    <div class="summary-highlight-item">
                        <div class="highlight-icon">📦</div>
                        <div class="highlight-content">
                            <h4>Shipping To</h4>
                            <p><%= address %>, <%= city %>, <%= state %> - <%= pincode %></p>
                        </div>
                    </div>
                    <div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #e2e8f0;">
                        <div style="display: flex; gap: 10px;">
                            <span style="color: #64748b;">📞</span>
                            <span style="color: #1e293b;"><%= phone %></span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Payment Method Tabs -->
            <div class="payment-method-tabs">
                <div class="tab <%= "card".equals(paymentMethod) ? "active" : "" %>" onclick="switchTab('card')">
                    <span>💳</span> Card
                </div>
                <div class="tab <%= "upi".equals(paymentMethod) ? "active" : "" %>" onclick="switchTab('upi')">
                    <span>📱</span> UPI
                </div>
                <div class="tab <%= "cod".equals(paymentMethod) ? "active" : "" %>" onclick="switchTab('cod')">
                    <span>💵</span> Cash
                </div>
            </div>
            
            <!-- Card Payment Form -->
            <form id="cardForm" class="payment-form <%= "card".equals(paymentMethod) ? "active" : "" %>" action="${pageContext.request.contextPath}/ProcessPaymentServlet" method="post">
                <input type="hidden" name="paymentMethod" value="card">
                <input type="hidden" name="totalAmount" value="<%= total %>">
                
                <div class="form-group">
                    <label>Card Number</label>
                    <input type="text" name="cardNumber" placeholder="1234 5678 9012 3456" 
                           maxlength="19" oninput="formatCardNumber(this)" required>
                    <div class="card-icons">
                        <span class="card-icon">Visa</span>
                        <span class="card-icon">Master</span>
                        <span class="card-icon">RuPay</span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Cardholder Name</label>
                    <input type="text" name="cardHolderName" placeholder="JOHN DOE" value="<%= firstName + " " + lastName %>" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Expiry Date</label>
                        <input type="text" name="expiry" placeholder="MM/YY" maxlength="5" 
                               oninput="formatExpiry(this)" required>
                    </div>
                    
                    <div class="form-group">
                        <label>CVV</label>
                        <input type="password" name="cvv" placeholder="123" maxlength="3" required>
                    </div>
                </div>
                
                <button type="submit" class="pay-button" id="cardPayBtn">
                    <span>💳</span> Pay ₹<%= String.format("%,.2f", total) %>
                </button>
            </form>
            
            <!-- UPI Payment Form -->
            <form id="upiForm" class="payment-form <%= "upi".equals(paymentMethod) ? "active" : "" %>" action="${pageContext.request.contextPath}/ProcessPaymentServlet" method="post">
                <input type="hidden" name="paymentMethod" value="upi">
                <input type="hidden" name="totalAmount" value="<%= total %>">
                
                <div class="form-group">
                    <label>UPI ID</label>
                    <input type="text" name="upiId" placeholder="username@okhdfcbank" value="<%= phone %>@okhdfcbank" required>
                </div>
                
                <div class="form-group">
                    <label>Select UPI App</label>
                    <select name="upiApp">
                        <option value="gpay">Google Pay</option>
                        <option value="phonepe">PhonePe</option>
                        <option value="paytm">Paytm</option>
                        <option value="amazonpay">Amazon Pay</option>
                    </select>
                </div>
                
                <button type="submit" class="pay-button" id="upiPayBtn">
                    <span>📱</span> Pay ₹<%= String.format("%,.2f", total) %>
                </button>
            </form>
            
            <!-- Cash on Delivery Form -->
            <form id="codForm" class="payment-form <%= "cod".equals(paymentMethod) ? "active" : "" %>" action="${pageContext.request.contextPath}/ProcessPaymentServlet" method="post">
                <input type="hidden" name="paymentMethod" value="cod">
                <input type="hidden" name="totalAmount" value="<%= total %>">
                
                <div class="cod-info">
                    <div class="icon">💵</div>
                    <h3>Cash on Delivery</h3>
                    <p>Pay when you receive your order</p>
                    <p>Our delivery partner will collect cash at your doorstep</p>
                    
                </div>
                
                <button type="submit" class="pay-button" id="codPayBtn">
                    <span>✅</span> Place Order (Pay on Delivery)
                </button>
            </form>
            
            <!-- Security Info -->
            <div class="secure-info">
                <span>🔒</span>
                <span>Encryption</span>
                <span>🔒</span>
            </div>
            
            <a href="checkout.jsp" class="back-link">← Back to Checkout</a>
        </div>
    </div>

    <script>
        // Switch between payment tabs
        function switchTab(tab) {
            // Update tabs
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            event.target.classList.add('active');
            
            // Show corresponding form
            document.querySelectorAll('.payment-form').forEach(f => f.classList.remove('active'));
            document.getElementById(tab + 'Form').classList.add('active');
        }
        
        // Format card number with spaces
        function formatCardNumber(input) {
            let value = input.value.replace(/\D/g, '');
            let formattedValue = '';
            for(let i = 0; i < value.length; i++) {
                if(i > 0 && i % 4 === 0) {
                    formattedValue += ' ';
                }
                formattedValue += value[i];
            }
            input.value = formattedValue;
        }
        
        // Format expiry date
        function formatExpiry(input) {
            let value = input.value.replace(/\D/g, '');
            if(value.length >= 2) {
                input.value = value.substring(0, 2) + '/' + value.substring(2, 4);
            } else {
                input.value = value;
            }
        }
        
        // Validate card number (Luhn algorithm)
        function validateCardNumber(cardNumber) {
            let sum = 0;
            let alternate = false;
            cardNumber = cardNumber.replace(/\s/g, '');
            
            for(let i = cardNumber.length - 1; i >= 0; i--) {
                let n = parseInt(cardNumber.charAt(i));
                if(alternate) {
                    n *= 2;
                    if(n > 9) n -= 9;
                }
                sum += n;
                alternate = !alternate;
            }
            return (sum % 10 === 0);
        }
        
        // Form submission with loading state
        document.querySelectorAll('.payment-form').forEach(form => {
            form.addEventListener('submit', function(e) {
                const payBtn = this.querySelector('.pay-button');
                
                // Validate based on form type
                if(this.id === 'cardForm') {
                    let cardNumber = this.querySelector('input[name="cardNumber"]').value;
                    let cvv = this.querySelector('input[name="cvv"]').value;
                    
                    if(cardNumber.replace(/\s/g, '').length < 16) {
                        alert('Please enter a valid 16-digit card number');
                        e.preventDefault();
                        return;
                    }
                    
                    if(cvv.length < 3) {
                        alert('Please enter a valid CVV');
                        e.preventDefault();
                        return;
                    }
                }
                
                if(this.id === 'upiForm') {
                    let upiId = this.querySelector('input[name="upiId"]').value;
                    if(!upiId.includes('@')) {
                        alert('Please enter a valid UPI ID');
                        e.preventDefault();
                        return;
                    }
                }
                
                // Change button state
                payBtn.innerHTML = '<span>⏳</span> Processing...';
                payBtn.disabled = true;
            });
        });
        
        // Auto-select tab based on payment method
        window.addEventListener('load', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            if(error) {
                console.log('Payment error:', error);
                setTimeout(() => {
                    document.querySelector('.error-message').style.opacity = '0';
                }, 5000);
            }
        });
        
        // Prevent double submission
        let submitted = false;
        document.querySelectorAll('.payment-form').forEach(form => {
            form.addEventListener('submit', function() {
                if(submitted) {
                    e.preventDefault();
                    return false;
                }
                submitted = true;
            });
        });
    </script>

</body>
</html>