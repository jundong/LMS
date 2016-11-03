package com.spirent.update;

import java.util.TimerTask;

import javax.servlet.ServletContext;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.stream.StreamGobbler;

public class UpdateChassisCal extends TimerTask {
	private ServletContext context = null;
	
	public UpdateChassisCal(ServletContext context){
	   this.context = context;
	}
	   
    public void run() {	   
    	   try {
				Process process = null;
				String cmdStr = "";
			    cmdStr = "cmd /c tclsh  " + InitBaseParameters.getTclPath() + "scan_cal.tcl";
				process = Runtime.getRuntime().exec(cmdStr);
				new StreamGobbler(process.getInputStream(),"INFO",InitBaseParameters.getTclPath()).updateChassis();
				process.waitFor();
			    process.destroy();
			    process = null;
		    
	   	   } catch (Exception e) {
	   		   System.out.println("Error occurred in scan_cal.tcl!");
			    e.printStackTrace();
	       }
    }
}

