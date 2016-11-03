<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
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
		<title>Update</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">           
             function updateChassis() {
             	updateform.action="/inventory/updateresource.do?isChassis=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }
             
             function updateDUT() {
                updateform.action="/inventory/updateresource.do?isDUT=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }
             
             function updateAV() {
             	updateform.action="/inventory/updateresource.do?isAV=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }
             
             function updateVM() {
             	updateform.action="/inventory/updateresource.do?isVM=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }
             
             function updatePC() {
             	updateform.action="/inventory/updateresource.do?isPC=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }                                                    
        </script>
	</head>

	<body>
		<div class="content">
			<a HREF="/inventory/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/inventory/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Update Information</b>
			<hr>
			<%
				String Hostname = "";
				if (request.getParameter("Ip") != null) {
					Hostname = request.getParameter("Ip");
				}
				String DUT = "";
				if (request.getParameter("DUTIp") != null) {
					DUT = request.getParameter("DUTIp");
				}
				String VM = "";
				if (request.getParameter("VMIp") != null) {
					VM = request.getParameter("VMIp");
				}
				String AV = "";
				if (request.getParameter("AVIp") != null) {
					AV = request.getParameter("AVIp");
				}
				String PC = "";
				if (request.getParameter("PCIp") != null) {
					PC = request.getParameter("PCIp");
				}				
			%>
			<form method="post" name="updateform" id="updateform">
				<table  border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="Ip" border="0" value="<%=Hostname%>"
								style="width: 150px;" />
						</td>
						<td>
							Department (PV, HW, SW, MKT, etc):
						</td>
						<td>
							<input type="text" name="Department" value="" size="4"
								maxlength="4">
						</td>
						<td>
							<input type="submit" border="0" value="Update Chassis"
								onClick="updateChassis();" style="width: 130px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							DUT IP:
						</td>
						<td>
							<input type="text" name="DUTIp" border="0" value="<%=DUT%>"
								style="width: 150px;" />
						</td>
						<td>
							Department (PV, HW, SW, MKT, etc):
						</td>
						<td>
							<input type="text" name="DUTDepartment" value="" size="4"
								maxlength="4">
						</td>
						<td>
							<input type="submit" border="0" value="Update DUT"
								onClick="updateDUT();" style="width: 130px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							VM IP:
						</td>
						<td>
							<input type="text" name="VMIp" border="0" value="<%=VM%>"
								style="width: 150px;" />
						</td>
						<td>
							Department (PV, HW, SW, MKT, etc):
						</td>
						<td>
							<input type="text" name="VMDepartment" value="" size="4"
								maxlength="4">
						</td>
						<td>
							<input type="submit" border="0" value="Update VM"
								onClick="updateVM();" style="width: 130px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							AV IP:
						</td>
						<td>
							<input type="text" name="AVIp" border="0" value="<%=AV%>"
								style="width: 150px;" />
						</td>
						<td>
							Department (PV, HW, SW, MKT, etc):
						</td>
						<td>
							<input type="text" name="AVDepartment" value="" size="4"
								maxlength="4">
						</td>
						<td>
							<input type="submit" border="0" value="Update AV"
								onClick="updateAV();" style="width: 130px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							PC Name:
						</td>
						<td>
							<input type="text" name="PCIp" border="0" value="<%=PC%>"
								style="width: 150px;" />
						</td>
						<td>
							Department (PV, HW, SW, MKT, etc):
						</td>
						<td>
							<input type="text" name="PCDepartment" value="" size="4"
								maxlength="4">
						</td>
						<td>
							<input type="submit" border="0" value="Update PC"
								onClick="updatePC();" style="width: 130px;" />
						</td>
					</tr>					
				</table>
			</form>
			<br>
			<br>
			<br>

			Note: This operation allows you to enter, up to 4 characters,
			describing a department information regarding the chassis into
			database.
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
