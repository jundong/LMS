<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Port-Scheduler</title>
<link rel="stylesheet" href="/inventory/common/css/style.css" type="text/css"
			media="screen" />
	<%
		String DNSHostName = request.getParameter("DNSHostName");
	%>
	
  </head>
   <frameset rows="130,*"  frameborder=0>
  <frame src="/inventory/tree/treepc.jsp?DNSHostName=<%=DNSHostName %>">
   <frame src="/inventory/scheduler/scheduler.jsp?Port=<%=DNSHostName %>&type=pcspage" > 
 </frameset> 

</html>
