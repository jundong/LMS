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
		<title>PC</title>
		<meta   http-equiv='Expires'   content='-10'>
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
			<b>PC Information</b>
			<hr>
			<%
				String Site = request.getParameter("Site");
				String DNSHostName = request.getParameter("DNSHostName");
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
	                    if (DNSHostName != null) {
	                        upd = "SELECT * FROM lab_pcs WHERE DNSHostName='" + DNSHostName + "' ORDER BY Site,DNSHostName";
	                    } else if (Site != null) {
							if (Site.equals("ALL")) {
								upd = "SELECT * FROM lab_pcs ORDER BY Site,DNSHostName";
							} else {
								upd = "SELECT * FROM lab_pcs WHERE Site = '"
										+ Site + "' ORDER BY Site,DNSHostName";
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
						Location&nbsp;&nbsp;
					</td>
					<td>
						DNS&nbsp;Host&nbsp;Name&nbsp;&nbsp;
					</td>					
					<td>
						IP&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Manufacturer&nbsp;&nbsp;
					</td>	
					<td>
						Model&nbsp;&nbsp;
					</td>	
					<td>
						CPU&nbsp;&nbsp;
					</td>	
					<td>
						OS&nbsp;&nbsp;
					</td>																							
					<td>
						Service&nbsp;Pack&nbsp;&nbsp;
					</td>	
					<td>
						Processors&nbsp;Number&nbsp;&nbsp;
					</td>	
					<td>
						Ram&nbsp;&nbsp;
					</td>														
					<td>
						HD&nbsp;Size&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
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
							HREF="/inventory/tree/pc.jsp?Site=<%=rs.getString("Site")%>" ><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update.jsp?PCIp=<%=rs.getString("DNSHostName")%>" ><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/inventory/update/location.jsp?ip=<%=rs.getString("DNSHostName")%>&location=<%=rs.getString("Location")%>&type=PC"><%=rs.getString("Location")%>&nbsp;&nbsp;</a>
					</td>
					<td>
                        <%=rs.getString("DNSHostName")%>&nbsp;&nbsp;
					</td>	
					<td>
                        <%=rs.getString("IPAddress")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Manufacturer")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Model")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("CPUName")%>&nbsp;&nbsp;
					</td>																											
					<td>
						<%=rs.getString("OSName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("ServicePack")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("NumberOfProcessors")%>&nbsp;&nbsp;
					</td>														
					<td>
						<%=rs.getString("Ram")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("HDSize")%>&nbsp;&nbsp;
					</td>						
					<td>
						<%=rs.getString("Status")%>&nbsp;&nbsp;
					</td>																		
					<td>
                        <%=(new FormatString()).vpResEnd(rs.getString("DNSHostName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
					<%
						String resBy = (new FormatString()).vpResBy(rs.getString("DNSHostName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue());
						if(resBy == null || resBy.trim().equals("")) {
					 %>
					 	<B><font color="#00FF00">AVAILABLE</font></B>
					 	<%} else { %>
					 	<%=resBy%>
					 	<%} %>
					</td>					
					<td>
						<%=rs.getString("UserName")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/inventory/update/notes.jsp?DNSHostName=<%=rs.getString("DNSHostName")%>&DNSHostNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
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
						System.out
								.println("Error occourred in pc.jsp: "
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
							.println("Close DB error occourred in pc.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>

			</table>
		</div>
	</body>
</html>
