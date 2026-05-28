<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, com.dao.DAOInterface, java.util.*" %>

<%
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
    
    // Get product ID from request
    String productId = request.getParameter("id");
    
    if(productId == null || productId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    // Get DAO object and fetch product
    DAOInterface DAOobj = (DAOInterface) application.getAttribute("DAOobj");
    ProductBean product = null;
    
    if(DAOobj != null) {
        try {
            product = DAOobj.getProductById(Integer.parseInt(productId));
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    if(product == null) {
        response.sendRedirect(request.getContextPath() + "/admin/products?error=notfound");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Admin Panel</title>
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
        
        .success-message {
            background: #ecfdf5;
            color: #065f46;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border-left: 4px solid #10b981;
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
        .required::after {
            content: " *";
            color: #ef4444;
            font-weight: bold;
        }
        
        /* Current Image Display */
        .current-image {
            margin: 20px 0;
            padding: 20px;
            background: #f8fafc;
            border-radius: 10px;
            text-align: center;
            border: 2px dashed #e2e8f0;
        }
        
        .current-image h4 {
            color: #1e293b;
            margin-bottom: 15px;
            font-size: 1rem;
        }
        
        .image-container {
            width: 150px;
            height: 150px;
            margin: 0 auto;
            border-radius: 10px;
            overflow: hidden;
            border: 3px solid white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .image-filename {
            margin-top: 10px;
            color: #64748b;
            font-size: 0.9rem;
        }
        
        /* Button Group */
        .button-group {
            display: flex;
            gap: 15px;
            margin: 30px 0 20px;
        }
        
        .btn-update {
            flex: 2;
            padding: 15px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4);
        }
        
        .btn-delete {
            flex: 1;
            padding: 15px;
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-delete:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4);
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
            margin: 15px auto 0;
        }
        
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
        
        /* Loading state */
        .btn-update.loading,
        .btn-delete.loading {
            opacity: 0.7;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .btn-update.loading::after,
        .btn-delete.loading::after {
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
        
        /* Category select styling */
        select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%234b5563' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1rem;
            padding-right: 2.5rem;
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
            
            .button-group {
                flex-direction: column;
            }
            
            .btn-update, .btn-delete {
                width: 100%;
            }
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
                    <span>✏️</span> Edit Product
                </h2>
                <p>Update product information #<%= product.getP_ID() %></p>
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
                    <% } else if("updatefailed".equals(request.getParameter("error"))) { %>
                        ❌ Failed to update product. Please try again.
                    <% } else if("system".equals(request.getParameter("error"))) { %>
                        ❌ System error. Please try again later.
                    <% } else { %>
                        ❌ An error occurred. Please check your input.
                    <% } %>
                </div>
            <% } %>
            
            <!-- Success Message -->
            <% if(request.getParameter("success") != null) { %>
                <div class="success-message">
                    ✅ Product updated successfully!
                </div>
            <% } %>
            
            <!-- Edit Product Form -->
            <form action="UpdateProductServlet" method="post" enctype="multipart/form-data">
                
                
                <input type="hidden" name="productId" value="<%= product.getP_ID() %>">
                
                <div class="form-group">
                    <label class="required">Product Name</label>
                    <input type="text" name="productName" value="<%= product.getP_Name() %>" placeholder="e.g., Wireless Headphones" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="required">Price (₹)</label>
                        <input type="number" name="productPrice" step="0.01" value="<%= product.getP_Price() %>" placeholder="1999.99" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="required">Quantity</label>
                        <input type="number" name="productQuantity" value="<%= product.getP_Quantity() %>" placeholder="50" required>
                    </div>
                </div>
                
             
                
            
                
                <!-- Current Image Display -->
                <div class="current-image">
                    <h4>Current Image</h4>
                    <div class="image-container">
                        <img src="${pageContext.request.contextPath}/images/<%= product.getP_Image() != null ? product.getP_Image() : "placeholder.jpg" %>" 
                             alt="<%= product.getP_Name() %>"
                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                    </div>
                    <div class="image-filename">
                        <%= product.getP_Image() != null ? product.getP_Image() : "placeholder.jpg" %>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>New Product Image (optional)</label>
                    <input type="file" name="productImage" accept="image/*" id="productImage" onchange="previewImage(this)">
                    <small>Leave empty to keep current image</small>
                    <div class="file-name" id="fileName"></div>
                    <div class="image-preview" id="imagePreview">
                        <img src="" alt="Preview" id="previewImg">
                    </div>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn-update" id="updateBtn">
                        <span>💾</span> Update Product
                    </button>
                    
                    <button type="button" class="btn-delete" onclick="confirmDelete()">
                        <span>🗑️</span> Delete
                    </button>
                </div>
            </form>
            
            <!-- Hidden delete form -->
            <form id="deleteForm" action="${pageContext.request.contextPath}/admin/DeleteProductServlet" method="post" style="display:none;">
                <input type="hidden" name="productId" value="<%= product.getP_ID() %>">
            </form>
            
            <a href="${pageContext.request.contextPath}/admin/products" class="back-link">← Back to Products</a>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Image preview functionality
        function previewImage(input) {
            const fileName = document.getElementById('fileName');
            const preview = document.getElementById('imagePreview');
            const img = document.getElementById('previewImg');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Show file name
                fileName.textContent = 'New image: ' + file.name;
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
        
        // Confirm delete
        function confirmDelete() {
            if(confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
                document.getElementById('deleteForm').submit();
            }
        }
        
        // Form submission with loading state
        document.getElementById('editProductForm').addEventListener('submit', function(e) {
            const updateBtn = document.getElementById('updateBtn');
            updateBtn.classList.add('loading');
            updateBtn.disabled = true;
            updateBtn.innerHTML = '<span>⏳</span> Updating...';
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
            
            if (!quantity || parseInt(quantity) < 0) {
                alert('Please enter a valid quantity');
                return false;
            }
            
            return true;
        }
        
        // Add validation on submit
        document.getElementById('editProductForm').addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                const updateBtn = document.getElementById('updateBtn');
                updateBtn.classList.remove('loading');
                updateBtn.disabled = false;
                updateBtn.innerHTML = '<span>💾</span> Update Product';
            }
        });
        
        // Auto-hide success message after 3 seconds
        window.addEventListener('load', function() {
            const successMsg = document.querySelector('.success-message');
            if(successMsg) {
                setTimeout(function() {
                    successMsg.style.opacity = '0';
                    setTimeout(function() {
                        successMsg.style.display = 'none';
                    }, 500);
                }, 3000);
            }
        });
    </script>

</body>
</html>