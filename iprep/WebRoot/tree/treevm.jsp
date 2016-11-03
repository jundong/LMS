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
		<title>TreeVM</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
	</head>
	<body style="height: 140px">
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL" target="_parent">STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL" target="_parent">DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL" target="_parent">VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>VM Client Information</b>
			<hr>
			<%
				String ClientName = request.getParameter("ClientName");
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
	
						if (ClientName != null) {
							upd = "SELECT * FROM vm_client WHERE ClientName = '" + ClientName
									+ "'";
						}
	
						rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
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
							HREF="/iprep/tree/vmhost.jsp?Site=<%=rs.getString("Site")%>" target="_parent"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/update.jsp?VMIp=<%=rs.getString("VMHost")%>" target="_parent"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>" target="_parent"><%=rs.getString("VMHostName")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>" target="_parent"><%=rs.getString("VMHost")%>&nbsp;&nbsp;</a>
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
<%
						String resBy = (new FormatString()).vpResBy(rs.getString("ClientName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue());
						if(resBy == null || resBy.trim().equals("")) {
					 %>
					 	<B><font color="#00FF00">AVAILABLE</font></B>
					 	<%} else { %>
					 	<%=resBy%>
					 	<%} %>					</td>
					<td>
						<%=rs.getString("UserName")%>&nbsp;&nbsp;
					</td>																	
					<td>
						<a HREF="/iprep/update/notes.jsp?ClientIp=<%=rs.getString("VMClient")%>&ClientNotes=<%=rs.getString("Notes")%>" target="_parent"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					          x = x + 1;
						  }
				%>
			</table>
			<%
			        }
				} catch (Exception e) {
					System.out.println("Error occourred in treevm.jsp: "
							+ e.getMessage());
				}finally {
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
							.println("Close DB error occourred in treevm.jsp: "
									+ e.getMessage());
			        	}
			        }
			%>
		</div>
	</body>
</html>
