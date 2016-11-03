<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>

<%
  if (request.getSession().getAttribute("username") == null){
      	out.println("<script type=\"text/javascript\">");
		out.println("top.location = '/inventory/login.jsp'");
		out.println("</script>");
  }
%>


