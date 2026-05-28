<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*" %>

<%
    System.out.println("========== USERS.JSP LOADED ==========");
    
    // PROTECTION: Redirect to servlet if accessed directly
    if(request.getAttribute("users") == null) {
        System.out.println("DIRECT ACCESS DETECTED - Redirecting to servlet");
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    // Check if admin is logged in
    if(session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/signIn.jsp");
        return;
    }
    
    String adminUser = (String) session.getAttribute("admin");
    
    // Get users from request attribute
    List<UserPojo> users = (List<UserPojo>) request.getAttribute("users");
    
    System.out.println("Users received from servlet: " + (users != null ? users.size() : "null"));
    
    if(users == null) {
        users = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin Panel</title>
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
        
        /* Message Container */
        .message-container {
            max-width: 1400px;
            margin: 20px auto 0;
            padding: 0 25px;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 4px solid #28a745;
            margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 4px solid #dc3545;
            margin-bottom: 20px;
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
        
        /* Main Container */
        .main-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 25px;
        }
        
        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-header h2 {
            font-size: 2rem;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-count {
            background: #3b82f6;
            color: white;
            padding: 5px 15px;
            border-radius: 40px;
            font-size: 0.9rem;
            margin-left: 15px;
        }
        
        /* Search Section */
        .search-section {
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
            min-width: 300px;
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
            padding: 12px 25px;
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
        
        /* Filter by Status */
        .status-filter {
            padding: 12px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            min-width: 150px;
        }
        
        /* Users Table */
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
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.1rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-details h4 {
            color: #1e293b;
            margin-bottom: 4px;
        }
        
        .user-details p {
            color: #64748b;
            font-size: 0.85rem;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-blocked {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
        }
        
        .block-btn {
            background: #ef4444;
            color: white;
        }
        
        .block-btn:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }
        
        .unblock-btn {
            background: #10b981;
            color: white;
        }
        
        .unblock-btn:hover {
            background: #059669;
            transform: translateY(-2px);
        }
        
        .view-btn {
            background: #3b82f6;
            color: white;
        }
        
        .view-btn:hover {
            background: #2563eb;
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
        
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .search-section {
                flex-direction: column;
            }
            
            .search-box {
                width: 100%;
            }
            
            table {
                display: block;
                overflow-x: auto;
            }
            
            .action-btn {
                margin-bottom: 5px;
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

    <!-- Message Container -->
    <div class="message-container">
        <% if(request.getParameter("success") != null) { %>
            <% if("blocked".equals(request.getParameter("success"))) { %>
                <div class="success-message">
                    ✅ User blocked successfully!
                </div>
            <% } else if("unblocked".equals(request.getParameter("success"))) { %>
                <div class="success-message">
                    ✅ User unblocked successfully!
                </div>
            <% } %>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
            <div class="error-message">
                <% if("invalid".equals(request.getParameter("error"))) { %>
                    ❌ Invalid user ID.
                <% } else if("blockfailed".equals(request.getParameter("error"))) { %>
                    ❌ Failed to block user. Please try again.
                <% } else if("unblockfailed".equals(request.getParameter("error"))) { %>
                    ❌ Failed to unblock user. Please try again.
                <% } else if("invalidaction".equals(request.getParameter("error"))) { %>
                    ❌ Invalid action.
                <% } else if("system".equals(request.getParameter("error"))) { %>
                    ❌ System error. Please try again later.
                <% } else if("exception".equals(request.getParameter("error"))) { %>
                    ❌ An error occurred. Please try again.
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        
        <div class="page-header">
            <h2>
                👥 User Management
                <span class="user-count"><%= users.size() %> users</span>
            </h2>
        </div>
        
        <!-- Search and Filter Section -->
        <div class="search-section">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search users by username..." onkeyup="searchUsers()">
                <button class="search-btn" onclick="searchUsers()">🔍 Search</button>
            </div>
            <select class="status-filter" id="statusFilter" onchange="filterByStatus()">
                <option value="all">All Users</option>
                <option value="active">Active Users</option>
                <option value="blocked">Blocked Users</option>
            </select>
        </div>
        
        <!-- Users Table -->
        <div class="table-container">
            <% if(users.isEmpty()) { %>
                <div class="no-data">
                    <div class="icon">👥</div>
                    <h3>No Users Found</h3>
                    <p>There are no registered users yet.</p>
                </div>
            <% } else { %>
                <table id="usersTable">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Username</th>
                            <th>User ID</th>
                            <th>Security Question</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(UserPojo user : users) { 
                            String status = user.getStatus() != null ? user.getStatus() : "active";
                            String statusClass = "active".equals(status) ? "status-active" : "status-blocked";
                            String statusText = "active".equals(status) ? "Active" : "Blocked";
                        %>
                        <tr data-status="<%= status %>">
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <%= user.getUsername().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div class="user-details">
                                        <h4><%= user.getUsername() %></h4>
                                    </div>
                                </div>
                            </td>
                            <td>@<%= user.getUsername() %></td>
                            <td>#<%= user.getUser_id() %></td> 
                            <td><%= user.getQuestion() != null ? user.getQuestion() : "Not set" %></td>
                            <td>
                                <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                            </td>
                            <td>
                                <% if("active".equals(status)) { %>
                                    <form action="${pageContext.request.contextPath}/admin/UserManagementServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="userId" value="<%= user.getUser_id() %>">
                                        <input type="hidden" name="action" value="block">
                                        <button type="submit" class="action-btn block-btn" onclick="return confirm('Are you sure you want to block this user? They will not be able to login.')">Block</button>
                                    </form>
                                <% } else { %>
                                    <form action="${pageContext.request.contextPath}/admin/UserManagementServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="userId" value="<%= user.getUser_id() %>">
                                        <input type="hidden" name="action" value="unblock">
                                        <button type="submit" class="action-btn unblock-btn" onclick="return confirm('Are you sure you want to unblock this user? They will be able to login again.')">Unblock</button>
                                    </form>
                                <% } %>
                               
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-link">← Back to Dashboard</a>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        function searchUsers() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('usersTable');
            
            if(!table) return;
            
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const usernameCell = row.getElementsByTagName('td')[1];
                
                if(usernameCell) {
                    const username = usernameCell.textContent || usernameCell.innerText;
                    if(username.toUpperCase().indexOf(filter) > -1) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            }
        }
        
        function filterByStatus() {
            const filter = document.getElementById('statusFilter').value;
            const table = document.getElementById('usersTable');
            
            if(!table) return;
            
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const status = row.getAttribute('data-status');
                
                if(filter === 'all' || status === filter) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }
        
        // Auto-hide messages after 5 seconds
        window.addEventListener('load', function() {
            const successMsg = document.querySelector('.success-message');
            if(successMsg) {
                setTimeout(function() {
                    successMsg.style.opacity = '0';
                    setTimeout(function() {
                        successMsg.style.display = 'none';
                    }, 500);
                }, 5000);
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
        
        document.getElementById('searchInput').addEventListener('keyup', function(e) {
            if(e.key === 'Enter') {
                searchUsers();
            }
        });
    </script>

</body>
</html>