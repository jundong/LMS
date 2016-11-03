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
<link rel="stylesheet" href="/iprep/common/css/style.css" type="text/css"
			media="screen" />
	<%
		String Ip = request.getParameter("Ip");
		String Port = request.getParameter("Port");
		String DUTPort = Ip + "//" + Port;
	%>
	
  </head>
   <frameset rows="130,*"  frameborder=0>
  <frame src="/iprep/tree/dutport.jsp?Ip=<%=Ip %>&Port=<%=Port %>">
   <frame src="/iprep/scheduler/scheduler.jsp?Port=<%=DUTPort %>&type=dspage" > 
 </frameset> 

</html>
