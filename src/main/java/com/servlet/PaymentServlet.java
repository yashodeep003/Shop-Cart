package com.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.beans.CartItem;
import com.beans.OrderBean;
import com.beans.OrderItemBean;
import com.beans.UserPojo;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== PAYMENT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if(session == null || session.getAttribute("p") == null) {
            response.sendRedirect("signIn.jsp");
            return;
        }
        
        UserPojo currentUser = (UserPojo) session.getAttribute("p");
        
        // Get cart from session
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        
        if(cart == null || cart.isEmpty()) {
            response.sendRedirect("Products.jsp");
            return;
        }
        
        try {
            // Get form data from checkout.jsp
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String country = request.getParameter("country");
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Get payment details (these will come from payment.jsp)
            String cardNumber = request.getParameter("cardNumber");
            String cardHolderName = request.getParameter("cardHolderName");
            String expiryMonth = request.getParameter("expiryMonth");
            String expiryYear = request.getParameter("expiryYear");
            String cvv = request.getParameter("cvv");
            
            // Calculate totals
            double subtotal = Double.parseDouble(request.getParameter("subtotal"));
            double shippingCharge = Double.parseDouble(request.getParameter("shippingCharge"));
            double tax = Double.parseDouble(request.getParameter("tax"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            
            // Create full shipping address
            String fullAddress = address + ", " + city + ", " + state + " - " + pincode + ", " + country;
            
            // Create OrderBean
            OrderBean order = new OrderBean();
            order.setUserId(getUserId(currentUser)); // You need to implement this method
            order.setUserName(currentUser.getUsername());
            order.setOrderDate(new java.util.Date().toString());
            order.setTotalAmount(totalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus("PENDING");
            order.setOrderStatus("PROCESSING");
            order.setShippingAddress(fullAddress);
            order.setPhone(phone);
            
            // Create OrderItem list
            List<OrderItemBean> orderItems = new ArrayList<>();
            for(CartItem item : cart.values()) {
                OrderItemBean orderItem = new OrderItemBean();
                orderItem.setProductId(Integer.parseInt(item.getProduct().getP_ID()));
                orderItem.setProductName(item.getProduct().getP_Name());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setPrice(Double.parseDouble(item.getProduct().getP_Price()));
                orderItem.setSubtotal(item.getSubtotal());
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);
            
            // Store order in session for confirmation page
            session.setAttribute("currentOrder", order);
            
            // For payment processing, we'll redirect to a payment page
            // You can either process payment here or show a payment form
            
            if("cod".equals(paymentMethod)) {
                // Cash on Delivery - process immediately
                processOrder(session, order, orderItems, "COMPLETED", "Cash on Delivery");
                response.sendRedirect("confirmation.jsp");
            } else {
                // For card/UPI payments, show payment form
                session.setAttribute("paymentData", request.getParameterMap());
                response.sendRedirect("payment.jsp");
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=paymentfailed");
        }
    }
    
    private void processOrder(HttpSession session, OrderBean order, List<OrderItemBean> items, 
                              String paymentStatus, String paymentMethod) {
        // Update order status
        order.setPaymentStatus(paymentStatus);
        order.setPaymentMethod(paymentMethod);
        
        // Get DAO object
        DAOInterface DAOobj = (DAOInterface) session.getServletContext().getAttribute("DAOobj");
        
        if(DAOobj != null) {
            // Save order to database
            boolean orderCreated = DAOobj.createOrder(order, items);
            if(orderCreated) {
                System.out.println("Order saved successfully");
                
                // Update product quantities
                for(OrderItemBean item : items) {
                    // You need to add this method to DAO
                    // DAOobj.updateProductQuantity(item.getProductId(), item.getQuantity());
                }
                
                // Clear the cart
                session.removeAttribute("cart");
                session.setAttribute("cartCount", 0);
                
                // Store order in session for confirmation
                session.setAttribute("lastOrder", order);
            }
        }
    }
    
    // Helper method to get user ID - you need to implement this based on your UserPojo
    private int getUserId(UserPojo user) {
        // You need to fetch user ID from database using username
        // For now, return a default value
        return 1;
    }
}