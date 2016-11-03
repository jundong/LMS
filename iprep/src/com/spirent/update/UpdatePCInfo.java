package com.spirent.update;

import java.util.TimerTask;

import javax.servlet.ServletContext;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.stream.StreamGobbler;

public class UpdatePCInfo extends TimerTask {
	private ServletContext context = null;
	
	public UpdatePCInfo(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
    	   try {
				Process process = null;
				String cmdStr = "";
			    
			    cmdStr = "cmd /c " + InitBaseParameters.getTclPath() + "labpc.vbs"; 
				process = Runtime.getRuntime().exec(cmdStr);
				new StreamGobbler(process.getInputStream(),"INFO",InitBaseParameters.getTclPath()).updatePC();
				process.waitFor();
			    process.destroy();
			    process = null;
		    
	   	   } catch (Exception e) {
	   		    System.out.println("Error occurred in UpdatePCInfo.java!");
			    e.printStackTrace();
	       }
    }
}
