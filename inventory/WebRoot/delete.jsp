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

		<title>Delete Resource</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">
		function refreshTreeView() {
		   window.open(" /inventory/tree/inventorytree.jsp?Site=<%=session.getAttribute("loginsite")%>", "treeframe");
		}

             function delChassis() {
             	delform.action="/inventory/deleteresource.do?isChassis=true";
			    delform.target="basefrm";
			    delform.submit();   
             }
             
             function delDUT() {
                delform.action="/inventory/deleteresource.do?isDUT=true";
			    delform.target="basefrm";
			    delform.submit();  
             }
             
             function delDUTIntf() {
                delform.action="/inventory/deleteresource.do?isDUTIntf=true";
			    delform.target="basefrm";
			    delform.submit();  
             }             
             
             function delAV() {
             	delform.action="/inventory/deleteresource.do?isAV=true";
			    delform.target="basefrm";
			    delform.submit();  
             }
             
             function delVM() {
             	delform.action="/inventory/deleteresource.do?isVM=true";
			    delform.target="basefrm";
			    delform.submit();  
             }    
             
             function delPC() {
             	delform.action="/inventory/deleteresource.do?isPC=true";
			    delform.target="basefrm";
			    delform.submit();  
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
			<b>Delete Resource</b>
			<hr>
			<form method="post" name="delform" id="delform">
				<table border="0" cellpadding="0" cellspacing="0"
					width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							Chassis IP:
						</td>
						<td>
							<input type="text" name="Resources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delChassis();"
								style="width: 130px;" border="0" value="Delete Chassis" />
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
							Avlanche IP:
						</td>
						<td>
							<input type="text" name="AVResources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delAV();"
								style="width: 130px;" border="0" value="Delete Avalanche" />
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
							VM IP:
						</td>
						<td>
							<input type="text" name="VMResources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delVM();"
								style="width: 130px;" border="0" value="Delete VM" />
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
							<input type="text" name="PCResources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delPC();"
								style="width: 130px;" border="0" value="Delete PC" />
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
							DUT IP:
						</td>
						<td>
							<input type="text" name="DUTResources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delDUT();"
								style="width: 130px;" border="0" value="Delete DUT" />
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
							DUT IP:
						</td>
						<td>
							<input type="text" name="DUTIntfIPResources" border="0"
								value="" style="width: 120px;" />
						</td>					
						<td>
							DUT Intf:
						</td>
						<td>
						
							<input type="text" name="DUTIntfResources" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delDUTIntf();"
								style="width: 130px;" border="0" value="Delete DUTIntf" />
						</td>
					</tr>															
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>

							<input type="submit" border="0" value="Update Tree View"
								onClick="refreshTreeView();" style="width: 150px;"/>
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
			Note: Please refer to below items to delete resource
			<ul>
				<li type=disc>
					The resource must be in LMS (Can be search or in left inventory view)
				<li type=disc>
					You can delete multi-resources one by one
				<li type=disc>
					The best way to avoid any error, you can copy the resource for the input items
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
