package com.spirent.update;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

import com.spirent.javaconnector.DataBaseConnection;

public class UpdateVMLocation extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String ip = request.getParameter("ip");
				String type = request.getParameter("type");
				String newLocation = request.getParameter("newLocation");
				
				String tableName = "";
				String primaryKey = "";
				String redirect = ""; 
				
				if(type.equals("VM")){
					tableName = "vm_host";
					primaryKey = "VMHost";
					redirect = "vmhost.jsp"; 
				} else if(type.equals("PC")){
					tableName = "lab_pcs";
					primaryKey = "DNSHostName";
					redirect = "pc.jsp"; 
				} else if(type.equals("DUT")){
					tableName = "dut_inventory";
					primaryKey = "DutIpAddress";
					redirect = "dut.jsp"; 
				} else if(type.equals("Chassis")){
					tableName = "stc_inventory_chassis";
					primaryKey = "Hostname";
					redirect = "chassis.jsp"; 
				} else if(type.equals("AV")){
					tableName = "avl_appliances";
					primaryKey = "ipaddress";
					redirect = "av.jsp"; 
				} 
				
				String sql = "UPDATE " + tableName + " SET Location='" + newLocation 
							 + "' WHERE " + primaryKey + "='" + ip + "'";
				
				System.out.println(type);
				
				stmt.execute(sql);
				response.sendRedirect("/inventory/tree/" + redirect + "?Site="+request.getSession().getAttribute("loginsite"));
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
