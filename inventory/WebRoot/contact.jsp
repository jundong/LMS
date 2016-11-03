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
							<a href="/inventory/sendmail.jsp?mail=bibin.shakya@spirentcom.com&name=Bibin Shakya">Bibin Shakya</a>
						</td>
						<td>
							Honolulu
						</td>
						<td>
							Project Management
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/inventory/sendmail.jsp?mail=yiqin.zhou@spirentcom.com&name=Yiqin Zhou">Yiqin Zhou</a>
						</td>
						<td>
							Beijing
						</td>
						<td>
							BDC Resource Management
						</td>
					</tr>
					<tr>
						<td>
							<a href="/inventory/sendmail.jsp?mail=saiyoot@spirentcom.com&name=Saiyoot Nakkhongkham">Saiyoot Nakkhongkham</a>
						</td>
						<td>
							Honolulu
						</td>
						<td>
							Research, Proto Type & DevTests
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/inventory/sendmail.jsp?mail=jundong.xu@spirentcom.com&name=Jundong Xu">Jundong Xu</a>
						</td>
						<td>
							Beijing
						</td>
						<td>
							Development
						</td>
					</tr>
					<tr>
						<td>
							<a href="/inventory/sendmail.jsp?mail=angel.comonfort@spirentcom.com&name=Angel Comonfort">Angel Comonfort</a>
						</td>
						<td>
							Sunnyvale
						</td>
						<td>
							Lab Prime
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/inventory/sendmail.jsp?mail=james.skibenes@spirentcom.com&name=James Skibenes">James Skibenes</a>
						</td>
						<td>
							Raleigh
						</td>
						<td>
							Lab Prime
						</td>
					</tr>
					<tr>
						<td>
							<a href="/inventory/sendmail.jsp?mail=dong.ha@spirentcom.com&name=Dong Ha">Dong Ha</a>
						</td>
						<td>
							Honolulu
						</td>
						<td>
							Lab Prime
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<a href="/inventory/sendmail.jsp?mail=kai.shao@spirentcom.com&name=Kevin Sha">Kevin Shao</a>
						</td>
						<td>
							Beijing
						</td>
						<td>
							Lab Prime
						</td>
					</tr>
					<tr>
						<td>
							<a href="/inventory/sendmail.jsp?mail=niaz.sadeqiar@spirentcom.com&name=Niaz Sadeqiar">Niaz Sadeqiar</a>
						</td>
						<td>
							Calabasas
						</td>
						<td>
							Lab Prime
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
