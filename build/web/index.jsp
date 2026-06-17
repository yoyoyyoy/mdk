<%@ page import="logistics.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("MainServlet?action=dashboard");
    } else {
        response.sendRedirect("MainServlet?action=login");
    }
%>