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
		<title>VM Server</title>
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
			<b>VM Server Information</b>
			<hr>
			<%
				String Site = request.getParameter("Site");
				String BladName = request.getParameter("BladName");
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
	
	                    if (BladName != null) {
		                    upd = "SELECT distinct VMHostName FROM vm_client WHERE Site = '" + Site
										+ "' AND BladName = '" + BladName + "' ORDER BY VMHostName";
							rs = stmt.executeQuery(upd);
							String vmhosts = "";
							int count = 0;
							while (rs.next()) {
							   if (count > 0) {
							      vmhosts = vmhosts + " OR ";
							   }
							   vmhosts = vmhosts + "Name='" + rs.getString("VMHostName") + "'";
							   count++; 
							}
							upd = "SELECT * FROM vm_host WHERE Site = '" + Site
										+ "' AND (" + vmhosts + ") ORDER BY Site,VMHost";
	                    } else {
							if (Site.equals("ALL")) {
								upd = "SELECT * FROM vm_host ORDER BY Site,VMHost";
							} else {
								upd = "SELECT * FROM vm_host WHERE Site = '" + Site
										+ "' ORDER BY Site,VMHost";
							}
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
						Location
					</td>
					<td>
						Server&nbsp;&nbsp;
					</td>
					<td>
						IP&nbsp;&nbsp;
					</td>
					<td>
						VM&nbsp;Name&nbsp;&nbsp;
					</td>
					<td>
						Status
					</td>										
					<td>
						Manufacturer&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;&nbsp;
					</td>
					<td>
						Processor&nbsp;&nbsp;
					</td>										
					<td>
						CPU&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;Capacity&nbsp;&nbsp;
					</td>	
					<td>
					   HD	
					</td>
					<td>
					    NIC Numbers	
					</td>						
					<td>
					    VM Numbers	
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
						<a HREF="/inventory/tree/vmhost.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update.jsp?VMIp=<%=rs.getString("VMHost")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update/location.jsp?ip=<%=rs.getString("VMHost")%>&location=<%=rs.getString("Location")%>&type=VM"><%=rs.getString("Location")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<a HREF="/inventory/tree/cssummary.jsp?VMHostName=<%=rs.getString("Name")%>"><%=rs.getString("Name")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<a HREF="/inventory/tree/cssummary.jsp?VMHostName=<%=rs.getString("Name")%>"><%=rs.getString("VMHost")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("VMServerName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("PowerState")%>&nbsp;&nbsp;
					</td>								
					<td>
						<%=rs.getString("Manufacturer")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Model")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Processor")%>&nbsp;&nbsp;
					</td>									
					<td>
						<%=rs.getString("CPU")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("MemoryCapacity")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("HD")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("TotalNumberOfNIC")%>&nbsp;&nbsp;
					</td>						
					<td>
						<%=rs.getString("TotalVMNumber")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/update/notes.jsp?Ip=<%=rs.getString("VMHost")%>&IpNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
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
						System.out.println("Error occourred in vmhost.jsp: "
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
							.println("Close DB error occourred in vmhost.jsp: "
									+ e.getMessage());
			        	}
			        } 
				%>

			</table>
		</div>
	</body>
</html>
