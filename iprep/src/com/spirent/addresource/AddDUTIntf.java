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

public class AddDUTIntf extends HttpServlet {
	
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
				String ModuleType = request.getParameter("ModuleType").trim();
				String IntfName = request.getParameter("IntfName").trim();
				String IntfDescr = request.getParameter("IntfDescr").trim();
				String Pid = request.getParameter("Pid");
				String ModuleSN = request.getParameter("ModuleSN").trim();
				String ModuleIndex = request.getParameter("ModuleIndex").trim();
				String Dept = request.getParameter("Dept").trim();
				int StartIndex = Integer.valueOf(request.getParameter("StartIndex")).intValue();
				int EndIndex = Integer.valueOf(request.getParameter("EndIndex")).intValue();
				//int PidStep = Integer.valueOf(request.getParameter("PidStep")).intValue();
				
				if (Dept.equals("")){
					Dept = "TBD";
				}
				String Notes = request.getParameter("Notes").trim();
				
				String parameters = "";
				String errorMsg = "";
				
				if (!IntfName.equals("") && !ModuleIndex.equals("") && !IntfName.equals("")){
					String Site = selectSite(DutIpAddress);
					for (int i=StartIndex; i<=EndIndex; i++){
						String FullInterfaceName = getIntfName(ModuleType, IntfName, i);
						
						sqlStr = "select DutIpAddress from dut_inventory_intf where DutIpAddress='"+DutIpAddress+"' and IntfName='"+FullInterfaceName+"' and ModuleIndex='"+ModuleIndex+"'";
						rs = stmt.executeQuery(sqlStr);
						if(rs.next()){
						    sqlStr = "update dut_inventory_intf set Site='"+Site+"',DutName='"+DutName+"',ModuleType='"+ModuleType+"',Dept='"+Dept+"',IntfDescr='"+IntfDescr+"',Pid='"+Pid+"',ModuleSN='"+ModuleSN+"',Notes='"+Notes+"' where DutIpAddress='"+DutIpAddress+"' and IntfName='"+FullInterfaceName+"' and ModuleIndex='"+ModuleIndex+"'";
						    stmt.execute(sqlStr);
						} else {
						    sqlStr = "insert into dut_inventory_intf values ('"+Site+"','"+Dept+"','"+DutName+"','"+DutIpAddress+"','"+Pid+"','"+IntfDescr+"','"+FullInterfaceName+"','"+ModuleIndex+"','','"+ModuleSN+"','','','"+Notes+"','','"+ModuleType+"','','','','','','')";
						    stmt.execute(sqlStr);
						}
					}
					errorMsg = "";
					parameters = "Update=true&DutIpAddress="+DutIpAddress+"&DutName="+DutName;
					parameters = parameters +"&ModuleType="+ModuleType+"&IntfName="+IntfName;
					parameters = parameters + "&IntfDescr="+IntfDescr+"&Pid="+Pid+"&ModuleSN="+ModuleSN;
					parameters = parameters + "&ModuleIndex="+ModuleIndex+"&Dept="+Dept+"&Notes="+Notes+"&errorMsg="+errorMsg;
					parameters = parameters + "&StartIndex="+StartIndex+"&EndIndex="+EndIndex;
					
					response.sendRedirect("/iprep/update/updatedutintf.jsp?"+parameters);
				} else {
					errorMsg = "* items was required!";
					parameters = "Update=true&DutIpAddress="+DutIpAddress+"&DutName="+DutName;
					parameters = parameters +"&ModuleType="+ModuleType+"&IntfName="+IntfName;
					parameters = parameters + "&IntfDescr="+IntfDescr+"&Pid="+Pid+"&ModuleSN="+ModuleSN;
					parameters = parameters + "&ModuleIndex="+ModuleIndex+"&Dept="+Dept+"&Notes="+Notes+"&errorMsg="+errorMsg;
					parameters = parameters + "&StartIndex="+StartIndex+"&EndIndex="+EndIndex;
			    	 
					response.sendRedirect("/iprep/update/updatedutintf.jsp?" +parameters);
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in AddDUTIntf.java: "
							+ e.getMessage());
			response.sendRedirect("/iprep/add.jsp");
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
				.println("Close DB error occourred in AddDUTIntf.java: "
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
    
    public String getIntfName(String ModuleType, String IntfName, int Index){
    	IntfName = ModuleType + IntfName+String.valueOf(Index).trim();
  	 return IntfName;
   }    
}
