<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>	
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<base href="<%=basePath%>">
		<title>Contact</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />

	</head>
	<body>
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Contact</b>
			<hr>
			<div style="margin: 0px 0px 0px 15%;">
				<table >
					<tr bgcolor="#C2D5FC">
						<td>
							Name
						</td>
						<td>
							Site
						</td>
						<td>
							Roles
						</td>
					</tr>
					<tr>
						<td>
							<a href="/iprep/sendmail.jsp?mail=Chris.chapman@spirent.com&name=Chris Chapman">Chris Chapman</a>
						</td>
						<td>
							Sunnyvale
						</td>
						<td>
							Layer 2-7
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/iprep/sendmail.jsp?mail=Brett.wolmarans@spirent.com&name=Brett Wolmarans">Brett Wolmarans</a>
						</td>
						<td>
							Calabasas
						</td>
						<td>
							Virtual and Storage
						</td>
					</tr>
					<tr>
						<td>
							<a href="/iprep/sendmail.jsp?mail=Himesh.mehta@spirent.com&name=Himesh Mehta">Himesh Mehta</a>
						</td>
						<td>
							Calabasas
						</td>
						<td>
							Routing and Mobile backhaul
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/iprep/sendmail.jsp?mail=Diego Lozano de Fournas@spirent.com&name=Diego Lozano de Fournas">Diego Lozano de Fournas</a>
						</td>
						<td>
							Sunnyvale
						</td>
						<td>
							Mobility
						</td>
					</tr>
					<tr>
						<td>
							<a href="/iprep/sendmail.jsp?mail=Jim.Anuskiewicz@spirent.com&name=Jim Anuskiewicz">Jim Anuskiewicz</a>
						</td>
						<td>
							Honolulu
						</td>
						<td>
							TME Manager; Layer 4-7
						</td>
					</tr>
				</table>
			</div>
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
