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

public class WeeklyLoginReport extends TimerTask {
	private ServletContext context = null;
	
	public WeeklyLoginReport(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, Integer> mapLogin = new TreeMap<String, Integer>();

		try {
			String fullName = "";
			
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String sqlStr = "SELECT domainname, logintimes FROM users";
				rs = stmt.executeQuery(sqlStr);
				
				while (rs.next()){
					fullName = rs.getString("domainname");
					mapLogin.put(fullName, rs.getInt("logintimes"));
		     	}
				
				List<Map.Entry<String, Integer>> listLogin = new ArrayList<Map.Entry<String, Integer>>( 
						mapLogin.entrySet()); 
				
				Collections.sort(listLogin, new Comparator<Map.Entry<String, Integer>>() { 
					public int compare(Map.Entry<String, Integer> o1, 
					Map.Entry<String, Integer> o2) { 
					     return (o2.getValue() - o1.getValue()); 
					} 
				}); 
				
				    UtilizationReport ur = new UtilizationReport();
				    String topTen = ur.topList(listLogin, 10, "User Name", "Login Times");
				    String lastTen = ur.lastList(listLogin, 10, "User Name", "Login Times");
				    
					sqlStr = "SELECT domainname, mail, recloginreport FROM users WHERE recloginreport='1'";
					rs = stmt.executeQuery(sqlStr);
					while (rs.next()){
						if (!rs.getString("mail").equals("")){
							fullName = rs.getString("domainname");
							String[] splitName = fullName.split(",");
							fullName = splitName[1].trim() + " " + splitName[0].trim();
						
							String subject = "Spirent Lab Management System Weekly Login Report";
				     		String contentMsg = "Dear " + fullName + ", <br><br>";
		
							contentMsg = contentMsg + "<b>The top 10 login Users:</b> <br>" + topTen + "<br>";
							contentMsg = contentMsg + "<b>The last 10 login Users:</b> <br>"  + lastTen;
							contentMsg = contentMsg + "<br>";
							contentMsg = contentMsg + "If you want to use Spirent Lab Management System, please click <a href='http://englabmanager/inventory/index.jsp'>[here]</a>.";
							
		    				SendMail sm = new SendMail();
		    				sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", rs.getString("mail"), "lms@spirentcom.com", subject);
						}
				}
				
				resetWeekly();	
			}
		} catch (Exception e) {
			System.out.println("Error occourred in WeeklyLoginReport.java: "
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
				.println("Close DB error occourred in WeeklyLoginReport.java: "
						+ e.getMessage());
        	}
        }  
    }
    
    public void resetWeekly() {	   
		ArrayList<String> loginNamesList = new ArrayList<String>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String sqlStr = "SELECT username FROM users";
				rs = stmt.executeQuery(sqlStr);	
				
				while (rs.next()){
					loginNamesList.add(rs.getString("username"));
				}
				
				for (int i=0; i<loginNamesList.size(); i++) {
					String sqlUpdStr = "UPDATE users SET logintimes='0' WHERE username='" + loginNamesList.get(i) + "'";
					stmt.execute(sqlUpdStr);	
				}
			}
		} catch (Exception e) {
			System.out.println("Error occourred in WeeklyLoginReport.java->resetWeekly: "
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
				.println("Close DB error occourred in WeeklyLoginReport.java->resetWeekly: "
						+ e.getMessage());
        	}
        } 
    }
}

