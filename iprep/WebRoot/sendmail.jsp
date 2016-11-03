<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.notification.*"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
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
		<title>Send Mail</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />

	</head>
	<body>
		<div class="content">
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Send Mail</b>
			<hr>
			<%
				String mailTo = request.getParameter("mail");
				String name = request.getParameter("name");
				String subject = request.getParameter("subject");
				String commentMsg = request.getParameter("comment");
				String username = "";
				String mailFrom = "";
				
				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
				try {
					conn = DataBaseConnection.getConnection();
			        if (conn != null) {
						stmt = conn.createStatement();
						String SQLstmt = "SELECT domainname, mail FROM iprep_users WHERE username='" + request.getSession().getAttribute("username") + "'";
	
						rs = stmt.executeQuery(SQLstmt);
						if(rs.next()) {
							username = rs.getString("domainname");
							String[] splitName = username.split(",");
							username = splitName[1].trim();
							
							mailFrom = rs.getString("mail");						
						}
						
						String comment = "Dear " + name + ", <br><br>";
	
						comment = comment + "<p>&nbsp;&nbsp;&nbsp;&nbsp;" + commentMsg + "</p>";
						comment = comment + "Best wishes, <br>";
						comment = comment + username + "<br>";
						comment = comment + "<br>";
						comment = comment + "If you want to use Spirent Lab Management System, use the link <a href='http://englabmanager/iprep/index.jsp'>[here]</a>.";
						
						if (subject != null && !subject.equals("") && !username.equals("") && !mailTo.equals("")){
	                       SendMail sm = new SendMail();
					       sm.sendMail(sm, comment, "smtp.spirentcom.com", mailTo, mailFrom, subject);
					       response.sendRedirect("/iprep/contact.jsp");
					    }
			        }
				} catch (Exception e) {
					System.out.println("Error occourred in sendmail.jsp: "
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
							.println("Close DB error occourred in sendmail.jsp: "
									+ e.getMessage());
			        	}
			        }
			%>
			<div style="margin: 0px 0px 0px 15%;">
				<form name=sendmailform method="post" action="/iprep/sendmail.jsp">
					<table >
						<tr bgcolor="#C2D5FC">
							<td>
								Your Name*:
							</td>
							<td>
								<input type="text" name="name" border="0" value="<%=username %>"
									style="width: 200px;" />
							</td>
						</tr>
						<tr bgcolor="#d7dce6">
							<td>
								Email To*: 
							</td>
							<td>
								<input readonly type="text" name="mail" border="0"
									value="<%=mailTo %>" style="width: 250px;" />
							</td>
						</tr>
						<tr bgcolor="#C2D5FC">
							<td>
								Subject*:
							</td>
							<td>
								<input type="text" name="subject" border="0" value=""
									style="width: 400px;" />
							</td>
						</tr>
						<tr bgcolor="#d7dce6">
							<td>
								Comment:
							</td>
							<td>
								<textarea name="comment" wrap="hard"
									style="width: 400px; height: 200px;" > </textarea>
							</td>
						</tr>
						<tr bgcolor="#C2D5FC">
							<td>
							</td>
							<td>
								<input type="submit" name="send" border="0" value="Send"
									style="width: 60px;" />
								<font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;								
								*Required Fields</font>
							</td>
						</tr>					
					</table>
			</div>
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
