<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		 <% if(request.getParameter("Update") != null) {%>
		<title>Update TestBed</title>
		<%}else { %>
		<title>Add TestBed</title>
		<%} %>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
	</head>

	<body>
		<div class="content">
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;

			<hr>
			<% if(request.getParameter("Update") != null) {%>
				<b>Update TestBed</b>
			<%}else { %>
				<b>Add TestBed</b>
			<%} %>
			<hr>
			<%
				String TestBedIndex = "";
			    String TestBedName = "";
			    String Description = "";
			    String ImageLoc = "";
			    String Location = "";
			   // String ResvBy = "";
			    //String ResvStart = "";
			   // String ResvEnd = "";
			    String SpirentEquipment = "";
			    String CompeteEquipment = "";
			    String DutEquipment = "";
			    String Notes = "";
			    
			    String update = "";
			    
			    Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
		   	
				String sql = "";	      
		    	try {
		    		conn = DataBaseConnection.getConnection();
				    if(request.getParameter("Update") != null){  
				    	TestBedIndex = request.getParameter("TestBedIndex"); 
				    	if(TestBedIndex.isEmpty()){
				    		return;
				    	} 
				    	update = "true";
						stmt = conn.createStatement();
						sql = "SELECT * FROM iprep_testbed WHERE TestBedIndex=" + TestBedIndex;
						rs = stmt.executeQuery(sql);
						if(rs.next()){
							TestBedName = rs.getString("TestBedName");
			   				Description = rs.getString("Description");
			   				ImageLoc = rs.getString("ImageLoc");
			    			Location = rs.getString("Location");
			    			//ResvBy = rs.getString("ResvBy");
			   				//ResvStart = rs.getString("ResvStart");
			    			//ResvEnd = rs.getString("ResvEnd");
			    			SpirentEquipment = rs.getString("SpirentEquipment");
			    			CompeteEquipment = rs.getString("CompeteEquipment");
			    			DutEquipment = rs.getString("DutEquipment");
			    			Notes = rs.getString("Notes");
						}
				    } 
			    } catch (Exception e) {
					System.out
					.println("Close DB error occourred in updateTestBed.jsp: "
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
						.println("Close DB error occourred in updateTestBed.jsp: "
								+ e.getMessage());
		        	}
       		 	 } 
			%>
			<form method="post" name="adddutform" id="adddutform"
				action="/iprep/addtestbed.do" ENCTYPE="multipart/form-data" >
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							TestBedName *:
						</td>
						<td>
							<input type="text" name="TestBedName" border="0"
								value="<%=TestBedName%>"
								style="width: 600px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td>
							Description *:
						</td>
						<td>
							<textarea style="width:600px;height:180px;" name="Description"><%=Description.trim()%></textarea>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Topology *:
						</td>
						<td>
							<input type="file" name="ImageLoc" border="0"
								style="width: 250px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td>
							Equipment1:
						</td>
						<td>
							<input type="text" name="SpirentEquipment" border="0" value="<%=SpirentEquipment%>"
								style="width: 600px;" />
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Equipment2:
						</td>
						<td>
							<input type="text" name="CompeteEquipment" border="0" value="<%=CompeteEquipment%>"
								style="width: 600px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td>
							DutEquipment:
						</td>
						<td>
							<input type="text" name="DutEquipment" border="0"
								value="<%=DutEquipment%>" style="width: 600px;" />
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="Notes" border="0"
								value="<%=Notes%>" style="width: 300px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td>
						<input type="hidden" name="update" value="<%=update%>" />
						<input type="hidden" name="TestBedIndex" value="<%=TestBedIndex%>" />
						<input type="hidden" name="Location" value="<%=Location%>" />
						<%if(request.getParameter("Update") == null) {%>
							<input type="submit" name="adddut" border="0" value="Add TestBed"
								style="width: 120px;" />
						<%} else { %>
							<input type="submit" name="adddut" border="0" value="Update TestBed"
								style="width: 120px;" />
						<%} %>
						</td>
						<td>
					</tr>
				</table>
			</form>
			<br>
			<% if (request.getParameter("errorMsg") != null){ %>
			<font><%=request.getParameter("errorMsg") %> </font>
			<%} %>
			<br>
			<br>
			Note:
			<ul>
				<li type=disc>
					- "*" indicated fields are mandatory.
				</li>
				<li type=disc>
				    - Please avoid using '?', ',', '&' and ' (single quotes). Only alpha numerical texts are highly recommended.
				</li>
			</ul>
		</div>
		<div class="footer">
			<div class="footer-logo"></div>
			<div class="copyright">
				2010 Spirent Communications
				<br />
				All rights reserved.
			</div>
		</div>
	</body>
</html>
