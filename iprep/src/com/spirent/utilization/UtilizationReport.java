package com.spirent.utilization;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.spirent.javaconnector.DataBaseConnection;

public class UtilizationReport {
      
	Map<String, Integer> getResourcesList(){
	    Map<String, Integer> resourceMap = new TreeMap<String, Integer>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				String sqlQuery = "";
				String endResource = "";
				
				//Collect Avalanche resources
				sqlQuery = "select TestBedName from iprep_testbed order by TestBedIndex";
				rs = stmt.executeQuery(sqlQuery);
				while(rs.next()){
					endResource = rs.getString("TestBedName");
					resourceMap.put(endResource, 0);
				}
			}
		} catch (Exception e) {
			System.out.println("Error occourred in UtilizationReport.java: "
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
				.println("Close DB error occourred in UtilizationReport.java: "
						+ e.getMessage());
        	}
        }
		return resourceMap;
      }
	
    int ParseTime( String time ){

       int pos1 = time.indexOf('-',0);
       int year = Integer.parseInt(time.substring(0, pos1).trim());
       int pos2 = time.indexOf('-', pos1+1);
       int month = Integer.parseInt(time.substring( pos1+1, pos2).trim());
       pos1 = time.indexOf(' ', pos2+1);
       int day = Integer.parseInt(time.substring(pos2+1, pos1).trim());
       pos2 = time.indexOf(':', pos1+1);
       int hour = Integer.parseInt(time.substring(pos1+1, pos2).trim());

       int totalTime = year*365*24 +  
       month*30*24 +
       day*24 +
       hour;
       
       return totalTime;

    }
    
    boolean isExactMatch(String resources, String res){    
        String[] strArray = resources.split(",");

        for(int i=0; i<strArray.length; ++i){
            String str = strArray[i].trim();

            if(str.length() < 1)
               continue;
            
            if (res.equals(str)){
            	return true;
            }
        }      
        return false;
     }
	
    void Parser(String startTime, String stopTime, String resources, String res, Map<String, Integer> utilizationMap){

       int start = ParseTime( startTime);
       int stop  = ParseTime( stopTime);
       int totalTime = stop - start;
       if (isExactMatch(resources, res)){
	       utilizationMap.put(res, utilizationMap.get(res) + totalTime);
       }
    }
	
    public String topList(List<Map.Entry<String, Integer>> listLogin, int counts, String col1, String col2){
    	String emailStr = "<table><tr><td>" + col1 + "</td><td>" + col2 + "</td></tr>";
    	if (listLogin.size() < counts){
			for (int i = 0; i < listLogin.size(); i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
				emailStr = emailStr + "<tr><td>" + splitMap[0] + "</td><td>"+ splitMap[1] + "</td><tr>";
		    } 
    	} else {
			for (int i = 0; i < counts; i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		emailStr = emailStr + "<tr><td>" + splitMap[0] + "</td><td>"+ splitMap[1] + "</td><tr>";
		    } 	
    	}
    	emailStr = emailStr + "</table>";
    	return emailStr;
    }
    
    public String lastList(List<Map.Entry<String, Integer>> listLogin, int counts, String col1, String col2){
    	String emailStr = "<table><tr><td>" + col1 + "</td><td>" + col2 + "</td></tr>";
    	if (listLogin.size() < counts){
			for (int i = listLogin.size() - 1; i >= 0; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		emailStr = emailStr + "<tr><td>" + splitMap[0] + "</td><td>"+ splitMap[1] + "</td><tr>";
		    } 
    	} else {
			for (int i = listLogin.size() - 1; i >= listLogin.size() - counts; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		emailStr = emailStr + "<tr><td>" + splitMap[0] + "</td><td>"+ splitMap[1] + "</td><tr>";
		    } 	
    	}
    	emailStr = emailStr + "</table>";
    	return emailStr;
    }
}
