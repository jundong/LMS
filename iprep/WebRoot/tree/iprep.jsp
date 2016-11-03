<%@ page language="java"
	import="java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.formatstring.*"
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
			    String testBedName = request.getParameter("TestBedName");
			    if(testBedName.isEmpty())
			    	testBedName = "A - High Performance Landslide with Spirent TestCenter 10G Mobility";
				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String upd = "";                 
	                    upd = "SELECT * FROM iprep_testbed WHERE TestBedName='"+testBedName+"' ORDER BY TestBedIndex";
						rs = stmt.executeQuery(upd);
						if(rs.next()) {
							String[] resvInfo = new FormatString().iPREPResInfo(rs.getString("TestBedName"));
							System.out.println(basePath+rs.getString("ImageLoc"));
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="center"
				width="100%">
					<tr>
						<td align="center">
							<img src="<%=basePath+rs.getString("ImageLoc")%>"></img>
						</td>
					</tr>
			</table>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC" height="50">
					<td width="30">
						TestBedName&nbsp;&nbsp;
					</td>
					<td>
						<%if(levels.equals("1") || levels.equals("0")) { %>
						<a HREF="/iprep/update/updateTestBed.jsp?Update=true&TestBedIndex=<%=rs.getString("TestBedIndex")%>">
							<%=rs.getString("TestBedName")%>&nbsp;&nbsp;
						</a>
						<%} else {%>
							<%=rs.getString("TestBedName")%>&nbsp;&nbsp;
						<%} %>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td>
						Description&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Description")%>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC" height="50">
					<td>
						Reserved&nbsp;By&nbsp;&nbsp;
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
				</tr>
				<tr bgcolor="#FFFFFF" height="50">
					<td>
						Start&nbsp;&nbsp;
					</td>
					<td>
						<%=resvInfo[1]%>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC" height="50">
					<td>
						End&nbsp;&nbsp;
					</td>
					<td>
						<%=resvInfo[0]%>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="50">
					<td>
						Equipment1&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("SpirentEquipment")%>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC" height="50">
					<td>
						Equipment2&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("CompeteEquipment")%>&nbsp;&nbsp;
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="50">
					<td>
						DutEquipment&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("DutEquipment")%>&nbsp;&nbsp;
					</td>
				</tr>
				<tr bgcolor="#C2D5FC" height="50">
					<td>
						Notes&nbsp;&nbsp;
					</td>
					<td>
						<form id="noteForm" action="/iprep/updateiprepnotes.do?TestBedIndex=<%=rs.getString("TestBedIndex")%>" method="post">
							<input onkeydown="formSubmit()" type="text" name="Notes" value="<%=rs.getString("Notes")%>" style="border:0;background-color:#C2D5FC"/>
						</form>
					</td>
				</tr>
				</table>
				<%
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
		</div>
	</body>
</html>
