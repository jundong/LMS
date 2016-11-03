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

public class Login extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String fullName = "";
		String levels = "";
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
				String password = request.getParameter("password").trim();
				String site = "ALL";
				//String company = request.getParameter("Company").trim();
				
				String sql = "select * from iprep_users where username='" + userName + 
							 "' and pwd='" + password + "'";
				rs = stmt.executeQuery(sql);
				if(rs.next()) {
					levels = rs.getString("levels");
					logintimes = rs.getInt("logintimes") + 1;
					monloginreport = rs.getInt("monloginreport") + 1;
					totallogin = rs.getInt("totallogin") + 1;
					
					String updateSite = "update iprep_users set site ='"
							+ site + "', session = '" + loginSession
							+ "', logintimes = '" + logintimes
							+ "', monloginreport = '" + monloginreport
							+ "', totallogin = '" + totallogin
							+ "', timeoffset = '" + timeoffset
							+ "' where username='" + userName + "'";
					stmt.execute(updateSite);

					//Add user into cookie
					Cookie lrsCookies = new Cookie(userName,
							loginSession);
					lrsCookies.setMaxAge(7 * 24 * 60 * 60);
					response.addCookie(lrsCookies);
					
					request.getSession().setAttribute("username", userName);
					request.getSession().setAttribute("levels", levels);
					request.getSession().setAttribute("loginsite", site);
					request.getSession().setAttribute("timeoffset", timeoffset);
					request.getSession().setMaxInactiveInterval(60 * 60);

					response.sendRedirect("/iprep/index.jsp");
				} else {
					response.sendRedirect("/iprep/login.jsp?isFailed=true");
				}
		   }
		} catch (Exception e) {
			System.out.println("Error occourred in Login.java: "
					+ e.getMessage());
			response.sendRedirect("/iprep/login.jsp");
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
				.println("Close DB error occourred in Login.java: "
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
	        String sqlStr = "SELECT logintimes FROM iprep_users WHERE username='" + username + "'";
	        ResultSet rs = stmt.executeQuery(sqlStr);
	        
	        if (rs.next()){
	        	logintimes = rs.getInt("logintimes");
	        }
        
		} catch (Exception e){
			System.out.println("Error occourred in Login.java: "
					+ e.getMessage());
		}
		return logintimes;
	}
}
