package com.spirent.vminforparse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import com.spirent.javaconnector.DataBaseConnection;

public class XMLParse {
     public void parseXML(String fileName){
    	 SAXBuilder builder = new SAXBuilder(false);
			Connection conn = null;
			try {
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
				Statement stmt = conn.createStatement();
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();
				SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Calendar cal = Calendar.getInstance();
				Date date = cal.getTime();
				String lastscan = getCanlender(df.format(date), serverTimeOffset);
				
				String updSQL = "";
				ResultSet rs ;
				
	    		 Document doc = builder.build(fileName);
	    		 Element inventory = doc.getRootElement();
	    		 
	    		 List server = inventory.getChildren();
	    		 for(int i=0; i<server.size(); i++){	    			 
	    			 String VMHost = ((Element)server.get(i)).getChildTextTrim("networkName"); 
	    			 String Username = ((Element)server.get(i)).getChildTextTrim("id");
	    			 String Password = ((Element)server.get(i)).getChildTextTrim("password");
	    			 String ServerOSType = ((Element)server.get(i)).getChildTextTrim("osType");
	    			 String VMVersion = ((Element)server.get(i)).getChildTextTrim("version");
	    			 String TotalVMNumber = ((Element)server.get(i)).getChildTextTrim("virtualMachineCount");
	    			 String Manufacturer = ((Element)server.get(i)).getChildTextTrim("vendor");
	    			 String Site = selectSite(VMHost);
	    			 
	    			 updSQL = "SELECT VMHost FROM vm_host WHERE VMHost='" + VMHost + "'";
	    			 rs = stmt.executeQuery(updSQL);
	    			 if(rs.next()){
	    				 updSQL="UPDATE vm_host SET Site='"+Site+"', Username='"+Username+"', Password='"+Password+"', Manufacturer='"+Manufacturer+"', TotalVMNumber='"+TotalVMNumber+"', ServerOSType='"+ServerOSType+"', VMVersion='"+VMVersion+"', LastScan='"+lastscan+"' WHERE VMHost='"+VMHost+"'";
	    				 stmt.execute(updSQL);
	    			 } else {
	    				 updSQL="INSERT INTO vm_host VALUE ('"+VMHost+"','','"+Username+"','"+Password+"','"+ServerOSType+"','"+VMVersion+"','"+Site+"','TBD','"+TotalVMNumber+"','"+Manufacturer+"','','','','','','','"+lastscan+"')";
	    				 stmt.execute(updSQL);
	    			 }
	    			 
	    			 List vm = ((Element)server.get(i)).getChildren("vm");
	    			 for (int j=0; j<vm.size(); j++){
	    				 String RunState = ((Element)vm.get(j)).getChildTextTrim("runState");
	    				 String ClientName = ((Element)vm.get(j)).getChildTextTrim("name");
	    				 
	    				 if (RunState.contains("not")){
			    			 updSQL = "SELECT VMClient FROM vm_client WHERE ClientName='" + ClientName + "'";
			    			 rs = stmt.executeQuery(updSQL);
			    			 if(rs.next()){
			    				 updSQL="UPDATE vm_client SET RunState='"+RunState+"', NumberOfCPU='0' WHERE ClientName='"+ClientName+"'";	    				
			    				 stmt.execute(updSQL);
			    			 } 
	    					 continue;
	    				 } else {		    				 
		    				 String VMClient = ((Element)vm.get(j)).getChildTextTrim("ipAddress");
		    				 int NumberOfCPU = 0;
		    				 for(int x = 0; x < 10; x++){
		    					 String cpu = "cpu" + String.valueOf(x).toString();
		    					 if (((Element)vm.get(j)).getChildTextTrim(cpu) != null) {
		    						 NumberOfCPU++;
		    					 } else {
		    						 break;
		    					 }
		    				 }
		    				 String MemoryActive = "";
		    				 String MemoryConsumed = "";
		    				 if (VMVersion.contains("3.5")){
			    				 MemoryActive = ((Element)vm.get(j)).getChildTextTrim("MemoryActiveAverage");
			    				 MemoryConsumed = ((Element)vm.get(j)).getChildTextTrim("MemoryConsumedAverage");
		    				 } else if (VMVersion.contains("4.0")){
		    				     MemoryActive = ((Element)vm.get(j)).getChildTextTrim("MemoryActive");
		    				     MemoryConsumed = ((Element)vm.get(j)).getChildTextTrim("MemoryConsumed");
		    				 }
		    				 int Memory = Integer.valueOf(MemoryActive).intValue() + Integer.valueOf(MemoryConsumed).intValue();
			    			 
			    			 updSQL = "SELECT VMClient FROM vm_client WHERE VMClient='" + VMClient + "'";
			    			 rs = stmt.executeQuery(updSQL);
			    			 if(rs.next()){
			    				 updSQL="UPDATE vm_client SET Site='"+Site+"', ClientName='"+ClientName+"', NumberOfCPU='"+NumberOfCPU+"', Memory='"+Memory+"', VMHost='"+VMHost+"', RunState='";
			    				 updSQL=updSQL+RunState+"', MemoryActive='"+MemoryActive+"', MemoryConsumed='"+MemoryConsumed+"', LastScan='"+lastscan+"' WHERE VMClient='"+VMClient+"'";	    				
			    				 stmt.execute(updSQL);
			    			 } else {
			    				 updSQL="INSERT INTO vm_client VALUE ('"+VMClient+"','"+ClientName+"','0.0.0.0','Standalone','"+RunState+"','','"+NumberOfCPU+"','','"+Memory+"','"+MemoryActive+"','"+MemoryConsumed+"','"+Site+"','TBD','"+VMHost+"','','','"+lastscan+"')";
			    				 stmt.execute(updSQL);
			    			 }			    			
	    				 }
	    			 }
	    		 }
	 			DataBaseConnection.freeConnection(conn);
				} 
    	 }catch (JDOMException e){
				System.out
				.println("JDOM error occourred in XMLParse.java.");
    		 e.printStackTrace();
    	 }catch (IOException e){
				System.out
				.println("IO error occourred in XMLParse.java.");
    		 e.printStackTrace();
    	 }catch (Exception e) {
				System.out
				.println("Error occourred in XMLParse.java: "
						+ e.getMessage());
		 } 
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
     
	 public String getCanlender(String dateString, int timeOffset){
		  Calendar cal = Calendar.getInstance();
		  String[] splitDateString = dateString.split(" ");
		  String[] splitDate = splitDateString[0].split("-");
		  int year = Integer.parseInt(splitDate[0]);
		  int month = Integer.parseInt(splitDate[1]);
		  int day = Integer.parseInt(splitDate[2]);
		  
		  String[] splitTime = splitDateString[1].split(":");
		  int hour = Integer.parseInt(splitTime[0]);
		  int minute = Integer.parseInt(splitTime[1]);
		  int second = Integer.parseInt("00");
		  
		  cal.set(Calendar.YEAR, year);
		  cal.set(Calendar.MONTH, month-1);
		  cal.set(Calendar.DAY_OF_MONTH, day);
		  
		  cal.set(Calendar.HOUR_OF_DAY, hour);
		  cal.set(Calendar.MINUTE, minute);
		  cal.set(Calendar.SECOND, second);
		  
		  SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		  Date date = cal.getTime();
		 
		  cal.add(Calendar.MINUTE, timeOffset);
		  date = cal.getTime();
		  
		  return df.format(date);
		 }
     
     /*public static void main(String[] args) {
		try {
			XMLParse j2x = new XMLParse();
			j2x.parseXML("C:/WorkSpace/MainLine/LRS/iprep/WebRoot/common/scripts/vm/inventorylist.xml");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/
}
