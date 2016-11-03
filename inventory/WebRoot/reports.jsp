<%@ page language="java" import="java.util.*,com.spirent.formatstring.*"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String levels = request.getSession().getAttribute("levels")
			.toString();

	String resourcesList = request.getParameter("portList");
	String isEmpty = request.getParameter("isEmpty");

	if (resourcesList != null) {
		if (resourcesList.equals("")) {
			isEmpty = "true";
		} else {
			isEmpty = "false";
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Reports</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />

		<script type="text/javascript">
			function generateResourcesReport(){
			    generateReport.action="/inventory/utilizationreport.do?isResourcesReport=true&isEmpty=<%=isEmpty%>";
			    generateReport.target="basefrm";
			    generateReport.submit();  
			}

			function generateUserReport(){
			    generateReport.action="/inventory/utilizationreport.do?isUserReport=true&isEmpty=<%=isEmpty%>";
			    generateReport.target="basefrm";
			    generateReport.submit();  
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
			<b>Reports</b>
			<hr>
			<%
				if (request.getSession().getAttribute("resourcesList") == null) {
					request.getSession().setAttribute("resourcesList", "");
				}
				String isUserReport = request.getParameter("isUserReport");
				String topResources = "";
				String lastResources = "";
				String totalHours = "";
				String tmpResources = "";
				String siteStr = "";
				if (resourcesList == null) {
					if (isUserReport != null) {
						topResources = "Top Users";
						lastResources = "Last Users";
						totalHours = "Total Times";
					} else {
						topResources = "Top Resources";
						lastResources = "Last Resources";
						totalHours = "Total Hours";
						siteStr = "Site";
					}
					resourcesList = (String) request.getSession().getAttribute(
							"resourcesList");

					String topList = request.getParameter("topList");
					String lastList = request.getParameter("lastList");

					if (topList != null && lastList != null) {
						String[] splitTop = topList.split(",");
						String[] splitLast = lastList.split(",");
						for (int i = 0; i < splitTop.length; i = i + 2) {
							tmpResources = tmpResources + splitTop[i] + ","
									+ splitTop[i + 1] + "," + splitLast[i] + ","
									+ splitLast[i + 1] + ",";
						}
					}
				} else {
					topResources = "Resources";
					lastResources = "";
					totalHours = "";

					request.getSession().setAttribute("resourcesList",
							resourcesList);

					tmpResources = resourcesList;
				}

				String[] splitResources = tmpResources.split(",");
			%>
			<form method="post" name="generateReport">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#C2D5FC">
						<td>
							<input type=radio name="topCounts" value="5" checked>
							Top 5
						</td>
						<td>
						</td>
						<td>
							<input type=radio name="topCounts" value="10">
							Top 10
						</td>
						<td>
							<input type=radio name="topCounts" value="20">
							Top 20
						</td>
						<td>
						</td>
						<td>
							<input type=radio name="topCounts" value="40">
							Top 40
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<%=topResources%>
						</td>
						<td>
							<%=siteStr%>
						</td>
						<td>
							<%=totalHours%>
						</td>
						<td>
							<%=lastResources%>
						</td>
						<td>
							<%=siteStr%>
						</td>
						<td>
							<%=totalHours%>
						</td>
					</tr>
					<%
						String color = "";
						int i = 0;
						int reminder = splitResources.length % 4;
						int quotient = splitResources.length / 4;
						if (quotient > 0) {
							for (int x = 0; x < quotient; x++, i++) {
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
					%>
					<tr bgcolor=<%=color%>>
						<td>
							<%=splitResources[x * 4].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString()).getSite(
									splitResources[x * 4].replace("@", ","),
									siteStr)%>
						</td>
						<td>
							<%=splitResources[x * 4 + 1].replace("@", ",")%>
						</td>
						<td>
							<%=splitResources[x * 4 + 2].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString())
									.getSite(splitResources[x * 4 + 2].replace(
											"@", ","), siteStr)%>
						</td>
						<td>
							<%=splitResources[x * 4 + 3].replace("@", ",")%>
						</td>
					</tr>
					<%
						}
						}
						if (reminder == 1) {
							if (i % 2 == 0) {
								color = "#FFFFFF";
							} else {
								color = "#C2D5FC";
							}
					%>
					<tr bgcolor=<%=color%>>
						<td>
							<%=splitResources[i * 4].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString()).getSite(splitResources[i * 4]
								.replace("@", ","), siteStr)%>
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
					<%
						} else if (reminder == 2) {
							if (i % 2 == 0) {
								color = "#FFFFFF";
							} else {
								color = "#C2D5FC";
							}
					%>
					<tr bgcolor=<%=color%>>
						<td>
							<%=splitResources[i * 4].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString()).getSite(splitResources[i * 4]
								.replace("@", ","), siteStr)%>
						</td>
						<td>
							<%=splitResources[i * 4 + 1].replace("@", ",")%>
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
						</td>
					</tr>
					<%
						} else if (reminder == 3) {
							if (i % 2 == 0) {
								color = "#FFFFFF";
							} else {
								color = "#C2D5FC";
							}
					%>
					<tr bgcolor=<%=color%>>
						<td>
							<%=splitResources[i * 4].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString()).getSite(splitResources[i * 4]
								.replace("@", ","), siteStr)%>
						</td>
						<td>
							<%=splitResources[i * 4 + 1].replace("@", ",")%>
						</td>
						<td>
							<%=splitResources[i * 4 + 2].replace("@", ",")%>
						</td>
						<td>
							<%=(new FormatString()).getSite(splitResources[i * 4]
								.replace("@", ","), siteStr)%>
						</td>
						<td>
						</td>
					</tr>
					<%
						}
					%>
					<tr bgcolor="#FFFFFF" height="10px">
						<td>
						</td>
					</tr>
					<tr bgcolor="#C2D5FC">
						<td>
							<input type="submit" border="0" value="Resources Reports"
								onClick="generateResourcesReport();" style="width: 150px;" />
						</td>
						<td>
						</td>
						<td>
						</td>
						<td>
							<%
								if (levels.equals("1") || levels.equals("0")) {
							%>
							<input type="submit" border="0" value="User Reports"
								onClick="generateUserReport();" style="width: 150px;" />
							<%
								}
							%>
						</td>
						<td>
						</td>
						<td>
						</td>
					</tr>
					<tr bgcolor="#FFFFFF" height="10px">
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
			<br>
			Note: Please refer to below items to use report page
			<ul>
				<li type=disc>
					Use inventory tree view to select resources and then click
					"Reports" to show them in this page
				<li type=disc>
					If you don't select resources in left tree, you'll use all
					resources for the utilization report
				<li type=disc>
					Select radio button to determin the resource counts (Default is 5)


				
				<li type=disc>
					Click "Generate Resources Reports" button to list the top and last
					resaources total utilization
					<%
					if (levels.equals("1") || levels.equals("0")) {
				%>
				
				<li type=disc>
					Click "Generate User Reports" button to list the top and last user weekly login times
					<%
									}
								%>
				
			</ul>
		</div>
	</body>
</html>
