<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
	String type = request.getParameter("type");
	String ip = request.getParameter("ip");
	String oldLocation = request.getParameter("location");
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update equipment location</title>
<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />
</head>
<body>
<div class="content">
			<a HREF="/inventory/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/inventory/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Update Information</b>
			<hr>
	<form action="/inventory/updatevmlocation.do" method="post"> 
	<table>
		<tr bgcolor="#C2D5FC">
			<td>
				IPAdress:
			</td>
			<td> 
				<input type="text" value="<%=ip%>" disabled/>
			</td>
		</tr>
		<tr bgcolor="#C2D5FC">
			<td>
				Location:
			</td> 
			<td>
				<textarea rows="3" cols="80" name="newLocation"><%=oldLocation%></textarea>
			</td>
		</tr>
	</table>
		<input type="hidden" name="type" value="<%=type%>"/>
		<input type="hidden" name="ip" value="<%=ip%>"/>
		<input type="submit" value="Update"/>
	</form>
	</div>
</body>
</html>