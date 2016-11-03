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
		<title>AVPorts</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />

	</head>
	<body>
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL" target="_parent">STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL" target="_parent">DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL" target="_parent">VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp" target="_parent">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Avalanch Port(s) Information</b>
			<hr>
			<%
				String AVAddr = request.getParameter("Ip");
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
							upd = "SELECT * FROM avl_portgroups where ipaddress = '"
									+ AVAddr
									+ "'"
									+ "AND PortIndex = '"
									+ PortIndex
									+ "'";
						} else {
							upd = "SELECT * FROM avl_portgroups where ipaddress = '"
									+ AVAddr + "' ORDER BY PortIndex";
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
						<%=rs.getString("site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update.jsp?AVIp=<%=rs.getString("ipaddress")%>" target="_parent"><%=rs.getString("dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>" target="_parent"><%=rs.getString("ipaddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("model")%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>&Index=<%=rs.getString("portindex")%>" target="_parent"><%=rs.getString("portindex")%>&nbsp;&nbsp;</a>
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
					 	<%} %>					</td>												
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
							HREF="/iprep/update/avconnection.jsp?Ip=<%=rs.getString("ipaddress")%>&PortGroupIndex=<%=rs.getString("portgroupindex")%>&PortIndex=<%=rs.getString("portindex")%> &RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>" target="_parent"><%=rs.getString("connection")%>&nbsp;&nbsp;</a>
					</td>					
					<td>
						<%=rs.getString("user")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?AVPortIp=<%=rs.getString("ipaddress")%>&AVPortGP=<%=rs.getString("portgroupindex")%>&AVPort=<%=rs.getString("portindex")%>&AVPortNotes=<%=rs.getString("Notes")%>" target="_parent"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
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
								.println("Error occourred in avport.jsp: "
										+ e.getMessage());
					}  finally {
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
							.println("Close DB error occourred in avport.jsp: "
									+ e.getMessage());
			        	}
			    } 
				%>

			</table>
		</div>
	</body>
</html>