package com.spirent.convert2xml;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

import com.spirent.javaconnector.DataBaseConnection;

public class Generate2TreeXML {

	public String BuildXMLDoc(String filter) throws IOException, JDOMException {
		
		String siteStr = "";
		
		if (filter.equals("ALL")){
			siteStr = "CAL;CHN;HNL;RTP;SNV";
	    } else {
	    	siteStr = filter;
	    }
        
		String[] sites = siteStr.split(";");
		
		ConvertDUT dut = new ConvertDUT();
		ConvertPC pc = new ConvertPC();
		ConvertVM vm = new ConvertVM();
		ConvertAV av = new ConvertAV();
		ConvertChassis chassis = new ConvertChassis();
		Element root = new Element("tree");
		root.setAttribute("id", "0");
		//root.setAttribute("radio", "1");
		Element treeroot = chassis.addRootNode(root);;
		Element siteroot;
		
		Document Doc = new Document(root);
		XMLOutputter XMLOut = new XMLOutputter();
		StringWriter strwriter = new StringWriter(); 
		// Set query string
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String SQLStr = "";
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				// Below codes deal with Chassis and DUT tree view
				for (int i = 0; i < sites.length; i++){
				   filter = sites[i];
				   SQLStr = "select Site, Hostname, SlotIndex, PortIndex, Status from stc_inventory_portgroup where Site='" + filter + "' order by Hostname, SlotIndex,PortIndex";
				   
				   rs = stmt.executeQuery(SQLStr);
	
					siteroot = chassis.addSiteNode(filter, treeroot);
					
					//Chassis node
					Element chassisroot = chassis.addChassisNode(filter, siteroot);
					//DUT node
					Element dutroot = dut.addDUTNode(filter, siteroot);
					//VM node
					Element vmroot = vm.addVMNode(filter, siteroot);
					//AV node
					Element avroot = av.addAVNode(filter, siteroot);
					//PC node
					Element pcroot = pc.addPCNode(filter, siteroot);
					
					if (rs.next()) {
						String hostname = rs.getString("Hostname");
						int slotindex = rs.getInt("SlotIndex");
						
						Element chassisiproot = chassis.addChassisIPNode(hostname, chassisroot);
						Element slotroot = chassis.addSlotNode(hostname, slotindex,
								chassisiproot);
						chassis.addPortNode(hostname, slotindex, rs.getInt("PortIndex"), slotroot, rs.getString("Status"));
	
						while (rs.next()) {
							String nexthostname = rs.getString("Hostname");
							int nextslotindex = rs.getInt("SlotIndex");
							
							if (hostname.equals(nexthostname)) {
								if (slotindex == nextslotindex) {
									chassis.addPortNode(nexthostname,
											nextslotindex, rs.getInt("PortIndex"),
											slotroot, rs.getString("Status"));
								} else {
									slotroot = chassis.addSlotNode(
											nexthostname, nextslotindex,
											chassisiproot);
									chassis.addPortNode(nexthostname,
											nextslotindex, rs.getInt("PortIndex"),
											slotroot, rs.getString("Status"));
								}
							} else {
								chassisiproot = chassis.addChassisIPNode(
										nexthostname, chassisroot);
								slotroot = chassis.addSlotNode(nexthostname,
										nextslotindex, chassisiproot);
								chassis.addPortNode(nexthostname, nextslotindex,
										rs.getInt("PortIndex"), slotroot, rs.getString("Status"));
									
							}
	
							hostname = nexthostname;
							slotindex = nextslotindex;
						}
					}
					
					SQLStr = "select Site, DutIpAddress, ModuleIndex, IntfName from dut_inventory_intf where Site='" + filter + "' order by DutIpAddress, ModuleIndex, IntfName";
					rs = stmt.executeQuery(SQLStr);
					
					if (rs.next()) {
						String hostname = rs.getString("DutIpAddress");
						int bladindex = rs.getInt("ModuleIndex");
						
						Element dutiproot = dut.addDUTIPNode(hostname, dutroot);
						Element bladroot = dut.addDUTBladNode(hostname, bladindex,
								dutiproot);
						dut.addDUTPortNode(hostname, rs.getString("IntfName"), bladroot);
	
						while (rs.next()) {
							String nexthostname = rs.getString("DutIpAddress");
							int nextbladindex = -1;
							try {
								String temp = rs.getString("ModuleIndex");	
								nextbladindex = Integer.parseInt(temp);
							} catch (NumberFormatException e) {
								continue;
							}
							
							if (hostname.equals(nexthostname)) {
								if (bladindex == nextbladindex) {
									dut.addDUTPortNode(nexthostname, rs.getString("IntfName"), bladroot);
								} else {
									 bladroot = dut.addDUTBladNode(nexthostname, nextbladindex,
												dutiproot);
									 dut.addDUTPortNode(nexthostname, rs.getString("IntfName"), bladroot);
								}
							} else {
								dutiproot = dut.addDUTIPNode(nexthostname, dutroot);
								bladroot = dut.addDUTBladNode(nexthostname, nextbladindex,
											dutiproot);
								dut.addDUTPortNode(nexthostname, rs.getString("IntfName"), bladroot);			
							}
							
							hostname = nexthostname;
							bladindex = nextbladindex;
						}
					}	
					
					SQLStr = "SELECT Site, VMHostName, ClientName, BladName FROM vm_client WHERE Site='" + filter + "' ORDER BY BladName, VMHostName, ClientName";
					rs = stmt.executeQuery(SQLStr);
					
					if (rs.next()) {
						String hostip = rs.getString("VMHostName");
						String bladName = rs.getString("BladName");				
						
						Element vmbladroot = vm.addBladNode(bladName, rs.getString("Site"), vmroot);
						Element vmiproot = vm.addVMServerIPNode(hostip, vmbladroot);
						vm.addVMClientNode(rs.getString("ClientName"), vmiproot);
	
						while (rs.next()) {
						    String nexthostip = rs.getString("VMHostName");
						    String nextbladName = rs.getString("BladName");
						    
							if (bladName.equals(nextbladName)) {
								if (hostip.equals(nexthostip)){
								    vm.addVMClientNode(rs.getString("ClientName"), vmiproot);
								} else {
									//vmbladroot = vm.addBladNode(nextbladName, nexthostip, vmiproot);
									vmiproot = vm.addVMServerIPNode(nexthostip, vmbladroot);
									vm.addVMClientNode(rs.getString("ClientName"), vmiproot);
								}
							} else {
								vmbladroot = vm.addBladNode(nextbladName, rs.getString("Site"), vmroot);
								vmiproot = vm.addVMServerIPNode(nexthostip, vmbladroot);
								vm.addVMClientNode(rs.getString("ClientName"), vmiproot);
							}
	
							hostip = nexthostip;
							bladName = nextbladName;
						}
					}		
					
					SQLStr = "select site, ipaddress, portindex from avl_portgroups where site='" + filter + "' order by ipaddress, portindex";
					rs = stmt.executeQuery(SQLStr);
					
					if (rs.next()) {
						String hostname = rs.getString("ipaddress");
						
						Element aviproot = av.addAVIPNode(hostname, avroot);
						av.addAVPortNode(hostname, rs.getInt("portindex"), aviproot);
	
						while (rs.next()) {
							String nexthostname = rs.getString("ipaddress");
	
								if (hostname.equals(nexthostname)) {
									av.addAVPortNode(nexthostname, rs.getInt("portindex"), aviproot);
								} else {
									aviproot = av.addAVIPNode(nexthostname, avroot);
									av.addAVPortNode(nexthostname, rs.getInt("portindex"), aviproot);
								}
	
							hostname = nexthostname;
						}
					}
					
					SQLStr = "select Site, DNSHostName, Status from lab_pcs where Site='" + filter + "' order by Site, DNSHostName";
					rs = stmt.executeQuery(SQLStr);
					
					while (rs.next()) {
						Element pciproot = pc.addPCIPNode(rs.getString("Status"),rs.getString("DNSHostName"), pcroot);
					}				
				}	
				XMLOut.output(Doc, strwriter);
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in Generate2TreeXML.java: "
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
				.println("Close DB error occourred in Generate2TreeXML.java: "
						+ e.getMessage());
        	}
        } 	
		return strwriter.toString();
	}
}
