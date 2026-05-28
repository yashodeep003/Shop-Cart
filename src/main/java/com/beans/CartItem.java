package com.beans;

public class CartItem {
	private ProductBean product;
	private int quantity;
	private int cartId; 
	private int userId; 

	// Constructors
	public CartItem() {
	}

	public CartItem(ProductBean product, int quantity) {
		this.product = product;
		this.quantity = quantity;
	}

	// Getters and Setters
	public ProductBean getProduct() {
		return product;
	}

	public void setProduct(ProductBean product) {
		this.product = product;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getCartId() {
		return cartId;
	}

	public void setCartId(int cartId) {
		this.cartId = cartId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public double getSubtotal() {
		double price = 0.0;
		try {
			price = Double.parseDouble(product.getP_Price());
		} catch (NumberFormatException e) {
			price = 0.0;
		}
		return price * quantity;
	}
}