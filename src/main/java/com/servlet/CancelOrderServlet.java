package com.servlet;

import java.io.IOException;

import com.beans.OrderBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== CANCEL ORDER SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if(session == null || session.getAttribute("p") == null) {
            response.sendRedirect("signIn.jsp");
            return;
        }
        
        try {
            // Get order ID from request
            String orderIdParam = request.getParameter("orderId");
            
            if(orderIdParam == null || orderIdParam.isEmpty()) {
                response.sendRedirect("orders.jsp?error=invalidorder");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdParam);
            System.out.println("Attempting to cancel order ID: " + orderId);
            
            // Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj == null) {
                response.sendRedirect("orders.jsp?error=systemerror");
                return;
            }
            
            // Fetch the order to check its current status
            OrderBean order = DAOobj.getOrderById(orderId);
            
            if(order == null) {
                response.sendRedirect("orders.jsp?error=ordernotfound");
                return;
            }
            
            // Check if order can be cancelled (only if status is PROCESSING or PENDING)
            String orderStatus = order.getOrderStatus();
            if(!"PROCESSING".equals(orderStatus) && !"PENDING".equals(orderStatus)) {
                response.sendRedirect("orderDetails.jsp?orderId=" + orderId + "&error=cannotcancel");
                return;
            }
            
            // Update order status to CANCELLED
            boolean cancelled = DAOobj.updateOrderStatus(orderId, "CANCELLED");
            
            if(cancelled) {
                System.out.println("Order #" + orderId + " cancelled successfully");
                response.sendRedirect("orders.jsp?success=cancelled");
            } else {
                response.sendRedirect("orderDetails.jsp?orderId=" + orderId + "&error=cancelfailed");
            }
            
        } catch(NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("orders.jsp?error=invalidnumber");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("orders.jsp?error=exception");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}