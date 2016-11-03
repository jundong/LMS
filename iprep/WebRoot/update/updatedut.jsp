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

		<title>Add DUT</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
	</head>

	<body>
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;

			<hr>
			<b>Add DUT</b>
			<hr>
			<%
			    String DutIpAddress = "";
			    String DutName = "";
			    String BladeCount = "";
			    String IosVersion = "";
			    String IosImage = "";
			    String Status = "";
			    String SN = "";
			    String Vendor = "";
			    String DutChassisDescr = "";
			    String DutPid = "";
			    String Dept = "";
			    String Notes = "";
			    
			    String EnginePN = "";
			    String EngineDescr = "";
			    String EngineSN = "";
			    String LoginName = "";
			    String LoginPassword = "";
			    String LoginEnablePassword = "";
			    String SerialPortAccess = "";
			    
			    if(request.getParameter("Update") != null){    
					DutIpAddress = request.getParameter("DutIpAddress");
					DutName = request.getParameter("DutName");
					BladeCount = request.getParameter("BladeCount");
					IosVersion = request.getParameter("IosVersion");
					IosImage = request.getParameter("IosImage");
					Status = request.getParameter("Status");
					SN = request.getParameter("SN");
					Vendor = request.getParameter("Vendor");
					DutChassisDescr = request.getParameter("DutChassisDescr");
					DutPid = request.getParameter("DutPid");
					Notes = request.getParameter("Notes");
					Dept = request.getParameter("Dept");
					if (Dept.equals("")){
						Dept = "TBD";
					}
					
					LoginName = request.getParameter("LoginName");
			        LoginPassword = request.getParameter("LoginPassword");
			        LoginEnablePassword = request.getParameter("LoginEnablePassword");
			        SerialPortAccess = request.getParameter("SerialPortAccess");
			        EnginePN = request.getParameter("EnginePN");
			        EngineDescr = request.getParameter("EngineDescr");
			        EngineSN = request.getParameter("EngineSN");			        
			    } else {
			        DutIpAddress = request.getParameter("DutIpAddress");
			        LoginName = request.getParameter("LoginName");
			        LoginPassword = request.getParameter("LoginPassword");
			        LoginEnablePassword = request.getParameter("LoginEnablePassword");
			    }
			%>
			<form method="post" name="adddutform" id="adddutform"
				action="/iprep/adddut.do">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							DUT IP *:
						</td>
						<td>
							<input readonly type="text" name="DutIpAddress" border="0"
								value="<%=DutIpAddress%>"
								style="background-color: Cadetblue; width: 120px;" />
						</td>
						<td>
							User *:
						</td>
						<td>
							<input readonly type="text" name="LoginName" border="0"
								value="<%=LoginName%>"
								style="background-color: Cadetblue; width: 120px;" />
						</td>
						<td>
							Password *:
						</td>
						<td>
							<input readonly type="text" name="LoginPassword" border="0"
								value="<%=LoginPassword%>"
								style="background-color: Cadetblue; width: 120px;" />
						</td>
						<td>
							En./Conf.PW *:
						</td>
						<td>
							<input readonly type="text" name="LoginEnablePassword" border="0"
								value="<%=LoginEnablePassword%>"
								style="background-color: Cadetblue; width: 120px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							DUT Name:
						</td>
						<td>
							<input type="text" name="DutName" border="0" value="<%=DutName%>"
								style="width: 120px;" />
						</td>
						<td>
							Module Count:
						</td>
						<td>
							<input type="text" name="BladeCount" border="0"
								value="<%=BladeCount%>" style="width: 120px;" />

						</td>
						<td>
							IOS Version:
						</td>
						<td>
							<input type="text" name="IosVersion" border="0"
								value="<%=IosVersion%>" style="width: 120px;" />
						</td>
						<td>
							Status:
						</td>
						<td>
							<input type="text" name="Status" border="0" value="<%=Status%>"
								style="width: 120px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Engine PN:
						</td>
						<td>
							<input type="text" name="EnginePN" border="0" value="<%=EnginePN%>"
								style="width: 120px;" />
						</td>
						<td>
							Engine Descr:
						</td>
						<td>
							<input type="text" name="EngineDescr" border="0"
								value="<%=EngineDescr%>" style="width: 120px;" />

						</td>
						<td>
							Engine SN:
						</td>
						<td>
							<input type="text" name="EngineSN" border="0"
								value="<%=EngineSN%>" style="width: 120px;" />
						</td>
						<td>
							Serial Port Access:
						</td>
						<td>
							<input type="text" name="SerialPortAccess" border="0"
								value="<%=SerialPortAccess%>" style="width: 120px;" />
						</td>	
					</tr>					
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Vendor:
						</td>
						<td>
							<input type="text" name="Vendor" border="0" value="<%=Vendor%>"
								style="width: 120px;" />
						</td>
						<td>
							IOS Image:
						</td>
						<td>
							<input type="text" name="IosImage" border="0"
								value="<%=IosImage%>" style="width: 120px;" />
						</td>
						<td>
							SN:
						</td>
						<td>
							<input type="text" name="SN" border="0" value="<%=SN%>"
								style="width: 120px;" />
						</td>
						<td>
							DUT PID:
						</td>
						<td>
							<input type="text" name="DutPid" border="0" value="<%=DutPid%>"
								style="width: 120px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">				
						<td>
							Dut Description:
						</td>
						<td>
							<input type="text" name="DutChassisDescr" border="0"
								value="<%=DutChassisDescr%>" style="width: 120px;" />
						</td>

						<td>
							Deptment:
						</td>
						<td>
							<input type="text" name="Dept" border="0" value="<%=Dept%>"
								style="width: 120px;" />
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="Notes" border="0" value="<%=Notes%>"
								style="width: 120px;" />
						</td>
						<td>
						</td>
						<td>
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<input type="submit" name="adddut" border="0" value="Add DUT"
								style="width: 120px;" />
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
					</tr>
				</table>
			</form>
			<br>
			<% if (request.getParameter("errorMsg") != null){ %>
			<font><%=request.getParameter("errorMsg") %> </font>
			<%} %>
			<br>
			<br>
			Note: Please refer to below items to add DUT
			<ul>
				<li type=disc>
					"*" is required item
				<li type=disc>
					To make sure the update successful, please avoid using "'" (single qutoes) in input column
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
