package com.spirent.utilization;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;
import java.util.TreeMap;

import javax.servlet.ServletContext;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.notification.SendMail;

public class WeeklyResourcesReport extends TimerTask {
	private ServletContext context = null;
	
	public WeeklyResourcesReport(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, Integer> resourcesMap = new TreeMap<String, Integer>();

		UtilizationReport ur = new UtilizationReport();
		resourcesMap = ur.getResourcesList();
		
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				String sqlStr = "";
				
				for (String key: resourcesMap.keySet()){
					sqlStr = "SELECT dtstart, dtend, resources FROM events_ex WHERE resources LIKE '%" + key + "%' ORDER BY dtstart";
					rs = stmt.executeQuery(sqlStr);
					while(rs.next()){
				    	ur.Parser(rs.getString("dtstart"), rs.getString("dtend"), rs.getString("resources"), key, resourcesMap);
					}
				}
				
		    	List<Map.Entry<String, Integer>>  resourcesList = new ArrayList<Map.Entry<String, Integer>>(resourcesMap.entrySet());
		    	 
				Collections.sort(resourcesList, new Comparator<Map.Entry<String, Integer>>() { 
						public int compare(Map.Entry<String, Integer> o1, 
						Map.Entry<String, Integer> o2) { 
						     return (o2.getValue() - o1.getValue()); 
						} 
				}); 
				
			    String fullName = "";
			    String topTwenty = ur.topList(resourcesList, 20, "Resource", "Total Hours");
			    String lastTwenty = ur.lastList(resourcesList, 20, "Resource", "Total Hours");
			    
				sqlStr = "SELECT domainname, mail, recresreport FROM iprep_users WHERE recresreport='1'";
				rs = stmt.executeQuery(sqlStr);
				
				while (rs.next()){
					if (!rs.getString("mail").equals("")){
						fullName = rs.getString("domainname");
						String[] splitName = fullName.split(",");
						fullName = splitName[1].trim() + " " + splitName[0].trim();
					
						String subject = "Spirent Lab Management System Weekly Resources Report";
			     		String contentMsg = "Dear " + fullName + ", <br><br>";
	
						contentMsg = contentMsg + "<b>The top 20 resources:</b> <br>" + topTwenty + "<br>";
						contentMsg = contentMsg + "<b>The last 20 resources:</b> <br>"  + lastTwenty;
						contentMsg = contentMsg + "<br>";
						contentMsg = contentMsg + "If you want to use Spirent Lab Management System, please click <a href='http://englabmanager/iprep/index.jsp'>[here]</a>.";
						
	    				SendMail sm = new SendMail();
	    				sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", rs.getString("mail"), "lms@spirentcom.com", subject);
					}
				}
			}
		} catch (Exception e) {
			System.out.println("Error occourred in WeeklyResourcesReport.java: "
							+ e.getMessage());
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
				.println("Close DB error occourred in WeeklyResourcesReport.java: "
						+ e.getMessage());
        	}
        } 
    }
}

