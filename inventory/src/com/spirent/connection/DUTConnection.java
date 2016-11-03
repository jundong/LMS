package com.spirent.connection;

import java.util.regex.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.utilization.ConnectionMap;

public class DUTConnection extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
			String SQLstmt = "";
			String ConnectionStr = "";
			String PeerConnectionStr = "";
			try {
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
				stmt = conn.createStatement();
				
				String connectionType = request
				.getParameter("ConnectionType");
				String DutIpAddress = request
						.getParameter("DutIpAddress").trim();
				String IntfName = request.getParameter("IntfName").trim();
				String ModuleIndex = request
						.getParameter("ModuleIndex").trim();
				String ConnectionNotes = request.getParameter("ConnectionNotes").trim();
				String ConnectionHostname = request
				.getParameter("ConnectionHostname").trim();
		        String ConnectionSlot = request.getParameter("ConnectionSlot");
				if(ConnectionSlot != null){
					ConnectionSlot = ConnectionSlot.trim();
				} else {
					ConnectionSlot = "TBD";
				}
		        String ConnectionPortIndex = request
				.getParameter("ConnectionPortIndex").trim();

				//Delete Peer connection information
				deletePeerConnection(DutIpAddress, IntfName, stmt);
				  
				if (!ConnectionHostname.equals("")
						||!ConnectionPortIndex.equals("") ||!ConnectionSlot.equals("")) {
						if (connectionType.equals("AV")) {	
							if (ConnectionNotes.equals("")) {
								ConnectionSlot = "";
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "/"
										+ ConnectionPortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "/"
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
							}
						} else if (connectionType.equals("SPIRENT")) {			
							if (ConnectionNotes.equals("")) {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "//"
										+ ConnectionSlot + "/"
										+ ConnectionPortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "//"
										+ ConnectionSlot + "/"
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
							}				
						}
						
						//Peer connection string
						if (ConnectionNotes.equals("")) {
							PeerConnectionStr = "DUT "
							+ DutIpAddress + "//"
							+ IntfName;
						} else {
							PeerConnectionStr = "DUT "
							+ DutIpAddress + "//"
							+ IntfName + "\n("
							+ ConnectionNotes + ")";
						}
						
						SQLstmt = "UPDATE dut_inventory_intf SET Connection ='"
							+ ConnectionStr
							+ "', ConnectionType = '"
							+ connectionType
							+ "', PeerHost = '"
							+ ConnectionHostname
							+ "', PeerModule = '"
							+ ConnectionSlot
							+ "', PeerPort = '"
							+ ConnectionPortIndex
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE DutIpAddress = '"
							+ DutIpAddress
							+ "' AND IntfName = '"
							+ IntfName
							+ "' AND ModuleIndex = '" + ModuleIndex + "'";
						
						//Update ConnectionMap (Peer)
						String Key = DutIpAddress + "//" + IntfName.trim();
						String Value = "";
						if(connectionType.equals("AV")){
							Value = ConnectionHostname + "/" + ConnectionPortIndex;
						} else if(connectionType.equals("SPIRENT")){
							Value = ConnectionHostname + "//" + ConnectionSlot + "/" + ConnectionPortIndex;
						}
						ConnectionMap.addMyConnectionMap(Key, Value);
						ConnectionMap.addMyConnectionMap(Value, Key);
				   } else { 
						SQLstmt = "UPDATE dut_inventory_intf SET Connection ='TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE DutIpAddress = '"
							+ DutIpAddress
							+ "' AND IntfName = '"
							+ IntfName
							+ "' AND ModuleIndex = '" + ModuleIndex + "'";					
				   }				
				
			      stmt.execute(SQLstmt);
			      response.sendRedirect("/inventory/tree/dutIntf.jsp?Ip="+DutIpAddress+"&ModuleIndex="+ModuleIndex);
			      
			      //Parse IntfName into Module and Port
			      String peerModule = "";
			      String peerPort = "";
					Pattern p = Pattern.compile("(\\w+[-]*\\w*\\s*]*)(\\d+.*)"); 
					Matcher m = p.matcher(IntfName); 
					if(m.find()){ 
						peerModule = m.group(1);
						peerPort = m.group(2);
					} 
					//Update peer connection information
					if(connectionType.equals("AV")){
						
						SQLstmt = "UPDATE avl_portgroups SET connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = 'DUT', PeerHost = '"
							+ DutIpAddress
							+ "', PeerModule = '"
							+ peerModule
							+ "', PeerPort = '"
							+ peerPort
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE ipaddress = '"
							+ ConnectionHostname
							+ "' AND portindex = '" + ConnectionPortIndex + "'";
						stmt.execute(SQLstmt);
					} else if(connectionType.equals("SPIRENT")){
						SQLstmt = "UPDATE stc_inventory_portgroup SET Connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = 'DUT', PeerHost = '"
							+ DutIpAddress
							+ "', PeerModule = '"
							+ peerModule
							+ "', PeerPort = '"
							+ peerPort
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE Hostname = '"
							+ ConnectionHostname
							+ "' AND SlotIndex = '"
							+ ConnectionSlot
							+ "' AND PortIndex = '" + ConnectionPortIndex + "'";
					    stmt.execute(SQLstmt);
					}
				}
			} catch (Exception e) {
				System.out
						.println("Error occourred in DUTConnection.java: "
								+ e.getMessage());
			} finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in DUTConnection.java: "
							+ e.getMessage());
	        	}
	        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
	public void deletePeerConnection(String DutIpAddress, String IntfName, Statement stmt){
		 String peerConnection = "";
		try {
			String sqlStr = "SELECT ConnectionType, PeerHost, PeerModule, PeerPort, Comments FROM dut_inventory_intf WHERE DutIpAddress = '"
				+ DutIpAddress
				+ "' AND IntfName = '"
				+ IntfName
				+ "'";
			ResultSet rs = stmt.executeQuery(sqlStr);
		    if(rs.next()){
		    	if(rs.getString("ConnectionType").equals("SPIRENT")){
		    		sqlStr = "UPDATE stc_inventory_portgroup SET connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE Hostname = '"
						+ rs.getString("PeerHost")
						+ "' AND SlotIndex = '" 
						+ rs.getString("PeerModule") 
						+ "' AND PortIndex = '"
						+ rs.getString("PeerPort") + "'";
		    	    
		    	    peerConnection = rs.getString("PeerHost")+"//"+rs.getString("PeerModule")+"/"+rs.getString("PeerPort");
		    	    stmt.execute(sqlStr);
		    	    
		    	    //Delete Peer ConnectionMap
			    	ConnectionMap.removeMyConnectionMap(peerConnection);
			    	
					//Delete Current ConnectionMap
					String Key = DutIpAddress + "//" + IntfName.trim();
					ConnectionMap.removeMyConnectionMap(Key);

		    	}else if(rs.getString("ConnectionType").equals("AV")){
		    		sqlStr = "UPDATE avl_portgroups SET connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE ipaddress = '"
						+ rs.getString("PeerHost")
						+ "' AND portindex = '" + rs.getString("PeerPort") + "'";		    	    
		    	    peerConnection = rs.getString("PeerHost")+"/"+rs.getString("PeerPort");
		    	    stmt.execute(sqlStr);
		    	    
		    	    //Delete Peer ConnectionMap
			    	ConnectionMap.removeMyConnectionMap(peerConnection);
			    	
					//Delete Current ConnectionMap
					String Key = DutIpAddress + "//" + IntfName.trim();
					ConnectionMap.removeMyConnectionMap(Key);
		    	}
		    }
		    rs.close();
		} catch(Exception e){
			System.out
			.println("Error occourred in DUTConnection.java->deletePeerConnection: "
					+ e.getMessage());
		}
	}
}