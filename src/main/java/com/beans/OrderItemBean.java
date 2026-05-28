package com.beans;

public class OrderItemBean {
    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;
    private int quantity;
    private double price;
    private double subtotal;
    
    // Constructors
    public OrderItemBean() {}
    
    public OrderItemBean(int orderItemId, int orderId, int productId, 
                         String productName, int quantity, double price) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = price * quantity;
    }
    
    // Getters and Setters
    public int getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
        this.subtotal = this.price * this.quantity;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
        this.subtotal = this.price * this.quantity;
    }
    
    public double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}