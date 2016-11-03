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

public class MonitoringChassis extends TimerTask {
	private ServletContext context = null;
	
	public MonitoringChassis(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			String fullName = "";
			String subject = "LMS monitoring notification";
     		String startMsg = "Spirent Lab Management System has detected following potential issues in your lab. Please investigate the issues.<br>";
     		String contentMsg = "";
     		String endMsg = "To use Spirent Lab Management System, please click <a href='http://englabmanager/iprep/index.jsp'>[here]</a>.";
			String sqlStr = "";
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				sqlStr = "SELECT * FROM stc_information WHERE TemperatureL1L > '80' OR TemperatureL11 > '80' OR";
				sqlStr = sqlStr + " TemperatureL12 > '80' OR TemperatureL13 > '80' OR TemperatureBP1L > '80' OR TemperatureBP11 > '80' OR ";
				sqlStr = sqlStr + " TemperatureL22 > '80' OR TemperatureL23 > '80' OR TemperatureL2L > '80' OR TemperatureL21 > '80' OR ";
				sqlStr = sqlStr + " TemperatureLSW1 > '80' OR TemperatureLSW3 > '80' OR TemperatureLSWL > '80' OR TemperatureLSW2 > '80' OR ";
				sqlStr = sqlStr + " TemperatureBP12 > '80' OR TemperatureBP13 > '80' OR PowerTop != '0' OR PowerMiddle != '0' OR Powerbottom != '0' OR ";
				sqlStr = sqlStr + " (PartNum = 'SPT-9000' AND (FanRearLeft != 'FAN_STATE_ON' OR FanRearMiddle != 'FAN_STATE_ON' OR FanRearRight != 'FAN_STATE_ON' OR";
				sqlStr = sqlStr + " FanFrontLeft != 'FAN_STATE_ON' OR FanFrontMiddle != 'FAN_STATE_ON' OR FanFrontRight != 'FAN_STATE_ON'))";
				//sqlStr = sqlStr + " (PartNum = 'SPT-5000' AND (OuterTopRear != 'FAN_STATE_ON' OR OuterTopCenter != 'FAN_STATE_ON' OR OuterTopFront != 'FAN_STATE_ON' OR";
				//sqlStr = sqlStr + " InnerTopRear != 'FAN_STATE_ON' OR InnerTopCenter != 'FAN_STATE_ON' OR InnerTopFront != 'FAN_STATE_ON' OR";
				//sqlStr = sqlStr + " InnerBottomRear != 'FAN_STATE_ON' OR InnerBottomCenter != 'FAN_STATE_ON' OR InnerBottomFront != 'FAN_STATE_ON' OR";
				//sqlStr = sqlStr + " Controller1 != 'FAN_STATE_ON' OR Controller2 != 'FAN_STATE_ON' OR";
				//sqlStr = sqlStr + " OuterBottomRear != 'FAN_STATE_ON' OR OuterBottomCenter != 'FAN_STATE_ON' OR OuterBottomFront != 'FAN_STATE_ON'))";
				rs = stmt.executeQuery(sqlStr);	
	
				while (rs.next()){
					contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;Site: "+rs.getString("Site")+"<br>";
					contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;Chassis: "+rs.getString("Hostname")+", Type: "+rs.getString("PartNum")+"<br>";
					
					if(rs.getInt("TemperatureL1L") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L1-L\" sensor temperature is "+rs.getInt("TemperatureL1L")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}
					if(rs.getInt("TemperatureL11") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L1-1\" sensor temperature is "+rs.getInt("TemperatureL11")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}
					if(rs.getInt("TemperatureL12") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L1-2\" sensor temperature is "+rs.getInt("TemperatureL12")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureL13") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L1-3\" sensor temperature is "+rs.getInt("TemperatureL13")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureBP1L") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"BP1-L\" sensor temperature is "+rs.getInt("TemperatureBP1L")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureBP11") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"BP1-1\" sensor temperature is "+rs.getInt("TemperatureBP11")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureBP12") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"BP1-2\" sensor temperature is "+rs.getInt("TemperatureBP12")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureBP13") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"BP1-3\" sensor temperature is "+rs.getInt("TemperatureBP13")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureL2L") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L2-L\" sensor temperature is "+rs.getInt("TemperatureL1L")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}
					if(rs.getInt("TemperatureL21") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L2-1\" sensor temperature is "+rs.getInt("TemperatureL11")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}
					if(rs.getInt("TemperatureL22") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L2-2\" sensor temperature is "+rs.getInt("TemperatureL12")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureL23") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"L2-3\" sensor temperature is "+rs.getInt("TemperatureL13")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureLSWL") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"SW1-L\" sensor temperature is "+rs.getInt("TemperatureBP1L")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureLSW1") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"SW1-1\" sensor temperature is "+rs.getInt("TemperatureBP11")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureLSW2") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"SW1-2\" sensor temperature is "+rs.getInt("TemperatureBP12")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}	
					if(rs.getInt("TemperatureLSW3") > 80){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"SW1-3\" sensor temperature is "+rs.getInt("TemperatureBP13")+"(Celsius), it's over the normal level 80(Celsius).<br>";
					}					
					if(!rs.getString("PowerTop").equals("0")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"top\" power supply is "+rs.getString("PowerTop")+", it's not in \"normal\" status.<br>";
					}	
					if(!rs.getString("PowerMiddle").equals("0")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"middle\" power supply is "+rs.getString("PowerMiddle")+", it's not in \"normal\" status.<br>";
					}
					if(!rs.getString("Powerbottom").equals("0")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"bottom\" power supply is "+rs.getString("Powerbottom")+", it's not in \"normal\" status.<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanRearLeft").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"rear left\" fan status is "+rs.getString("FanRearLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanRearMiddle").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"rear middle\" fan status is "+rs.getString("FanRearMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanRearRight").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"rear right\" fan status is "+rs.getString("FanRearRight")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanFrontLeft").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"front left\" fan status is "+rs.getString("FanFrontLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanFrontMiddle").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"front middle\" fan status is "+rs.getString("FanFrontMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-9000") && !rs.getString("FanFrontRight").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"front right\" fan status is "+rs.getString("FanFrontRight")+".<br>";
					}
					
	/*				if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterTopRear").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer top rear\" fan status is "+rs.getString("FanRearLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterTopCenter").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer top center\" fan status is "+rs.getString("FanRearMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterTopFront").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer top front\" fan status is "+rs.getString("FanRearRight")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterBottomRear").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer bottom rear\" fan status is "+rs.getString("FanFrontLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterBottomCenter").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer bottom center\" fan status is "+rs.getString("FanFrontMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("OuterBottomFront").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Outer bottom front\" fan status is "+rs.getString("FanFrontRight")+".<br>";
					}
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerTopRear").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner top rear\" fan status is "+rs.getString("FanRearLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerTopCenter").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner top center\" fan status is "+rs.getString("FanRearMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerTopFront").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner top front\" fan status is "+rs.getString("FanRearRight")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerBottomRear").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner bottom rear\" fan status is "+rs.getString("FanFrontLeft")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerBottomCenter").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner bottom center\" fan status is "+rs.getString("FanFrontMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("InnerBottomFront").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Inner bottom front\" fan status is "+rs.getString("FanFrontRight")+".<br>";
					}
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("Controller1").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Controller (1 of 2)\" fan status is "+rs.getString("FanFrontMiddle")+".<br>";
					}	
					if(rs.getString("PartNum").equals("SPT-5000") && !rs.getString("Controller2").equals("FAN_STATE_ON")){
						contentMsg = contentMsg + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"Controller (2 of 2)\" fan status is "+rs.getString("FanFrontRight")+".<br>";
					}	*/				
					contentMsg = contentMsg + "<br>";
				}
				
				//Send mail
				sqlStr = "SELECT domainname, mail, monitorreceive FROM iprep_users WHERE monitorreceive='1'";
				rs = stmt.executeQuery(sqlStr);
				
				while (rs.next()){
					fullName = getFullName(rs.getString("domainname"));
					String greetingMsg = "Dear " + fullName + ", <br><br>";
					contentMsg = greetingMsg + startMsg + "<p>" + contentMsg + "</p>" + endMsg;
	
	    		    SendMail sm = new SendMail();
	    		    sm.sendMail(sm, contentMsg, "smtp.spirentcom.com", rs.getString("mail"), "lms@spirentcom.com", subject);
		     	}
			}
		} catch (Exception e) {
			System.out.println("Error occourred in MonitoringChassis.java: "
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
				.println("Close DB error occourred in MonitoringChassis.java: "
						+ e.getMessage());
        	}
        }  
    }
    
    public String getFullName(String fullName){
		String[] splitName = fullName.split(",");
		fullName = splitName[1].trim() + " " + splitName[0].trim();
    	return fullName;
    }
}

