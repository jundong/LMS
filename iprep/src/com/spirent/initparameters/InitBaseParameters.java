package com.spirent.initparameters;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.stream.StreamGobbler;

public class InitBaseParameters {
	private static String dbPath = "";
	private static String username = "";
	private static String password = "";
	private static String reminderTime = "";
	private static String reminderDuration = "";
	private static String tclPath = "";
	private static String tclLibPath = "";
	private static String dbUpdateTime = "";

	public static String getDbPath() {
		return dbPath;
	}

	public static void setDbPath(String dpPath) {
		InitBaseParameters.dbPath = dpPath;
	}

	public static String getUsername() {
		return username;
	}

	public static void setUsername(String username) {
		InitBaseParameters.username = username;
	}

	public static String getPassword() {
		return password;
	}

	public static void setPassword(String password) {
		InitBaseParameters.password = password;
	}

	public static String getTclPath() {
		return tclPath;
	}

	public static void setTclPath(String tclPath) {
		InitBaseParameters.tclPath = tclPath;
	}

	public static String getTclLibPath() {
		return tclLibPath;
	}

	public static void setTclLibPath(String tclLibPath) {
		InitBaseParameters.tclLibPath = tclLibPath;
	}

	public static String getReminderTime() {
		return reminderTime;
	}

	public static void setReminderTime(String reminderTime) {
		InitBaseParameters.reminderTime = reminderTime;
	}

	public static String getReminderDuration() {
		return reminderDuration;
	}

	public static void setReminderDuration(String reminderDuration) {
		InitBaseParameters.reminderDuration = reminderDuration;
	}

	public static String getDbUpdateTime() {
		return dbUpdateTime;
	}

	public static void setDbUpdateTime(String dbUpdateTime) {
		InitBaseParameters.dbUpdateTime = dbUpdateTime;
	}
	
	public static void initParameters(ServletContext config) {
		InitBaseParameters.setDbPath(config.getInitParameter("dbPath"));
		InitBaseParameters.setUsername(config.getInitParameter("username"));
		InitBaseParameters.setPassword(config.getInitParameter("password"));
		InitBaseParameters.setTclPath(config.getInitParameter("tclPath"));
		if(!isSetReminder()){
		   InitBaseParameters.setReminderDuration(config.getInitParameter("reminderDuration"));
		   InitBaseParameters.setReminderTime(config.getInitParameter("reminderTime"));
		}
		InitBaseParameters.setDbUpdateTime(config.getInitParameter("updateDBInternal"));
		StreamGobbler initScriptsLib = new StreamGobbler(config.getInitParameter("tclLibPath"));
		initScriptsLib.initRunScriptsLib(config.getInitParameter("tclPath"));
	}
	
	public static boolean isSetReminder() {
		boolean isSetReminder = false;
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {					
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String sqlStr = "select distinct remindertime, remindertimeduration from iprep_users where levels='0' and remindertime!='0' and remindertimeduration='0'";
				rs = stmt.executeQuery(sqlStr);
				
				if(rs.next()){
					InitBaseParameters.setReminderDuration(rs.getString("remindertime"));
					InitBaseParameters.setReminderTime(rs.getString("remindertimeduration"));
					isSetReminder = true;
				}
			}
		} catch (Exception e) {
			System.out.println("Exception occurs in InitParameters.java->isSetReminder: ");
			e.printStackTrace();
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
				.println("Close DB error occourred in InitParameters.java->isSetReminder: "
						+ e.getMessage());
        	}
        } 
		return isSetReminder;
    }
}