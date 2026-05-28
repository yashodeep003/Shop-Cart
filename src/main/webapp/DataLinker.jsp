<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="p" class="com.beans.UserPojo" scope="session" />

<%
    String req = request.getParameter("name");

    if ("signup".equals(req)) {
%>
        <jsp:setProperty name="p" property="*" />
<%
    } else if ("signin".equals(req)) {
%>
        <jsp:setProperty name="p" property="username" />
        <jsp:setProperty name="p" property="password" />
<%
    } else if ("forgotpassword".equals(req)) {
%>
        <jsp:setProperty name="p" property="username" />
        <jsp:setProperty name="p" property="question" />
        <jsp:setProperty name="p" property="answer" />
        
        <%
            // Store new password in session
            session.setAttribute("newPassword", request.getParameter("newPassword"));
        %>
<%
    }
%>


<%
    // Forward to ControllerServlet
    RequestDispatcher rd = request.getRequestDispatcher("/ControllerServlet");
    rd.forward(request, response);
%>