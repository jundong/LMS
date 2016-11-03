package com.spirent.deleteresource;

import java.util.regex.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class DeleteResource extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
			try {
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					String isChassis = request.getParameter("isChassis");
					String isDUT = request.getParameter("isDUT");
					String isAV = request.getParameter("isAV");
					String isVM = request.getParameter("isVM");
					String isPC = request.getParameter("isPC");
					String isDUTIntf = request.getParameter("isDUTIntf");
					String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
					
					if (isChassis != null){
						String resources = request.getParameter("Resources");
					   	resources = resources.trim();
						Pattern pattern = Pattern.compile(regIP);
						Matcher matcher = pattern.matcher(resources);
						if (matcher.find()) {			
							String delChassisStr = "delete from stc_inventory_chassis where Hostname='" + resources + "'";
							String delTestModuleStr = "delete from stc_inventory_testmodule where Hostname='" + resources + "'";
			                String delPortGroupStr = "delete from stc_inventory_portgroup where Hostname='" + resources + "'";
			                stmt.execute(delChassisStr);
			                stmt.execute(delTestModuleStr);
			                stmt.execute(delPortGroupStr);
		                }
	                } else if (isDUT != null){  
						 String DUTResources = request.getParameter("DUTResources");
	                     DUTResources = DUTResources.trim();
					     Pattern pattern = Pattern.compile(regIP);
					     Matcher matcher = pattern.matcher(DUTResources);
					     if (matcher.find()) {
		                   	String delDUTStr = "delete from dut_inventory where DutIpAddress='" + DUTResources + "'";
							String delDUTIntfStr = "delete from dut_inventory_intf where DutIpAddress='" + DUTResources + "'";
			                stmt.execute(delDUTStr);
			                stmt.execute(delDUTIntfStr);
		                }
					} else if (isAV != null){  
						 String AVResources = request.getParameter("AVResources");
						 AVResources = AVResources.trim();
					     Pattern pattern = Pattern.compile(regIP);
					     Matcher matcher = pattern.matcher(AVResources);
					     if (matcher.find()) {
		                   	String delAVStr = "delete from avl_appliances where ipaddress='" + AVResources + "'";
							String delAVPortStr = "delete from avl_portgroups where ipaddress='" + AVResources + "'";
			                stmt.execute(delAVStr);
			                stmt.execute(delAVPortStr);
		                }
					} else if (isVM != null){  
						 String VMResources = request.getParameter("VMResources");
						 VMResources = VMResources.trim();
					     Pattern pattern = Pattern.compile(regIP);
					     Matcher matcher = pattern.matcher(VMResources);
					     if (matcher.find()) {
		                   	String delVMStr = "delete from vm_host where VMHost='" + VMResources + "'";
							stmt.execute(delVMStr);
							
		                   	delVMStr = "delete from vm_client where VMHost='" + VMResources + "'";
							stmt.execute(delVMStr);
		                }
					} else if (isPC != null){  
						 String PCResources = request.getParameter("PCResources");
						 PCResources = PCResources.trim();
					     Pattern pattern = Pattern.compile(regIP);
					     Matcher matcher = pattern.matcher(PCResources);
					     if (matcher.find()) {
		                   	String delPCStr = "delete from lab_pcs where DNSHostName='" + PCResources + "'";
							stmt.execute(delPCStr);
		                }
					} else if (isDUTIntf != null){  
						 String DUTIntfResources = request.getParameter("DUTIntfResources");
						 String DUTIntfIPResources = request.getParameter("DUTIntfIPResources");
						 DUTIntfResources = DUTIntfResources.trim();
	
		                 String delPCStr = "delete from dut_inventory_intf where DutIpAddress='" + DUTIntfIPResources + "' and IntfName='"+DUTIntfResources+"'";
						 stmt.execute(delPCStr);
					}
	               response.sendRedirect("/inventory/delete.jsp");
				}
			} catch (Exception e) {
				System.out
						.println("Error occourred in DeleteResource.java: "
								+ e.getMessage());
				response.sendRedirect("/inventory/delete.jsp");
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
					.println("Close DB error occourred in DeleteResource.java: "
							+ e.getMessage());
	        	}
	        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
}
