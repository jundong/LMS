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

public class ConnectionType extends HttpServlet {
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
					String Slot = request.getParameter("Slot");
					String PortIndex = request.getParameter("PortIndex");

					String connectionType = request
					.getParameter("ConnectionType");
					String ConnectionHostname = request
							.getParameter("ConnectionHostname").trim();
					String ConnectionSlot = request.getParameter("ConnectionSlot").trim();
					String ConnectionPortIndex = request
							.getParameter("ConnectionPortIndex").trim();
					String ConnectionNotes = request.getParameter("ConnectionNotes").trim();

					//Delete Peer connection information
					deletePeerConnection(Ip, Slot, PortIndex, stmt);
					
					if (!ConnectionHostname.equals("")
							||!ConnectionSlot.equals("")
							||!ConnectionPortIndex.equals("")) {
						
						if (connectionType.equals("SPIRENT")) {
							if (ConnectionNotes.equals("")) {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "//"
										+ ConnectionSlot + "/"
										+ ConnectionPortIndex;
								
								PeerConnectionStr = connectionType + " "
								+ Ip + "//"
								+ Slot + "/"
								+ PortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + "//"
										+ ConnectionSlot + "/"
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
								
								PeerConnectionStr = connectionType + " "
								+ Ip + "//"
								+ Slot + "/"
								+ PortIndex + "\n("
								+ ConnectionNotes + ")";
							}
						} else if (connectionType.equals("DUT")){
							if (ConnectionNotes.equals("")) {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + " "
										+ ConnectionSlot
										+ ConnectionPortIndex;
								
								PeerConnectionStr = "SPIRENT "
									+ Ip + "//"
									+ Slot + "/"
									+ PortIndex;
							} else {
								ConnectionStr = connectionType + " "
										+ ConnectionHostname + " "
										+ ConnectionSlot
										+ ConnectionPortIndex + "\n("
										+ ConnectionNotes + ")";
								
								PeerConnectionStr = "SPIRENT "
								+ Ip + "//"
								+ Slot + "/"
								+ PortIndex + "\n("
								+ ConnectionNotes + ")";
							}
						}
						
						//Update connection information
						SQLstmt = "UPDATE stc_inventory_portgroup SET Connection ='"
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
							+ "' WHERE Hostname = '"
							+ Ip
							+ "' AND SlotIndex = '"
							+ Slot
							+ "' AND PortIndex = '" + PortIndex + "'";
						
						//Update ConnectionMap (Peer)
						String Key = Ip+"//"+Slot+"/"+PortIndex;
						String Value = "";
						if(connectionType.equals("SPIRENT")){
							Value = ConnectionHostname + "//" + ConnectionSlot + "/" + ConnectionPortIndex;
						} else if(connectionType.equals("DUT")){
							Value = ConnectionHostname + "//" + ConnectionSlot + ConnectionPortIndex;
						}
						ConnectionMap.addMyConnectionMap(Key, Value);
						ConnectionMap.addMyConnectionMap(Value, Key);
					} else {
						SQLstmt = "UPDATE stc_inventory_portgroup SET Connection = 'TBD', ConnectionType='', PeerHost='', PeerModule='', PeerPort='', Comments='' WHERE Hostname = '"
							+ Ip
							+ "' AND SlotIndex = '"
							+ Slot
							+ "' AND PortIndex = '" + PortIndex + "'";
					}	
					
				    stmt.execute(SQLstmt);
					response.sendRedirect("/inventory/tree/port.jsp?Ip=" + Ip + "&Slot=" + Slot);
					
					//Update peer connection information
					if(connectionType.equals("DUT")){
						String intfName = ConnectionSlot+ConnectionPortIndex;
						SQLstmt = "UPDATE dut_inventory_intf SET Connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = 'SPIRENT', PeerHost = '"
							+ Ip
							+ "', PeerModule = '"
							+ Slot
							+ "', PeerPort = '"
							+ PortIndex
							+ "', Comments = '"
							+ ConnectionNotes
							+ "' WHERE DutIpAddress = '"
							+ ConnectionHostname
							+ "' AND IntfName = '"
							+ intfName + "'";
						stmt.execute(SQLstmt);
					} else if(connectionType.equals("SPIRENT")){
						SQLstmt = "UPDATE stc_inventory_portgroup SET Connection ='"
							+ PeerConnectionStr
							+ "', ConnectionType = '"
							+ connectionType
							+ "', PeerHost = '"
							+ Ip
							+ "', PeerModule = '"
							+ Slot
							+ "', PeerPort = '"
							+ PortIndex
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
						.println("Error occourred in ConnectionType.java: "
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
					.println("Close DB error occourred in ConnectionType.java: "
							+ e.getMessage());
	        	}
	        }  
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
	public void deletePeerConnection(String Ip, String Slot, String PortIndex, Statement stmt){
		 String peerConnection = "";
		try {
			String sqlStr = "SELECT ConnectionType, PeerHost, PeerModule, PeerPort, Comments FROM stc_inventory_portgroup WHERE Hostname = '"
				+ Ip
				+ "' AND SlotIndex = '"
				+ Slot
				+ "' AND PortIndex = '" + PortIndex + "'";
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
		    	    
		    	    //Delete Current ConnetionMap
					String Key = Ip+"//"+Slot+"/"+PortIndex;
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
					
		    	    //Delete Current ConnetionMap
					String Key = Ip+"//"+Slot+"/"+PortIndex;
					ConnectionMap.removeMyConnectionMap(Key);
		    	}
		    }
		} catch(Exception e){
			System.out
			.println("Error occourred in ConnectionType.java->deletePeerConnection: "
					+ e.getMessage());
		}
	}
}