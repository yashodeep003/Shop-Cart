package com.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.aspects.ObjectProvider;
import com.aspects.ObjectProviderDAO;
import com.beans.CartItem;
import com.beans.UserPojo;
import com.dao.DAOInterface;
import com.service.LoginValidationInterface;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ControllerServlet extends HttpServlet {

	LoginValidationInterface BLobj = null;
	DAOInterface DAOobj = null;
	Connection con;

	// Hardcoded admin username pass
	private static final String ADMIN_USERNAME = "Admin";
	private static final String ADMIN_PASSWORD = "Admin123";

	public void init() throws ServletException {

		con = (Connection) getServletContext().getAttribute("DBCon");

		if (con == null) {
			System.out.println("Connection is null - check context attribute");
		}

		String daoClassName = getServletConfig().getInitParameter("DAOClass");
		DAOobj = ObjectProviderDAO.createObjectDAO(daoClassName);
		DAOobj.setCon(con);

		// Store DAO in application context for JSPs
		getServletContext().setAttribute("DAOobj", DAOobj);

		String className = getServletConfig().getInitParameter("BLClass");
		BLobj = ObjectProvider.createObject(className);
		BLobj.setDAO(DAOobj);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("======In Controller Sevlet =======\n");

		PrintWriter out = response.getWriter();
		response.setContentType("text/html");

		HttpSession session = request.getSession(true);
		RequestDispatcher rd = null;

		String action = request.getParameter("name");

		if ("signup".equals(action)) {
			UserPojo p = (UserPojo) session.getAttribute("p");
			boolean value = BLobj.signUp(p);

			if (value) {
				rd = request.getRequestDispatcher("signIn.jsp");
			} else {
				session.invalidate();
				rd = request.getRequestDispatcher("signUp.jsp");
			}
			rd.forward(request, response);

			// In your ControllerServlet, in the signin section:
		} else if ("signin".equals(action)) {
			String username = request.getParameter("username");
			String password = request.getParameter("password");

			// Check for admin
			if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
				session.setAttribute("admin", username);
				response.sendRedirect("admin/dashboard.jsp");
				return;
			}

			boolean value = BLobj.signIn(username, password);

			if (value) {
				// Check if user is blocked
				String userStatus = DAOobj.getUserStatusByUsername(username);
				if ("blocked".equals(userStatus)) {
					request.setAttribute("error", "Your account has been blocked.");
					request.getRequestDispatcher("signIn.jsp").forward(request, response);
					return;
				}

				// Get full user details
				UserPojo loggedInUser = DAOobj.getUserByUsername(username);
				session.setAttribute("p", loggedInUser);

				// ===== CRITICAL: LOAD CART FROM DATABASE =====
				List<CartItem> dbCart = DAOobj.getCartItemsFromDB(loggedInUser.getUser_id());

				// Convert to session cart format
				Map<Integer, CartItem> sessionCart = new HashMap<>();
				int totalCount = 0;

				for (CartItem item : dbCart) {
					int productId = Integer.parseInt(item.getProduct().getP_ID());
					sessionCart.put(productId, item);
					totalCount += item.getQuantity();
				}

				session.setAttribute("cart", sessionCart);
				session.setAttribute("cartCount", totalCount);

				System.out.println("Cart loaded for user: " + username + " - Items: " + sessionCart.size());

				response.sendRedirect("Products.jsp");
			} else {
				request.setAttribute("error", "Invalid username or password");
				request.getRequestDispatcher("signIn.jsp").forward(request, response);
			}
		} else if ("forgotpassword".equals(action)) {
			// forgot password code
			if (session.getAttribute("p") == null) {
				response.sendRedirect("forgotPassword.jsp");
				return;
			}

			String newPassword = (String) session.getAttribute("newPassword");
			System.out.println("New password from session: " + (newPassword != null ? "present" : "null"));

			UserPojo p = (UserPojo) session.getAttribute("p");
			System.out.println("Verifying security question for: " + p.getUsername());

			String status = BLobj.forgetPassword(p.getUsername(), p.getQuestion(), p.getAnswer());
			System.out.println("ForgetPassword status: " + status);

			if ("success".equals(status)) {
				System.out.println("Security question verified, updating password...");

				boolean updated = BLobj.updateUserPassword(p.getUsername(), newPassword);
				System.out.println("Password update result: " + updated);

				if (updated) {
					session.removeAttribute("newPassword");
					session.invalidate();
					rd = request.getRequestDispatcher("signIn.jsp?message=passwordreset");
				} else {
					rd = request.getRequestDispatcher("forgotPassword.jsp?error=updatefailed");
				}
			} else {
				System.out.println("Security question verification failed");
				rd = request.getRequestDispatcher("forgotPassword.jsp?error=" + status);
			}

			rd.forward(request, response);
		} else {
			response.sendRedirect("signIn.jsp");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}