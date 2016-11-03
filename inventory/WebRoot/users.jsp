<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
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
		<title>Users</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />
	</head>
	<body>
		<div class="content">
			<a HREF="/inventory/admin.jsp">Admin</A>
			<hr>
			<b>Users</b>
			<hr>
			<%
				Connection conn = null;
				try {
					conn = (new DataBaseConnection()).getConnection();
					Statement stmt = conn.createStatement();
					String upd = "SELECT * FROM users";
					ResultSet rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						User&nbsp;Name&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						User&nbsp;Full&nbsp;Name&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						User&nbsp;Levels&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						Default&nbsp;Site&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						E-Mail&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						Weekly&nbsp;Login&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						Monthly&nbsp;Login&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						Total&nbsp;Login&nbsp;&nbsp;&nbsp;&nbsp;
					</td>															
				</tr>
				<%
					int x = 0;
						String color = "";
						while (rs.next()) {
							if (x % 2 == 0) {
								color = "#FFFFFF";
							} else {
								color = "#C2D5FC";
							}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/admin.jsp?<%=rs.getString("username")%>"><%=rs.getString("username")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("domainname")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("levels")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("site")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("mail")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("logintimes")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("monloginreport")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("totallogin")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					x = x + 1;
						}
						rs.close();
				%>

				<%
					} catch (Exception e) {
						System.out.println("Error occourred in users.jsp: "
								+ e.getMessage());
					} finally {
						try {
							if (conn != null)
								conn.close();
						} catch (SQLException sqle) {
							System.out
									.println("Unable to close database connection in users.jsp: "
											+ sqle.getMessage());
						}
					}
				%>

			</table>
		</div>
	</body>
</html>
