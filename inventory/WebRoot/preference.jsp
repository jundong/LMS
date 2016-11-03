<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String levels = request.getSession().getAttribute("levels").toString();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Preferences</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />
     
     <script type="text/javascript">
              function updateSite() {
             	updateForm.action="/inventory/preferences.do?isUpdateSite=true";
			    updateForm.target="_top";
			    updateForm.submit();  
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
			<b>Preferences</b>
			<hr>
			<table border="0" cellpadding="0" cellspacing="0" 
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						<form method="post" name="updateForm" id="updateForm">
							Select Site:
							<select name="site">
								<option value="ALL">
									ALL
								</option>
								<option value="CHN">
									Beijing
								</option>
								<option value="CAL">
									Calabasas
								</option>
								<option value="HNL">
									Honolulu
								</option>
								<option value="RTP">
									Raleigh
								</option>
								<option value="SNV">
									Sunnyvale
								</option>
							</select>
							<input type="submit" onClick="updateSite();" border="0" value="Update Site"
								style="width: 100px" />
						</form>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="10px">
					<td>
						<p></p>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<form method="post" action="preferences.do?isSetting=true">
							<input type="checkbox" border="0" name="receivemail" />
							Disable Receive Notification
							<br>
							<input type="checkbox" border="0" name="loanerreceive" />
							Enable Loaner End Date Notification
							<br>
							 <%  if (!levels.equals("2")) { %>
							<input type="checkbox" border="0" name="recresreport" />
							Enable Receive Weekly Resources Utilization Report
							<br>
							<input type="checkbox" border="0" name="recloginreport" />
							Enable Receive Weekly Users Login Report
							<br>
							<input type="checkbox" border="0" name="monitorreport" />
							Enable Receive Hourly Monitor Report
							<br>
							<%} %>
							<input type="submit" border="0" value="Save" style="width: 100px" />
						</form>
					</td>
				</tr>
				<%  if (!levels.equals("2")) { %>
				<tr bgcolor="#FFFFFF" height="10px">
					<td>
						<p></p>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<form method="post" action="updateremindertime.do">
							Reminder:
							<select name="reminder">
								<option value="min5">
									5 minutes  
								</option>
								<option value="min15" selected>
									15 minutes
								</option>
								<option value="min30">
									30 minutes
								</option>
								<option value="hour1">
									1 hour
								</option>
								<option value="hour2">
									2 hours
								</option>
								<option value="hour3">
									3 hours
								</option>
							</select>
							Reminder Duration:
							<select name="reminderduration">
								<option value="min30">
									30 minutes
								</option>
								<option value="hour1">
									1 hour
								</option>
								<option value="hour2">
									2 hour
								</option>
								<option value="hour3">
									3 hour
								</option>
								<option value="hour4">
									4 hour
								</option>
								<option value="hour5">
									5 hour
								<option value="hour6">
									6 hour
								</option>
							</select>	
							<input type="submit" border="0" value="Save" style="width: 100px" />
						</form>
					</td>
				</tr>
				<%} %>
			</table>
			<br>
			<br>
			<br>
			Note: Please refer to below items to use this page
			<ul>
				<li type=disc>
					"Select Site" will be your default auto-login site and update inventory tree
				</li>
				<li type=disc>
                    Default you'll receive notification.
				</li>
				<li type=disc>
					Default you'll not receive weekly report.
				</li>
				<li type=disc>
					Default you'll not receive houly monitor report.
				</li>
				<li type=disc>
					"Reminder" is the interval time to send reminder notification.
				</li>
				<li type=disc>
					"Reminder Duration" is the time before the reservation occurs. For example, you set "Reminder = 15" and "Reminder Duration = 30", you'll get 2 notifications with interval time 15 mins.
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
