package com.spirent.update;

import java.io.File;
import java.io.FileWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.TimerTask;

import javax.servlet.ServletContext;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.javaconnector.DataBaseConnection;
import com.spirent.stream.StreamGobbler;
import com.spirent.vminforparse.GenerateVMInforXML;
import com.spirent.vminforparse.XMLParse;

public class UpdateVMInfo extends TimerTask {
	private ServletContext context = null;
	
	public UpdateVMInfo(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
			Connection conn = null;
			GenerateVMInforXML vmXML = new GenerateVMInforXML();
	    	Element root = new Element("hypervisors");
	    	Document Doc = new Document(root);
			try {    
				FileWriter fw=new FileWriter(InitBaseParameters.getTclPath() + "vm/serverlist.xml");
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
				Statement stmt = conn.createStatement();
				String queryStr = "SELECT * FROM vm_host ORDER BY VMHost";
				ResultSet rs = stmt.executeQuery(queryStr);
				
				while (rs.next()){
					Element server = vmXML.addServerNode(root);
					vmXML.addServerInfor(server, rs.getString("VMHost"),rs.getString("Username"),rs.getString("Password"));
				}
				
	    		XMLOutputter XMLOut = new XMLOutputter();
	    		StringWriter strwriter = new StringWriter();
	    		XMLOut.output(Doc, strwriter);
	    		
	    		fw.write(strwriter.toString());
	    		fw.close();
				DataBaseConnection.freeConnection(conn);
			}
	   	     } catch (Exception e) {
	   		    System.out.println("Error occurred in UpdateVMInfo.java!");
			    e.printStackTrace();
	         }
	    
	        try {
				Process process = null;
				String cmdStr = "";
				deleteFile(InitBaseParameters.getTclPath() + "vm/inventorylist.xml"); 
				cmdStr = "cmd /c " + InitBaseParameters.getTclPath() + "vm/vminventory.exe -p " + InitBaseParameters.getTclPath() + "vm/serverlist.xml >>" + InitBaseParameters.getTclPath() + "vm/inventorylist.xml";
				process = Runtime.getRuntime().exec(cmdStr);
				new StreamGobbler(process.getInputStream(),"INFO",InitBaseParameters.getTclPath()).updateVM();
				process.waitFor();
			    process.destroy();
			    process = null;			   		  
	       
			    XMLParse updateVM = new XMLParse();
			    updateVM.parseXML(InitBaseParameters.getTclPath() + "vm/inventorylist.xml");
			    
	        } catch (Exception e) {
	   		    System.out.println("Error occurred in UpdateVMInfo.java!");
			    e.printStackTrace();
	        }
    }
    
    public void deleteFile(String fileName){
    	File f1 = new File(fileName);
    	if(f1.exists()){
    		f1.delete();
    	}
    }
}
