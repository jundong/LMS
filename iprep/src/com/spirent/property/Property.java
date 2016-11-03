package com.spirent.property;

import java.util.regex.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class Property extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				String SQLstmt = "";
				String isPermanent = request.getParameter("isPermanent");
				String isLoaner = request.getParameter("isLoaner");
				String SN = request.getParameter("SN");
				String ResourceType = request.getParameter("ResourceType");
				if (ResourceType.equals("1") || ResourceType.equals("2")){
					ResourceType = "CONTROLLER " + ResourceType;
				}
				
				if (isPermanent != null){
					String per = request.getParameter("per");
					String so = request.getParameter("so");
					if(so == null){
						so = "";
					}
					String Ip = request.getParameter("Ip");
					String Slot = request.getParameter("Slot");
					if (!so.equals("")){
						if (!Slot.equals("")) {
							SQLstmt = "UPDATE stc_inventory_testmodule SET Property ='"
								+ per
								+ "', SO ='"
								+ so
								+ "' WHERE Hostname = '"
								+ Ip
								+ "' AND SlotIndex = '"
								+ Slot + "'";
							
							stmt.execute(SQLstmt);				
							response.sendRedirect("/iprep/tree/slot.jsp?Ip=" + Ip + "&Slot=" + Slot);
						} else {
							SQLstmt = "UPDATE stc_inventory_chassis SET Property ='"
								+ per
								+ "', SO ='"
								+ so
								+ "' WHERE Hostname = '"
								+ Ip + "'";
							
							stmt.execute(SQLstmt);
							response.sendRedirect("/iprep/tree/chassis.jsp?Ip=" + Ip);
						}
						
						//Update property table
						SQLstmt = "SELECT * FROM stc_property WHERE SN ='"+SN+"'";
						rs = stmt.executeQuery(SQLstmt);
						if(rs.next()){
							SQLstmt = "UPDATE stc_property SET Property ='"
								+ per
								+ "', SO ='"
								+ so
								+ "', ResourceType ='"
								+ ResourceType
								+ "' WHERE SN = '" + SN + "'";
						} else {
							SQLstmt = "INSERT INTO stc_property VALUE('"+SN+"','"+selectSite(Ip)+"','"+per+"','"+so+"','','','"+ResourceType+"')";
						}
						stmt.execute(SQLstmt);	
					} else {
						response.sendRedirect("/iprep/update/chassisproperty.jsp?Ip=" + Ip + "&Slot=" + Slot + "&Property=Permanent" + "&ResourceType=" + ResourceType);
					}		
				} else if (isLoaner != null){
					String loaner = request.getParameter("loaner");
					String so = request.getParameter("so");	
					if(so == null){
						so = "";
					}
					String sostart = request.getParameter("sostart");
					sostart = convertDate(sostart);
					String soend = request.getParameter("soend");	
					soend = convertDate(soend);
					String notificationdate = request.getParameter("notificationdate");
					String saveNotificationDate = request.getParameter("saveNotificationDate");
					if(saveNotificationDate == null){
						notificationdate = "";
					} else {
						notificationdate = convertDate(notificationdate);
					}
					String Ip = request.getParameter("Ip");
					String Slot = request.getParameter("Slot");
					if (!so.equals("") && !sostart.equals("") && !soend.equals("")){
						if (!Slot.equals("")) {
							SQLstmt = "UPDATE stc_inventory_testmodule SET Property ='"
								+ loaner
								+ "', SO ='"
								+ so
								+ "', SOStart ='"
								+ sostart
								+ "', SOEnd ='"
								+ soend
								+ "', LoanerNotificationDate ='"
								+ notificationdate
								+ "' WHERE Hostname = '"
								+ Ip
								+ "' AND SlotIndex = '"
								+ Slot + "'";
							
							stmt.execute(SQLstmt);
							response.sendRedirect("/iprep/tree/slot.jsp?Ip=" + Ip + "&Slot=" + Slot);
	
						} else {
							SQLstmt = "UPDATE stc_inventory_chassis SET Property ='"
								+ loaner
								+ "', SO ='"
								+ so
								+ "', SOStart ='"
								+ sostart
								+ "', SOEnd ='"
								+ soend
								+ "', LoanerNotificationDate ='"
								+ notificationdate
								+ "' WHERE Hostname = '"
								+ Ip + "'";
							
							stmt.execute(SQLstmt);
							response.sendRedirect("/iprep/tree/chassis.jsp?Ip=" + Ip);
						}
						
						//Update property table
						SQLstmt = "SELECT * FROM stc_property WHERE SN ='"+SN+"'";
						rs = stmt.executeQuery(SQLstmt);
						if(rs.next()){
							SQLstmt = "UPDATE stc_property SET Property ='"
								+ loaner
								+ "', SO ='"
								+ so
								+ "', SOStart ='"
								+ sostart
								+ "', ResourceType ='"
								+ ResourceType
								+ "', SOEnd ='"
								+ soend
								+ "' WHERE SN = '" +SN+"'";
						} else {
							SQLstmt = "INSERT INTO stc_property VALUE('"+SN+"','"+selectSite(Ip)+"','"+loaner+"','"+so+"','"+sostart+"','"+soend+"','"+ResourceType+"')";
						}
						stmt.execute(SQLstmt);	
					} else {
						response.sendRedirect("/iprep/update/chassisproperty.jsp?Ip=" + Ip + "&Slot=" + Slot + "&Property=Loaner"  + "&ResourceType=" + ResourceType);
					}
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in Property.java: "
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
				.println("Close DB error occourred in Property.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
	public String convertDate(String date){
		if(!date.contains("/")) return "";
		
		String[] splitDate = date.split("/");
		date = splitDate[2]+"-"+splitDate[1]+"-"+splitDate[0];
		return date;
	}
	
    public String selectSite(String ipAddress){
   	 String site = "";
	     if (Pattern.matches("^10.14.*", ipAddress)){
	    	 site = "HNL";
	     } else if (Pattern.matches("^10.100.*", ipAddress)){
	    	 site = "CAL";
	     } else if (Pattern.matches("^10.61.*", ipAddress)){
	    	 site = "CHN";
	     } else if (Pattern.matches("^10.47.*", ipAddress)){
	    	 site = "SNV";
	     } else if (Pattern.matches("^10.6.*", ipAddress)){
	    	 site = "RTP";
	     }
   	 return site;
    }
}