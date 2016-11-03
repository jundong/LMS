package com.spirent.admin;

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

public class Admin extends HttpServlet {
		public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			try {
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					String isAddUser = request.getParameter("isAddUser");
					String isUpdate = request.getParameter("isUpdate");
					String isDelete = request.getParameter("isDelete");
					String isUpdateSite = request.getParameter("isUpdateSite");
		            
				    stmt = conn.createStatement();
	 			    String SQLstmt = "";
					
		            if (isAddUser != null) {
		            	   String firstusername = request.getParameter("firstusername");
		            	   String lastusername = request.getParameter("lastusername");
		            	   String domainusername = request.getParameter("domainusername");
		            	   String addrank = request.getParameter("addrank");
		            	   String fullName = "";
		            	   
		            	   if (!firstusername.isEmpty() && !lastusername.isEmpty() && !domainusername.isEmpty()) {
		            		   fullName = lastusername.trim() + ", " + firstusername.trim();
				 			   SQLstmt = "select * from users where  username='" + domainusername.trim() + "'";
					 	       rs = stmt.executeQuery(SQLstmt);
							  if(rs.next()) {
									SQLstmt = "update users set domainname='" + fullName.trim() + "', " + "levels ='" + addrank + "' where username='" + domainusername.trim() + "'";
								    stmt.execute(SQLstmt);
							   } else {
								   SQLstmt = "insert into users values ('"+ domainusername.trim() + "','" + addrank + "','" + fullName + "','ALL', '', '','1','0', '0', '0', '0', '0','0','0','0','0','0')";
							       stmt.execute(SQLstmt);
							   }
		            	   }
		            	   response.sendRedirect("/inventory/admin.jsp");
				     } else if (isUpdate != null) {
						String updateName = request.getParameter("updatename");
						String updateRank = request.getParameter("updaterank");
						
						if (updateName != null && !updateName.isEmpty()) {
							SQLstmt = "update users set levels ='"
								+ updateRank.trim() + "'  where username='"
								+ updateName.trim() + "'";
						    stmt.execute(SQLstmt);
						}
						response.sendRedirect("/inventory/admin.jsp");
				     } else if (isDelete != null) {
				    	String deleteName = request.getParameter("delname");
	                    if (deleteName != null && !deleteName.isEmpty()) {
							//Delete record in local DB server 
	                    	SQLstmt = "delete from users where username='"
									+ deleteName.trim() + "'";
							stmt.execute(SQLstmt);
						} 
	                    response.sendRedirect("/inventory/admin.jsp");
				    }
				}
			} catch (Exception e) {
			    System.out.print("Exception occurs in Admin.java: "+e.getMessage());
			    response.sendRedirect("/inventory/admin.jsp");
			}finally {
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
					.println("Close DB error occourred in Admin.java: "
							+ e.getMessage());
	        	}
	        } 
	   }
		
		public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			
		}
}
