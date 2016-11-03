package com.spirent.preferences;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;

public class Preferences extends HttpServlet {
		public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			Connection conn = null;
			Statement stmt = null;
			try {
				String isSetting = request.getParameter("isSetting");
				///String isUpdateSite = request.getParameter("isUpdateSite");
	            
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
				    stmt = conn.createStatement();
	 			    String SQLstmt = "";
					
	                if (isSetting != null) {
						int receivemail = 1;
						int recresreport = 0;
						int recloginreport = 0;
						int monitorreport = 0;
						int loanerreceive = 0;
						
						if (request.getParameter("receivemail") != null) {
							receivemail = 0;
						}
						if (request.getParameter("recresreport") != null) {
							recresreport = 1;
						}
						if (request.getParameter("recloginreport") != null) {
							recloginreport = 1;
						}
						if (request.getParameter("monitorreport") != null) {
							monitorreport = 1;
						}
						if (request.getParameter("loanerreceive") != null) {
							loanerreceive = 1;
						}
						SQLstmt = "update iprep_users set receive='" + receivemail + "', recresreport='" + recresreport + "', monitorreceive='" + monitorreport + "', recloginreport='" + recloginreport+ "', loanerreceive='" + loanerreceive + "' where username='"
								+ request.getSession().getAttribute("username") + "'";
						    stmt.execute(SQLstmt);
						    
						response.sendRedirect("/iprep/preference.jsp");
				    }  
				}
			} catch (Exception e) {
				System.out.print("Exception occurs in Preferences.java: "+e.getMessage());
				response.sendRedirect("/iprep/preference.jsp");
			} finally {
		      	try {
		    		if(stmt != null){
		    			stmt.close();
		    		}
		    		if(conn != null){
		    			DataBaseConnection.freeConnection(conn); 
		    		}
		    	} catch (Exception e) {      
					System.out
					.println("Close DB error occourred in Preferences.java: "
							+ e.getMessage());
		    	}
		    }
	   }
		
		public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			
		}
}
