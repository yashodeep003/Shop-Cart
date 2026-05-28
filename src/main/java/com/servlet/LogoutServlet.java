package com.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== LOGOUT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        if(session != null) {
            // IMPORTANT: Do NOT clear database cart
            // Cart data is already saved in database from previous operations
            // Just remove session attributes
            
            session.removeAttribute("cart");
            session.removeAttribute("cartCount");
            session.removeAttribute("p");
            session.removeAttribute("admin");
            session.invalidate();
            
            System.out.println("Session invalidated - Database cart preserved");
        }
        
        response.sendRedirect("signIn.jsp?message=loggedout");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}