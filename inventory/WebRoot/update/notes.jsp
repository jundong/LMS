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
		<title>Update</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">                      
             function updateVM() {
             	updateform.action="/inventory/updatevmnotes.do?isVM=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
             function updateVMClient() {
             	updateform.action="/inventory/updatevmnotes.do?isVMClient=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
            function updatePC() {
             	updateform.action="/inventory/updatevmnotes.do?isPC=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }
             function updateDUT() {
             	updateform.action="/inventory/updatevmnotes.do?isDUT=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
             function updateDUTSerPort() {
             	updateform.action="/inventory/updatevmnotes.do?isDUTSerPort=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }               
            function updateDUTIntf() {
             	updateform.action="/inventory/updatevmnotes.do?isDUTIntf=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             } 
            function updateChassis() {
             	updateform.action="/inventory/updatevmnotes.do?isChassis=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             } 
            function updateModule() {
             	updateform.action="/inventory/updatevmnotes.do?isModule=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
            function updatePort() {
             	updateform.action="/inventory/updatevmnotes.do?isPort=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
            function updateAv() {
             	updateform.action="/inventory/updatevmnotes.do?isAV=true";
			    updateform.target="basefrm";
			    updateform.submit();  
             }  
            function updateAvPort() {
             	updateform.action="/inventory/updatevmnotes.do?isAVPort=true";
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
				String Ip = "";
				String IpNotes = "";
				if (request.getParameter("Ip") != null) {
					Ip = request.getParameter("Ip");
					if (request.getParameter("IpNotes") != null){
					   IpNotes = request.getParameter("IpNotes");
					}
				}
				String ClientIp = "";
				String ClientNotes = "";
				if (request.getParameter("ClientIp") != null) {
					ClientIp = request.getParameter("ClientIp");
					if (request.getParameter("ClientNotes") != null){
					   ClientNotes = request.getParameter("ClientNotes");
					}
				}
				String DNSHostName = "";
				String DNSHostNotes = "";
				if (request.getParameter("DNSHostName") != null) {
					DNSHostName = request.getParameter("DNSHostName");
					if (request.getParameter("DNSHostNotes") != null){
					    DNSHostNotes = request.getParameter("DNSHostNotes");
					}
				}
				String DutIp = "";
				String DutNotes = "";
				if (request.getParameter("DutIp") != null) {
					DutIp = request.getParameter("DutIp");
					if (request.getParameter("DutNotes") != null){
					    DutNotes = request.getParameter("DutNotes");
					}
				}
				String DutSerialIp = "";
				if (request.getParameter("DutSerialIp") != null) {
					DutSerialIp = request.getParameter("DutSerialIp");
				}
				String DUTIntfName = "";
				String DUTIntfNotes = "";
				if (request.getParameter("DUTIntfName") != null) {
					DUTIntfName = request.getParameter("DUTIntfName");
					if (request.getParameter("DUTIntfNotes") != null){
					    DUTIntfNotes = request.getParameter("DUTIntfNotes");
					}
				}
				String DUTIntfIp = "";
				if (request.getParameter("DUTIntfIp") != null) {
					DUTIntfIp = request.getParameter("DUTIntfIp");
				}
				String ChIP = "";
				String ChNotes = "";
				if (request.getParameter("ChIP") != null) {
					ChIP = request.getParameter("ChIP");
					if (request.getParameter("ChNotes") != null){
					    ChNotes = request.getParameter("ChNotes");
					}
				}
				String ChPortIP = "";
				String ChPortNotes = "";
				if (request.getParameter("ChPortIP") != null) {
					ChPortIP = request.getParameter("ChPortIP");
					if (request.getParameter("ChPortNotese") != null){
					    ChPortNotes = request.getParameter("ChPortNotese");
					}
				}
				String ChSlotPortIndex = "";
				if (request.getParameter("ChSlotPortIndex") != null) {
					ChSlotPortIndex = request.getParameter("ChSlotPortIndex");
				}
				String ChPortIndex = "";
				if (request.getParameter("ChPortIndex") != null) {
					ChPortIndex = request.getParameter("ChPortIndex");
				}
				String ChSlotIP = "";
				String ChSlotNotes = "";
				if (request.getParameter("ChSlotIP") != null) {
					ChSlotIP = request.getParameter("ChSlotIP");
					if (request.getParameter("ChSlotNotes") != null){
					    ChSlotNotes = request.getParameter("ChSlotNotes");
					}
				}
				String SlotIndex = "";
				if (request.getParameter("SlotIndex") != null) {
					SlotIndex = request.getParameter("SlotIndex");
				}
				String AVIp = "";
				String AVNotes = "";
				if (request.getParameter("AVIp") != null) {
					AVIp = request.getParameter("AVIp");
					if (request.getParameter("AVNotes") != null){
					    AVNotes = request.getParameter("AVNotes");
					}
				}
				String AVPortIp = "";
				String AVPortNotes = ""; 
				if (request.getParameter("AVPortIp") != null) {
					AVPortIp = request.getParameter("AVPortIp");
					if (request.getParameter("AVPortNotes") != null){
					    AVPortNotes = request.getParameter("AVPortNotes");
					}
				}
				String AVPortGP = "";
				if (request.getParameter("AVPortGP") != null) {
					AVPortGP = request.getParameter("AVPortGP");
				}
				String AVPort = "";
				if (request.getParameter("AVPort") != null) {
					AVPort = request.getParameter("AVPort");
				}	
			%>
			<form method="post" name="updateform" id="updateform">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="ChIP" border="0" value="<%=ChIP%>"
								style="width: 120px;" />
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="ChassisNotes" style="width: 120px;"
								value="<%=ChNotes %>" >
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
							<input type="submit" border="0" value="Update Chassis Notes"
								onClick="updateChassis();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="ChSlotIP" border="0"
								value="<%=ChSlotIP%>" style="width: 120px;">
						</td>
						<td>
							Slot Index:
						</td>
						<td>
							<input type="text" name="SlotIndex" border="0"
								value="<%=SlotIndex%>" style="width: 80px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="SlotNotes" style="width: 120px;"
								value="<%=ChSlotNotes%>">
						</td>
						<td>

						</td>
						<td>
						</td>
						<td>
							<input type="submit" border="0" value="Update Module Notes"
								onClick="updateModule();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="ChPortIP" border="0"
								value="<%=ChPortIP %>" style="width: 120px;">
						</td>
						<td>
							Slot Index:
						</td>
						<td>
							<input type="text" name="ChSlotPortIndex" border="0"
								value="<%=ChSlotPortIndex %>" style="width: 80px;">
						</td>
						<td>
							Port Index:
						</td>
						<td>
							<input type="text" name="ChPortIndex" border="0"
								value="<%=ChPortIndex %>" style="width: 80px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="PortNotes" style="width: 120px;"
								value="<%=ChPortNotes %>">
						</td>
						<td>
							<input type="submit" border="0" value="Update Port Notes"
								onClick="updatePort();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Avalanche IP:
						</td>
						<td>
							<input type="text" name="AVIp" border="0" value="<%=AVIp %>"
								style="width: 120px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="AVNotes" style="width: 120px;" value="<%=AVNotes %>">
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
							<input type="submit" border="0" value="Update Avalanche Notes"
								onClick="updateAv();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Avalanche IP:
						</td>
						<td>
							<input type="text" name="AVPortIp" border="0"
								value="<%=AVPortIp %>" style="width: 120px;">
						</td>
						<td>
							Av Port Group:
						</td>
						<td>
							<input type="text" name="AVPortGP" border="0"
								value="<%=AVPortGP %>" style="width: 80px;">
						</td>
						<td>
							Av Port Index:
						</td>
						<td>
							<input type="text" name="AVPort" border="0" value="<%=AVPort %>"
								style="width: 80px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="AVPortNotes" style="width: 120px;"
								value="<%=AVPortNotes %>">
						</td>
						<td>
							<input type="submit" border="0" value="Update AV Port Notes"
								onClick="updateAvPort();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							VM Server:
						</td>
						<td>
							<input type="text" name="VMIp" border="0" value="<%=Ip %>"
								style="width: 120px;" />
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="VMNotes" style="width: 120px;" value="<%=IpNotes %>">
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
							<input type="submit" border="0" value="Update Server Notes"
								onClick="updateVM();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							VM Client:
						</td>
						<td>
							<input type="text" name="VMClientIp" border="0"
								value="<%=ClientIp%>" style="width: 120px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="VMClientNotes" style="width: 120px;"
								value="<%=ClientNotes %>">
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
							<input type="submit" border="0" value="Update Client Notes"
								onClick="updateVMClient();" style="width: 170px;">
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
							<input type="text" name="PCName" border="0"
								value="<%=DNSHostName%>" style="width: 120px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="PCNotes" style="width: 120px;" value="<%=DNSHostNotes%>">
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
							<input type="submit" border="0" value="Update PC Notes"
								onClick="updatePC();" style="width: 170px;">
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
							<input type="text" name="DUTIp" border="0" value="<%=DutIp%>"
								style="width: 120px;" />
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="DUTNotes" style="width: 120px;" value="<%=DutNotes%>">
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
							<input type="submit" border="0" value="Update DUT Notes"
								onClick="updateDUT();" style="width: 170px;">
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
							<input type="text" name="DutSerialIp" border="0"
								value="<%=DutSerialIp%>" style="width: 120px;">
						</td>
						<td>
							Serial Port Access:
						</td>
						<td>
							<input type="text" name="SerialPortAccess" style="width: 80px;"
								value="">
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
							<input type="submit" border="0" value="Update DUT Serial Port"
								onClick="updateDUTSerPort();" style="width: 170px;">
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							DUT Intf IP:
						</td>
						<td>
							<input type="text" name="DUTIntfIP" border="0"
								value="<%=DUTIntfIp%>" style="width: 120px;">
						</td>
						<td>
							DUT Interface:
						</td>
						<td>
							<input type="text" name="DUTIntfName" border="0"
								value="<%=DUTIntfName%>" style="width: 120px;">
						</td>
						<td>
							Notes:
						</td>
						<td>
							<input type="text" name="DUTIntfNotes" value="<%=DUTIntfNotes%>" style="width: 120px;">
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
							<input type="submit" border="0" value="Update DUTIntf Notes"
								onClick="updateDUTIntf();" style="width: 170px;">
						</td>
					</tr>
				</table>
			</form>
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
