package com.servlet;

import java.io.IOException;

import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeleteProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== DELETE PRODUCT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            String productIdStr = request.getParameter("productId");
            
            if(productIdStr == null || productIdStr.isEmpty()) {
                System.out.println("Product ID is null or empty");
                response.sendRedirect(request.getContextPath() + "/admin/products?error=invalid");
                return;
            }
            
            int productId = Integer.parseInt(productIdStr);
            System.out.println("Deleting product ID: " + productId);
            
            // Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                try {
                    boolean deleted = DAOobj.deleteProduct(productId);
                    
                    if(deleted) {
                        System.out.println("Product deleted successfully");
                        response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
                    } else {
                        System.out.println("Failed to delete product");
                        response.sendRedirect(request.getContextPath() + "/admin/products?error=deletefailed");
                    }
                } catch(Exception e) {
                    String errorMessage = e.getMessage();
                    System.out.println("Error deleting product: " + errorMessage);
                    
                    // Check if it's a foreign key constraint error
                    if(errorMessage.contains("foreign key constraint") || errorMessage.contains("Cannot delete or update a parent row")) {
                        response.sendRedirect(request.getContextPath() + "/admin/products?error=constraint");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/products?error=exception");
                    }
                }
            } else {
                System.out.println("DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/products?error=system");
            }
            
        } catch(Exception e) {
            System.out.println("Exception in DeleteProductServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=exception");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}