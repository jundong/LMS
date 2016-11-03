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
		<title>Blade</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
	</head>
	<body style="height: 140px">
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL" >STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL" >DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL" >VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp" >Document</a>&nbsp;&nbsp;
			<hr>
			<b>Spirent DUT Interface(s) Information</b>
			<hr>
			<%
				String Ip = request.getParameter("Ip");
				String Port = request.getParameter("Port");
				String ModuleIndex = request.getParameter("ModuleIndex");

				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String upd = "";
						if (ModuleIndex != null){
						   upd = "SELECT * FROM dut_inventory_intf WHERE DutIpAddress = '"
								+ Ip + "' AND ModuleIndex = '" + ModuleIndex 
								+ "' ORDER BY Site,DutIpAddress, ModuleIndex, IntfName";
						} else if (Port != null) {
						   upd = "SELECT * FROM dut_inventory_intf WHERE DutIpAddress = '"
								+ Ip
								+ "' AND IntfName = '"
								+ Port
								+ "' ORDER BY Site,DutIpAddress,  ModuleIndex, IntfName";
						} else {
							upd = "SELECT * FROM dut_inventory_intf WHERE DutIpAddress = '"
								+ Ip
								+ "' ORDER BY Site,DutIpAddress,  ModuleIndex, IntfName";
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
						DUT&nbsp;Name&nbsp;&nbsp;
					</td>						
					<td>
						IP&nbsp;Address&nbsp;&nbsp; 
					</td>
					<td>
						Blade&nbsp;Model&nbsp;&nbsp;
					</td>						
					<td>
						Interface&nbsp;Description&nbsp;&nbsp;
					</td>								
					<td>
						Interface&nbsp;Name&nbsp;&nbsp;
					</td>
					<td>
						Connection&nbsp;&nbsp;
					</td>	
					<td>
						Interface&nbsp;SN&nbsp;&nbsp;
					</td>									
					<td>
						ResEnd&nbsp;&nbsp;
					</td>
					<td>
						ResBy&nbsp;&nbsp;
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
						<%=rs.getString("Site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update.jsp?DUTIp=<%=rs.getString("DutIpAddress")%>" ><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("DutName")%>&nbsp;&nbsp;
					</td>					
					<td>
						<a HREF="/iprep/tree/dutIntf.jsp?Ip=<%=rs.getString("DutIpAddress")%>" ><%=rs.getString("DutIpAddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("Pid")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("IntfDescr")%>&nbsp;&nbsp;
					</td>										
					<td>
						<%=rs.getString("IntfName")%>&nbsp;&nbsp;
					</td>	
					<td>
						<a HREF="/iprep/update/dutconnection.jsp?DutIpAddress=<%=rs.getString("DutIpAddress")%>&ModuleIndex=<%=rs.getString("ModuleIndex")%>&IntfName=<%=rs.getString("IntfName")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>" ><%=rs.getString("Connection")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("ModuleSN")%>&nbsp;&nbsp;
					</td>															
					<td>
						<%=(new FormatString()).dutResEnd(rs.getString("DutIpAddress"), rs.getString("IntfName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).dutResBy(rs.getString("DutIpAddress"), rs.getString("IntfName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>								
					<td>
						<a HREF="/iprep/update/notes.jsp?DUTIntfName=<%=rs.getString("IntfName")%>&DUTIntfIp=<%=rs.getString("DutIpAddress")%>&DUTIntfNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
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
					System.out.println("Error occourred in dutIntf.jsp: "
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
							.println("Close DB error occourred in dutIntf.jsp: "
									+ e.getMessage());
			        	}
			        }
			%>
			</table>
		</div>
	</body>
</html>
