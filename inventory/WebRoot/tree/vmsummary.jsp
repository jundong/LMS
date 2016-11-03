<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%--<%@ include file="../authentication.jsp"%>--%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>VM Client Summary</title>
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
			<b>VM Client Summary</b>
			<hr>
			<%
				String IP = request.getParameter("Ip");
				String Site = request.getParameter("Site");
			%>

			<%
				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String upd = "";
	
						if (Site != null) {
							if (Site.equals("ALL")) {
								upd = "SELECT * FROM vm_summary ORDER BY Site,VMClient";
							} else {
								upd = "SELECT * FROM vm_summary WHERE Site = '" + Site
										+ "' ORDER BY Site,VMClient";
							}
						} else {
							upd = "SELECT * FROM vm_summary WHERE VMHost = '" + IP
									+ "' ORDER BY Site,VMClient";
						}
	
						rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						VM&nbsp;Client&nbsp;&nbsp;
					</td>
					<td>
						Client&nbsp;Name&nbsp;&nbsp;
					</td>
					<td>
						Server&nbsp;&nbsp;
					</td>
					<td>
						Reserve1&nbsp;&nbsp;
					</td>
					<td>
						Reserve2&nbsp;&nbsp;
					</td>
					<td>
						Reserve3&nbsp;&nbsp;
					</td>
					<td>
						Reserve4&nbsp;&nbsp;
					</td>
					<td>
						Reserve5&nbsp;&nbsp;
					</td>
					<td>
						Reserve6&nbsp;&nbsp;
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
						<a
							HREF="/inventory/tree/vmsummary.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/inventory/update.jsp?VMIp=<%=rs.getString("VMClient")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/inventory/tree/vmclient.jsp?Ip=<%=rs.getString("VMClient")%>"><%=rs.getString("VMClient")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("ClientName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("VMHost")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve1")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve2")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve3")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve4")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve5")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Reserve6")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
				            	x = x + 1;
						    }
				%>

				<%
			            }
					} catch (Exception e) {
						System.out.println("Error occourred in vmsummary.jsp: "
								+ e.getMessage());
					} finally {
			        	try {
			        		if(rs != null){
			        			rs.close();
			        		}
			        		if(stmt != null){
			        			stmt.close();
			        		}
			        		if(conn != null){
			        			DataBaseConnection.freeConnection(conn); 
			        		}
			        	} catch (Exception e) {      
			    			System.out
							.println("Close DB error occourred in vmsummary.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>

			</table>
		</div>
	</body>
</html>
