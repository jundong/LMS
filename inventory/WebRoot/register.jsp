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
		<title>Login Lab Management System</title>
		<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />
	</head>
	<body>
		<%
			String isLogout = request.getParameter("isLogout");
			//System.out.println(isLogout);
			if (isLogout == null) {
				isLogout = "";
			}
			String isFailed = request.getParameter("isFailed");
			String isInLocalDB = request.getParameter("isInLocalDB");
			Cookie lrsCookie[] = request.getCookies();
		%>

		<div class="header">
			<a class="logo" href="http://www.spirent.com" title="Spirent"></a>
			<div class="tittle-inventory">
				Spirent Lab Management System
			</div>
		</div>
		<div class="content">
			<h4>
				Register Spirent Lab Management System
			</h4>
			<div class="line">
					<ul>
						<li>
							<font color="#FF0000"> If you have forgotten your username or password,
								please contact your lab administrator for assistance.</font>
						</li>
						<li>
							<font color="#FF0000"> If you have registered in Lab Management System, please <a
								href="/inventory/login.jsp?isRegister=true">login</a>.</font>
						</li>
						<li>
							<font color="#FF0000">*</font> Indicates required field
						</li>
						<%
							if (isFailed != null) {
						%>
						<li>
							<font color="#FF0000">Make sure your name and password are correct. Please
								try it again. </font>
						</li>
						<%
							}
						%>
						<form id="register" name="register" method=post
							action="register.do">
							<li>
								*First Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="text" border="0" name="firstusername"
									style="width: 100px" />
							</li>
							<li>
								*Last Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="text" border="0" name="lastusername"
									style="width: 100px" />
							</li>
							<li>
								*User Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="text" border="0" name="username"
									style="width: 100px" />
							</li>
							<li>
								&nbsp;&nbsp;Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="password" name="rpassword">
							</li>
							<li>
								*Select Site:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<select name="rsite">
									<option value="ALL" selected>
										ALL
									</option>
									<option value="CAL">
										Calabasas
									</option>
									<option value="CHN">
										Beijing
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
							</li>
							<li>
								<input type="submit" border="0" value="Register"
									style="width: 100px" />
							</li>
							<li>
								<input type="hidden" name="timeoffset" value="">
							</li>
						</form>
						<li>
							<font color="#FF0000">If you provide password here, you can login LRS
								directly.</font>
						</li>
						<script type="text/javascript">
							       document.getElementById("register").timeoffset.value = (new Date()).getTimezoneOffset();
							</script>
						<li>
							*For the best performance and stability of this tool, please use
							Firefox or Google Chrome browser.
						</li>
					</ul>
			</div>
		</div>
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
