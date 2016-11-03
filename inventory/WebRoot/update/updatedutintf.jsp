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

		<title>Add DUT Blade/Interface</title>
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
			<b>Add DUT Blade/Interface</b>
			<hr>
			<%
			    String DutIpAddress = "";
			    String DutName = "";
			    String ModuleType = "";
			    String IntfName = "";
			    String IntfDescr = "";
			    String Pid = "";
			    String ModuleSN = "";
			    String ModuleIndex = "";
			    String Dept = "";
			    String Notes = "";
			    String StartIndex = "";
			    String EndIndex = "";
			    //String PidStep = "";
			    
			    if(request.getParameter("Update") != null){    
					DutIpAddress = request.getParameter("DutIpAddress");
					DutName = request.getParameter("DutName");
					ModuleType = request.getParameter("ModuleType");
					IntfName = request.getParameter("IntfName");
					IntfDescr = request.getParameter("IntfDescr");
					Pid = request.getParameter("Pid");
					ModuleSN = request.getParameter("ModuleSN");
					ModuleIndex = request.getParameter("ModuleIndex");
					Dept = request.getParameter("Dept");
			        StartIndex = request.getParameter("StartIndex");
			        EndIndex = request.getParameter("EndIndex");
			        //PidStep = request.getParameter("PidStep");
			        				
					if (Dept.equals("")){
						Dept = "TBD";
					}
					Notes = request.getParameter("Notes");
			    } else if (request.getParameter("UpdateFromDUT") != null){
			        DutIpAddress = request.getParameter("DutIpAddress");
					DutName = request.getParameter("DutName");
					Dept = request.getParameter("Dept");
					if (Dept.equals("")){
						Dept = "TBD";
					}
			    } else {
			        DutIpAddress = request.getParameter("DutIpAddress");
			    }
			%>
			<form method="post" name="adddutintfform" id="adddutintfform"
				action="/inventory/adddutintf.do">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							DUT IP *:
						</td>
						<td>
							<input type="text" name="DutIpAddress" border="0"
								value="<%=DutIpAddress%>" 
								style="width: 120px;" />
						</td>
						<td>
							DUT Name:
						</td>
						<td>
							<input type="text" name="DutName" border="0" value="<%=DutName%>" 
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
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Module Index *:
						</td>
						<td>
							<input type="text" name="ModuleIndex" border="0"
								value="<%=ModuleIndex%>" style="width: 120px;" />
						</td>						
						<td>
							Module Type *:
						</td>
						<td>
							<input type="text" name="ModuleType" border="0"
								value="<%=ModuleType%>" style="width: 120px;" />
						</td>					
						<td>
							Module SN:
						</td>
						<td>
							<input type="text" name="ModuleSN" value="<%=ModuleSN%>" border="0"
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
							Interface prefix *:
						</td>
						<td>
							<input type="text" name="IntfName" border="0" value="<%=IntfName%>" 
								style="width: 120px;" />
						</td>
						<td>
							Start Index *:
						</td>
						<td>
							<input type="text" name="StartIndex" border="0" value="<%=StartIndex%>" 
								style="width: 120px;" />
						</td>					
						<td>
							End Index *:
						</td>
						<td>
							<input type="text" name="EndIndex" border="0" value="<%=EndIndex%>" 
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
							Interface Description:
						</td>
						<td>
							<input type="text" name="IntfDescr" border="0"
								value="<%=IntfDescr%>" style="width: 120px;" />
						</td>					
						<td>
							PID:
						</td>
						<td>
							<input type="text" name="Pid" border="0" value="<%=Pid%>" 
								style="width: 120px;" />
						</td>	
						<%--<td>
							PID Step: 
						</td>--%>
						<%--<td>
							<input type="text" name="PidStep" border="0" value="<%=PidStep%>" 
								style="width: 120px;" />
						</td>--%>	
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="Notes" border="0" value="<%=Notes%>" 
								style="width: 120px;" />
						</td>
						<td>
							Deptment:
						</td>
						<td>
							<input type="text" name="Dept" border="0" value="<%=Dept%>" 
								style="width: 120px;" />
						</td>															
					</tr>										
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<input type="submit" name="adddutintf" border="0" value="Add DUTIntf"
								style="width: 150px;" /> 
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
					eg. DUT IP = 10.10.10.10, Module Index = 1, Module Type = FastEthernet, Interface prefix = 1/0/, Start Index = 1, End Index = 2, we'll add 2 interface records into DB: FastEthernet1/0/1 ad FastEthernet1/0/2				
<li type=disc>				
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
