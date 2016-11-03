<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();  
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <base href="<%=basePath%>">   
    <title>AVPort-Scheduler</title>
<link rel="stylesheet" href="/inventory/common/css/style.css" type="text/css"
			media="screen" />
	<%
		String AVAddr = request.getParameter("Ip");
		String PortIndex = request.getParameter("Index");
		String Port = AVAddr + "/" + PortIndex;
	%>
	
  </head>
   <frameset rows="130,*"  frameborder=0>
  <frame src="/inventory/tree/avsport.jsp?Ip=<%=AVAddr %>&Index=<%=PortIndex %>">
   <frame src="/inventory/scheduler/scheduler.jsp?type=aspage&Port=<%=Port %>" > 
 </frameset> 

</html>
