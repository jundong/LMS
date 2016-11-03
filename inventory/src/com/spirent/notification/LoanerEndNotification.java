package com.spirent.notification;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;
import java.util.TreeMap;

import javax.servlet.ServletContext;

import com.spirent.javaconnector.DataBaseConnection;

public class LoanerEndNotification extends TimerTask{

 /**
  * @param args
  */
	private ServletContext context = null;
	
	public LoanerEndNotification(ServletContext context){
	   this.context = context;
	}
	
    public void run() {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sqlStr = "";
	    int serverTimeOffset = (new Date()).getTimezoneOffset();
	    String fullName = "";
	    boolean isSendNotification = false;
	    try {     
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
			   stmt = conn.createStatement();
			
			   SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");
			   Calendar cal = Calendar.getInstance();
			   Date date = cal.getTime();
			   String currentGMTDate = df.format(date);
			   
			   String mailResources = "<table><tr><td>Resource</td><td>Loaner End Date</td></tr>";
			   
			   sqlStr = "select Hostname, SOEnd from stc_inventory_chassis where LoanerNotificationDate='"+currentGMTDate+"'";
			   rs = stmt.executeQuery(sqlStr);
			   while (rs.next()) {
				   isSendNotification = true;
				   mailResources = mailResources + "<tr><td>" + rs.getString("Hostname") + "</td><td>"+ rs.getString("SOEnd") + "</td><tr>";
			   }
			   rs.close();
			   
			   sqlStr = "select Hostname, SlotIndex, SOEnd from stc_inventory_testmodule where LoanerNotificationDate='"+currentGMTDate+"'";
			   rs = stmt.executeQuery(sqlStr);
			   while (rs.next()) {
				   isSendNotification = true;
				   String slotResource = rs.getString("Hostname") + "//" + rs.getString("SlotIndex");
				   mailResources = mailResources + "<tr><td>" + slotResource + "</td><td>"+ rs.getString("SOEnd") + "</td><tr>";
			   }
			   rs.close();
			   mailResources = mailResources + "</table>";
			   
			   sqlStr = "select domainname, mail from users where loanerreceive='1'";
			   rs = stmt.executeQuery(sqlStr);
			   while (rs.next() && isSendNotification){
					fullName = rs.getString("domainname");
					String[] splitName = fullName.split(",");					
					fullName = splitName[1].trim() + " " + splitName[0].trim();
					
					String subject = "Spirent Lab Management System Loaner Expire Reminder";
					 String contentMsg = "Dear " + fullName + ", <br><br>";
						contentMsg = contentMsg + "Thank you for using the Lab Management System.<br>";
				 		contentMsg = contentMsg + "Following loaner resource(s) will expire:<br>"; 
						contentMsg = contentMsg + " &nbsp;&nbsp;&nbsp;&nbsp;" + mailResources;
	
						contentMsg = contentMsg + "<br>";
						contentMsg = contentMsg + "Please access <a href='http://englabmanager/inventory/index.jsp'>[here]</a> for more information.";	
					
		    		SendMail sm = new SendMail();
		    		sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", rs.getString("mail"), "lms@spirentcom.com", subject);
			  }
		}
	 } catch (Exception e) {
		    System.out.println("Exception occurrence in LoanerEndNotification.java->run: "+e.getMessage());
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
			.println("Close DB error occourred in LoanerEndNotification.java->run: "
					+ e.getMessage());
    	}
    }
   }
	 
	 public void formatResources(List<Map.Entry<String, String>>  resourcesList){
			 String mailResources = "<table><tr><td>Resource</td><td>Loaner End Date</td></tr>";
			 
				for (int i = 0; i < resourcesList.size(); i++) { 
					mailResources = resourcesList.get(i).toString();
		    		String[] splitMap = mailResources.split("=");
		    		mailResources = mailResources + "<tr><td>" + splitMap[0] + "</td><td>"+ splitMap[1] + "</td><tr>";
			    } 
				mailResources = mailResources + "</table>";
	}
}
