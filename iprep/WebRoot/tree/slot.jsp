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
<title>Slot</title>
<meta   http-equiv='Expires'   content='-10'>
<link rel="stylesheet" href="/iprep/common/css/style.css" type="text/css"
			media="screen" />
</head>
	<body>
	<div class="content">
		<a HREF="/iprep/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
		<a HREF="/iprep/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
		<a HREF="/iprep/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
		<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
		<hr>
		<b>Spirent STC Test Module(s) Information</b>
		<hr>
		<%
			String ChassisAddr = request.getParameter("Ip");
			String SlotIndex = request.getParameter("Slot");
			
			Connection conn = null;
	        Statement stmt = null;
	        ResultSet rs = null;
		    try {
				conn = DataBaseConnection.getConnection();
			    if (conn != null) {
					stmt = conn.createStatement();
					String upd = "";
			
					if (SlotIndex != null) {
						upd = "SELECT * FROM stc_inventory_testmodule where Hostname = '"
								+ ChassisAddr
								+ "'"
								+ " AND SlotIndex ='"
								+ SlotIndex + "'";
					} else {
						upd = "SELECT * FROM stc_inventory_testmodule where Hostname = '"
								+ ChassisAddr + "'";
					}
			
					rs = stmt.executeQuery(upd);
		%>

		<table BORDER="0" CELLPADDING="0" CELLSPACING="0" align="left"
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
					Chassis&nbsp;&nbsp;
				</td>
				<td>
					Slot&nbsp;&nbsp;
				</td>
				<td>
					Status&nbsp;&nbsp;
				</td>
				<td>
					ProductFamily&nbsp;&nbsp;
				</td>
				<td>
					PartNum&nbsp;&nbsp;
				</td>
				<td>
					Description&nbsp;&nbsp;
				</td>
				<td>
					Firmware&nbsp;&nbsp;
				</td>
				<td>
					SerialNum&nbsp;&nbsp;
				</td>
				<td>
					Property&nbsp;&nbsp;
				</td>
				<td>
					SO#&nbsp;&nbsp;
				</td>
				<td>
					SO&nbsp;Start&nbsp;&nbsp;
				</td>
				<td>
					SO&nbsp;End&nbsp;&nbsp;
				</td>					
				<td>
					ProductId&nbsp;&nbsp;
				</td>
				<td>
					Ports&nbsp;&nbsp;
				</td>
				<td>
					PortGroups&nbsp;&nbsp;
				</td>
				<td>
					HwRevCode&nbsp;&nbsp;
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
				<a HREF="/iprep/tree/chassis.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<a HREF="/iprep/update.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<%=rs.getString("Hostname")%>&nbsp;&nbsp;
				</td>
				<td>
					<a HREF="/iprep/tree/port.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>"><%=rs.getString("SlotIndex")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<%=(new FormatString()).formatPortInfor(rs.getString("Status"))%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("ProductFamily")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PartNum")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("Description")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("FirmwareVersion")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("SerialNum")%>&nbsp;&nbsp;
				</td>
				<td>
					<a HREF="/iprep/update/chassisproperty.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>&Property=<%=rs.getString("Property")%>&SOEnd=<%=rs.getString("SOEnd")%>&SO=<%=rs.getString("SO")%>&SOStart=<%=rs.getString("SOStart")%>&LoanerNotificationDate=<%=rs.getString("LoanerNotificationDate")%>&SN=<%=rs.getString("SerialNum")%>&ResourceType=<%=rs.getString("ProductFamily")%>"><%=rs.getString("Property")%>&nbsp;&nbsp;</a>
				</td>
				<td>
					<%=rs.getString("SO")%>&nbsp;&nbsp;
				</td>
				<td>
					<%=rs.getString("SOStart")%>&nbsp;&nbsp;
				</td>
				<td>
					<%=rs.getString("SOEnd")%>&nbsp;&nbsp;
				</td>					
				<td>
				<%=rs.getString("ProductId")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PortCount")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PortGroupCount")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("HwRevCode")%>&nbsp;&nbsp;
				</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?ChSlotIP=<%=rs.getString("Hostname")%>&SlotIndex=<%=rs.getString("SlotIndex")%>&ChSlotNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
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
									.println("An unknown error occourred while connecting to DataBase."
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
								.println("Close DB error occourred in av.jsp: "
										+ e.getMessage());
				        	}
				        }
					%>
				
		</table>
		</div>
	</body>
</html>
