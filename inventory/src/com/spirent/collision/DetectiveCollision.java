package com.spirent.collision;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;

public class DetectiveCollision extends HttpServlet{

	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException  {
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		int resCount=0;
		String collisonStr="Just for testing";
		String sqlStr="";
		try {					
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt=conn.createStatement();
				
				PrintWriter out = response.getWriter();
				String rec_type=request.getParameter("rec_type");
				if(rec_type == null){
					rec_type="";
				}
				String uid=request.getParameter("uid"); 
				String event_length=request.getParameter("event_length"); 
				int timeoffset=Integer.parseInt(request.getParameter("timeoffset")); 
				String dtstart=getCanlender(request.getParameter("dtstart"), timeoffset);
				String dtend=getCanlender(request.getParameter("dtend"), timeoffset);
		         
				if(rec_type.equals("")){
					sqlStr="SELECT resources, organizer FROM events_rec WHERE STRCMP(dtstart, '";
					sqlStr=sqlStr + dtend + "')=-1 AND STRCMP(dtstart, '" + dtstart + "')=1";
					rs=stmt.executeQuery(sqlStr);
					while(rs.next()){
						String[] resSplit=(rs.getString("resources").replaceAll("\n", "")).split(",");
						for(int i=0; i<resSplit.length; i++){
							++resCount;
							if(resCount <= 12){
						       collisonStr=collisonStr+"Resource: "+resSplit[i].trim()+" has been reserved by "+rs.getString("organizer")+"\n";
							}
						}
					}
		
					if(resCount > 0){
						if(resCount > 12){
							int skipCount=resCount-12;
							collisonStr=collisonStr+"...... skip "+skipCount+" items\n\n";
							collisonStr=collisonStr+"Please select different time period.";
						} else {
							collisonStr=collisonStr+"\nPlease select different time period.";
						}
					}
				} else {
					
				}
				
				out.println(collisonStr);
			}
		} catch (Exception e) {
			System.out.println("Exception occurs in DetectiveCollision.java->detectiveCollision: "+e.getMessage());
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
				.println("Close DB error occourred in DetectiveCollision.java: "
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
}
