<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.beans.*, java.util.*"%>

<%
System.out.println("========== ORDERS.JSP LOADED ==========");

// PROTECTION: Redirect to servlet if accessed directly
if (request.getAttribute("orders") == null) {
	System.out.println("DIRECT ACCESS DETECTED - Redirecting to servlet");
	response.sendRedirect(request.getContextPath() + "/admin/orders");
	return;
}

// Check if admin is logged in
if (session.getAttribute("admin") == null) {
	response.sendRedirect(request.getContextPath() + "/signIn.jsp");
	return;
}

String adminUser = (String) session.getAttribute("admin");

// Get orders from request attribute
List<OrderBean> orders = (List<OrderBean>) request.getAttribute("orders");

System.out.println("Orders received from servlet: " + (orders != null ? orders.size() : "null"));

if (orders == null) {
	orders = new ArrayList<>();
}

// Calculate statistics
double totalRevenue = 0;
int shippingOrders = 0;
int processingOrders = 0;
int deliveredOrders = 0;
int cancelledOrders = 0;

for (OrderBean order : orders) {
	totalRevenue += order.getTotalAmount();
	switch (order.getOrderStatus()) {
		case "SHIPPING" :
			shippingOrders++;
	break;
		case "PROCESSING" :
	processingOrders++;
	break;
		case "DELIVERED" :
	deliveredOrders++;
	break;
		case "CANCELLED" :
	cancelledOrders++;
	break;
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Orders - Admin Panel</title>
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
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
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
	background: rgba(255, 255, 255, 0.1);
	padding: 10px 25px;
	border-radius: 40px;
	display: flex;
	align-items: center;
	gap: 12px;
	border: 1px solid rgba(255, 255, 255, 0.2);
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

/* Success/Error Messages */
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

@
keyframes slideIn {from { opacity:0;
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
	margin-bottom: 30px;
}

.page-header h2 {
	font-size: 2rem;
	color: #1e293b;
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 20px;
}

.order-count {
	background: #3b82f6;
	color: white;
	padding: 5px 15px;
	border-radius: 40px;
	font-size: 0.9rem;
	margin-left: 15px;
}

/* Stats Grid */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 20px;
	margin: 30px 0;
}

.stat-card {
	background: white;
	border-radius: 15px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	text-align: center;
	transition: transform 0.3s;
}

.stat-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.stat-icon {
	font-size: 2rem;
	margin-bottom: 10px;
}

.stat-card h4 {
	color: #64748b;
	font-size: 0.9rem;
	margin-bottom: 10px;
	text-transform: uppercase;
}

.stat-number {
	font-size: 2rem;
	font-weight: bold;
	color: #1e293b;
}

.stat-revenue {
	color: #10b981;
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
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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
	min-width: 150px;
	background: white;
	cursor: pointer;
}

/* Orders Table */
.table-container {
	background: white;
	border-radius: 20px;
	padding: 25px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
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

.order-id {
	font-weight: 600;
	color: #3b82f6;
}

.customer-info {
	display: flex;
	flex-direction: column;
}

.customer-name {
	font-weight: 600;
	color: #1e293b;
}

.customer-email {
	font-size: 0.85rem;
	color: #64748b;
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

.status-delivered {
	background: #d4edda;
	color: #155724;
}

.status-cancelled {
	background: #f8d7da;
	color: #721c24;
}

/* Status Update Form */
.status-form {
	display: flex;
	gap: 8px;
	align-items: center;
}

.status-select {
	padding: 8px 12px;
	border: 2px solid #e2e8f0;
	border-radius: 6px;
	font-size: 0.9rem;
	background: white;
	cursor: pointer;
	min-width: 130px;
}

.status-select:focus {
	outline: none;
	border-color: #3b82f6;
}

.update-btn {
	padding: 8px 16px;
	background: #10b981;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 0.85rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s;
	white-space: nowrap;
}

.update-btn:hover {
	background: #059669;
	transform: translateY(-2px);
}

.view-btn {
	background: #3b82f6;
	color: white;
	padding: 8px 16px;
	border-radius: 6px;
	text-decoration: none;
	font-size: 0.85rem;
	transition: all 0.3s;
	white-space: nowrap;
}

.view-btn:hover {
	background: #2563eb;
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

@media ( max-width : 1024px) {
	.status-form {
		flex-direction: column;
		gap: 5px;
	}
	.status-select, .update-btn {
		width: 100%;
	}
}

@media ( max-width : 768px) {
	.stats-grid {
		grid-template-columns: 1fr 1fr;
	}
	.filter-section {
		flex-direction: column;
	}
	.search-box {
		width: 100%;
	}
	table {
		display: block;
		overflow-x: auto;
	}
	th, td {
		white-space: nowrap;
	}
}
</style>
</head>
<body>

	<!-- Admin Header -->
	<header class="admin-header">
		<div class="header-container">
			<div class="logo">
				<h1>
					🛍️ Shop<span>Cart</span>
				</h1>
				<span>Admin Panel</span>
			</div>
			<div class="admin-info">
				<div class="admin-badge">
					<div class="admin-avatar">
						<%=adminUser.substring(0, 1).toUpperCase()%>
					</div>
					<span class="admin-name"><%=adminUser%></span>
				</div>
				<a href="${pageContext.request.contextPath}/LogoutServlet"
					class="logout-btn"> <span>🚪</span> Logout
				</a>
			</div>
		</div>
	</header>

	<!-- Success/Error Messages -->
	<div class="message-container">
		<%
		if (request.getParameter("success") != null) {
		%>
		<%
		if ("updated".equals(request.getParameter("success"))) {
		%>
		<div class="success-message">✅ Order status updated
			successfully!</div>
		<%
		}
		%>
		<%
		}
		%>

		<%
		if (request.getParameter("error") != null) {
		%>
		<div class="error-message">
			<%
			if ("invalid".equals(request.getParameter("error"))) {
			%>
			❌ Invalid order ID or status.
			<%
			} else if ("notfound".equals(request.getParameter("error"))) {
			%>
			❌ Order not found.
			<%
			} else if ("updatefailed".equals(request.getParameter("error"))) {
			%>
			❌ Failed to update order status. Please try again.
			<%
			} else if ("system".equals(request.getParameter("error"))) {
			%>
			❌ System error. Please try again later.
			<%
			} else if ("exception".equals(request.getParameter("error"))) {
			%>
			❌ An error occurred. Please try again.
			<%
			}
			%>
		</div>
		<%
		}
		%>
	</div>

	<!-- Main Container -->
	<div class="main-container">

		<div class="page-header">
			<h2>
				📦 Order Management <span class="order-count"><%=orders.size()%>
					orders</span>
			</h2>

			<!-- Statistics Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon">💰</div>
					<h4>Total Revenue</h4>
					<div class="stat-number stat-revenue">
						₹<%=String.format("%,.2f", totalRevenue)%></div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">⚙️</div>
					<h4>Processing</h4>
					<div class="stat-number"><%=processingOrders%></div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">📦</div>
					<h4>Shipping</h4>
					<div class="stat-number"><%=shippingOrders%></div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">✅</div>
					<h4>Delivered</h4>
					<div class="stat-number"><%=deliveredOrders%></div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">❌</div>
					<h4>Cancelled</h4>
					<div class="stat-number"><%=cancelledOrders%></div>
				</div>
			</div>

			<!-- Filter Section -->
			<div class="filter-section">
				<div class="search-box">
					<input type="text" id="searchInput"
						placeholder="Search by Order ID or Customer...">
					<button class="search-btn" onclick="searchOrders()">Search</button>
				</div>
				<select class="filter-select" id="statusFilter"
					onchange="filterByStatus()">
					<option value="all">All Orders</option>
					<option value="PROCESSING">Processing</option>
					<option value="SHIPPING">Shipping</option>
					<option value="DELIVERED">Delivered</option>
					<option value="CANCELLED">Cancelled</option>
				</select>
			</div>
		</div>

		<!-- Orders Table -->
		<div class="table-container">
			<%
			if (orders.isEmpty()) {
			%>
			<div class="no-data">
				<div class="icon">📦</div>
				<h3>No Orders Found</h3>
				<p>There are no orders in the system yet.</p>
			</div>
			<%
			} else {
			%>
			<table id="ordersTable">
				<thead>
					<tr>
						<th>Order ID</th>
						<th>Customer</th>
						<th>Date</th>
						<th>Amount</th>
						<th>Payment</th>
						<th>Current Status</th>
						<th>Update Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (OrderBean order : orders) {
						String statusClass = "";
						switch (order.getOrderStatus()) {
							case "SHIPPING" :
						statusClass = "status-shipping";
						break;
							case "PROCESSING" :
						statusClass = "status-processing";
						break;
							case "DELIVERED" :
						statusClass = "status-delivered";
						break;
							case "CANCELLED" :
						statusClass = "status-cancelled";
						break;
						}
					%>
					<tr data-status="<%=order.getOrderStatus()%>">
						<td class="order-id">#<%=order.getOrderId()%></td>
						<td>
							<div class="customer-info">
								<span class="customer-name"> <%=order.getUserName() != null ? order.getUserName() : "Unknown"%>
								</span> <span class="customer-email">ID: <%=order.getUserId()%></span>
							</div>
						</td>
						<td><%=order.getOrderDate()%></td>
						<td><strong>₹<%=String.format("%,.2f", order.getTotalAmount())%></strong></td>
						<td><%=order.getPaymentMethod()%></td>
						<td><span class="status-badge <%=statusClass%>"> <%=order.getOrderStatus()%>
						</span></td>
						<td>
							<form class="status-form"
								action="${pageContext.request.contextPath}/admin/UpdateOrderStatusServlet"
								method="post">
								<input type="hidden" name="orderId"
									value="<%=order.getOrderId()%>"> <select
									name="status" class="status-select"
									<%="DELIVERED".equals(order.getOrderStatus()) || "CANCELLED".equals(order.getOrderStatus()) ? "disabled" : ""%>>
									<option value="SHIPPING"
										<%="SHIPPING".equals(order.getOrderStatus()) ? "selected" : ""%>>Shipping</option>
									<option value="PROCESSING"
										<%="PROCESSING".equals(order.getOrderStatus()) ? "selected" : ""%>>Processing</option>
									<option value="DELIVERED"
										<%="DELIVERED".equals(order.getOrderStatus()) ? "selected" : ""%>>Delivered</option>
									<option value="CANCELLED"
										<%="CANCELLED".equals(order.getOrderStatus()) ? "selected" : ""%>>Cancelled</option>
								</select>
								<%
								if (!"DELIVERED".equals(order.getOrderStatus()) && !"CANCELLED".equals(order.getOrderStatus())) {
								%>
								<button type="submit" class="update-btn">Update</button>
								<%
								}
								%>
							</form>
						</td>
						<td><a
							href="${pageContext.request.contextPath}/admin/orderDetails.jsp?id=<%= order.getOrderId() %>"
							class="view-btn">View</a></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<%
			}
			%>
		</div>

		<div style="text-align: center; margin-top: 20px;">
			<a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
				class="back-link">← Back to Dashboard</a>
		</div>
	</div>

	<!-- JavaScript -->
	<script>
		function searchOrders() {
			const input = document.getElementById('searchInput');
			const filter = input.value.toUpperCase();
			const table = document.getElementById('ordersTable');

			if (!table)
				return;

			const rows = table.getElementsByTagName('tr');

			for (let i = 1; i < rows.length; i++) {
				const row = rows[i];
				const orderIdCell = row.getElementsByTagName('td')[0];
				const customerCell = row.getElementsByTagName('td')[1];

				if (orderIdCell && customerCell) {
					const orderId = orderIdCell.textContent
							|| orderIdCell.innerText;
					const customer = customerCell.textContent
							|| customerCell.innerText;

					if (orderId.toUpperCase().indexOf(filter) > -1
							|| customer.toUpperCase().indexOf(filter) > -1) {
						row.style.display = '';
					} else {
						row.style.display = 'none';
					}
				}
			}
		}

		function filterByStatus() {
			const filter = document.getElementById('statusFilter').value;
			const table = document.getElementById('ordersTable');

			if (!table)
				return;

			const rows = table.getElementsByTagName('tr');

			for (let i = 1; i < rows.length; i++) {
				const row = rows[i];
				const status = row.getAttribute('data-status');

				if (filter === 'all' || status === filter) {
					row.style.display = '';
				} else {
					row.style.display = 'none';
				}
			}
		}

		// Auto-hide messages after 5 seconds
		window.addEventListener('load', function() {
			const successMsg = document.querySelector('.success-message');
			if (successMsg) {
				setTimeout(function() {
					successMsg.style.opacity = '0';
					setTimeout(function() {
						successMsg.style.display = 'none';
					}, 500);
				}, 5000);
			}

			const errorMsg = document.querySelector('.error-message');
			if (errorMsg) {
				setTimeout(function() {
					errorMsg.style.opacity = '0';
					setTimeout(function() {
						errorMsg.style.display = 'none';
					}, 500);
				}, 5000);
			}
		});

		document.getElementById('searchInput').addEventListener('keyup',
				function(e) {
					if (e.key === 'Enter') {
						searchOrders();
					}
				});
	</script>

</body>
</html>