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
		<title>STC Connection</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
		<script type="text/javascript">
			 function display(type){
			    switch(type){
			       case "SPIRENT":
			         document.getElementById("SPIRENT").style.display="";
			         document.getElementById("AV").style.display="none";
			         break;
			       case "AV":
			         document.getElementById("SPIRENT").style.display="none";
			         document.getElementById("AV").style.display="";	         
			         break;
			       default:
			         break;         
			    }
			 };
			  </script>
	</head>

	<body>
		<div class="content">
			<a HREF="/iprep/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/iprep/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;

			<hr>
			<b>Update DUT Connection Information</b>
			<hr>
			<%
				String DutIpAddress = request.getParameter("DutIpAddress");
				String IntfName = request.getParameter("IntfName");
				String ModuleIndex = request.getParameter("ModuleIndex");
				String radioConnection = request.getParameter("RadioConnection");
				String PeerHost = request.getParameter("PeerHost");
				String PeerModule = request.getParameter("PeerModule");
				String PeerPort = request.getParameter("PeerPort");
				String Comments = request.getParameter("Comments");
				String spirentstate = "";
				String avstate = "";
				String spirentdisstate = "none";
				String avdisstate = "none";

				if (radioConnection != null) {
					if (radioConnection.equals("SPIRENT")) {
						spirentstate = "checked";
						spirentdisstate = "";
					} else if (radioConnection.equals("AV")) {
						avstate = "checked";
						avdisstate = "";
					}
				}
          %>
			<table BORDER=0 CELLPADDING="0" CELLSPACING="0" width="100%">
				<tr bgcolor="#C2D5FC" style="width: 100%">
					<td>
						<input type="radio" onclick="display(this.value);"
							name="RadioConnection" value="SPIRENT" <%=spirentstate%>>
						SPIRENT
					</td>
					<td>
						<input type="radio" onclick="display(this.value);"
							name="RadioConnection" value="AV" <%=avstate%>>
						AV
					</td>
				</tr>
			</table>
			<br>

			<div name="SPIRENT" id="SPIRENT"
				style="display: <%= spirentdisstate %>">
				<form method=post action="/iprep/dutconnection.do">
					<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
						width="100%">
						<tr bgcolor="#C2D5FC">
						<td>
							DUT
						</td>
						<td>
							Module Index
						</td>
						<td>
							Interface Name
						</td>
							<td>
								Peer Type
							</td>
							<td>
								Peer Host
							</td>
							<td>
								Peer Module
							</td>
							<td>
								Peer Port
							</td>
							<td>
								Comments
							</td>
							<td></td>
						</tr>
						<tr>
							<td>
								<input readonly type="text" name="DutIpAddress" value="<%=DutIpAddress%>"
									style="background-color: Cadetblue; width: 100px">
							</td>
							<td>
								<input readonly type="text" name="ModuleIndex" value="<%=ModuleIndex%>"
									style="background-color: Cadetblue; width: 35px">
							</td>
							<td>
								<input readonly type="text" name="IntfName"
									value="<%=IntfName%>"
									style="background-color: Cadetblue; width: 150px">
							</td>
							<td>
								<input readonly type="text" name="ConnectionType"
									value="SPIRENT"
									style="background-color: Cadetblue; width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionHostname"
									value="<%=PeerHost %>" style="width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionSlot"
									value="<%=PeerModule %>" style="width: 150px;">
							</td>
							<td>
								<input type="text" name="ConnectionPortIndex"
									value="<%=PeerPort %>" style="width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionNotes" value="<%=Comments %>">
							</td>
							<td>
								<input type="submit" name="Submit" value="Update">
							</td>
						</tr>
					</table>
				</form>
			</div>

			<div name="AV" id="AV" style="display: <%= avdisstate %>">
				<form method=post action="/iprep/dutconnection.do">
					<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
						width="100%">
						<tr bgcolor="#C2D5FC">
						<td>
							DUT
						</td>
						<td>
							Module Index
						</td>
						<td>
							Interface Name
						</td>
							<td>
								Peer Type
							</td>
							<td>
								Peer Host
							</td>
							<td>
								Peer Port
							</td>
							<td>
								Comments
							</td>
							<td></td>
						</tr>
						<tr>
							<td>
								<input readonly type="text" name="DutIpAddress" value="<%=DutIpAddress%>"
									style="background-color: Cadetblue; width: 100px">
							</td>
							<td>
								<input readonly type="text" name="ModuleIndex"
									value="<%=ModuleIndex%>"
									style="background-color: Cadetblue; width: 85px">
							</td>
							<td>
								<input readonly type="text" name="IntfName"
									value="<%=IntfName%>"
									style="background-color: Cadetblue; width: 150px">
							</td>
							<td>
								<input readonly type="text" name="ConnectionType" value="AV"
									style="background-color: Cadetblue; width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionHostname"
									value="<%=PeerHost %>" style="width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionPortIndex"
									value="<%=PeerPort %>" style="width: 100px;">
							</td>
							<td>
								<input type="text" name="ConnectionNotes" value="<%=Comments %>">
							</td>
							<td>
								<input type="submit" name="Submit" value="Update">
							</td>
						</tr>
					</table>
				</form>
			</div>
			<p>
			<br>
			<br>
			<br>
			</p>
			Note: This page allows you to enter information describing the
			connection of STC port.
			<ul>
				<li type=disc>
					ie. "SPIRENT 10.14.18.19 (Peer Host), 2 (Peer Module), 3 (Peer Port)" will be
					recorded as "SPIRENT 10.14.18.19/2/3"
				<li type=disc>
					ie. "AV 10.61.40.33 (Peer Host), 1 (Peer Port), For example (Comments)"
					will be recorded as "AV 10.61.40.33/1 (For example)"
				<li type=disc>
					To make sure the update successful, please avoid using "'" (single
					qutoes) in input column
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
