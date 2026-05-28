package com.servlet;

import java.io.IOException;

import com.beans.OrderBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== UPDATE ORDER STATUS SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get parameters
            String orderIdStr = request.getParameter("orderId");
            String newStatus = request.getParameter("status");
            
            System.out.println("Order ID: " + orderIdStr);
            System.out.println("New Status: " + newStatus);
            
            if(orderIdStr == null || orderIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid");
                return;
            }
            
            if(newStatus == null || newStatus.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            // Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                // First verify the order exists
                OrderBean order = DAOobj.getOrderById(orderId);
                
                if(order == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=notfound");
                    return;
                }
                
                // Update the order status
                boolean updated = DAOobj.updateOrderStatus(orderId, newStatus);
                
                if(updated) {
                    System.out.println("Order #" + orderId + " status updated to: " + newStatus);
                    response.sendRedirect(request.getContextPath() + "/admin/orders?success=updated");
                } else {
                    System.out.println("Failed to update order status");
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=updatefailed");
                }
            } else {
                System.out.println("DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=system");
            }
            
        } catch(NumberFormatException e) {
            System.out.println("Invalid order ID format");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid");
        } catch(Exception e) {
            System.out.println("Exception in UpdateOrderStatusServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=exception");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}