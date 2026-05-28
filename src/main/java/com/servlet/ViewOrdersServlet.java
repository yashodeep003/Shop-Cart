package com.servlet;

import java.io.IOException;
import java.util.List;

import com.beans.OrderBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== VIEW ORDERS SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                System.out.println("Fetching all orders...");
                List<OrderBean> orders = DAOobj.getAllOrders();
                
                System.out.println("Orders fetched: " + (orders != null ? orders.size() : "null"));
                
                // Set orders in request attribute
                request.setAttribute("orders", orders);
                
                // Forward to JSP
                request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
            } else {
                System.out.println("DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=dao");
            }
            
        } catch(Exception e) {
            System.out.println("Error in ViewOrdersServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=exception");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}