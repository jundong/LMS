package com.spirent.update;

import java.util.regex.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class UpdateResource extends HttpServlet {
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
				String isVM = request.getParameter("isVM");
				String isAV = request.getParameter("isAV");
				String isPC = request.getParameter("isPC");
				if (isChassis != null){
					String Dept = request.getParameter("Department").trim();
					String Hostname = request.getParameter("Ip").trim();
	
					String updChassis = "UPDATE stc_inventory_chassis SET Dept ='"
							+ Dept + "' WHERE Hostname ='" + Hostname + "'";
					stmt.execute(updChassis);

					String updTestModule = "UPDATE stc_inventory_testmodule SET Dept ='"
							+ Dept
							+ "' WHERE Hostname ='"
							+ Hostname
							+ "'"; 
							
					stmt.execute(updTestModule);
					String updPortGroup = "UPDATE stc_inventory_portgroup SET Dept ='"
							+ Dept
							+ "' WHERE Hostname ='"
							+ Hostname
							+ "'";
					stmt.execute(updPortGroup);
					
					response.sendRedirect("/inventory/tree/chassis.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isDUT != null){  
					String DUT = request.getParameter("DUTIp").trim();
					String DUTDept = request.getParameter("DUTDepartment").trim();
						
				   	String updDUT = "UPDATE dut_inventory SET Dept ='"
							+ DUTDept + "' WHERE DutIpAddress ='" + DUT + "'";
					stmt.execute(updDUT);

					String updDUTInv = "UPDATE dut_inventory_intf SET Dept ='"
								+ DUTDept
								+ "' WHERE DutIpAddress ='"
								+ DUT
								+ "'"; 
								
					stmt.execute(updDUTInv);
					
					response.sendRedirect("/inventory/tree/dut.jsp?Ip="+DUT);
				} else if (isVM != null){
					String VMDept = request.getParameter("VMDepartment").trim();
					String VMHostname = request.getParameter("VMIp").trim();
						
					String updVMStr = "UPDATE vm_client SET Dept ='"
							+ VMDept + "' WHERE VMHost ='" + VMHostname + "'";
					stmt.execute(updVMStr);

					updVMStr = "UPDATE vm_host SET Dept ='"
							+ VMDept
							+ "' WHERE VMHost ='"
							+ VMHostname
							+ "'"; 							
					stmt.execute(updVMStr);
					
					response.sendRedirect("/inventory/tree/vmhost.jsp?Site="+request.getSession().getAttribute("loginsite"));
                }  else if (isAV != null){
					String AVDept = request.getParameter("AVDepartment").trim();
					String AVHostname = request.getParameter("AVIp").trim();
						
					String updappliances = "UPDATE avl_appliances SET dept ='"
							+ AVDept + "' WHERE ipaddress ='" + AVHostname + "'";
					stmt.execute(updappliances);

					String updavport = "UPDATE avl_portgroups SET dept ='"
							+ AVDept
							+ "' WHERE ipaddress ='"
							+ AVHostname
							+ "'"; 
							
					stmt.execute(updavport);
					
					response.sendRedirect("/inventory/tree/av.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isPC != null){
					String PCDept = request.getParameter("PCDepartment").trim();
					String PCHostname = request.getParameter("PCIp").trim();
						
					String updpcs = "UPDATE lab_pcs SET dept ='"
							+ PCDept + "' WHERE DNSHostName ='" + PCHostname + "'";
					stmt.execute(updpcs);

					response.sendRedirect("/inventory/tree/pc.jsp?Site="+request.getSession().getAttribute("loginsite"));
                }
			}
		} catch (Exception e) {
			System.out.println("Error occourred in UpdateResource.java: "
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
				.println("Close DB error occourred in UpdateResource.java: "
						+ e.getMessage());
        	}
        }  
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
}
