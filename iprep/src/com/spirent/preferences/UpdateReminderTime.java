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

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.javaconnector.DataBaseConnection;

public class UpdateReminderTime extends HttpServlet {
		public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			Connection conn = null;
			Statement stmt = null;
			try {
				String reminder = request.getParameter("reminder");
				if (reminder.equals("min5")) {
					reminder = "5";
				}else if (reminder.equals("min15")) {
					reminder = "15";
				}else if (reminder.equals("min30")) {
					reminder = "30";
				}else if (reminder.equals("hour1")) {
					reminder = "60";
				}else if (reminder.equals("hour2")) {
					reminder = "120";
				}else if (reminder.equals("hour3")) {
					reminder = "180";
				}else if (reminder.equals("hour4")) {
					reminder = "1440";
				}
				String reminderduration = request.getParameter("reminderduration");
				if (reminderduration.equals("min30")) {
					reminderduration = "30";
				}else if (reminderduration.equals("hour1")) {
					reminderduration = "60";
				}else if (reminderduration.equals("hour2")) {
					reminderduration = "120";
				}else if (reminderduration.equals("hour3")) {
					reminderduration = "180";
				}else if (reminderduration.equals("hour4")) {
					reminderduration = "240";
				}else if (reminderduration.equals("hour5")) {
					reminderduration = "300";
				}else if (reminderduration.equals("hour6")) {
					reminderduration = "360";
				}
	            
				InitBaseParameters.setReminderDuration(reminderduration);
				InitBaseParameters.setReminderTime(reminder);
				
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
				     stmt = conn.createStatement();
	 			     String SQLstmt = "";
					SQLstmt = "update iprep_users set remindertime='" + reminder + "', remindertimeduration='" + reminderduration + "' where levels='0'";
					    stmt.execute(SQLstmt);
					    
					response.sendRedirect("/iprep/preference.jsp");
						
	   			    DataBaseConnection.freeConnection(conn);
				}
			} catch (Exception e) {
				System.out.print("Exception occurs in UpdateReminderTime.java: "+e.getMessage());
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
					.println("Close DB error occourred in UpdateReminderTime.java: "
							+ e.getMessage());
	        	}
	        }
	   }
		
		public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			
		}
}
