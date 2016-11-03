package com.spirent.utilization;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;

public class Reports extends HttpServlet {
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		UtilizationReport ur = new UtilizationReport();
		
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				String sqlStr = "";
				String isResourcesReport = request.getParameter("isResourcesReport");
				String isUserReport = request.getParameter("isUserReport");
				int counts = Integer.valueOf(request.getParameter("topCounts")).intValue();
				String isEmpty = request.getParameter("isEmpty");
				
				if (isResourcesReport != null){
					Map<String, Integer> resourcesMap = new TreeMap<String, Integer>();
					String resources = (String) request.getSession().getAttribute("resourcesList");
					
					if (isEmpty.equals("true")){
						resourcesMap = ur.getResourcesList();
					} else {
					    resourcesMap = generateMap(resources);
					}
	
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
					String topList = "";
					String lastList = "";
					topList = topList(resourcesList, counts);
					lastList = lastList(resourcesList, counts);
		
				    response.sendRedirect("/iprep/reports.jsp?topList=" + topList + "&lastList=" + lastList + "&isResourcesReport=true&isEmpty=" + isEmpty);
				} else if(isUserReport != null) {
					Map<String, Integer> mapLogin = new TreeMap<String, Integer>();
					String fullName = "";
					sqlStr = "SELECT domainname, logintimes FROM iprep_users";
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
					
					String topList = "";
					String lastList = "";
					topList = topUserList(listLogin, counts);
					lastList = lastUserList(listLogin, counts);
					response.sendRedirect("/iprep/reports.jsp?topList=" + topList + "&lastList=" + lastList + "&isUserReport=true&isEmpty=" + isEmpty);
				}
			}
		} catch (Exception e) {
			System.out.print("Exception occurs in Reports.java: "+e.getMessage());
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
				.println("Close DB error occourred in Reports.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
    public String topList(List<Map.Entry<String, Integer>> listLogin, int counts){
    	String keyStr = "";
    	if (listLogin.size() < counts){
			for (int i = 0; i < listLogin.size(); i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0] + ","+ splitMap[1] + ",";
		    } 
    	} else {
			for (int i = 0; i < counts; i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0] + ","+ splitMap[1] + ",";
		    } 	
    	}

    	return keyStr;
    }
    
    public String lastList(List<Map.Entry<String, Integer>> listLogin, int counts){
    	String keyStr = "";
    	if (listLogin.size() < counts){
			for (int i = listLogin.size() - 1; i >= 0; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0] + ","+ splitMap[1] + ",";
		    } 
    	} else {
			for (int i = listLogin.size() - 1; i >= listLogin.size() - counts; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0] + ","+ splitMap[1] + ",";
		    } 	
    	}
    	return keyStr;
    }
    
    public String topUserList(List<Map.Entry<String, Integer>> listLogin, int counts){
    	String keyStr = "";
    	if (listLogin.size() < counts){
			for (int i = 0; i < listLogin.size(); i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0].replace(",", "@") + ","+ splitMap[1] + ",";
		    } 
    	} else {
			for (int i = 0; i < counts; i++) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0].replace(",", "@") + ","+ splitMap[1] + ",";
		    } 	
    	}
    	return keyStr;
    }
    
    public String lastUserList(List<Map.Entry<String, Integer>> listLogin, int counts){
    	String keyStr = "";
    	if (listLogin.size() < counts){
			for (int i = listLogin.size() - 1; i >= 0; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0].replace(",", "@") + ","+ splitMap[1] + ",";
		    } 
    	} else {
			for (int i = listLogin.size() - 1; i >= listLogin.size() - counts; i--) { 
				String mapStr = listLogin.get(i).toString();
	    		String[] splitMap = mapStr.split("=");
	    		keyStr = keyStr + splitMap[0].replace(",", "@") + ","+ splitMap[1] + ",";
		    } 	
    	}
    	return keyStr;
    }
    
    public Map<String, Integer> generateMap(String resources){
    	Map<String, Integer> resourceMap = new TreeMap<String, Integer>(); 
    	
        String[] splitResources = resources.split(",");
        
        for (int i = 0; i < splitResources.length; i++){
        	resourceMap.put(splitResources[i], 0);
        }
    	return resourceMap;
    }
}
