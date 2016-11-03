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
		<title>Port</title>
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
			<b>Port Group(s) Information</b>
			<hr>
			<%
				String ChassisAddr = request.getParameter("Ip");
				String SlotIndex = request.getParameter("Slot");
				String PortIndex = request.getParameter("Index");

				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String upd = "";
						if (PortIndex != null) {
							upd = "SELECT * FROM stc_inventory_portgroup where Hostname = '"
									+ ChassisAddr
									+ "'"
									+ " AND SlotIndex ='"
									+ SlotIndex
									+ "'"
									+ "AND PortIndex = '"
									+ PortIndex
									+ "'";
						}
	
						rs = stmt.executeQuery(upd);
			%>

			<table BORDER="0" CELLPADDING="0" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						PortGroup&nbsp;&nbsp;
					</td>
					<td>
						PortIdx&nbsp;&nbsp;
					</td>
					<td>
						ResEnd&nbsp;&nbsp;
					</td>
					<td>
						ResBy&nbsp;&nbsp;
					</td>											
					<td>
						Connection&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;&nbsp;
					</td>
					<td>
						OwnershipState&nbsp;&nbsp;
					</td>
					<td>
						OwnerHostname&nbsp;&nbsp;
					</td>
					<td>
						OwnerUserId&nbsp;&nbsp;
					</td>
					<td>
						OwnerTimestamp&nbsp;&nbsp;
					</td>
					<td>
						Personality&nbsp;&nbsp;
					</td>
					<td>
						Transceiver&nbsp;&nbsp;
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
						<%=rs.getString("PortGroupIndex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("PortIndex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).chassisResEnd(rs.getString("Hostname"), rs.getString("SlotIndex"), rs.getString("PortIndex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
					<%
						String resBy = (new FormatString()).chassisResBy(rs.getString("Hostname"), rs.getString("SlotIndex"), rs.getString("PortIndex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue());
						if(resBy == null || resBy.trim().equals("")) {
					 %>
					 	<B><font color="#00FF00">AVAILABLE</font></B>
					 	<%} else { %>
					 	<%=resBy%>
					 	<%} %>
					</td>						
					<td>
						<A
							HREF="/iprep/update/connection.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>&PortIndex=<%=rs.getString("PortIndex")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>"
							target="_parent"><%=rs.getString("Connection")%>&nbsp;&nbsp;</A>
					</td>
					<td>
						<%=(new FormatString()).formatPortInfor(rs
									.getString("Status"))%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("FirmwareVersion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).formatPortInfor(rs
									.getString("OwnershipState"))%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("OwnerHostname")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("OwnerUserId")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("OwnerTimestamp")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("PersonalityCardType")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).formatTransceiver(rs
									.getString("TransceiverType"))%>&nbsp;&nbsp;
					</td>	
					<td>
						<a HREF="/iprep/update/notes.jsp?ChPortIP=<%=rs.getString("Hostname")%>&ChSlotPortIndex=<%=rs.getString("SlotIndex")%>&ChPortIndex=<%=rs.getString("PortIndex")%>&ChPortNotes=<%=rs.getString("Notes")%>" target="_parent"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					               x = x + 1;
				              }
				%>

				<%
			              }
					} catch (Exception e) {
						System.out
								.println("Error occourred in treeport.jsp: "
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
							.println("Close DB error occourred in treeport.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>

			</table>
		</div>
	</body>
</html>