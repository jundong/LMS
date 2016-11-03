package com.spirent.addresource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.jspsmart.upload.*;


import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.jsp.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.javaconnector.DataBaseConnection;

public class AddTestBed extends HttpServlet {
	
	private ServletConfig config;
    private static final String CONTENT_TYPE = "text/html; charset=ISO-8859-1";
    private static final String UPLOAD_FOLDER = "/common/imgs/";
    //Initialize global variables
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.config = config;
    }
    final public ServletConfig getServletConfig() {
        return config;
    }
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sqlStr = "";
		String update = "";
		String TestBedIndex = "";
		String path = getServletContext().getRealPath("/");
		String fileName = "";
		
		try {
			SmartUpload su = new SmartUpload();
		    su.initialize(getServletConfig(), request,response);
		    su.setMaxFileSize(200000);
		    su.setAllowedFilesList("jpg,jpeg,gif,png,JPG,JPEG,GIF,PNG");
		    su.upload();
		    
		    TestBedIndex = su.getRequest().getParameter("TestBedIndex");
		    if(su.getRequest().getParameter("update") != null)
				update = su.getRequest().getParameter("update").trim();
		    
		    if(su.getFiles().getCount() > 0) {
			    com.jspsmart.upload.File file = su.getFiles().getFile(0);
			    String extension = file.getFileExt();
	
			    if(!extension.isEmpty()) {
				    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-ddHHmmss");
				    String timestamp = df.format(new Date());
				    fileName = UPLOAD_FOLDER + timestamp + "." + extension;
				    file.saveAs( fileName,SmartUpload.SAVE_VIRTUAL);
			    }
		    }
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				String TestBedName = su.getRequest().getParameter("TestBedName").trim();
			    String Description = su.getRequest().getParameter("Description").trim();
			    String ImageLoc = fileName;
			    String Location = su.getRequest().getParameter("Location").trim();
			    String SpirentEquipment = su.getRequest().getParameter("SpirentEquipment").trim();
			    String CompeteEquipment = su.getRequest().getParameter("CompeteEquipment").trim();
			    String DutEquipment = su.getRequest().getParameter("DutEquipment").trim();
			    String Notes = su.getRequest().getParameter("Notes").trim();
			    	    				
			   	if(update.isEmpty()) {
			   		sqlStr = "INSERT INTO iprep_testbed VALUES(null,'"+TestBedName+"','"+Description+"','"
			   		+ImageLoc+"','"+Location+"','','','','"+SpirentEquipment+"','"+CompeteEquipment+"','"+DutEquipment+"','"+Notes+"')";
			   	} else {
			   		if(!fileName.isEmpty()) {
				   		sqlStr = "SELECT ImageLoc FROM iprep_testbed WHERE TestBedIndex="+TestBedIndex;
				   		rs = stmt.executeQuery(sqlStr);
				   		if(rs.next()) {
					   		java.io.File f = new java.io.File(path.substring(0,path.length()-1) + rs.getString("ImageLoc"));
					   		if(f.exists())
					   			f.delete();
				   		}
				   		sqlStr = "UPDATE iprep_testbed SET TestBedName='"+TestBedName+
				   		"',Description='"+Description+
				   		"',ImageLoc='"+ImageLoc+
				   		"',Location='"+Location+
				   		"',SpirentEquipment='"+SpirentEquipment+
				   		"',CompeteEquipment='"+CompeteEquipment+
				   		"',DutEquipment='"+DutEquipment+
				   		"',Notes='"+Notes+"' WHERE TestBedIndex="+TestBedIndex;
			   		} else {
			   			sqlStr = "UPDATE iprep_testbed SET TestBedName='"+TestBedName+
				   		"',Description='"+Description+
				   		"',Location='"+Location+
				   		"',SpirentEquipment='"+SpirentEquipment+
				   		"',CompeteEquipment='"+CompeteEquipment+
				   		"',DutEquipment='"+DutEquipment+
				   		"',Notes='"+Notes+"' WHERE TestBedIndex="+TestBedIndex;
			   		}
			   	}
			   	stmt.execute(sqlStr);
			   	response.sendRedirect("/iprep/update/updateTestBed.jsp");
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in AddTestBed.java: "
							+ e.getMessage());
			if(update.isEmpty())
				response.sendRedirect("/iprep/update/updateTestBed.jsp");
			else
				response.sendRedirect("/iprep/update/updateTestBed.jsp?Update=true&TestBedIndex="+TestBedIndex);
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
		doPost(request,response);
	}
}
