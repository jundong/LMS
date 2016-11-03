<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="ISO-8859-1"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<base href="<%=basePath%>">
		<title>Welcome To iPREP Lab Management System</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
		<script type="text/javascript">
			function expandTree()
			{
				if(parent.treeframe.tree!= null && parent.treeframe.tree.getOpenState(0) == 1)
				{
					parent.treeframe.tree.openAllItems(0);
				}
			}	
		</script>
	</head>
	<body onload="return expandTree();">
		<center>
			<div class="content">
				<h4>
					Welcome to iPREP Lab Management System!
				</h4>
				<p>
					In the effort of building virtual labs and maximum sharing of Lab
					inventory, this tool was created as a one-stop solution for all
					sites to share Lab resources effectively. This tool gives a
					visibility of Lab inventory and their availability to all sites.
					One can search and reserve resources across sites. It identifies
					Lab Primes for effective communications. It indicates the Lab
					management if the resources are underutilized or over utilized
					based on utilization reports.
				</p>
			</div>
			<p>
			</p>
			<%
				if (request.getParameter("Animation") != null) {
			%>
			<div id="loading" style="width: 100%; text-align: center;">
				<img src="/iprep/common/imgs/loading.gif" border=0>
			</div>
			<%
				}
			%>
			
			<div style="width: 100%;bottom: 64px;display:block;position:absolute;text-align: center;">
						*For the best performance and stability of this tool, please use
			Firefox or Google Chrome browser.
			</div>
		</center>



		<br>
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
