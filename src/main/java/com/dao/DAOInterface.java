package com.dao;

import java.sql.Connection;
import java.util.List;

import com.beans.CartItem;
import com.beans.OrderBean;
import com.beans.OrderItemBean;
import com.beans.ProductBean;
import com.beans.UserPojo;

public interface DAOInterface {


	int insertData(UserPojo u);

	boolean retriveData(String username, String password);

	String updatePassword(UserPojo u);

	boolean verifySecurityQuestion(String username, String question, String answer);

	boolean updatePassword(String username, String newPassword);

	List<ProductBean> getAllProducts();

	ProductBean getProductById(int productId);
	
	public String getUserStatusByUsername(String username);

	
	
	// ORDER METHODS
	boolean createOrder(OrderBean order, List<OrderItemBean> items);

	List<OrderBean> getOrdersByUserId(int userId);

	OrderBean getOrderById(int orderId);

	boolean updateOrderStatus(int orderId, String status);

	List<OrderBean> getAllOrders();
	
	int getUserIdByUsername(String username);
	
	UserPojo getUserByUsername(String username);
	

	
	
	// ADMIN METHODS
	boolean addProduct(ProductBean product);

	boolean updateProduct(ProductBean product);

	boolean deleteProduct(int productId);

	List<UserPojo> getAllUsers();

	int getProductCount();

	int getUserCount();

	int getOrderCount();

	double getTotalRevenue();

	List<OrderBean> getRecentOrders(int limit);

	
	
	// NEW USER MANAGEMENT METHODS
	boolean blockUser(int userId);

	boolean unblockUser(int userId);

	String getUserStatus(int userId);

	void setCon(Connection con);
	
	
	
	
	
	 // CART DATABASE METHODS 
	
	 boolean addToCartDB(int userId, int productId, int quantity);
	 boolean updateCartQuantityDB(int userId, int productId, int quantity);
	 boolean removeFromCartDB(int userId, int productId);
	 List<CartItem> getCartItemsFromDB(int userId);
	 boolean clearCartDB(int userId);
	 int getCartCountDB(int userId);

	 boolean updateProductQuantity(int productId, int quantity);

}
