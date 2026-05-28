package com.servlet;

import java.io.IOException;
import java.util.Map;

import com.beans.CartItem;
import com.beans.UserPojo;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RemoveFromCartServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("p") == null) {
			response.sendRedirect("signIn.jsp");
			return;
		}

		UserPojo currentUser = (UserPojo) session.getAttribute("p");
		int userId = currentUser.getUser_id();

		try {
			int productId = Integer.parseInt(request.getParameter("productId"));

			DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");

			// Remove from DATABASE
			boolean dbRemoved = DAOobj.removeFromCartDB(userId, productId);

			if (dbRemoved) {
				// Remove from session
				Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
				if (cart != null) {
					cart.remove(productId);
					session.setAttribute("cart", cart);

					// Update cart count
					int cartCount = DAOobj.getCartCountDB(userId);
					session.setAttribute("cartCount", cartCount);
				}
			}

			response.sendRedirect("cart.jsp");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("cart.jsp?error=exception");
		}
	}
}