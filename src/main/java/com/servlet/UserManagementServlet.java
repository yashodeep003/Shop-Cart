package com.servlet;

import java.io.IOException;

import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== USER MANAGEMENT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        
        if(userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=system");
                return;
            }
            
            boolean success = false;
            
            if("block".equals(action)) {
                success = DAOobj.blockUser(userId);
                if(success) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=blocked");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=blockfailed");
                }
            } else if("unblock".equals(action)) {
                success = DAOobj.unblockUser(userId);
                if(success) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=unblocked");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=unblockfailed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalidaction");
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=exception");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}