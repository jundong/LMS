<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
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
		<title>DUT</title>
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
			<b>Spirent DUT Information</b>
			<hr>
			<%
				String Site = request.getParameter("Site");
				String Ip = request.getParameter("Ip");
				String Vendor = request.getParameter("Vendor");
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
								upd = "SELECT * FROM dut_inventory ORDER BY Site,DutIpAddress";
							} else {
								upd = "SELECT * FROM dut_inventory WHERE Site = '"
										+ Site + "' ORDER BY Site,DutIpAddress";
							}
						} else if (Ip != null) {
							upd = "SELECT * FROM dut_inventory WHERE DutIpAddress = '" + Ip
									+ "' ORDER BY Site,DutIpAddress";
						} else if (Vendor != null) {
							upd = "SELECT * FROM dut_inventory WHERE Vendor = '" + Vendor
									+ "' ORDER BY Site,DutIpAddress";
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
						Location&nbsp;&nbsp;
					</td>
					<td>
						DUT&nbsp;Name&nbsp;&nbsp;
					</td>					
					<td>
						IP&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Vendor&nbsp;&nbsp;
					</td>
					<td>
						Chassis&nbsp;Model&nbsp;&nbsp;
					</td>	
					<td>
						Chassis&nbsp;Desc&nbsp;&nbsp;
					</td>	
					<td>
						Chassis&nbsp;SN&nbsp;&nbsp;
					</td>
					<td>
						Engine&nbsp;Model&nbsp;&nbsp;
					</td>
					<td>
						Engine&nbsp;Desc&nbsp;&nbsp;
					</td>	
					<td>
						Engine&nbsp;SN&nbsp;&nbsp;
					</td>																																
					<td>
						Blade&nbsp;Count&nbsp;&nbsp;
					</td>				
					<td>
						SW&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						SW&nbsp;Image&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Serial Port Access&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>	
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>	
					<td>
						User&nbsp;&nbsp;
					</td>	
					<td>
						Password&nbsp;&nbsp;
					</td>	
					<td>
						En./Conf.PW&nbsp;&nbsp;
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
						<a HREF="/iprep/tree/dut.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/update.jsp?DUTIp=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/update/location.jsp?ip=<%=rs.getString("DutIpAddress")%>&location=<%=rs.getString("Location")%>&type=DUT"><%=rs.getString("Location")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("DutName")%>&nbsp;&nbsp;
					</td>					
					<td>
						<a
							HREF="/iprep/tree/dutIntf.jsp?Ip=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("DutIpAddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/dut.jsp?Vendor=<%=rs.getString("Vendor")%>"><%=rs.getString("Vendor")%>&nbsp;&nbsp;</a>
					</td>
					<td><%=rs.getString("DutPid")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("DutChassisDescr")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("SN")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EnginePN")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EngineDescr")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EngineSN")%>&nbsp;&nbsp;
					</td>	
					<td>
                           <%=rs.getString("BladeCount")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("IosVersion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("IosImage")%>&nbsp;&nbsp;
					</td>																																						
					<td>
						<%=rs.getString("Status")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?DutSerialIp=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("SerialPortAccess")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<a HREF="/iprep/update/notes.jsp?DutIp=<%=rs.getString("DutIpAddress")%>&DutNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>		
					<td>
						<%=rs.getString("LoginName")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("LoginPassword")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("LoginEnabledPassword")%>&nbsp;&nbsp;
					</td>																			
				</tr>
				<%
				              	x = x + 1;
					    	}
				%>
				<%
			            }
					} catch (Exception e) {
						System.out.println("Error occourred in dut.jsp: "
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
							.println("Close DB error occourred in dut.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>
			</table>
		</div>
	</body>
</html>
