package com.spirent.update;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class UpdateiPREPNotes extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		String sqlStr = "";
		String Notes = request.getParameter("Notes");
		if(Notes == null) 
			Notes = "";
		else
			Notes = Notes.trim();
		String TestBedIndex = request.getParameter("TestBedIndex");
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();	
				sqlStr = "UPDATE iprep_testbed SET Notes='" + Notes + "' WHERE " +
						"TestBedIndex=" + TestBedIndex;
				stmt.execute(sqlStr);			
				response.sendRedirect("/iprep/tree/iprepsummary.jsp");
			}
		} catch (Exception e) {
			System.out.println("Error occourred in UpdateiPREPNotes.java: "
							+ e.getMessage());
		}finally {
        	try {
        		if(stmt != null){
        			stmt.close();
        		}
        		if(conn != null){
        			DataBaseConnection.freeConnection(conn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in UpdateiPREPNotes.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		doPost(request,response);
	}
}
