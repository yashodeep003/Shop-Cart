package com.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.beans.CartItem;
import com.beans.ProductBean;
import com.beans.UserPojo;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AddToCartServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if(session == null || session.getAttribute("p") == null) {
            response.sendRedirect("signIn.jsp");
            return;
        }
        
        UserPojo currentUser = (UserPojo) session.getAttribute("p");
        int userId = currentUser.getUser_id(); 
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            // STEP 1: Save to DATABASE first
            boolean dbAdded = DAOobj.addToCartDB(userId, productId, quantity);
            
            if(dbAdded) {
                // STEP 2: Update session cart
                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
                if(cart == null) {
                    cart = new HashMap<>();
                }
                
                // Fetch product details
                ProductBean product = DAOobj.getProductById(productId);
                
                if(cart.containsKey(productId)) {
                    CartItem existingItem = cart.get(productId);
                    existingItem.setQuantity(existingItem.getQuantity() + quantity);
                } else {
                    cart.put(productId, new CartItem(product, quantity));
                }
                
                session.setAttribute("cart", cart);
                
                // Update cart count
                int cartCount = DAOobj.getCartCountDB(userId);
                session.setAttribute("cartCount", cartCount);
                
                response.sendRedirect("Products.jsp?success=added");
            } else {
                response.sendRedirect("Products.jsp?error=cartfailed");
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("Products.jsp?error=exception");
        }
    }
}