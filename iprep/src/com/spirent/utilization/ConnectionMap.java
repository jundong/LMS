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

public class ConnectionMap {
	private static Map<String, String> myConnectionMap = null;
      
	public Map<String, String> getResourcesList(){
	    Map<String, String> resourceMap = new TreeMap<String, String>();;
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
				sqlQuery = "select ipaddress, portindex, ConnectionType, PeerHost, PeerModule, PeerPort from avl_portgroups order by site, ipaddress, portindex";
				rs = stmt.executeQuery(sqlQuery);
				while(rs.next()){
					endResource = rs.getString("ipaddress") + "/" + rs.getString("portindex");
					String connectionResource = "";
					if(rs.getString("ConnectionType").equals("AV")){
						connectionResource = rs.getString("PeerHost") + "/" + rs.getString("PeerPort");
					} else if(rs.getString("ConnectionType").equals("DUT")){
						connectionResource = rs.getString("PeerHost") + "//" + rs.getString("PeerModule") + rs.getString("PeerPort");
					}
					resourceMap.put(endResource, connectionResource);
				}
				
				//Collect Chassis resources
				sqlQuery = "select Hostname, SlotIndex, PortIndex, ConnectionType, PeerHost, PeerModule, PeerPort from stc_inventory_portgroup order by Site, Hostname, SlotIndex,PortIndex";
				rs = stmt.executeQuery(sqlQuery);
				while(rs.next()){
					endResource = rs.getString("Hostname") + "//" + rs.getString("SlotIndex") + "/" + rs.getString("PortIndex");
					String connectionResource = "";
					if(rs.getString("ConnectionType").equals("SPIRENT")){
						connectionResource = rs.getString("PeerHost") + "//" + rs.getString("PeerModule") + "/" + rs.getString("PeerPort");
					} else if(rs.getString("ConnectionType").equals("DUT")){
						connectionResource = rs.getString("PeerHost") + "//" + rs.getString("PeerModule") + rs.getString("PeerPort");
					}
					resourceMap.put(endResource, connectionResource);
				}
				
				//Collect DUT resources
				sqlQuery = "select DutIpAddress, IntfName, ConnectionType, PeerHost, PeerModule, PeerPort from dut_inventory_intf order by Site,DutIpAddress,  ModuleIndex, IntfName";
				rs = stmt.executeQuery(sqlQuery);
				while(rs.next()){
					endResource = rs.getString("DutIpAddress") + "//" + rs.getString("IntfName").trim();
					String connectionResource = "";
					if(rs.getString("ConnectionType").equals("AV")){
						connectionResource = rs.getString("PeerHost") + "/" + rs.getString("PeerPort");
					} else if(rs.getString("ConnectionType").equals("SPIRENT")){
						connectionResource = rs.getString("PeerHost") + "//" + rs.getString("PeerModule") + "/" + rs.getString("PeerPort");
					}
					resourceMap.put(endResource, connectionResource);
				}
			}
		} catch (Exception e) {
			System.out.println("Error occourred in ConnectionMap.java: "
							+ e.getMessage());
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
				.println("Close DB error occourred in ConnectionMap.java: "
						+ e.getMessage());
        	}
        } 
		return resourceMap;
      }

	public static Map<String, String> getMyConnectionMap() {
		return myConnectionMap;
	}

	public static void setMyConnectionMap(Map<String, String> myConnectionMap) {
		ConnectionMap.myConnectionMap = myConnectionMap;
	}
	
	public static void addMyConnectionMap(String Key, String Value) {
		ConnectionMap.myConnectionMap.put(Key, Value);
	}
	
	public static void removeMyConnectionMap(String Key) {
		ConnectionMap.myConnectionMap.remove(Key);
	}
	
	public String getConnectionResource(String portList) {
		String[] splitPortList = portList.split(",");
		for(int i=0; i<splitPortList.length; i++){
			if(splitPortList[i].equals("")) continue;
			
			String peerConnectionResource = ConnectionMap.myConnectionMap.get(splitPortList[i]);
			if(peerConnectionResource != null){
				if(peerConnectionResource.equals(""))continue;
				
				boolean isExist = false;
				for(int j=0; j<splitPortList.length; j++){
					if(splitPortList[j].equals(peerConnectionResource)){
						isExist = true;
						break;
					}
				}
				
				if(!isExist){
					portList = portList + "," + peerConnectionResource;
				}
			}
		}
		return portList;
	}
}
