<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.formatstring.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
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
		<title>VM Client</title>
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
			<b>VM Client Information</b>
			<hr>
			<%
				String ClientIp = request.getParameter("ClientIp");
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
	
						if (ClientIp != null) {
							upd = "SELECT * FROM vm_client WHERE VMClient = '" + ClientIp
									+ "'";
						}
	
						rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0"
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
						Server&nbsp;&nbsp;
					</td>						
					<td>
						IP&nbsp;&nbsp;
					</td>	
					<td>
						Name&nbsp;&nbsp;
					</td>					
					<td>
						ClientDNS&nbsp;&nbsp;
					</td>										
					<td>
						Client&nbsp;&nbsp;
					</td>	
					<td>
						Guest&nbsp;OS&nbsp;&nbsp;
					</td>												
					<td>
						Status&nbsp;&nbsp;
					</td>															
					<td>
						CPU&nbsp;Numbers&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;&nbsp;
					</td>	
					<td>
						ResEnd&nbsp;&nbsp;
					</td>	
					<td>
						ResBy&nbsp;&nbsp;
					</td>	
					<td>
						UserName&nbsp;&nbsp;
					</td>																								
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
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
							HREF="/inventory/tree/vmhost.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/inventory/update.jsp?VMIp=<%=rs.getString("VMHost")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>"><%=rs.getString("VMHostName")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<a HREF="/inventory/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>"><%=rs.getString("VMHost")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<%=rs.getString("ClientName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("VMClientDNS")%>&nbsp;&nbsp;
					</td>																			
					<td>
						<%=rs.getString("VMClient")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("GuestOS")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("RunState")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("NumberOfCPU")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Memory")%>&nbsp;&nbsp;
					</td>																	
					<td>
                        <%=(new FormatString()).vpResEnd(rs.getString("ClientName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).vpResBy(rs.getString("ClientName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("UserName")%>&nbsp;&nbsp;
					</td>																	
					<td>
						<a HREF="/inventory/update/notes.jsp?ClientIp=<%=rs.getString("VMClient")%>&ClientNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
				                	x = x + 1;
					          	}
				%>

				<%
			            }
					} catch (Exception e) {
						System.out.println("Error occourred in vmclient.jsp: "
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
							.println("Close DB error occourred in vmclient.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>

			</table>
		</div>
	</body>
</html>
