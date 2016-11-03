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
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
	</head>
	<body>
		<%
			String isLogout = request.getParameter("isLogout");
			String isFailed = request.getParameter("isFailed");
			String isRegister = request.getParameter("isRegister");
			Cookie lrsCookie[] = request.getCookies();

			if (isLogout != null) {
				request.getSession().removeAttribute("username");
				request.getSession().removeAttribute("levels");
				request.getSession().removeAttribute("loginsite");
				request.getSession().removeAttribute("Site");
				request.getSession().removeAttribute("SQLstmt");
				request.getSession().setMaxInactiveInterval(1);
			}
			
			Connection conn = null;
		    Statement stmt = null;
		    ResultSet rs = null;

			try {
				if (isLogout == null && isFailed == null && isRegister == null) {
					conn = DataBaseConnection.getConnection();
					if (conn != null) {
						stmt = conn.createStatement();
						if (lrsCookie != null) {
							for (int i = 0; i < lrsCookie.length; i++) {
								String searchUser = "select * from users where  session='"
										+ lrsCookie[i].getValue() + "'";
								rs = stmt.executeQuery(searchUser);
								if (rs.next()) {

									request.getSession().setAttribute(
											"username", lrsCookie[i].getName());
									request.getSession().setAttribute("levels",
											rs.getString("levels"));
									request.getSession().setAttribute(
											"loginsite", rs.getString("site"));
									request.getSession().setAttribute(
											"timeoffset",
											rs.getString("timeoffset"));
									request.getSession()
											.setMaxInactiveInterval(60 * 60);

									int logintimes = rs.getInt("logintimes") + 1;
									int monloginreport = rs
											.getInt("monloginreport") + 1;
									int totallogin = rs.getInt("totallogin") + 1;

									String updateSite = "update iprep_users set logintimes = '"
											+ logintimes
											+ "', monloginreport = '"
											+ monloginreport
											+ "', totallogin = '"
											+ totallogin
											+ "'  where username='"
											+ lrsCookie[i].getName() + "'";

									stmt.execute(updateSite);

									response
											.sendRedirect("/iprep/index.jsp");
									break;
								}
							}
						}
					}
				}
			} catch (Exception e) {
					System.out
							.println("SQL exception occurs in login.jsp: "
									+ e.getMessage());
				} finally {
			        	try {
			        		if(rs != null){
			        			rs.close();
			        		}
			        		if(stmt != null){
			        			stmt.close();
			        		}
			        		if(conn != null){
			        			DataBaseConnection.freeConnection(conn); 
			        		}
			        	} catch (Exception e) {      
			    			System.out
							.println("Close DB error occourred in login.jsp: "
									+ e.getMessage());
			        	}
			   }
		%>

		<div class="header">
			 <a class="logo" href="http://www.spirent.com" target="_top" title="Spirent">
            	<img src="/iprep/common/imgs/iPrepLogo.png" width="125" height="70" />
            </a>
			<div class="tittle-inventory">
				iPREP Lab Management System
			</div>
		</div>
		<div class="content">
			<h4>
				Login iPREP Lab Management System
			</h4>
			<div class="line">
					<ul>
						<li>
							<font> If you have forgotten your username or password,
								please contact your lab administrator for assistance.</font>
						</li>
						
						<li>
							<font> If this is the first time you are logging into the
								iPREP Management System, please <a
								href="/iprep/register.jsp">register</a> prior
								to logging in.</font>
						</li>
						
						<li>
							<font>*</font> Indicates required field
						</li>
						
						<%
							if (isFailed != null) {
						%>
						<li>
							<font>Make sure your name and password are correct. Please
								try it again. If you are non-Spirent user, please ask administrator to add an account for you.</font>
						</li>
						
						<%
							}
						%>
						<form id="login" name="login" method=post
							action="login.do">
							<li>
								*User Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="text" name="username">
							</li>
							
							<li>
								*Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="password" name="password">
							</li>
							<li>
								<input type="submit" value="Login" style="width: 100px">
							</li>
							<li>
								<input type="hidden" name="timeoffset" value="">
							</li>
						</form>
						<script type="text/javascript">
							       document.getElementById("login").timeoffset.value = (new Date()).getTimezoneOffset();
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
