package com.spirent.deleteresource;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class DeleteResource extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
			try {
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					String TestBedIndex = request.getParameter("TestBedIndex");
					String TestBedName = request.getParameter("TestBedName");
					String sql = "";
					if (!TestBedIndex.isEmpty()){
						sql = "DELETE FROM iprep_testbed WHERE TestBedIndex="+TestBedIndex;
	                } else if (!TestBedName.isEmpty()){  
	                	sql = "DELETE FROM iprep_testbed WHERE TestBedName='"+TestBedName+"'";
	                } else {
	                	//To do: If parameter was 
	                	response.sendRedirect("/iprep/delete.jsp");
	                }
					stmt.execute(sql);
	                response.sendRedirect("/iprep/delete.jsp");
				}
			} catch (Exception e) {
				System.out
						.println("Error occourred in DeleteResource.java: "
								+ e.getMessage());
				response.sendRedirect("/iprep/delete.jsp");
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
					.println("Close DB error occourred in DeleteResource.java: "
							+ e.getMessage());
	        	}
	        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		doPost(request,response);
	}
}
