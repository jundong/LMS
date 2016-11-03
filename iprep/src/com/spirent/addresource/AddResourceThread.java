package com.spirent.addresource;

import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.stream.StreamGobbler;
//import com.spirent.vminforparse.XMLParse;

public class AddResourceThread extends Thread {
    private String path = "";
    private String resource = "";
    private String type = "";
    
    public AddResourceThread(String path, String resource, String type) {
	   this.path = path;
	   this.resource = resource;
	   this.type = type;
    }
	public String getPath() {
		return path;
	}
	
	public void run(){
		Process process = null;
		String cmdStr = "";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
				
				if (getType().equals("Chassis")){
				    cmdStr = "cmd /c tclsh  " + getPath()
					+ "Stc_Inventory_Add.tcl  " + getResource();
			
					process = Runtime.getRuntime().exec(cmdStr);
					new StreamGobbler(process.getInputStream(),"INFO",getPath()).run();
					process.waitFor();
				    process.destroy();
				    
				    cmdStr = "select * from  stc_inventory_chassis  where Hostname='"+getResource()+"'";
				    rs = stmt.executeQuery(cmdStr);
				    if (!rs.next()){
				    	cmdStr = "insert into stc_inventory_chassis values ('','','"+getResource()+"','','','','','','','','','','','','','','','','','','')";
				    	stmt.execute(cmdStr);
				    }
				    
				} else if (getType().equals("DUT")){
		             cmdStr = "cmd /c tclsh  " + getPath()
				        + "Dut_Inventory_Add.tcl  " + getResource();
				 
					 process = Runtime.getRuntime().exec(cmdStr);
					 new StreamGobbler(process.getInputStream(),"INFO",getPath()).run();
				     process.waitFor();
				     process.destroy();
				     
				} else if (getType().equals("AV")){
		             cmdStr = "cmd /c tclsh  " + getPath()
				        + "Avl_scanner_Add.tcl  " + getResource();
				 
					 process = Runtime.getRuntime().exec(cmdStr);
					 new StreamGobbler(process.getInputStream(),"INFO",getPath()).run();
				     process.waitFor();
				     process.destroy();
				     
				    cmdStr = "select * from  avl_appliances  where ipaddress='"+getResource()+"'";
				    rs = stmt.executeQuery(cmdStr);
				    if (!rs.next()){
				    	cmdStr = "insert into avl_appliances values ('','','"+getResource()+"','','','','','','','','','','','','','','','','','','','','','','')";
				    	stmt.execute(cmdStr);
				    }			     
				     
				} 	    
			    process = null;
		    }
		} catch (Exception e) {
			System.out.print("Exception occurs in AddResourceThread.java: "+e.getMessage());
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
				.println("Close DB error occourred in AddResourceThread.java: "
						+ e.getMessage());
        	}
        } 
	}
	public String getResource() {
		return resource;
	}
	public String getType() {
		return type;
	}
    public void deleteFile(String fileName){
    	File f1 = new File(fileName);
    	if(f1.exists()){
    		f1.delete();
    	}
    }
}
