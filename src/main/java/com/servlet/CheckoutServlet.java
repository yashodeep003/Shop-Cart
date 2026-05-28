package com.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== CHECKOUT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        if(session == null || session.getAttribute("p") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get all form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String country = request.getParameter("country");
            String totalAmount = request.getParameter("totalAmount");
            
            
            
            // Store in session
            Map<String, String[]> paymentData = new HashMap<>();
            paymentData.put("firstName", new String[]{firstName});
            paymentData.put("lastName", new String[]{lastName});
            paymentData.put("email", new String[]{email});
            paymentData.put("phone", new String[]{phone});
            paymentData.put("address", new String[]{address});
            paymentData.put("city", new String[]{city});
            paymentData.put("state", new String[]{state});
            paymentData.put("pincode", new String[]{pincode});
            paymentData.put("country", new String[]{country});
            paymentData.put("totalAmount", new String[]{totalAmount});
            
            session.setAttribute("paymentData", paymentData);
            
            // Redirect to payment page
            response.sendRedirect(request.getContextPath() + "/payment.jsp");
            
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=exception");
        }
    }
}