<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.formatstring.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String levels = request.getSession().getAttribute("levels").toString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>iPREP</title>
		<meta   http-equiv='Expires'   content='-10'>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
		<script language="javascript">
			function formSubmit()
			{
				if(event.keyCode==13)
				{
					noteForm.target = "basefrm"
					noteForm.submit();
				}
			}
		</script>
	</head>
	<body>
		<div class="content">
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>iPREP Information</b>
			<hr>
			<%
				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String upd = "";                 
	                    upd = "SELECT * FROM iprep_testbed ORDER BY TestBedIndex";
						rs = stmt.executeQuery(upd);
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						TestBedName&nbsp;&nbsp;
					</td>
					<td>
						Reserved&nbsp;By&nbsp;&nbsp;
					</td>
					<td>
						Start&nbsp;&nbsp;
					</td>
					<td>
						End&nbsp;&nbsp;
					</td>
					<td>
						Equipment1&nbsp;&nbsp;
					</td>
					<td>
						Equipment2&nbsp;&nbsp;
					</td>
					<td>
						DutEquipment&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
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
							String[] resvInfo = new FormatString().iPREPResInfo(rs.getString("TestBedName"));
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%if(levels.equals("1") || levels.equals("0")) { %>
						<a HREF="/iprep/update/updateTestBed.jsp?Update=true&TestBedIndex=<%=rs.getString("TestBedIndex")%>">
							<%=rs.getString("TestBedName")%>&nbsp;&nbsp;
						</a>
						<%} else {%>
							<%=rs.getString("TestBedName")%>&nbsp;&nbsp;
						<%} %>
					</td>
					<td>
						<%
						String resBy = resvInfo[2];
						if(resBy == null || resBy.trim().equals("")) {
					 %>
					 	<B><font color="#0000FF">AVAILABLE</font></B>
					 	<%} else { %>
					 	<%=resBy%>
					 	<%} %>&nbsp;&nbsp;
					</td>
					<td>
						<%=resvInfo[1]%>&nbsp;&nbsp;
					</td>
					<td>
						<%=resvInfo[0]%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("SpirentEquipment")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("CompeteEquipment")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("DutEquipment")%>&nbsp;&nbsp;
					</td>
					<td>
						<form id="noteForm" action="/iprep/updateiprepnotes.do?TestBedIndex=<%=rs.getString("TestBedIndex")%>" method="post">
							<input onkeydown="formSubmit()" type="text" name="Notes" value="<%=rs.getString("Notes")%>" style="border:0;background-color:<%=color%>"/>
						</form>
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
								.println("Error occourred in iprepsummary.jsp: "
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
							.println("Close DB error occourred in iprepsummary.jsp: "
									+ e.getMessage());
			        	}
			        }
				%>

			</table>
		</div>
	</body>
</html>
