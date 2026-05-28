<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*" %>

<%
    System.out.println("========== PRODUCTS.JSP LOADED ==========");
    
    // PROTECTION: Redirect to servlet if accessed directly
    if(request.getAttribute("products") == null) {
        System.out.println("DIRECT ACCESS DETECTED - Redirecting to servlet");
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
    
    // Get products from request attribute
    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");
    
    System.out.println("Products received from servlet: " + (products != null ? products.size() : "null"));
    
    if(products == null) {
        products = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin Panel</title>
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
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 25px;
        }
        
        /* Success/Error Messages */
        .message-container {
            margin-bottom: 20px;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 4px solid #28a745;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s ease;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 4px solid #dc3545;
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        /* Header Actions */
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .header-actions h2 {
            font-size: 2rem;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .product-count {
            background: #3b82f6;
            color: white;
            padding: 5px 15px;
            border-radius: 40px;
            font-size: 0.9rem;
            margin-left: 15px;
        }
        
        .add-btn {
            background: #10b981;
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .add-btn:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3);
        }
        
        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .search-box {
            flex: 1;
            min-width: 250px;
            display: flex;
            gap: 10px;
        }
        
        .search-box input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: border-color 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #3b82f6;
        }
        
        .search-btn {
            padding: 12px 20px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .search-btn:hover {
            background: #2563eb;
        }
        
        .filter-select {
            padding: 12px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            min-width: 150px;
            background: white;
        }
        
        /* Products Table */
        .table-container {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            text-align: left;
            padding: 15px;
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            vertical-align: middle;
        }
        
        tr:hover td {
            background: #f8fafc;
        }
        
        .product-image {
            width: 50px;
            height: 50px;
            background: #f1f5f9;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            overflow: hidden;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .product-info {
            display: flex;
            flex-direction: column;
        }
        
        .product-name {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 4px;
        }
        
        .product-id {
            font-size: 0.8rem;
            color: #64748b;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-instock {
            background: #d4edda;
            color: #155724;
        }
        
        .status-lowstock {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-outofstock {
            background: #f8d7da;
            color: #721c24;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .edit-btn {
            background: #3b82f6;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .edit-btn:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }
        
        .delete-btn {
            background: #ef4444;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .delete-btn:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }
        
        .no-data .icon {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #cbd5e1;
        }
        
        .no-data h3 {
            font-size: 1.5rem;
            color: #334155;
            margin-bottom: 10px;
        }
        
        .no-data p {
            margin-bottom: 20px;
        }
        
        .no-data .add-first-btn {
            background: #3b82f6;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .no-data .add-first-btn:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #64748b;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .back-link:hover {
            color: #3b82f6;
            text-decoration: underline;
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .page-btn {
            padding: 8px 15px;
            border: 1px solid #e2e8f0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .page-btn:hover {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }
        
        .page-btn.active {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }
        
        @media (max-width: 768px) {
            .header-actions {
                flex-direction: column;
                text-align: center;
            }
            
            .filter-section {
                flex-direction: column;
            }
            
            .search-box {
                width: 100%;
            }
            
            .filter-select {
                width: 100%;
            }
            
            table {
                display: block;
                overflow-x: auto;
            }
            
            .actions {
                flex-direction: column;
                gap: 5px;
            }
            
            .edit-btn, .delete-btn {
                text-align: center;
                justify-content: center;
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
        
        <!-- Success/Error Messages -->
        <div class="message-container">
            <% if(request.getParameter("success") != null) { %>
                <% if("deleted".equals(request.getParameter("success"))) { %>
                    <div class="success-message">
                        <span>✅</span> Product deleted successfully!
                    </div>
                <% } else if("updated".equals(request.getParameter("success"))) { %>
                    <div class="success-message">
                        <span>✅</span> Product updated successfully!
                    </div>
                <% } else if("added".equals(request.getParameter("success"))) { %>
                    <div class="success-message">
                        <span>✅</span> Product added successfully!
                    </div>
                <% } %>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <span>❌</span>
                    <% if("deletefailed".equals(request.getParameter("error"))) { %>
                        Failed to delete product. Please try again.
                    <% } else if("invalid".equals(request.getParameter("error"))) { %>
                        Invalid product ID.
                    <% } else if("system".equals(request.getParameter("error"))) { %>
                        System error. Please try again later.
                    <% } else if("exception".equals(request.getParameter("error"))) { %>
                        An error occurred. Please try again.
                    <% } else if("notfound".equals(request.getParameter("error"))) { %>
                        Product not found.
                    <% } else { %>
                        An error occurred. Please try again.
                    <% } %>
                </div>
            <% } %>
        </div>
        
        <div class="header-actions">
            <h2>
                📋 Manage Products
                <span class="product-count"><%= products.size() %> products</span>
            </h2>
            <a href="${pageContext.request.contextPath}/admin/addProduct.jsp" class="add-btn">
                <span>➕</span> Add New Product
            </a>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search products by name or ID..." onkeyup="searchProducts()">
                <button class="search-btn" onclick="searchProducts()">🔍 Search</button>
            </div>
            <select class="filter-select" id="stockFilter" onchange="filterByStock()">
                <option value="all">All Products</option>
                <option value="instock">In Stock</option>
                <option value="lowstock">Low Stock (≤5)</option>
                <option value="outofstock">Out of Stock</option>
            </select>
        </div>
        
        <div class="table-container">
            <% if(products.isEmpty()) { %>
                <div class="no-data">
                    <div class="icon">📦</div>
                    <h3>No Products Found</h3>
                    <p>Click the "Add New Product" button to create your first product.</p>
                    <a href="${pageContext.request.contextPath}/admin/addProduct.jsp" class="add-first-btn">➕ Add New Product</a>
                </div>
            <% } else { %>
                <table id="productsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(ProductBean product : products) { 
                            int quantity = 0;
                            try {
                                quantity = Integer.parseInt(product.getP_Quantity());
                            } catch(Exception e) {}
                            
                            String statusClass = "";
                            String statusText = "";
                            String stockStatus = "";
                            
                            if(quantity > 10) {
                                statusClass = "status-instock";
                                statusText = "In Stock";
                                stockStatus = "instock";
                            } else if(quantity > 0) {
                                statusClass = "status-lowstock";
                                statusText = "Low Stock (" + quantity + ")";
                                stockStatus = "lowstock";
                            } else {
                                statusClass = "status-outofstock";
                                statusText = "Out of Stock";
                                stockStatus = "outofstock";
                            }
                        %>
                        <tr data-stock="<%= stockStatus %>">
                            <td>#<%= product.getP_ID() %></td>
                            <td>
                                <div class="product-image">
                                    <img src="${pageContext.request.contextPath}/images/<%= product.getP_Image() != null ? product.getP_Image() : "placeholder.jpg" %>" 
                                         alt="<%= product.getP_Name() %>"
                                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                </div>
                            </td>
                            <td>
                                <div class="product-info">
                                    <span class="product-name"><%= product.getP_Name() %></span>
                                    <span class="product-id">ID: <%= product.getP_ID() %></span>
                                </div>
                            </td>
                            <td><strong>₹<%= product.getP_Price() %></strong></td>
                            <td><%= product.getP_Quantity() %></td>
                            <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/admin/editProduct.jsp?id=<%= product.getP_ID() %>" class="edit-btn">
                                    <span>✏️</span> Edit
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/DeleteProductServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this product?')">
                                    <input type="hidden" name="productId" value="<%= product.getP_ID() %>">
                                    <button type="submit" class="delete-btn">
                                        <span>🗑️</span> Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <!-- Pagination -->
                <div class="pagination">
                    <button class="page-btn">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">3</button>
                    <button class="page-btn">4</button>
                    <button class="page-btn">5</button>
                </div>
            <% } %>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-link">← Back to Dashboard</a>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Search functionality
        function searchProducts() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('productsTable');
            
            if(!table) return;
            
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const idCell = row.getElementsByTagName('td')[0];
                const nameCell = row.getElementsByTagName('td')[2];
                
                if(idCell && nameCell) {
                    const idText = idCell.textContent || idCell.innerText;
                    const nameText = nameCell.textContent || nameCell.innerText;
                    
                    if (idText.toUpperCase().indexOf(filter) > -1 || nameText.toUpperCase().indexOf(filter) > -1) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            }
        }
        
        // Filter by stock status
        function filterByStock() {
            const filter = document.getElementById('stockFilter').value;
            const table = document.getElementById('productsTable');
            
            if(!table) return;
            
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const stockStatus = row.getAttribute('data-stock');
                
                if(filter === 'all' || stockStatus === filter) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }
        
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
            
            const errorMsg = document.querySelector('.error-message');
            if(errorMsg) {
                setTimeout(function() {
                    errorMsg.style.opacity = '0';
                    setTimeout(function() {
                        errorMsg.style.display = 'none';
                    }, 500);
                }, 5000);
            }
        });
        
        // Enter key for search
        document.getElementById('searchInput').addEventListener('keyup', function(e) {
            if(e.key === 'Enter') {
                searchProducts();
            }
        });
    </script>

</body>
</html>