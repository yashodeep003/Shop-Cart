package com.servlet;

import java.io.IOException;
import java.util.List;

import com.beans.ProductBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== ADMIN PRODUCTS SERVLET CALLED ==========");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            System.out.println("Admin not logged in - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get DAO object
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                System.out.println("DAO object found, fetching all products...");
                List<ProductBean> products = DAOobj.getAllProducts();
                
                System.out.println("Products fetched from DAO: " + (products != null ? products.size() : "null"));
                
                if(products != null) {
                    for(ProductBean p : products) {
                        System.out.println("  - Product: ID=" + p.getP_ID() + 
                                         ", Name=" + p.getP_Name() + 
                                         ", Price=" + p.getP_Price());
                    }
                } else {
                    System.out.println("WARNING: getAllProducts() returned null");
                    products = new java.util.ArrayList<>(); // Empty list instead of null
                }
                
                // Set products in request attribute
                request.setAttribute("products", products);
                System.out.println("Products set in request attribute with size: " + products.size());
                
                // Forward to JSP
                System.out.println("Forwarding to /admin/products.jsp");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            } else {
                System.out.println("ERROR: DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=dao");
            }
            
        } catch(Exception e) {
            System.out.println("ERROR in AdminProductsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=exception");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}