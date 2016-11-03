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

public class UpdateVMNotes extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		String sqlStr = "";
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String isVM = request.getParameter("isVM");
				String isVMClient = request.getParameter("isVMClient");
				String isPC = request.getParameter("isPC");
				String isDUT = request.getParameter("isDUT");
				String isDUTSerPort = request.getParameter("isDUTSerPort");
				String isDUTIntf = request.getParameter("isDUTIntf");
				String isChassis = request.getParameter("isChassis");
				String isModule = request.getParameter("isModule");
				String isPort = request.getParameter("isPort");
				String isAV = request.getParameter("isAV");
				String isAVPort = request.getParameter("isAVPort");
				
				if (isVM != null){
					String VMNotes = request.getParameter("VMNotes");
					String VMIp = request.getParameter("VMIp");
						
					sqlStr = "UPDATE vm_host SET Notes ='"
							+ VMNotes.trim() + "' WHERE VMHost ='" + VMIp.trim() + "'";
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/vmhost.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isVMClient != null){
					String VMClientNotes = request.getParameter("VMClientNotes");
					String VMClientIp = request.getParameter("VMClientIp");

					sqlStr = "UPDATE vm_client SET Notes ='"
							+ VMClientNotes.trim()
							+ "' WHERE VMClient ='"
							+ VMClientIp.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/vmclient.jsp?ClientIp="+VMClientIp.trim());
                } else if (isPC != null){
					String PCNotes = request.getParameter("PCNotes");
					String PCName = request.getParameter("PCName");

					sqlStr = "UPDATE lab_pcs SET Notes ='"
							+ PCNotes.trim()
							+ "' WHERE DNSHostName ='"
							+ PCName.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/pc.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isDUT != null){
					String DUTNotes = request.getParameter("DUTNotes");
					String DUTIp = request.getParameter("DUTIp");

					sqlStr = "UPDATE dut_inventory SET Notes ='"
							+ DUTNotes.trim()
							+ "' WHERE DutIpAddress ='"
							+ DUTIp.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/dut.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isDUTSerPort != null){
					String SerialPortAccess = request.getParameter("SerialPortAccess");
					String DutSerialIp = request.getParameter("DutSerialIp");
					String FullSerialPortAccess = DutSerialIp.trim()+":"+SerialPortAccess.trim();

					sqlStr = "UPDATE dut_inventory SET SerialPortAccess ='"
							+ FullSerialPortAccess
							+ "' WHERE DutIpAddress ='"
							+ DutSerialIp.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/dut.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isDUTIntf != null){
					String DUTIntfNotes = request.getParameter("DUTIntfNotes");
					String DUTIntfName = request.getParameter("DUTIntfName");
					String DUTIntfIP = request.getParameter("DUTIntfIP");

					sqlStr = "UPDATE dut_inventory_intf SET Notes ='"
							+ DUTIntfNotes.trim()
							+ "' WHERE IntfName ='"
							+ DUTIntfName.trim()
							+ "' AND DutIpAddress ='"
							+ DUTIntfIP.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/dutIntf.jsp?Ip="+DUTIntfIP.trim());
                }  else if (isChassis != null){
					String ChIP = request.getParameter("ChIP");
					String ChassisNotes = request.getParameter("ChassisNotes");

					sqlStr = "UPDATE stc_inventory_chassis SET Notes ='"
							+ ChassisNotes.trim()
							+ "' WHERE Hostname ='"
							+ ChIP.trim() + "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/chassis.jsp?Site="+request.getSession().getAttribute("loginsite"));
                }  else if (isModule != null){
					String ChSlotIP = request.getParameter("ChSlotIP");
					String SlotIndex = request.getParameter("SlotIndex");
					String SlotNotes = request.getParameter("SlotNotes");

					sqlStr = "UPDATE stc_inventory_testmodule SET Notes ='"
							+ SlotNotes.trim()
							+ "' WHERE Hostname ='"
							+ ChSlotIP.trim()
							+ "' AND SlotIndex ='"
							+ SlotIndex.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/slot.jsp?Ip="+ChSlotIP.trim());
                } else if (isPort != null){
					String ChPortIP = request.getParameter("ChPortIP");
					String ChSlotPortIndex = request.getParameter("ChSlotPortIndex");
					String ChPortIndex = request.getParameter("ChPortIndex");
					String PortNotes = request.getParameter("PortNotes");

					sqlStr = "UPDATE stc_inventory_portgroup SET Notes ='"
							+ PortNotes.trim()
							+ "' WHERE Hostname ='"
							+ ChPortIP.trim()
							+ "' AND SlotIndex ='"
							+ ChSlotPortIndex.trim()
							+ "' AND PortIndex ='"
							+ ChPortIndex.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/port.jsp?Ip="+ChPortIP.trim());
                } else if (isAV != null){
					String AVIp = request.getParameter("AVIp");
					String AVNotes = request.getParameter("AVNotes");

					sqlStr = "UPDATE avl_appliances SET Notes ='"
							+ AVNotes.trim()
							+ "' WHERE ipaddress ='"
							+ AVIp.trim()
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/av.jsp?Site="+request.getSession().getAttribute("loginsite"));
                } else if (isAVPort != null){
					String AVPortIp = request.getParameter("AVPortIp");
					String AVPortGP = request.getParameter("AVPortGP");
					String AVPort = request.getParameter("AVPort");
					String AVPortNotes = request.getParameter("AVPortNotes");

					sqlStr = "UPDATE avl_portgroups SET Notes ='"
							+ AVPortNotes.trim()
							+ "' WHERE ipaddress ='"
							+ AVPortIp.trim()
							+ "' AND portgroupindex ='"
							+ AVPortGP.trim()
							+ "' AND portindex ='"
							+ AVPort.trim()							
							+ "'"; 							
					stmt.execute(sqlStr);
					
					response.sendRedirect("/iprep/tree/avport.jsp?Ip="+AVPortIp.trim());
                }
			}
		} catch (Exception e) {
			System.out.println("Error occourred in UpdateVMNotes.java: "
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
				.println("Close DB error occourred in UpdateVMNotes.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
}
