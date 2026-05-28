<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Admin Panel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: #f5f7fa;
            min-height: 100vh;
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
            max-width: 1400px;
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
            background: rgba(251, 191, 36, 0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        
        .admin-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .admin-badge {
            background: rgba(255,255,255,0.1);
            padding: 10px 25px;
            border-radius: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .admin-avatar {
            width: 35px;
            height: 35px;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #1e293b;
        }
        
        .admin-name {
            font-weight: 500;
        }
        
        .logout-btn {
            background: #ef4444;
            color: white;
            padding: 10px 25px;
            border-radius: 40px;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }
        
        .logout-btn:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3);
        }
        
        /* Main Container */
        .main-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        /* Form Card */
        .form-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.05);
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-header h2 {
            font-size: 2rem;
            color: #1e293b;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header p {
            color: #64748b;
            font-size: 1rem;
        }
        
        /* Error Message */
        .error-message {
            background: #fef2f2;
            color: #991b1b;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border-left: 4px solid #ef4444;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Form Groups */
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1e293b;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: white;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .form-group input:hover,
        .form-group select:hover,
        .form-group textarea:hover {
            border-color: #94a3b8;
        }
        
        .form-group input[type="file"] {
            padding: 10px;
            background: #f8fafc;
            border: 2px dashed #cbd5e1;
            cursor: pointer;
        }
        
        .form-group input[type="file"]:hover {
            border-color: #3b82f6;
            background: #f0f9ff;
        }
        
        .form-group small {
            display: block;
            margin-top: 5px;
            color: #64748b;
            font-size: 0.85rem;
        }
        
        /* Form Row */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        /* Required field indicator */
        .form-group label::after {
            content: " *";
            color: #ef4444;
            font-weight: bold;
        }
        
        /* Submit Button */
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin: 20px 0 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        /* Back Link */
        .back-link {
            display: block;
            text-align: center;
            color: #64748b;
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.3s;
            padding: 10px;
        }
        
        .back-link:hover {
            color: #3b82f6;
            text-decoration: underline;
        }
        
        /* File name display */
        .file-name {
            margin-top: 10px;
            padding: 8px 12px;
            background: #f1f5f9;
            border-radius: 6px;
            color: #1e293b;
            font-size: 0.9rem;
            display: none;
        }
        
        .file-name.active {
            display: block;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .admin-info {
                width: 100%;
                justify-content: center;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .form-card {
                padding: 25px;
            }
            
            .form-header h2 {
                font-size: 1.6rem;
            }
        }
        
        /* Loading state */
        .btn-submit.loading {
            background: #94a3b8;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .btn-submit.loading::after {
            content: "";
            width: 20px;
            height: 20px;
            border: 3px solid white;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spinner 0.8s linear infinite;
        }
        
        @keyframes spinner {
            to { transform: rotate(360deg); }
        }
        
        /* Success animation */
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }
        
        /* Category select styling */
        select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%234b5563' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1rem;
            padding-right: 2.5rem;
        }
        
        /* Image preview */
        .image-preview {
            margin-top: 15px;
            max-width: 200px;
            max-height: 200px;
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            padding: 5px;
            display: none;
        }
        
        .image-preview.active {
            display: block;
        }
        
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body>

    <!-- Admin Header -->
    <header class="admin-header">
        <div class="header-container">
            <div class="logo">
                <h1>🛍️ Shop<span>Cart</span></h1>
                <span>Admin Panel</span>
            </div>
            <div class="admin-info">
                <div class="admin-badge">
                    <div class="admin-avatar">
                        <%= adminUser.substring(0, 1).toUpperCase() %>
                    </div>
                    <span class="admin-name"><%= adminUser %></span>
                </div>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
                    <span>🚪</span> Logout
                </a>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <div class="main-container">
        <div class="form-card">
            
            <div class="form-header">
                <h2>
                    <span>➕</span> Add New Product
                </h2>
                <p>Fill in the details to add a new product to your store</p>
            </div>
            
            <!-- Error Messages -->
            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <% if("namerequired".equals(request.getParameter("error"))) { %>
                        ⚠️ Product name is required!
                    <% } else if("pricerequired".equals(request.getParameter("error"))) { %>
                        ⚠️ Product price is required!
                    <% } else if("quantityrequired".equals(request.getParameter("error"))) { %>
                        ⚠️ Product quantity is required!
                    <% } else if("failed".equals(request.getParameter("error"))) { %>
                        ❌ Failed to add product. Please try again.
                    <% } else if("system".equals(request.getParameter("error"))) { %>
                        ❌ System error. Please try again later.
                    <% } else if("exception".equals(request.getParameter("error"))) { %>
                        ❌ An error occurred. Please check your input.
                    <% } %>
                </div>
            <% } %>
            
            <!-- Success Message -->
            <% if(request.getParameter("success") != null) { %>
                <div class="error-message" style="background: #d4edda; color: #155724; border-left-color: #28a745;">
                    ✅ Product added successfully!
                </div>
            <% } %>
            
            <!-- Add Product Form -->
            <form action="${pageContext.request.contextPath}/admin/AddProductServlet" 
                  method="post" 
                  enctype="multipart/form-data"
                  id="addProductForm">
                
                <div class="form-group">
                    <label>Product Name</label>
                    <input type="text" name="productName" placeholder="e.g., Wireless Headphones" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Price (₹)</label>
                        <input type="number" name="productPrice" step="0.01" placeholder="1999.99" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" name="productQuantity" placeholder="50" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Product Image</label>
                    <input type="file" name="productImage" accept="image/*" id="productImage" onchange="previewImage(this)">
                    <small>Leave empty to use placeholder image</small>
                    <div class="file-name" id="fileName"></div>
                    <div class="image-preview" id="imagePreview">
                        <img src="" alt="Preview" id="previewImg">
                    </div>
                </div>
                
                <button type="submit" class="btn-submit" id="submitBtn">
                    <span>💾</span> Add Product
                </button>
            </form>
            
            <a href="${pageContext.request.contextPath}/admin/products.jsp" class="back-link">← Back to Products</a>
        </div>
    </div>

    <!-- JavaScript for image preview and form handling -->
    <script>
        // Image preview functionality
        function previewImage(input) {
            const fileName = document.getElementById('fileName');
            const preview = document.getElementById('imagePreview');
            const img = document.getElementById('previewImg');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Show file name
                fileName.textContent = 'Selected: ' + file.name;
                fileName.classList.add('active');
                
                // Show image preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    img.src = e.target.result;
                    preview.classList.add('active');
                };
                reader.readAsDataURL(file);
            } else {
                fileName.classList.remove('active');
                preview.classList.remove('active');
            }
        }
        
        // Form submission with loading state
        document.getElementById('addProductForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span>⏳</span> Adding Product...';
        });
        
        // Validate form before submission
        function validateForm() {
            const name = document.querySelector('input[name="productName"]').value.trim();
            const price = document.querySelector('input[name="productPrice"]').value.trim();
            const quantity = document.querySelector('input[name="productQuantity"]').value.trim();
            
            if (!name) {
                alert('Please enter product name');
                return false;
            }
            
            if (!price || parseFloat(price) <= 0) {
                alert('Please enter a valid price');
                return false;
            }
            
            if (!quantity || parseInt(quantity) <= 0) {
                alert('Please enter a valid quantity');
                return false;
            }
            
            return true;
        }
        
        // Add validation on submit
        document.getElementById('addProductForm').addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                const submitBtn = document.getElementById('submitBtn');
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<span>💾</span> Add Product';
            }
        });
    </script>

</body>
</html>