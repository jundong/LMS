package com.spirent.notification;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimerTask;

import javax.servlet.ServletContext;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.javaconnector.DataBaseConnection;

public class Reminder extends TimerTask{

 /**
  * @param args
  */
	private ServletContext context = null;
	
	public Reminder(ServletContext context){
	   this.context = context;
	}
	
    public void run() {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
	    int serverTimeOffset = (new Date()).getTimezoneOffset();
	    String beforeStartDate = "";
	    String afterStartDate = "";
	  
	    String beforeEndDate = "";
	    String afterEndDate = "";
	    String fullName = "";
	  
	    try {     
		   conn = DataBaseConnection.getConnection();
		   if (conn != null) {
			   stmt = conn.createStatement();
			
			   SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			   Calendar cal = Calendar.getInstance();
			   Date date = cal.getTime();
	
			   // Send reservation start reminder notification with internal 15min
			   int reminderTimeDuration=Integer.parseInt((InitBaseParameters.getReminderDuration()));
			   beforeStartDate = getCanlender(df.format(date), serverTimeOffset);	   
			   afterStartDate = getCanlender(df.format(date), serverTimeOffset + reminderTimeDuration);
			   //beforeStartDate = "2010-07-05 07:47:00";
			   //afterStartDate = "2010-07-05 08:00:00";
			   String searchReservations = "select e.uid, e.dtstart, e.description, e.dtend, e.resources, e.organizer, e.timeoffset, u.mail, u.domainname from events_rec e inner join iprep_users u on (strcmp(e.dtstart, '" +beforeStartDate + "')='1' or strcmp(e.dtstart, '" + beforeStartDate + "')='0') and (strcmp(e.dtstart, '" + afterStartDate + "')='-1' or strcmp(e.dtstart, '" + afterStartDate + "')='0') and e.organizer=u.username";
			   
			   rs = stmt.executeQuery(searchReservations);
			   while (rs.next()) {
					String dtstart = rs.getString("dtstart");
					String dtend = rs.getString("dtend");
					String description = rs.getString("description");
					String username = rs.getString("organizer");
					int timeoffset = rs.getInt("timeoffset");
					String mail = rs.getString("mail");
					
					String resources = rs.getString("resources");
					resources = formatRources(resources);
					
					fullName = rs.getString("domainname");
					String[] splitName = fullName.split(",");					
					fullName = splitName[1].trim() + " " + splitName[0].trim();
	
					startReminder(dtstart, dtend, description, mail, username, fullName, resources, timeoffset, beforeStartDate);	
			   }
			   
			   // Send reservation and reminder notification with internal 30min
			   beforeEndDate = getCanlender(df.format(date), serverTimeOffset);
			   afterEndDate = getCanlender(df.format(date), serverTimeOffset + reminderTimeDuration);
			   searchReservations = "select e.uid, e.dtstart, e.dtend,  e.description, e.resources, e.organizer, e.timeoffset, u.mail, u.domainname from events_rec e inner join iprep_users u on (strcmp(e.dtend, '" + beforeEndDate + "')='1' or strcmp(e.dtend, '" + beforeEndDate + "')='0') and (strcmp(e.dtend, '" + afterEndDate + "')='-1' or strcmp(e.dtend, '" + afterEndDate + "')='0') and e.organizer=u.username";
			   
			   rs = stmt.executeQuery(searchReservations);
			   while (rs.next()) {
					String dtstart = rs.getString("dtstart");
					String dtend = rs.getString("dtend");
					String description = rs.getString("description");
					String username = rs.getString("organizer");
					int timeoffset = rs.getInt("timeoffset");
					String mail = rs.getString("mail");
					
					String resources = rs.getString("resources");
					resources = formatRources(resources);
					
					fullName = rs.getString("domainname");
					String[] splitName = fullName.split(",");					
					fullName = splitName[1].trim() + " " + splitName[0].trim();
	
				    expiringReminder(dtstart, dtend, description, mail, username, fullName, resources, timeoffset, beforeEndDate);
			   }
		 } 
	  } catch (Exception e) {
		    System.out.println("Exception occurrence in Reminder.java->run: "+e.getMessage());
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
			.println("Close DB error occourred in Reminder.java->run: "
					+ e.getMessage());
    	}
    }
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
	 
	 public int getTime(String dateString){
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

		  Date date = cal.getTime();
		  date = cal.getTime();
		  
		  int time=(int)date.getTime();
		  
		  return time;
		 }
	 
	 public void startReminder(String dtstart, String dtend, String description, String mail, String username, String fullname, String resources, int timeOffset, String serverDate){
		 try {	
			 String start = getCanlender(dtstart, -timeOffset);
			 String end = getCanlender(dtend, -timeOffset);
			 String mailResources = formatRources(resources);
			 int startTime = (getTime(dtstart)- getTime(serverDate))/60000;
			 
			 String subject = "iPREP Lab Management System Start Reminder";
			 String contentMsg = "Dear " + fullname + ", <br><br>";
				contentMsg = contentMsg + "Thank you for using the iPREP Lab Management System.<br>";
				if(startTime <= 0){
		 		    contentMsg = contentMsg + "Your following reservation is starting:<br>"; 
				} else {
					contentMsg = contentMsg + "Your following reservation will be started in "+ startTime +" minutes:<br>"; 
				}
				contentMsg = contentMsg + "<p> &nbsp;&nbsp;&nbsp;&nbsp;User: " + username + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Purpose: " + description + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Resources: " + mailResources;
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Start Date: " + start + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;End &nbsp;&nbsp;Date: " + end + "</p>";
				contentMsg = contentMsg + "<br>";
				contentMsg = contentMsg + "To cancel, extend, or to make another reservation, please click <a href='http://englabmanager/iprep/index.jsp'>[here]</a>.";
				
			SendMail sm = new SendMail();
			sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", mail, "lms@spirentcom.com", subject,null);
			
		} catch (Exception e) {
			 System.out.println("Exception occurrence in Reminder.java->startReminder.");
				e.printStackTrace();
	    } 
	 }
	 
	 public void expiringReminder(String dtstart, String dtend, String description, String mail, String username, String fullname, String resources, int timeOffset, String serverDate){
		 try {	
			 String start = getCanlender(dtstart, -timeOffset);
			 String end = getCanlender(dtend, -timeOffset);
			 String mailResources = formatRources(resources);
			 int endTime = (getTime(dtend)- getTime(serverDate))/60000;
			 
			 String subject = "iPREP Lab Management System Expire Reminder";
			 String contentMsg = "Dear " + fullname + ", <br><br>";
				contentMsg = contentMsg + "Thank you for using the iPREP Lab Management System.<br>";
				if(endTime <= 0){
		 		    contentMsg = contentMsg + "Your following reservation has expired:<br>"; 
				} else {
		 		    contentMsg = contentMsg + "Your following reservation will expire in "+ endTime +" minutes:<br>"; 
				}
				contentMsg = contentMsg + "<p> &nbsp;&nbsp;&nbsp;&nbsp;User: " + username + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Purpose: " + description + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Resources: " + mailResources;
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;Start Date: " + start + "<br>";
				contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;End &nbsp;&nbsp;Date: " + end + "</p>";
				contentMsg = contentMsg + "<br>";
				contentMsg = contentMsg + "To cancel, extend, or to make another reservation, please click <a href='http://englabmanager/iprep/index.jsp'>[here]</a>.";
				
			SendMail sm = new SendMail();
			sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", mail, "lms@spirentcom.com", subject,null);
			
		} catch (Exception e) {
			 System.out.println("Exception occurrence in Reminder.java->expiringReminder.");
				e.printStackTrace();
	    } 
	}
	 
	 public String formatRources(String resources){
		 String[] splitResources = resources.split(",");
		 String mailResources = splitResources[0] + "<br>";
		 if (splitResources.length >= 101){
			 for (int index=1; index<100; index++){
				 mailResources = mailResources + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + splitResources[index] + "<br>";
			 }
			 int skipitems = splitResources.length - 101;
			 mailResources = mailResources + "......   skip " + skipitems + "items" + "<br>";
			 mailResources = mailResources + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + splitResources[splitResources.length-1] + "<br>";
		 } else {
			 for (int index=1; index<splitResources.length; index++){
				 mailResources = mailResources + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + splitResources[index] + "<br>";
			 }
		 }
		 return mailResources;
	 }
}
