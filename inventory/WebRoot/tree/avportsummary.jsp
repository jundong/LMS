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
		<title>AV/Port Summary</title>
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
			<b>Avalanch Information</b>
			<hr>
			<%
				String Ip = request.getParameter("Ip");
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
	
						if (Ip != null) {
								upd = "SELECT * FROM avl_appliances WHERE ipaddress = '"
										+ Ip + "'";
						}
	
						rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" width="100%">
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
						Avalanche&nbsp;&nbsp;
					</td>
					<td>
						Name&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						OS&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						Serial&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						MAC&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Default&nbsp;Gateway&nbsp;&nbsp;
					</td>
					<td>
						Subnet&nbsp;Mask&nbsp;&nbsp;
					</td>
					<td>
						Used&nbsp;DHCP&nbsp;&nbsp;
					</td>
					<td>
						Interfaces&nbsp;Number&nbsp;&nbsp;
					</td>					
					<td>
						Memory&nbsp;Size&nbsp;&nbsp;
					</td>
					<td>
						Units&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;Per&nbsp;Unit&nbsp;&nbsp;
					</td>
					<td>
						Has&nbsp;SSL&nbsp;Accelerator&nbsp;&nbsp;
					</td>
					<td>
						Dispatcher&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						Return&nbsp;Code&nbsp;&nbsp;
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
							HREF="/inventory/tree/av.jsp?Site=<%=rs.getString("site")%>"><%=rs.getString("site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update.jsp?AVIp=<%=rs.getString("ipaddress")%>"><%=rs.getString("dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update/location.jsp?ip=<%=rs.getString("ipaddress")%>&location=<%=rs.getString("Location")%>&type=AV"><%=rs.getString("Location")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/inventory/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>"><%=rs.getString("ipaddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("hostname")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("modelnumber")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("softwareversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("osversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("serialnumber")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("macaddress")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("defaultgateway")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("subnetmask")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("usedhcp")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("numofinterface")%>&nbsp;&nbsp;
					</td>								
					<td>
						<%=rs.getString("memorysize")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("numberofunits")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("memoryperunit")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("hassslaccelerator")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("dispatcherversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("returncode")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/update/notes.jsp?AVIp=<%=rs.getString("ipaddress")%>&AVNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>					
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					x = x + 1;
						}
						rs.close();
				%>
			</table>
			<br>
			<hr>
			<b>Avalanch Port(s) Information</b>
			<hr>
			<%
				if (Ip != null) {
						upd = "SELECT * FROM avl_portgroups where ipaddress = '"
								+ Ip + "' ORDER BY PortIndex";
					}
					
					rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" width="100%">
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
						Avalanche&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Port&nbsp;&nbsp;
					</td>	
					<td>
						ResEnd&nbsp;&nbsp;
					</td>	
					<td>
						ResBy&nbsp;&nbsp;
					</td>															
					<td>
						Port&nbsp;Group&nbsp;&nbsp;
					</td>
					<td>
						Active&nbsp;Software&nbsp;&nbsp;
					</td>					
					<td>
						Port&nbsp;Group&nbsp;Description&nbsp;&nbsp;
					</td>
					<td>
						Port&nbsp;Group&nbsp;Type&nbsp;&nbsp;
					</td>
					<td>
						Connection&nbsp;&nbsp;
					</td>					
					<td>
						User&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					x = 0;
						color = "";
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
						<%=rs.getString("site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/update.jsp?AVIp=<%=rs.getString("ipaddress")%>"><%=rs.getString("dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/inventory/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>"><%=rs.getString("ipaddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("model")%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/inventory/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>&Index=<%=rs.getString("portindex")%>"><%=rs.getString("portindex")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=(new FormatString()).avResEnd(rs.getString("ipaddress"), rs.getString("portindex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
					<%
						String resBy = (new FormatString()).avResBy(rs.getString("ipaddress"), rs.getString("portindex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue());
						if(resBy == null || resBy.trim().equals("")) {
					 %>
					 	<B><font color="#00FF00">AVAILABLE</font></B>
					 	<%} else { %>
					 	<%=resBy%>
					 	<%} %>
					</td>												
					<td>
						<%=rs.getString("portgroupindex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("activesoftware")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("portgroupdescr")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("portgrouptype")%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/inventory/update/avconnection.jsp?Ip=<%=rs.getString("ipaddress")%>&PortGroupIndex=<%=rs.getString("portgroupindex")%>&PortIndex=<%=rs.getString("portindex")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>"><%=rs.getString("connection")%>&nbsp;&nbsp;</a>
					</td>					
					<td>
						<%=rs.getString("user")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/update/notes.jsp?AVPortIp=<%=rs.getString("ipaddress")%>&AVPortGP=<%=rs.getString("portgroupindex")%>&AVPort=<%=rs.getString("portindex")%>&AVPortNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
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
					System.out.println("Error occourred in avportsummary.jsp: "
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
							.println("Close DB error occourred in avportsummary.jsp: "
									+ e.getMessage());
			        	}
			    } 
			%>
		</div>
	</body>
</html>
