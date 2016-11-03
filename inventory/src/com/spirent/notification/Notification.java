package com.spirent.notification;

/*
 * Copyright (c) 2010 - Spirent, All rights reserved
 */

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.scheduler.DataAction;

// TODO: Auto-generated Javadoc
/**
 * The Class TreeBasicConnector.
 */
public class Notification {
	
	public void sendNotification(DataAction action){
		
		if(action.get_value("organizer").equals("commonqa")){
			return;
		}
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String fullName = "";
		String email = "";
		
		try {					
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
			
				String searchUser = "select domainname, mail from users where  username='"
						+ action.get_value("organizer") + "' and receive='1'";
				rs = stmt.executeQuery(searchUser);
				
				if (rs.next()) {
					fullName = rs.getString("domainname");
					String[] splitName = fullName.split(",");
					fullName = splitName[1].trim() + " " + splitName[0].trim();
					email = rs.getString("mail");
					rs.close();
				
					String subject = "LMS auto notification";
			 		String contentMsg = "Dear " + fullName + ", <br><br>";
	
			 			if (action.get_status().equals("inserted")) {
				     		contentMsg = contentMsg + "Thank you for using Spirent Lab Management System.<br>";
				     		contentMsg = contentMsg + "You have reserved the following resources:<br>"; 
							contentMsg = contentMsg + "<p> &nbsp;&nbsp;&nbsp;&nbsp;User: " + action.get_value("organizer") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Purpose: " + action.get_value("description") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Resources: " + formatResources(action.get_value("resources"));
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Start Date: " + getCanlender(action.get_value("dtstart"),-(Integer.parseInt(action.get_value("timeoffset")))) + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;End &nbsp;&nbsp;Date: " + getCanlender(action.get_value("dtend"),-(Integer.parseInt(action.get_value("timeoffset")))) + "</p>";
							contentMsg = contentMsg + "<br>";
							contentMsg = contentMsg + "To cancel, extend, or to make another reservation, please click <a href='http://englabmanager/inventory/index.jsp'>[here]</a>.";
							subject = "Spirent Lab Management System Notification";
			 			} else if (action.get_status().equals("deleted")){
				     		contentMsg = contentMsg + "Your reservation has been deleted.<br>";
				     		contentMsg = contentMsg + "The details of the reservation are as follows: <br>"; 
							contentMsg = contentMsg + "<p> &nbsp;&nbsp;&nbsp;&nbsp;User: " + action.get_value("organizer") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Purpose: " + action.get_value("description") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Resources: " + formatResources(action.get_value("resources"));
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Start Date: " + getCanlender(action.get_value("dtstart"),-(Integer.parseInt(action.get_value("timeoffset")))) + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;End &nbsp;&nbsp;Date: " + getCanlender(action.get_value("dtend"),-(Integer.parseInt(action.get_value("timeoffset")))) + "</p>";
							contentMsg = contentMsg + "<br>";
							contentMsg = contentMsg + "To cancel, extend, or to make another reservation, please click <a href='http://englabmanager/inventory/index.jsp'>[here]</a>.";	
							subject = "Spirent Lab Management System Change Notification";
			 			} else {
				     		contentMsg = contentMsg + "Your reservation has been changed.<br>";
				     		contentMsg = contentMsg + "The details of the reservation are as follows: <br>"; 
							contentMsg = contentMsg + "<p> &nbsp;&nbsp;&nbsp;&nbsp;User: " + action.get_value("organizer") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Purpose: " + action.get_value("description") + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Resources: " + formatResources(action.get_value("resources"));
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Start Date: " + getCanlender(action.get_value("dtstart"),-(Integer.parseInt(action.get_value("timeoffset")))) + "<br>";
							contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;End &nbsp;&nbsp;Date: " + getCanlender(action.get_value("dtend"),-(Integer.parseInt(action.get_value("timeoffset")))) + "</p>";
							contentMsg = contentMsg + "<br>";
							contentMsg = contentMsg + "To cancel, extend, or to make another reservation, please click <a href='http://englabmanager/inventory/index.jsp'>[here]</a>.";
							subject = "Spirent Lab Management System Change Notification";						
			 		}
	
		    		SendMail sm = new SendMail();
		    		sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", email, "lms@spirentcom.com", subject);
				}
			}
		} catch (Exception e) {
			System.out.print("Exception occurs in Notification.java: "+e.getMessage());
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
				.println("Close DB error occourred in Notification.java: "
						+ e.getMessage());
        	}
        }
}
	
	public String formatDate(String str) {
		String[] splitDate = str.split(" ");
		String formatString = "";
		if (splitDate[4].equals("UTC")) {
		   formatString = splitDate[0]+", " + splitDate[1] + " " + splitDate[2] + ", " + splitDate[6] + " " + splitDate[3];
		} else {
			formatString = splitDate[0]+", " + splitDate[1] + " " + splitDate[2] + ", " + splitDate[5] + " " + splitDate[3];	
		}
		
		return formatString;
	}
	
	public String formatResources(String str) {
		String[] splitResources = str.split(",");
		String resources = splitResources[0] + "<br>";
		
		for (int i=1; i<splitResources.length; i++) {
			resources = resources + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + splitResources[i] + "<br>";
		}
		
		return resources;
	}
	
	 public String getCanlender(String dateString, int timeOffset){
		  Calendar cal = Calendar.getInstance();
		  String[] splitDateString = dateString.split(" ");
		  String[] splitDate = splitDateString[0].split("-");
		  int year = Integer.parseInt(splitDate[0]);
		  int month = Integer.parseInt(splitDate[1]);
		  int day = Integer.parseInt(splitDate[2]);
		  
		  String[] splitTime = splitDateString[1].split(":");
		  int hour = Integer.parseInt(splitTime[0]);
		  int minute = Integer.parseInt(splitTime[1]);
		  int second = Integer.parseInt("00");
		  
		  cal.set(Calendar.YEAR, year);
		  cal.set(Calendar.MONTH, month-1);
		  cal.set(Calendar.DAY_OF_MONTH, day);
		  
		  cal.set(Calendar.HOUR_OF_DAY, hour);
		  cal.set(Calendar.MINUTE, minute);
		  cal.set(Calendar.SECOND, second);
		  
		  SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		  Date date = cal.getTime();
		 
		  cal.add(Calendar.MINUTE, timeOffset);
		  date = cal.getTime();
		  
		  return df.format(date);
		 }
}