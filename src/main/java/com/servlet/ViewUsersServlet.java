package com.servlet;

import java.io.IOException;
import java.util.List;

import com.beans.UserPojo;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== VIEW USERS SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                List<UserPojo> users = DAOobj.getAllUsers();
                request.setAttribute("users", users);
                request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=dao");
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=exception");
        }
    }
}