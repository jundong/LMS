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
		<title>Warning</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

	</head>

	<body>
		<div class="content">
			<a HREF="/inventory/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/inventory/help.jsp">Documentation</a>
			<hr>
			<b>Warning</b>
			<hr>
			<table border="0" cellpadding="0" cellspacing="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						<font>* Warning: No permission to access this page.</font>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td>
						<br>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<font>* Please login with admin account to do this
							operation.</font>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td>
						<br>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<font>* Or contact your administrator to do this.</font>
					</td>
				</tr>
			</table>
		</div>
		<div class="footer">
			<div class="footer-logo"></div>
			<div class="copyright">
				2010 Spirent Communications
				<br />
				All rights reserved.
			</div>
		</div>
	</body>
</html>
