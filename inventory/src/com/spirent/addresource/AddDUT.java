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

import com.spirent.javaconnector.DataBaseConnection;

public class AddDUT extends HttpServlet {
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				String sqlStr = "";
				
				String DutIpAddress = request.getParameter("DutIpAddress").trim();
				String DutName = request.getParameter("DutName").trim();
				String BladeCount = request.getParameter("BladeCount").trim();
				String IosVersion = request.getParameter("IosVersion").trim();
				String IosImage = request.getParameter("IosImage").trim();
				String Status = request.getParameter("Status").trim();
				String SN = request.getParameter("SN").trim();
				String Vendor = request.getParameter("Vendor").trim();
				String DutChassisDescr = request.getParameter("DutChassisDescr").trim();
				String DutPid = request.getParameter("DutPid").trim();
				String Dept = request.getParameter("Dept").trim();
				
				String EnginePN = request.getParameter("EnginePN").trim();
				String EngineDescr = request.getParameter("EngineDescr").trim();
				String EngineSN = request.getParameter("EngineSN").trim();
				String SerialPortAccess = request.getParameter("SerialPortAccess").trim();
				String LoginName = request.getParameter("LoginName");
				String LoginPassword = request.getParameter("LoginPassword").trim();
				String LoginEnablePassword = request.getParameter("LoginEnablePassword").trim();
				
				if (Dept.equals("")){
					Dept = "TBD";
				}
				String Notes = request.getParameter("Notes").trim();
				
				String parameters = "";
				String errorMsg = "";
				
			   	String regIP = "^\\d+\\.\\d+\\.\\d+\\.\\d+$";
			   	DutIpAddress = DutIpAddress.trim();
				Pattern pattern = Pattern.compile(regIP);
				Matcher matcher = pattern.matcher(DutIpAddress);
				if (matcher.find()) {
					if (!DutIpAddress.equals("")){
						String Site = selectSite(DutIpAddress);
						sqlStr = "select DutIpAddress from dut_inventory where DutIpAddress='"+DutIpAddress+"'";
						rs = stmt.executeQuery(sqlStr);
						if (rs.next()){
						    sqlStr = "update dut_inventory set Site='"+Site+"',DutName='"+DutName+"',Vendor='"+Vendor+"',BladeCount='"+BladeCount+"',IosVersion='"+IosVersion+"',Dept='"+Dept+"',Status='"+Status+"',IosImage='"+IosImage+"',SN='"+SN+"',DutChassisDescr='"+DutChassisDescr+"',SerialPortAccess='"+SerialPortAccess+"',LoginName='"+LoginName+"',LoginPassword='"+LoginPassword+"',LoginEnabledPassword='"+LoginEnablePassword+"',DutPid='"+DutPid+"',Notes='"+Notes+"' where DutIpAddress='"+DutIpAddress+"'";
					        stmt.execute(sqlStr);
						} else {
							sqlStr = "insert into dut_inventory values ('"+Site+"','"+Dept+"','"+DutName+"','"+DutIpAddress+"','"+Vendor+"','"+DutPid+"','"+DutChassisDescr+"','"+SN+"','"+EnginePN+"','"+EngineDescr+"','"+EngineSN+"','"+BladeCount+"','"+IosVersion+"','"+IosImage+"','"+Status+"','"+SerialPortAccess+"','"+Notes+"','','"+LoginName+"','"+LoginPassword+"','"+LoginEnablePassword+"','')";
						    stmt.execute(sqlStr);
						}
						
						errorMsg = "";
						parameters = "UpdateFromDUT=true&DutIpAddress="+DutIpAddress+"&DutName="+DutName+"&Dept="+Dept+"&errorMsg="+errorMsg;
						
						response.sendRedirect("/inventory/update/updatedutintf.jsp?"+parameters);
					} else {
						errorMsg = "* items was required!";
						parameters = "Update=true&DutIpAddress="+DutIpAddress+"&DutName="+DutName;
						parameters = parameters + "&BladeCount="+BladeCount+"&IosVersion="+IosVersion+"&IosImage="+IosImage;
						parameters = parameters + "&Status="+Status+"&SN="+SN+"&Vendor="+Vendor+"&DutChassisDescr="+DutChassisDescr;
						parameters = parameters + "&EnginePN="+EnginePN+"&EngineDescr="+EngineDescr+"&EngineSN="+EngineSN+"&SerialPortAccess="+SerialPortAccess;
						parameters = parameters + "&LoginName="+LoginName+"&LoginPassword="+LoginPassword+"&LoginEnablePassword="+LoginEnablePassword;
						parameters = parameters + "&DutPid="+DutPid+"&Dept="+Dept+"&Notes="+Notes+"&errorMsg="+errorMsg;					
						response.sendRedirect("/inventory/update/updatedut.jsp?" +parameters);
					}
					
			    } else {
					errorMsg = "DUT IP Address must be right!";
					parameters = "Update=true&DutIpAddress="+DutIpAddress+"&DutName="+DutName;
					parameters = parameters + "&BladeCount="+BladeCount+"&IosVersion="+IosVersion+"&IosImage="+IosImage;
					parameters = parameters + "&Status="+Status+"&SN="+SN+"&Vendor="+Vendor+"&DutChassisDescr="+DutChassisDescr;
					parameters = parameters + "&EnginePN="+EnginePN+"&EngineDescr="+EngineDescr+"&EngineSN="+EngineSN+"&SerialPortAccess="+SerialPortAccess;
					parameters = parameters + "&LoginName="+LoginName+"&LoginPassword="+LoginPassword+"&LoginEnablePassword="+LoginEnablePassword;
					parameters = parameters + "&DutPid="+DutPid+"&Dept="+Dept+"&Notes="+Notes+"&errorMsg="+errorMsg;
			    	 response.sendRedirect("/inventory/update/updatedut.jsp?" +parameters);
			    }	
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in AddDUT.java: "
							+ e.getMessage());
			response.sendRedirect("/inventory/add.jsp");
		} finally {
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
				.println("Close DB error occourred in AddDUT.java: "
						+ e.getMessage());
        	}
        } 
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
	}
	
    public String selectSite(String ipAddress){
   	 String site = "";
	     if (Pattern.matches("^10.14.*", ipAddress)){
	    	 site = "HNL";
	     } else if (Pattern.matches("^10.100.*", ipAddress)){
	    	 site = "CAL";
	     } else if (Pattern.matches("^10.61.*", ipAddress)){
	    	 site = "CHN";
	     } else if (Pattern.matches("^10.47.*", ipAddress)){
	    	 site = "SNV";
	     } else if (Pattern.matches("^10.6.*", ipAddress)){
	    	 site = "RTP";
	     }
   	 return site;
    }
}
