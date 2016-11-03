package com.spirent.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.ldap.GenerateDN;
import com.spirent.ldap.LDAPSearchExample;

public class Register extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String fullName = "";
		try {	
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				String loginSession = request.getSession().toString(); 
				String timeoffset = request.getParameter("timeoffset");
				int logintimes = 0;
				int monloginreport = 0;
				int totallogin = 0;
				stmt = conn.createStatement();
			
				String userName = request.getParameter("username").trim();
				String firstname = request.getParameter("firstusername").trim();
				String lastname = request.getParameter("lastusername").trim();
				String rpassword = request.getParameter("rpassword").trim();
				String rsite = request.getParameter("rsite");
				if (!firstname.isEmpty() && !lastname.isEmpty() && !userName.isEmpty()) {
					fullName = lastname.trim() + ", " + firstname.trim();
					
					//Add record in local DB server
					String searchUser = "select * from users where  username='"
						+ userName.trim() + "'";
					rs = stmt.executeQuery(searchUser);
					if (!rs.next()) {
						String addUser = "insert into users values ('"
							+ userName.trim() + "','2','" + fullName.trim() + "','"
							+ rsite + "', '', '', '1', '0', '0', '0', '0', '" + timeoffset + "','0','0','0','0','0')";
					    stmt.execute(addUser);
					} else {
						logintimes = rs.getInt("logintimes") + 1;
						monloginreport = rs.getInt("monloginreport") + 1;
						totallogin = rs.getInt("totallogin") + 1;
						
						String updateUser = "update users set domainname='" + fullName + "', site ='" + rsite + "' where username='" + userName.trim() + "'";
						stmt.execute(updateUser);
					}

					if (!rpassword.isEmpty()) {
						//LDAP Search user, if get the user, login lab reservarion system
						LDAPSearchExample ldapConn = null;
						boolean isAutheUser = false;
						String replace = "\\,";
						GenerateDN generateDN = new GenerateDN(fullName.replace(",", replace));
						String[] dnList = generateDN.GenerateBindDN();
						//String fullUserNamePath = "cn="+userName+", "+"ou=people, dc=spirent, dc=com";
						for (int i = 0; i < dnList.length; i++) {
							ldapConn = new LDAPSearchExample(dnList[i],rpassword);
							isAutheUser = ldapConn.performSearch();

							if (isAutheUser)
								break;
						}

						if (isAutheUser) {
							//Update local DB
							String updateSite = "update users set site ='"
								+ rsite + "', session = '" + loginSession
								+ "', mail = '" + ldapConn.getEmail()
								+ "', logintimes = '" + logintimes
								+ "', monloginreport = '" + monloginreport
								+ "', totallogin = '" + totallogin
								+ "', timeoffset = '" + timeoffset
								+"'  where username='" + userName + "'";
						    stmt.execute(updateSite);

							//Add user into cookie
							Cookie lrsCookies = new Cookie(userName,
									loginSession);
							lrsCookies.setMaxAge(7 * 24 * 60 * 60);
							response.addCookie(lrsCookies);

							request.getSession().setAttribute("username", userName);
							request.getSession().setAttribute("levels", "2");
							request.getSession().setAttribute("loginsite", rsite);
							request.getSession().setAttribute("timeoffset", timeoffset);
							request.getSession().setMaxInactiveInterval(60 * 60);

							response.sendRedirect("/inventory/index.jsp");
						} else {
							response.sendRedirect("/inventory/login.jsp?isFailed=true");
						}
					} else {
						response.sendRedirect("/inventory/login.jsp?isRegister=true");
					}
			    } else {
			    	response.sendRedirect("/inventory/register.jsp");
			    }
			}
		} catch (Exception e) {
			System.out.println("Error occourred in Register.java: "
					+ e.getMessage());
			response.sendRedirect("/inventory/register.jsp");
		}  finally {
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
				.println("Close DB error occourred in Register.java: "
						+ e.getMessage());
        	}
        }
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

	}
	
	public int getLoginCount(String username, Statement stmt){
		int logintimes = 0;
		try {
	        String sqlStr = "SELECT logintimes FROM users WHERE username='" + username + "'";
	        ResultSet rs = stmt.executeQuery(sqlStr);
	        
	        if (rs.next()){
	        	logintimes = rs.getInt("logintimes");
	        }
        
		} catch (Exception e){
			System.out.println("Error occourred in Register.java: "
					+ e.getMessage());
		}
		return logintimes;
	}
}
