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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * ProcessPaymentServlet.java
 * 
 * This servlet handles the final payment processing and order creation.
 * It validates payment details, creates order in database, and clears the cart.
 * 
 * Responsibilities:
 * 1. Validate payment details from payment.jsp
 * 2. Create order in database (orders and order_items tables)
 * 3. Clear cart from database (cart table)
 * 4. Clear cart from session
 * 5. Redirect to confirmation page
 */
public class ProcessPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== PROCESS PAYMENT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // STEP 1: Check if user is logged in
        if(session == null || session.getAttribute("p") == null) {
            System.out.println("User not logged in - redirecting to login");
            response.sendRedirect("signIn.jsp");
            return;
        }
        
        // Get logged-in user details
        UserPojo currentUser = (UserPojo) session.getAttribute("p");
        int userId = currentUser.getUser_id();
        
        System.out.println("Processing order for user: " + currentUser.getUsername() + " (ID: " + userId + ")");
        
        // STEP 2: Get cart from session
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        
        if(cart == null || cart.isEmpty()) {
            System.out.println("Cart is empty - redirecting to products page");
            response.sendRedirect("Products.jsp");
            return;
        }
        
        try {
            // STEP 3: Get payment details from request
            String paymentMethod = request.getParameter("paymentMethod");
            String totalAmountStr = request.getParameter("totalAmount");
            
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Total Amount: " + totalAmountStr);
            
            // Validate request parameters
            if(totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                System.out.println("ERROR: totalAmount is null in request");
                response.sendRedirect("payment.jsp?error=amountmissing");
                return;
            }
            
            // STEP 4: Get shipping data from session (stored by CheckoutServlet)
            Map<String, String[]> paymentData = (Map<String, String[]>) session.getAttribute("paymentData");
            
            if(paymentData == null) {
                System.out.println("ERROR: paymentData is null in session");
                response.sendRedirect("checkout.jsp?error=sessionexpired");
                return;
            }
            
            // STEP 5: Extract shipping information with null checks
            String[] firstNameArr = paymentData.get("firstName");
            String[] lastNameArr = paymentData.get("lastName");
            String[] emailArr = paymentData.get("email");
            String[] phoneArr = paymentData.get("phone");
            String[] addressArr = paymentData.get("address");
            String[] cityArr = paymentData.get("city");
            String[] stateArr = paymentData.get("state");
            String[] pincodeArr = paymentData.get("pincode");
            String[] countryArr = paymentData.get("country");
            
            // Validate required fields
            if(firstNameArr == null || firstNameArr.length == 0) {
                System.out.println("ERROR: firstName is missing in session data");
                response.sendRedirect("checkout.jsp?error=missingdata");
                return;
            }
            
            // Extract values
            String firstName = firstNameArr[0];
            String lastName = (lastNameArr != null && lastNameArr.length > 0) ? lastNameArr[0] : "";
            String email = (emailArr != null && emailArr.length > 0) ? emailArr[0] : "";
            String phone = (phoneArr != null && phoneArr.length > 0) ? phoneArr[0] : "";
            String address = (addressArr != null && addressArr.length > 0) ? addressArr[0] : "";
            String city = (cityArr != null && cityArr.length > 0) ? cityArr[0] : "";
            String state = (stateArr != null && stateArr.length > 0) ? stateArr[0] : "";
            String pincode = (pincodeArr != null && pincodeArr.length > 0) ? pincodeArr[0] : "";
            String country = (countryArr != null && countryArr.length > 0) ? countryArr[0] : "India";
            
            // Create full shipping address
            String fullAddress = address + ", " + city + ", " + state + " - " + pincode + ", " + country;
            
            System.out.println("Shipping Address: " + fullAddress);
            System.out.println("Phone: " + phone);
            System.out.println("Email: " + email);
            
            // STEP 6: Calculate totals from cart
            double subtotal = 0;
            for(CartItem item : cart.values()) {
                subtotal += item.getSubtotal();
            }
            double shippingCharge = subtotal >= 500 ? 0 : 50;
            double tax = subtotal * 0.05;
            double totalAmount = Double.parseDouble(totalAmountStr);
            
            // STEP 7: Create OrderBean
            OrderBean order = new OrderBean();
            order.setUserId(userId);
            order.setUserName(currentUser.getUsername());
            order.setOrderDate(new java.util.Date().toString());
            order.setTotalAmount(totalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus("COMPLETED");
            order.setOrderStatus("PROCESSING");
            order.setShippingAddress(fullAddress);
            order.setPhone(phone);
            
            // STEP 8: Create OrderItem list
            List<OrderItemBean> orderItems = new ArrayList<>();
            for(CartItem item : cart.values()) {
                OrderItemBean orderItem = new OrderItemBean();
                orderItem.setProductId(Integer.parseInt(item.getProduct().getP_ID()));
                orderItem.setProductName(item.getProduct().getP_Name());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setPrice(Double.parseDouble(item.getProduct().getP_Price()));
                orderItem.setSubtotal(item.getSubtotal());
                orderItems.add(orderItem);
                
                System.out.println("Order Item: " + item.getProduct().getP_Name() + 
                                   " x " + item.getQuantity() + 
                                   " = ₹" + item.getSubtotal());
            }
            order.setItems(orderItems);
            
            // STEP 9: Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj == null) {
                System.out.println("ERROR: DAO object is null");
                response.sendRedirect("payment.jsp?error=systemerror");
                return;
            }
            
            // STEP 10: Save order to database
            System.out.println("Creating order in database...");
            boolean orderCreated = DAOobj.createOrder(order, orderItems);
            
            if(orderCreated) {
                System.out.println("Order saved successfully! Order ID: " + order.getOrderId());
                
                // ===== STEP 11: CLEAR CART FROM DATABASE =====
                // This is the key step - remove cart items from database after successful order
                boolean cartCleared = DAOobj.clearCartDB(userId);
                if(cartCleared) {
                    System.out.println("Cart cleared from database for user: " + userId);
                } else {
                    System.out.println("Warning: Failed to clear cart from database");
                }
                
                // ===== STEP 12: CLEAR CART FROM SESSION =====
                session.removeAttribute("cart");
                session.removeAttribute("paymentData");
                session.setAttribute("cartCount", 0);
                System.out.println("Cart cleared from session");
                
                // STEP 13: Store order in session for confirmation page
                session.setAttribute("lastOrder", order);
                
                // STEP 14: Update product quantities (reduce stock)
                for(OrderItemBean item : orderItems) {
                    boolean stockUpdated = DAOobj.updateProductQuantity(item.getProductId(), item.getQuantity());
                    if(stockUpdated) {
                        System.out.println("Stock updated for product: " + item.getProductId());
                    }
                }
                
                // STEP 15: Redirect to confirmation page
                System.out.println("Redirecting to confirmation page");
                response.sendRedirect("confirmation.jsp");
                
            } else {
                System.out.println("Failed to create order");
                response.sendRedirect("payment.jsp?error=orderfailed");
            }
            
        } catch(Exception e) {
            System.out.println("Exception in ProcessPaymentServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("payment.jsp?error=exception");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}