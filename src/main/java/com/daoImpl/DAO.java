package com.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.beans.CartItem;
import com.beans.OrderBean;
import com.beans.OrderItemBean;
import com.beans.ProductBean;
import com.beans.UserPojo;
import com.dao.DAOInterface;

public class DAO implements DAOInterface {

	Connection con;
	PreparedStatement psmt;
	ResultSet rs;

	public void setCon(Connection con) {
		this.con = con;
	}

	@Override
	public int insertData(UserPojo u) {

		int count = 0;

		String query = " INSERT INTO user (username, password, question, answer) VALUES(? , ? , ? , ? )";

		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, u.getUsername());
			psmt.setString(2, u.getPassword());
			psmt.setString(3, u.getQuestion());
			psmt.setString(4, u.getAnswer());

			count = psmt.executeUpdate();

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return count;
	}

	@Override
	public boolean retriveData(String username, String password) {

		String query = " SELECT * FROM user WHERE username = ? AND password=?";

		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, username);
			psmt.setString(2, password);

			rs = psmt.executeQuery();

			if (rs.next()) {
				return true;
			} else {
				return false;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;

	}

	@Override
	public String updatePassword(UserPojo u) {

		String query = "UPDATE user SET password = ?  WHERE username = ?";
		String status = null;
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, u.getPassword());
			psmt.setString(2, u.getUsername());

			int count = psmt.executeUpdate();

			if (count != 0) {
				status = "Updated Password";
			} else {
				status = "Update Failed";
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return status;
	}

	@Override
	public boolean verifySecurityQuestion(String username, String question, String answer) {

		String query = "SELECT * FROM user WHERE username = ? AND question = ? AND answer = ?";

		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, username);
			psmt.setString(2, question);
			psmt.setString(3, answer);

			rs = psmt.executeQuery();

			if (rs.next()) {
				return true;
			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean updatePassword(String username, String newPassword) {

		String query = "UPDATE user SET password = ? WHERE username = ?";

		try {
			psmt = con.prepareStatement(query);

			psmt.setString(1, newPassword);
			psmt.setString(2, username);

			int count = psmt.executeUpdate();

			if (count != 0) {
				return true;
			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return false;
	}

//Login Module End

//Product Module Start

	@Override
	public List<ProductBean> getAllProducts() {

		List<ProductBean> products = new ArrayList<ProductBean>();

		String query = " SELECT * FROM product ";

		try {
			psmt = con.prepareStatement(query);

			rs = psmt.executeQuery();

			while (rs.next()) {

				ProductBean product = new ProductBean();

				product.setP_ID(rs.getString(1));
				product.setP_Name(rs.getString(2));
				product.setP_Price(rs.getString(3));
				product.setP_Quantity(rs.getString(4));
				product.setP_Image(rs.getString(5));

				products.add(product);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return products;
	}

	/////

	// Add to your existing DAO.java

	@Override
	public boolean createOrder(OrderBean order, List<OrderItemBean> items) {
		boolean result = false;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// First, check if username column exists in orders table
			// If not, you need to add it: ALTER TABLE orders ADD COLUMN username
			// VARCHAR(100);

			String orderQuery = "INSERT INTO orders (user_id, username, order_date, total_amount, payment_method, "
					+ "payment_status, order_status, shipping_address, phone) "
					+ "VALUES (?, ?, NOW(), ?, ?, ?, ?, ?, ?)";

			System.out.println("Executing order insert: " + orderQuery);
			System.out.println("User ID: " + order.getUserId());
			System.out.println("Username: " + order.getUserName());
			System.out.println("Total Amount: " + order.getTotalAmount());

			pstmt = con.prepareStatement(orderQuery, java.sql.Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, order.getUserId());
			pstmt.setString(2, order.getUserName()); // Save the username
			pstmt.setDouble(3, order.getTotalAmount());
			pstmt.setString(4, order.getPaymentMethod());
			pstmt.setString(5, order.getPaymentStatus());
			pstmt.setString(6, order.getOrderStatus());
			pstmt.setString(7, order.getShippingAddress());
			pstmt.setString(8, order.getPhone());

			int rowsAffected = pstmt.executeUpdate();
			System.out.println("Rows affected: " + rowsAffected);

			if (rowsAffected > 0) {
				// Get generated order ID
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					int orderId = rs.getInt(1);
					System.out.println("Generated Order ID: " + orderId);

					// Insert order items
					String itemQuery = "INSERT INTO order_items (order_id, product_id, product_name, quantity, price) "
							+ "VALUES (?, ?, ?, ?, ?)";
					pstmt = con.prepareStatement(itemQuery);

					int itemCount = 0;
					for (OrderItemBean item : items) {
						pstmt.setInt(1, orderId);
						pstmt.setInt(2, item.getProductId());
						pstmt.setString(3, item.getProductName());
						pstmt.setInt(4, item.getQuantity());
						pstmt.setDouble(5, item.getPrice());
						pstmt.addBatch();
						itemCount++;
					}

					System.out.println("Inserting " + itemCount + " order items");
					int[] itemResults = pstmt.executeBatch();
					System.out.println("Items inserted: " + itemResults.length);

					result = true;
					System.out.println(
							"Order created successfully with ID: " + orderId + " for user: " + order.getUserName());
				} else {
					System.out.println("No generated keys returned");
				}
			} else {
				System.out.println("No rows affected in order insert");
			}

		} catch (Exception e) {
			System.out.println("Error in createOrder: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return result;
	}

	@Override
	public List<OrderBean> getOrdersByUserId(int userId) {
		List<OrderBean> orders = new ArrayList<>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				OrderBean order = new OrderBean();
				order.setOrderId(rs.getInt("order_id"));
				order.setUserId(rs.getInt("user_id"));
				order.setOrderDate(rs.getString("order_date"));
				order.setTotalAmount(rs.getDouble("total_amount"));
				order.setPaymentMethod(rs.getString("payment_method"));
				order.setPaymentStatus(rs.getString("payment_status"));
				order.setOrderStatus(rs.getString("order_status"));
				order.setShippingAddress(rs.getString("shipping_address"));
				order.setPhone(rs.getString("phone"));

				// Get order items
				order.setItems(getOrderItemsByOrderId(order.getOrderId()));

				orders.add(order);
			}

		} catch (Exception e) {
			System.out.println("Error in getOrdersByUserId: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return orders;
	}

	@Override
	public OrderBean getOrderById(int orderId) {
		OrderBean order = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// Updated query to join with user table to get username
			String query = "SELECT o.*, u.ID as user_id, u.username FROM orders o " + "JOIN user u ON o.user_id = u.ID "
					+ "WHERE o.order_id = ?";

			System.out.println("Executing query: " + query);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, orderId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				order = new OrderBean();
				order.setOrderId(rs.getInt("order_id"));
				order.setUserId(rs.getInt("user_id"));
				order.setUserName(rs.getString("username")); // This gets the username
				order.setOrderDate(rs.getString("order_date"));
				order.setTotalAmount(rs.getDouble("total_amount"));
				order.setPaymentMethod(rs.getString("payment_method"));
				order.setPaymentStatus(rs.getString("payment_status"));
				order.setOrderStatus(rs.getString("order_status"));
				order.setShippingAddress(rs.getString("shipping_address"));
				order.setPhone(rs.getString("phone"));

				System.out.println("Order found: ID=" + order.getOrderId() + ", User=" + order.getUserName()
						+ ", Phone=" + order.getPhone());

				// Get order items
				order.setItems(getOrderItemsByOrderId(orderId));
			} else {
				System.out.println("No order found with ID: " + orderId);
			}

		} catch (Exception e) {
			System.out.println("Error in getOrderById: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return order;
	}

	@Override
	public boolean updateOrderStatus(int orderId, String status) {
		boolean result = false;

		try {
			String query = "UPDATE orders SET order_status = ? WHERE order_id = ?";
			psmt = con.prepareStatement(query);
			psmt.setString(1, status);
			psmt.setInt(2, orderId);

			int rowsAffected = psmt.executeUpdate();
			result = (rowsAffected > 0);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (psmt != null)
					psmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

	@Override
	public List<OrderBean> getAllOrders() {
		List<OrderBean> orders = new ArrayList<>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// Join with user table to get username
			String query = "SELECT o.*, u.username FROM orders o " + "LEFT JOIN user u ON o.user_id = u.ID "
					+ "ORDER BY o.order_id DESC";

			System.out.println("Executing query: " + query);
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				OrderBean order = new OrderBean();
				order.setOrderId(rs.getInt("order_id"));
				order.setUserId(rs.getInt("user_id"));
				order.setUserName(rs.getString("username")); // Get username from user table
				order.setOrderDate(rs.getString("order_date"));
				order.setTotalAmount(rs.getDouble("total_amount"));
				order.setPaymentMethod(rs.getString("payment_method"));
				order.setPaymentStatus(rs.getString("payment_status"));
				order.setOrderStatus(rs.getString("order_status"));
				order.setShippingAddress(rs.getString("shipping_address"));
				order.setPhone(rs.getString("phone"));
				orders.add(order);

				System.out.println("Order #" + order.getOrderId() + " - User: " + order.getUserName());
			}

		} catch (Exception e) {
			System.out.println("Error in getAllOrders: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return orders;
	}

	// Helper method to get order items
	private List<OrderItemBean> getOrderItemsByOrderId(int orderId) {
		List<OrderItemBean> items = new ArrayList<>();

		try {
			String query = "SELECT * FROM order_items WHERE order_id = ?";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, orderId);
			rs = psmt.executeQuery();

			while (rs.next()) {
				OrderItemBean item = new OrderItemBean();
				item.setOrderItemId(rs.getInt("order_item_id"));
				item.setOrderId(rs.getInt("order_id"));
				item.setProductId(rs.getInt("product_id"));
				item.setProductName(rs.getString("product_name"));
				item.setQuantity(rs.getInt("quantity"));
				item.setPrice(rs.getDouble("price"));
				item.setSubtotal(item.getPrice() * item.getQuantity());
				items.add(item);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (psmt != null)
					psmt.close();
			} catch (Exception e) {
			}
		}

		return items;
	}

	@Override
	public ProductBean getProductById(int productId) {
		ProductBean product = null;
		String query = "SELECT * FROM product WHERE pid = ?"; // Changed from 'products' to 'product'

		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, productId);
			ResultSet rs = psmt.executeQuery();

			if (rs.next()) {
				product = new ProductBean();
				// Use column names based on your product table structure
				product.setP_ID(rs.getString(1)); // Using index 1 for ID
				product.setP_Name(rs.getString(2)); // Using index 2 for name
				product.setP_Price(rs.getString(3)); // Using index 3 for price
				product.setP_Quantity(rs.getString(4)); // Using index 4 for quantity
				product.setP_Image(rs.getString(5)); // Using index 5 for image
			}
			rs.close();
			psmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return product;
	}

	// ==================== ADMIN PRODUCT METHODS ====================

	@Override
	public boolean addProduct(ProductBean product) {
		boolean result = false;

		try {
			String query = "INSERT INTO product (p_name, price, quantity, image) VALUES (?, ?, ?, ?)";
			psmt = con.prepareStatement(query);

			psmt.setString(1, product.getP_Name());
			psmt.setString(2, product.getP_Price());
			psmt.setString(3, product.getP_Quantity());
			psmt.setString(4, product.getP_Image() != null ? product.getP_Image() : "placeholder.jpg");

			int rowsAffected = psmt.executeUpdate();

			if (rowsAffected > 0) {
				result = true;
				System.out.println("Product added successfully: " + product.getP_Name());
			}

		} catch (Exception e) {
			System.out.println("Error in addProduct: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public boolean updateProduct(ProductBean product) {
		boolean result = false;

		try {
			String query = "UPDATE product SET p_name=?, price=?, quantity=?, image=? WHERE pid=?";
			psmt = con.prepareStatement(query);

			System.out.println(product.getP_ID());

			psmt.setString(1, product.getP_Name());
			psmt.setString(2, product.getP_Price());
			psmt.setString(3, product.getP_Quantity());
			psmt.setString(4, product.getP_Image());
			psmt.setString(5, product.getP_ID());

			int rowsAffected = psmt.executeUpdate();

			if (rowsAffected > 0) {
				result = true;
				System.out.println("Product updated successfully: " + product.getP_ID());
			}

		} catch (Exception e) {
			System.out.println("Error in updateProduct: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public boolean deleteProduct(int productId) {
		boolean result = false;

		try {
			String query = "DELETE FROM product WHERE pid=?";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, productId);

			int rowsAffected = psmt.executeUpdate();

			if (rowsAffected > 0) {
				result = true;
				System.out.println("Product deleted successfully: " + productId);
			}

		} catch (Exception e) {
			System.out.println("Error in deleteProduct: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	// ==================== ADMIN USER METHODS ====================

	@Override
	public List<UserPojo> getAllUsers() {
		List<UserPojo> users = new ArrayList<>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT * FROM user ORDER BY ID DESC";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				UserPojo user = new UserPojo();
				user.setUser_id(rs.getInt("ID"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setQuestion(rs.getString("question"));
				user.setAnswer(rs.getString("answer"));
				user.setStatus(rs.getString("status") != null ? rs.getString("status") : "active");

				users.add(user);
			}

		} catch (Exception e) {
			System.out.println("Error in getAllUsers: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return users;
	}

	// ==================== ADMIN STATISTICS METHODS ====================

	@Override
	public int getProductCount() {
		int count = 0;

		try {
			String query = "SELECT COUNT(*) FROM product";
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("Error in getProductCount: " + e.getMessage());
			e.printStackTrace();
		}

		return count;
	}

	@Override
	public int getUserCount() {
		int count = 0;

		try {
			String query = "SELECT COUNT(*) FROM user";
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("Error in getUserCount: " + e.getMessage());
			e.printStackTrace();
		}

		return count;
	}

	@Override
	public int getOrderCount() {
		int count = 0;

		try {
			String query = "SELECT COUNT(*) FROM orders";
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("Error in getOrderCount: " + e.getMessage());
			e.printStackTrace();
		}

		return count;
	}

	@Override
	public double getTotalRevenue() {
		double revenue = 0.0;

		try {
			String query = "SELECT SUM(total_amount) FROM orders WHERE payment_status='COMPLETED'";
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();

			if (rs.next()) {
				revenue = rs.getDouble(1);
			}

		} catch (Exception e) {
			System.out.println("Error in getTotalRevenue: " + e.getMessage());
			e.printStackTrace();
		}

		return revenue;
	}

	@Override
	public List<OrderBean> getRecentOrders(int limit) {
		List<OrderBean> orders = new ArrayList<>();

		try {
			String query = "SELECT * FROM orders ORDER BY order_id DESC LIMIT ?";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, limit);
			rs = psmt.executeQuery();

			while (rs.next()) {
				OrderBean order = new OrderBean();
				order.setOrderId(rs.getInt("order_id"));
				order.setUserId(rs.getInt("user_id"));
				order.setOrderDate(rs.getString("order_date"));
				order.setTotalAmount(rs.getDouble("total_amount"));
				order.setPaymentMethod(rs.getString("payment_method"));
				order.setPaymentStatus(rs.getString("payment_status"));
				order.setOrderStatus(rs.getString("order_status"));

				// Get username (you might need to join with user table)
				String userQuery = "SELECT username FROM user WHERE user_id=?";
				PreparedStatement userPsmt = con.prepareStatement(userQuery);
				userPsmt.setInt(1, order.getUserId());
				ResultSet userRs = userPsmt.executeQuery();
				if (userRs.next()) {
					order.setUserName(userRs.getString("username"));
				}
				userRs.close();
				userPsmt.close();

				orders.add(order);
			}

		} catch (Exception e) {
			System.out.println("Error in getRecentOrders: " + e.getMessage());
			e.printStackTrace();
		}

		return orders;
	}

	@Override
	public boolean blockUser(int userId) {

		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "UPDATE user SET status = 'blocked' WHERE ID = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);

			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				result = true;
				System.out.println("User blocked successfully: " + userId);
			}

		} catch (Exception e) {
			System.out.println("Error in blockUser: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;

	}

	@Override
	public boolean unblockUser(int userId) {

		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "UPDATE user SET status = 'active' WHERE ID = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);

			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				result = true;
				System.out.println("User unblocked successfully: " + userId);
			}

		} catch (Exception e) {
			System.out.println("Error in unblockUser: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;

	}

	@Override
	public String getUserStatus(int userId) {

		String status = "active";
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT status FROM user WHERE ID = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				status = rs.getString("status");
				if (status == null)
					status = "active";
			}

		} catch (Exception e) {
			System.out.println("Error in getUserStatus: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return status;

	}

	// getting user ststus block or unblock
	public String getUserStatusByUsername(String username) {
		String status = "active";
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT status FROM user WHERE username = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, username);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				status = rs.getString("status");
				if (status == null)
					status = "active";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return status;
	}

	@Override
	public int getUserIdByUsername(String username) {
		int userId = -1;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT ID FROM user WHERE username = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, username);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				userId = rs.getInt("ID");
			}

		} catch (Exception e) {
			System.out.println("Error in getUserIdByUsername: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return userId;
	}

	@Override
	public UserPojo getUserByUsername(String username) {
		UserPojo user = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT ID, username, status FROM user WHERE username = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, username);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				user = new UserPojo();
				user.setUser_id(rs.getInt("ID")); // Get the actual user ID
				user.setUsername(rs.getString("username"));
				user.setStatus(rs.getString("status"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return user;
	}

	@Override
	public boolean addToCartDB(int userId, int productId, int quantity) {
		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			// Check if product already in cart
			String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
			pstmt = con.prepareStatement(checkQuery);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, productId);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				// Update existing cart item
				int existingQty = rs.getInt("quantity");
				String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
				pstmt = con.prepareStatement(updateQuery);
				pstmt.setInt(1, existingQty + quantity);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, productId);
			} else {
				// Insert new cart item
				String insertQuery = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
				pstmt = con.prepareStatement(insertQuery);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, productId);
				pstmt.setInt(3, quantity);
			}

			int rowsAffected = pstmt.executeUpdate();
			result = (rowsAffected > 0);

			if (result) {
				System.out.println("Added to DB cart - User: " + userId + ", Product: " + productId);
			}

		} catch (Exception e) {
			System.out.println("Error in addToCartDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

	@Override
	public boolean updateCartQuantityDB(int userId, int productId, int quantity) {
		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, quantity);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, productId);

			int rowsAffected = pstmt.executeUpdate();
			result = (rowsAffected > 0);

		} catch (Exception e) {
			System.out.println("Error in updateCartQuantityDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

	@Override
	public boolean removeFromCartDB(int userId, int productId) {
		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, productId);

			int rowsAffected = pstmt.executeUpdate();
			result = (rowsAffected > 0);

		} catch (Exception e) {
			System.out.println("Error in removeFromCartDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

	@Override
	public List<CartItem> getCartItemsFromDB(int userId) {
		List<CartItem> cartItems = new ArrayList<>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT c.*, p.* FROM cart c " + "JOIN product p ON c.product_id = p.pid "
					+ "WHERE c.user_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				// Create ProductBean from product table
				ProductBean product = new ProductBean();
				product.setP_ID(String.valueOf(rs.getInt("pid")));
				product.setP_Name(rs.getString("p_name"));
				product.setP_Price(String.valueOf(rs.getDouble("price")));
				product.setP_Quantity(String.valueOf(rs.getInt("quantity")));
				product.setP_Image(rs.getString("image"));

				// Create CartItem
				CartItem item = new CartItem(product, rs.getInt("c.quantity"));
				item.setCartId(rs.getInt("cart_id"));
				item.setUserId(rs.getInt("user_id"));

				cartItems.add(item);
			}

			System.out.println("Loaded " + cartItems.size() + " items from DB cart for user: " + userId);

		} catch (Exception e) {
			System.out.println("Error in getCartItemsFromDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return cartItems;
	}

	@Override
	public boolean clearCartDB(int userId) {
		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "DELETE FROM cart WHERE user_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);

			int rowsAffected = pstmt.executeUpdate();
			result = true;
			System.out.println("Cleared DB cart for user: " + userId);

		} catch (Exception e) {
			System.out.println("Error in clearCartDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

	@Override
	public int getCartCountDB(int userId) {
		int count = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt("total");
			}

		} catch (Exception e) {
			System.out.println("Error in getCartCountDB: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return count;
	}

	public boolean updateProductQuantity(int productId, int quantityOrdered) {
		boolean result = false;
		PreparedStatement pstmt = null;

		try {
			String query = "UPDATE product SET quantity = quantity - ? WHERE pid = ? AND quantity >= ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, quantityOrdered);
			pstmt.setInt(2, productId);
			pstmt.setInt(3, quantityOrdered);

			int rowsAffected = pstmt.executeUpdate();
			result = (rowsAffected > 0);

			if (result) {
				System.out.println("Stock updated for product " + productId + ": -" + quantityOrdered);
			}

		} catch (Exception e) {
			System.out.println("Error in updateProductQuantity: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
			}
		}

		return result;
	}

}
