package com.spirent.connection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.utilization.ConnectionMap;

public class AVConnection extends HttpServlet {
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
					
					String Ip = request.getParameter("Ip");
					String PortGroupIndex = request.getParameter("Slot");
					String PortIndex = request.getParameter("PortIndex");
					
					String connectionType = request
					.getParameter("ConnectionType");
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
					String ConnectionNotes = request.getParameter("ConnectionNotes").trim();
					
					//Delete Peer connection information
					deletePeerConnection(Ip, PortGroupIndex, PortIndex, stmt);

					if (!ConnectionHostname.equals("")
							||!ConnectionPortIndex.equals("") ||!ConnectionSlot.equals("")) {
						if (connectionType.equals("AV")) {
							ConnectionSlot = "";
							if (ConnectionNotes.equals("")) {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "/"
										+ ConnectionPortIndex;
								
								PeerConnectionStr = connectionType + " "
								+ Ip + "/"
								+ PortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "/"
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
								
								PeerConnectionStr = connectionType + " "
								+ Ip + "/"
								+ PortIndex + "\n("
								+ ConnectionNotes + ")";
							}
						} else if (connectionType.equals("DUT")){
							if (ConnectionNotes.equals("")) {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + " "
										+ ConnectionSlot
										+ ConnectionPortIndex;
								
								PeerConnectionStr = "AV "
									+ Ip + "/"
									+ PortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + " "
										+ ConnectionSlot
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
								
								PeerConnectionStr = "AV "
								+ Ip + "/"
								+ PortIndex + "\n("
								+ ConnectionNotes + ")";
							}
						}
						
						//Update connection information
						SQLstmt = "UPDATE avl_portgroups SET connection ='"
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
								+ "' WHERE ipaddress = '"
								+ Ip
								+ "' AND portgroupindex = '"
								+ PortGroupIndex
								+ "' AND portindex = '" + PortIndex + "'";		
						
						//Update ConnectionMap (Peer)
						String Key = Ip + "/" + PortIndex;
						String Value = "";
						if(connectionType.equals("AV")){
							Value = ConnectionHostname + "/" + ConnectionPortIndex;
						} else if(connectionType.equals("DUT")){
							Value = ConnectionHostname + "//" + ConnectionSlot + ConnectionPortIndex;
						}
						ConnectionMap.addMyConnectionMap(Key, Value);
						ConnectionMap.addMyConnectionMap(Value, Key);
					 } else {
						SQLstmt = "UPDATE avl_portgroups SET connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE ipaddress = '"
							+ Ip
							+ "' AND portgroupindex = '"
							+ PortGroupIndex
							+ "' AND portindex = '" + PortIndex + "'";			
					}
							
				    stmt.execute(SQLstmt);
					response.sendRedirect("/iprep/tree/avport.jsp?Ip=" + Ip);
					
					//Update peer connection information
					if(connectionType.equals("DUT")){
						String intfName = ConnectionSlot+ConnectionPortIndex;
						SQLstmt = "UPDATE dut_inventory_intf SET Connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = 'AV', PeerHost = '"
							+ Ip
							+ "', PeerModule = '"
							+ ""
							+ "', PeerPort = '"
							+ PortIndex
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE DutIpAddress = '"
							+ ConnectionHostname
							+ "' AND IntfName = '"
							+ intfName + "'";
						stmt.execute(SQLstmt);
					} else if(connectionType.equals("AV")){
						SQLstmt = "UPDATE avl_portgroups SET connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = 'DUT', PeerHost = '"
							+ Ip
							+ "', PeerModule = '"
							+ ""
							+ "', PeerPort = '"
							+ PortIndex
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE ipaddress = '"
							+ ConnectionHostname
							+ "' AND portindex = '" + ConnectionPortIndex + "'";	
					    stmt.execute(SQLstmt);
					}
				}
			} catch (Exception e) {
				System.out
						.println("Error occourred in AVConnection.java: "
								+ e.getMessage());
			}finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in AVConnection.java: "
							+ e.getMessage());
	        	}
	        }  
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
	public void deletePeerConnection(String Ip, String PortGroupIndex, String PortIndex, Statement stmt){
		ResultSet rs = null; 
		String peerConnection = "";
		try {
			String sqlStr = "SELECT ConnectionType, PeerHost, PeerModule, PeerPort, Comments FROM avl_portgroups WHERE ipaddress = '"
				+ Ip
				+ "' AND portgroupindex = '"
				+ PortGroupIndex
				+ "' AND portindex = '" + PortIndex + "'";
			rs = stmt.executeQuery(sqlStr);
		    if(rs.next()){
		    	if(rs.getString("ConnectionType").equals("AV")){
		    		sqlStr = "UPDATE avl_portgroups SET connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE ipaddress = '"
						+ rs.getString("PeerHost")
						+ "' AND portindex = '" + rs.getString("PeerPort") + "'";
		    		peerConnection = rs.getString("PeerHost")+"/"+rs.getString("PeerPort");
		    	    stmt.execute(sqlStr);
		    	    
		    	    //Delete Peer ConnectionMap
		    	    ConnectionMap.removeMyConnectionMap(peerConnection);
		    	    
					//Delete Current ConnectionMap
					String Key = Ip + "/" + PortIndex;
					ConnectionMap.removeMyConnectionMap(Key);

		    	}else if(rs.getString("ConnectionType").equals("DUT")){
					String intfName = rs.getString("PeerModule")+rs.getString("PeerPort");
					sqlStr = "UPDATE dut_inventory_intf SET connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE DutIpAddress = '"
						+ rs.getString("PeerHost")
						+ "' AND IntfName = '"
						+ intfName + "'";
					peerConnection = rs.getString("PeerHost")+"//"+intfName;
					stmt.execute(sqlStr);
					
					//Delete Peer ConnectionMap
					ConnectionMap.removeMyConnectionMap(peerConnection);
					
					//Delete Current ConnectionMap
					String Key = Ip + "/" + PortIndex;
					ConnectionMap.removeMyConnectionMap(Key);
   
		    	}
		    }
		} catch(Exception e){
			System.out
			.println("Error occourred in AVConnection.java->deletePeerConnection: "
					+ e.getMessage());
		}finally {
        	try {
        		if(rs != null){
        			rs.close();
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in AVConnection.java->deletePeerConnection: "
						+ e.getMessage());
        	}
        } 
	}
}