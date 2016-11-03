<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
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
		<title>Add Resource</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">
             function refreshTreeView() {
                window.open(" /inventory/tree/inventorytree.jsp?Site=<%=session.getAttribute("loginsite")%>", "treeframe");
             }
             
             function addChassis() {
             	addform.action="/inventory/addresource.do?isChassis=true";
			    addform.target="basefrm";
			    addform.submit();  
             }
             
             function addDUT() {
                addform.action="/inventory/update/updatedut.jsp";
			    addform.target="basefrm";
			    addform.submit();  
             }
             
             function addDUTIntf() {
                addform.action="/inventory/update/updatedutintf.jsp";
			    addform.target="basefrm";
			    addform.submit();  
             }             
             
             function addAV() {
             	addform.action="/inventory/addresource.do?isAV=true";
			    addform.target="basefrm";
			    addform.submit();  
             }
   
             function addPC() {
             	addform.action="/inventory/addresource.do?isPC=true";
			    addform.target="basefrm";
			    addform.submit();  
             }   
             
             function addVM() {
             	addform.action="/inventory/addresource.do?isVM=true";
			    addform.target="basefrm";
			    addform.submit();  
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
			<b>Add Resource</b>
			<hr>
			<form method="post" name="addform" id="addform">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="Resources" border="0" value=""
								style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="addChassis();" border="0"
								value="Add Chassis" style="width: 110px;" />
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
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							Avalanche IP:
						</td>
						<td>
							<input type="text" name="AVResources" border="0" value=""
								style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="addAV();" border="0"
								value="Add Avalanche" style="width: 110px;" />
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
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							PC Name:
						</td>
						<td>
							<input type="text" name="PCResources" border="0" value=""
								style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="addPC();" border="0" value="Add PC"
								style="width: 110px;" />
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
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							VM Server IP:
						</td>
						<td>
							<input type="text" name="VMResources" border="0" value=""
								style="width: 120px;" />
						</td>
						<td>
							Server User:
						</td>
						<td>
							<input type="text" name="VMUser" border="0" value=""
								style="width: 70px;" />
						</td>
						<td>
							Server Password:
						</td>
						<td>
							<input type="password" name="VMPassword" border="0" value=""
								style="width: 70px;" />
						</td>
						<td>
							<input type="submit" onClick="addVM();" border="0" value="Add VM"
								style="width: 110px;" />
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
							DUT IP
						</td>
						<td>
							<input type="text" name="DutIpAddress" border="0" value=""
								style="width: 120px;" />
						</td>
						<td>
							User:
						</td>
						<td>
							<input type="text" name="LoginName" border="0" value=""
								style="width: 70px;" />
						</td>
						<td>
							Password:
						</td>
						<td>
							<input type="password" name="LoginPassword" border="0" value=""
								style="width: 70px;" />
						</td>
						<td>
							En./Con.PW:
						</td>
						<td>
							<input type="password" name="LoginEnablePassword" border="0" value=""
								style="width: 70px;" />
						</td>
						<td>
							<input type="submit" onClick="addDUT();" border="0"
								value="Add DUT" style="width: 110px;" />
						</td>
						<td>
							<input type="submit" onClick="addDUTIntf();" border="0"
								value="Add DUTIntf" style="width: 110px;" />
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<input type="submit" border="0" value="Update Tree View"
								onClick="refreshTreeView();" style="width: 130px;" />
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
			<br>
			<br>
			Note: Please refer to below items to add resource
			<ul>
				<li type=disc>
					Resource IP address is available, PC needs PC name.
				</li>
				<li type=disc>
					After click "Add xxx" button, you can continue to your work in LMS,
					waiting a while you can update the left tree view to check your added resource(s).
				</li>
				<li type=disc>
					You can add multi-resources one by one
				</li>
				<li type=disc>
					PC, DUT and VM aren't updated in LMS in real time, but
					it'll be shown in LMS in next DB update cycle.
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
