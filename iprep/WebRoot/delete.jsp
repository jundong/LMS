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
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">
			function refreshTreeView() {
			   window.open(" /iprep/tree/inventorytree.jsp?Site=<%=session.getAttribute("loginsite")%>", "treeframe");
			}

             function delTestBed() {
             	delform.action="/iprep/deleteresource.do";
			    delform.target="basefrm";
			    delform.submit();   
             }           		
		</script>
	</head>

	<body>
		<div class="content">
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Delete TestBed</b>
			<hr>
			<form method="post" name="delform" id="delform">
				<table border="0" cellpadding="0" cellspacing="0"
					width="100%">		
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							TestBedName:
						</td>
						<td>
							<input type="text" name="TestBedName" border="0"
								value="" style="width: 120px;" />
						</td>
						<td>
							<input type="submit" onClick="delTestBed();"
								style="width: 130px;" border="0" value="Delete TestBed" />
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
					The resource must be in iPREP system (Can be search or in left tree view)
				<li type=disc>
					You can present a TestBedIndex OR a TestBedName for delete parameter, but one of them is required
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
