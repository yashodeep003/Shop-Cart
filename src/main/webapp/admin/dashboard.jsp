<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect("../signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
    
    
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ShopCart</title>
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
        
        /* Dashboard Container */
        .dashboard-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 25px;
        }
        
        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(37, 99, 235, 0.2);
        }
        
        .welcome-section::before {
            content: '👑';
            position: absolute;
            right: 30px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 8rem;
            opacity: 0.1;
        }
        
        .welcome-section h2 {
            font-size: 2.5rem;
            margin-bottom: 15px;
            position: relative;
        }
        
        .welcome-section p {
            font-size: 1.2rem;
            opacity: 0.95;
            max-width: 600px;
            position: relative;
        }
        
        .date-badge {
            position: absolute;
            right: 40px;
            top: 40px;
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 40px;
            font-size: 0.95rem;
            backdrop-filter: blur(5px);
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 25px;
            transition: all 0.3s;
            border: 1px solid rgba(0,0,0,0.05);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(59, 130, 246, 0.1);
            border-color: #3b82f6;
        }
        
        .stat-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            color: white;
            box-shadow: 0 10px 20px rgba(59, 130, 246, 0.3);
        }
        
        .stat-content {
            flex: 1;
        }
        
        .stat-content h3 {
            color: #64748b;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        
        .stat-content .number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #1e293b;
            line-height: 1.2;
            margin-bottom: 5px;
        }
        
        .stat-content .trend {
            color: #10b981;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        /* Quick Actions Grid */
        .quick-actions {
            margin-bottom: 40px;
        }
        
        .quick-actions h3 {
            font-size: 1.5rem;
            color: #1e293b;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
            border: 1px solid #e2e8f0;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            border-color: #3b82f6;
            box-shadow: 0 15px 30px rgba(59, 130, 246, 0.15);
        }
        
        .action-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        .action-card h4 {
            font-size: 1.1rem;
            margin-bottom: 8px;
            color: #1e293b;
        }
        
        .action-card p {
            color: #64748b;
            font-size: 0.9rem;
        }
        
        /* Charts Row */
        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .chart-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        
        .chart-card h3 {
            color: #1e293b;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .chart-placeholder {
            height: 250px;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            border: 2px dashed #cbd5e1;
        }
        
        /* Recent Orders */
        .recent-orders {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        
        .recent-orders-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .recent-orders-header h3 {
            font-size: 1.3rem;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .view-all-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .view-all-link:hover {
            color: #2563eb;
        }
        
        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .orders-table th {
            text-align: left;
            padding: 15px;
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .orders-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
        }
        
        .orders-table tr:hover td {
            background: #f8fafc;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        
        .action-link:hover {
            text-decoration: underline;
        }
        
        /* Activity Feed */
        .activity-feed {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: 25px;
        }
        
        .activity-feed h3 {
            color: #1e293b;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            background: #eef2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #3b82f6;
        }
        
        .activity-details {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 500;
            color: #1e293b;
            margin-bottom: 3px;
        }
        
        .activity-time {
            font-size: 0.85rem;
            color: #64748b;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .charts-row {
                grid-template-columns: 1fr;
            }
            
            .welcome-section h2 {
                font-size: 2rem;
            }
            
            .date-badge {
                position: static;
                margin-top: 20px;
                display: inline-block;
            }
        }
        
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
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .orders-table {
                display: block;
                overflow-x: auto;
            }
            
            .welcome-section {
                text-align: center;
            }
            
            .welcome-section::before {
                display: none;
            }
        }
        
        @media (max-width: 480px) {
            .actions-grid {
                grid-template-columns: 1fr;
            }
            
            .stat-card {
                flex-direction: column;
                text-align: center;
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
                    <div class="admin-avatar">A</div>
                    <span class="admin-name"><%= adminUser %></span>
                </div>
                <a href="../LogoutServlet" class="logout-btn">
                    <span>🚪</span> Logout
                </a>
            </div>
        </div>
    </header>

    <!-- Dashboard Container -->
    <div class="dashboard-container">
        
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="date-badge">
                <%= new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
            </div>
            <h2>Welcome back, <%= adminUser %>! 👋</h2>
            <p>Here's what's happening with your store today. Manage products, view orders, and track performance all in one place.</p>
        </div>
        
       
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <h3>⚡ Quick Actions</h3>
            <div class="actions-grid">
                <a href="addProduct.jsp" class="action-card">
                    <div class="action-icon">➕</div>
                    <h4>Add Product</h4>
                    <p>Create new product listing</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/products" class="action-card">
    				<div class="action-icon">📋</div>
    				<h4>Manage Products</h4>
    				<p>Edit or delete products</p>
				</a>
                
                <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                    <div class="action-icon">👥</div>
                    <h4>View Users</h4>
                    <p>Manage customer accounts</p>
                </a>
                
               <a href="${pageContext.request.contextPath}/admin/orders" class="action-card">
   					 <div class="action-icon">📦</div>
  					  <h4>View Orders</h4>
   						 <p>Manage customer orders</p>
				</a>
                
             
            </div>
        </div>
        
        
    <!-- Optional JavaScript for interactivity -->
    <script>
        // Auto-refresh dashboard every 5 minutes (optional)
        /*
        setTimeout(function() {
            location.reload();
        }, 300000);
        */
        
        // You can add more interactive features here
        console.log('Admin Dashboard loaded');
    </script>

</body>
</html>