<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
	if (!request.getSession().getAttribute("levels").toString().equals(
			"0")) {
		//out.println("<script type=\"text/javascript\">");
		//out.println("window.open('/inventory/login.jsp','_top');");
		//out.println("</script>");
		response.sendRedirect("/inventory/warning.jsp");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>Admin</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<style>
.bg {
	width: 100%;
}
</style>
	</head>

	<body>
		<div class="content">
			<a HREF="/inventory/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/inventory/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Administration</b>
			<hr>
			<table  border="0" cellpadding="0" cellspacing="0"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						<form id="deletename" name="deletename" method="post"
							action="admin.do?isDelete=true">
							User Name:
							<input type="text" border="0" name="delname" style="width: 100px" />
							<input type="submit" border="0" value="Delete User"
								style="width: 100px" />
						</form>
					</td>
				</tr>

				<tr bgcolor="#FFFFFF" height="10px">
					<td>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<form id="updatename" name="updatename" method="post"
							action="admin.do?isUpdate=true">
							User Name:
							<input type="text" border="0" name="updatename"
								style="width: 100px" />
							Account Rank:
							<select name="updaterank" style="width: 100px">
								<option value="2">
									User
								</option>
								<option value="1">
									Prime
								</option>
								<option value="0">
									Admin
								</option>
							</select>
							<input type="submit" border="0" value="Update User"
								style="width: 100px" />
						</form>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="10px">
					<td>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<form method="post" action="admin.do?isAddUser=true">
							First Name:
							<input type="text" border="0" name="firstusername"
								style="width: 100px" />
							Last Name:
							<input type="text" border="0" name="lastusername"
								style="width: 100px" />
							User Name:
							<input type="text" border="0" name="domainusername"
								style="width: 100px" />
							Account Rank:
							<select name="addrank" style="width: 100px">
								<option value="2">
									User
								</option>
								<option value="1">
									Prime
								</option>
								<option value="0">
									Admin
								</option>
							</select>
							<input type="submit" border="0" value="Add User"
								style="width: 100px" />
						</form>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="10px">
					<td>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<form method="post" action="users.jsp">
							<input type="submit" border="0" value="Show Users"
								style="width: 200px" />
						</form>
					</td>
				</tr>
			</table>

			<script language=javascript>
		  var queryStr = window.location.search.substr(1);
		  if (queryStr.length > 0  && queryStr.search("=") == -1) {
		          deletename.delname.value = queryStr; 
		          updatename.updatename.value = queryStr;
		  }
        </script>
			<br>
			<br>
			<br>
			Note: Please refer to below items to use this page
			<ul>
				<li type=disc>
					Delete User: Need use "User Name" (You can click "Show Users"
					button to get all available user name)
				<li type=disc>
					Update User: Need use "User Name" and select the user rank to
					update the user's privilege
				<li type=disc>
					Add User: Need "First Name", "Last Name" and "User Name", all
					fields are mandatory
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
