package com.spirent.addresource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.vminforparse.GenerateVMInforXML;

public class AddResource extends HttpServlet {
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

		String cmdStr = "";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String isChassis = request.getParameter("isChassis");
				String isDUT = request.getParameter("isDUT");
				String isAV = request.getParameter("isAV");
				String isVM = request.getParameter("isVM");
				String isPC = request.getParameter("isPC");
				
				if (isChassis != null){
					String resources = request.getParameter("Resources");
				   	String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
				   	resources = resources.trim();
					Pattern pattern = Pattern.compile(regIP);
					Matcher matcher = pattern.matcher(resources);
					if (matcher.find()) {
						new AddResourceThread(InitBaseParameters.getTclPath(), resources, "Chassis").start();
						//Thread.sleep(15 * 1000);
				    }
				} else if (isDUT != null){    
	            	 String DUTResources = request.getParameter("DUTResources");
	                 String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
	                 DUTResources = DUTResources.trim();
				     Pattern pattern = Pattern.compile(regIP);
				     Matcher matcher = pattern.matcher(DUTResources);
				     if (matcher.find()) {
				    	 new AddResourceThread(InitBaseParameters.getTclPath(), DUTResources, "DUT").start();
				    	 //Thread.sleep(15 * 1000);
				     }
	            } else if (isAV != null){    
		           	 String AVResources = request.getParameter("AVResources");
		             String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
		             AVResources = AVResources.trim();
				     Pattern pattern = Pattern.compile(regIP);
				     Matcher matcher = pattern.matcher(AVResources);
				     if (matcher.find()) {
				    	 new AddResourceThread(InitBaseParameters.getTclPath(), AVResources, "AV").start();
				    	 //Thread.sleep(15 * 1000);
				     }
	            } else if (isVM != null){    
		           	 String VMResources = request.getParameter("VMResources");
		             String VMUser = request.getParameter("VMUser");
		             String VMPassword = request.getParameter("VMPassword");
		             
		             String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
		             VMResources = VMResources.trim();
		             VMUser = VMUser.trim();
		             VMPassword = VMPassword.trim();
		             
				     Pattern pattern = Pattern.compile(regIP);
				     Matcher matcher = pattern.matcher(VMResources);
				     if (matcher.find() && !VMPassword.equals("") && !VMUser.equals("")) {	
				    	 //GenerateVMInforXML vmToXML = new GenerateVMInforXML(VMResources, VMUser, VMPassword);
				    	 //vmToXML.generateServerList();
				    	 //new AddResourceThread(InitBaseParameters.getTclPath(), VMResources, "VM").start();
				    	 //Thread.sleep(15 * 1000);
				    	 
						 cmdStr = "select * from  vm_host where VMHost='"+VMResources+"'";
						 rs = stmt.executeQuery(cmdStr);
						 if (!rs.next()){
						   cmdStr = "insert into vm_host values ('','','','"+VMResources+"','','','','','','','','','','','','"+VMUser+"','"+VMPassword+"','','','','','','','')";
						   stmt.execute(cmdStr);
						 }	
				     }
	            } else if (isPC != null){    
		           	 String PCResources = request.getParameter("PCResources");
				     cmdStr = "select * from  lab_pcs where DNSHostName='"+PCResources+"'";
				     rs = stmt.executeQuery(cmdStr);
				     if (!rs.next()){
				    	cmdStr = "insert into lab_pcs values ('','','"+PCResources+"','','','','','','','','','','','','','','','','')";
				    	stmt.execute(cmdStr);
				     }	
	            } 
				
			    response.sendRedirect("/inventory/add.jsp");
			}
		} catch (Exception e) {
			System.out.print("Exception occurs in AddResource.java: "+e.getMessage());
			response.sendRedirect("/inventory/add.jsp");
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
				.println("Close DB error occourred in AddResource.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
}
