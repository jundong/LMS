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
		<title>Property</title>
		<meta http-equiv='Expires' content='-10'>
		<script src="/inventory/common/mootools.js" type="text/javascript"
			charset="utf-8"></script>
		<script src="/inventory/common/calendar.rc4.js" type="text/javascript"
			charset="utf-8"></script>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />
		<link rel="stylesheet" type="text/css"
			href="/inventory/common/css/calendar.css" media="screen" />

		<script type="text/javascript">
			 function display(type){
			    switch(type){
			       case "Permanent":
			         document.getElementById("divpermanent").style.display="";
			         document.getElementById("divloaner").style.display="none";
			         break;
			       case "Loaner":
			         document.getElementById("divpermanent").style.display="none";
			         document.getElementById("divloaner").style.display="";	         
			         break;
			       default:
			         break;         
			    }
			 };
			 
			window.addEvent('domready', function() { 
			    startDateCal = new Calendar({ sostart: 'd/m/Y' }, { direction: 1, tweak: {x: 6, y: 0} });
			    endDateCal = new Calendar({ soend: 'd/m/Y' }, { direction: 1, tweak: {x: 6, y: 0} });
			    notificationdateCal = new Calendar({ notificationdate: 'd/m/Y' }, { direction: 1, tweak: {x: 6, y: 0} });
		    });
			 </script>
	</head>

	<body>
		<div class="content">
			<a HREF="/inventory/tree/chassis.jsp?Site=ALL">STC</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/dut.jsp?Site=ALL">DUT</a>&nbsp;&nbsp;
			<a HREF="/inventory/tree/vmhost.jsp?Site=ALL">VM</a>&nbsp;&nbsp;
			<a HREF="/inventory/help.jsp">Document</a>&nbsp;&nbsp;

			<hr>
			<b>Update Property Information</b>
			<hr>
			<%
				String Ip = request.getParameter("Ip");
				String Slot = request.getParameter("Slot");
				String Property = request.getParameter("Property");
				String perState = "";
				String loaState = "";
				String perDisState = "none";
				String loaDisState = "none";
				String SOEnd = "";
				String SO = "";
				String SN = request.getParameter("SN");
				String SOStart = "";
				String LoanerNotificationDate = "";
				String loanerCheckBox = "";
				String ResourceType = request.getParameter("ResourceType");
				if (Property.equals("Permanent")) {
					perState = "checked";
					perDisState = "";
					SO = request.getParameter("SO");
				} else if (Property.equals("Loaner")) {
					loaState = "checked";
					loaDisState = "";
					SO = request.getParameter("SO");
				    SOStart = request.getParameter("SOStart");
				    SOEnd = request.getParameter("SOEnd");
				    LoanerNotificationDate = request.getParameter("LoanerNotificationDate");
				    loanerCheckBox = "checked";
				}

				if (Slot == null) {
					Slot = "";
				}
			%>
			<form>
				<table BORDER=0 CELLPADDING="0" CELLSPACING="0" width="100%">
					<tr bgcolor="#C2D5FC" style="width: 100%">
						<td>

							<input type="radio" onclick="display(this.value);"
								name="RadioType" value="Permanent" <%=perState%>>
							Permanent
						</td>
						<td>
							<input type="radio" onclick="display(this.value)"
								name="RadioType" value="Loaner" <%=loaState%>>
							Loaner
						</td>
					</tr>
				</table>
			</form>
			<div name="divloaner" id="divloaner" style="display: <%=loaDisState%>">
				<form method=post
					action="/inventory/property.do?isLoaner=true&Ip=<%=Ip%>&Slot=<%=Slot%>&SN=<%=SN %>&ResourceType=<%=ResourceType %>">
					<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
						width="100%">
						<tr>
							<td>
								Type:
							</td>
							<td>
								<input readonly type="text" name="loaner" value="Loaner"
									style="background-color: Cadetblue; width: 80px">
							</td>
							<td>
								SO#:
							</td>
							<td>
								<input type="text" name="so" value="<%=SO %>" style="width: 100px">
							</td>
							<td>
								Start Date:
							</td>
							<td>
								<input type="text" id="sostart" name="sostart" value="<%=SOStart %>"
									style="width: 120px">
							</td>
							<td>
								End Date:
							</td>
							<td>
								<input type="text" id="soend" name="soend" value="<%=SOEnd %>"
									style="width: 120px">
							</td>
							<td>
								Notification Date:
							</td>							
							<td>
								<input type="text" id="notificationdate" name="notificationdate" value="<%=LoanerNotificationDate %>"
									 style="width: 120px">
							</td>	
							<td>
								<input type="checkbox" border="0" name="saveNotificationDate" <%=loanerCheckBox %>>
							</td>													
							<td>
								<input type="submit" name="Submit" value="Update">
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div name="divpermanent" id="divpermanent" style="display: <%=perDisState%>">
				<form method=post
					action="/inventory/property.do?isPermanent=true&Ip=<%=Ip%>&Slot=<%=Slot%>&SN=<%=SN %>&ResourceType=<%=ResourceType %>">
					<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
						width="100%">
						<tr>
							<td>
								Type:
							</td>
							<td>
								<input readonly type="text" name="per" value="Permanent"
									style="background-color: Cadetblue; width: 80px">
							</td>
							<td>
								SO#:
							</td>
							<td>
								<input type="text" name="so" value="<%=SO %>" style="width: 100px">
							</td>
							<td>
								Start Date:
							</td>
							<td>
								<input readonly type="text" name="sostart" value=""
									style="background-color: Cadetblue; width: 120px">
							</td>
							<td>
								End Date:
							</td>
							<td>
								<input readonly type="text" name="soend" value=""
									style="background-color: Cadetblue; width: 120px">
							</td>
							<td>
								<input type="submit" name="Submit" value="Update">
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<br>
		<br>
		<br>
		Note: This page allows you to enter information describing the
		property of STC/Module.
		<ul>
			<li type=disc>
				Date format: day/month/year, ie: 04/07/2010.
			<li type=disc>
				The check box after "Notification Date" is used for saving notification date. 
				If you "Checked" here and give a date, you can receive the notification when you "Enable Loaner End Date Notification" option in "Preferences" page. 				
		</ul>
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
