package com.spirent.timer;

import java.util.Calendar;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.spirent.initparameters.InitBaseParameters;
import com.spirent.notification.LoanerEndNotification;
import com.spirent.notification.Reminder;
import com.spirent.update.UpdateAVInfo;
import com.spirent.update.UpdateChassisInfo;
import com.spirent.update.UpdateChassisStatus;
import com.spirent.utilization.ConnectionMap;
import com.spirent.utilization.MonitoringChassis;
import com.spirent.utilization.MonthLoginReport;
import com.spirent.utilization.WeeklyLoginReport;
import com.spirent.utilization.WeeklyResourcesReport;

public class TimerListener implements ServletContextListener {
    private Timer updateChassis = null;
    private Timer updateChassisStatus = null;
    private Timer updateAV = null;
    private Timer sendReminder = null;
    private Timer weeklyLoginReport = null;
    //private Timer monthlyLoginReport = null;
    private Timer weeklyResRep = null;
    private Timer monitoringReport = null;
    private Timer loanerNoification = null;
    
	public void contextDestroyed(ServletContextEvent event) {
		updateChassis.cancel();
		updateAV.cancel();
		sendReminder.cancel();
		weeklyLoginReport.cancel();
		//monthlyLoginReport.cancel();
		weeklyResRep.cancel();
		monitoringReport.cancel();
		updateChassisStatus.cancel();
		loanerNoification.cancel();
		event.getServletContext().log("Destroyed timers.");
	}
	
	public void contextInitialized(ServletContextEvent event) {
		InitBaseParameters.initParameters(event.getServletContext());
		updateChassis = new Timer(true);
		sendReminder = new Timer(true);
		updateAV = new Timer(true);
		weeklyLoginReport = new Timer(true);
		//monthlyLoginReport = new Timer(true);
		weeklyResRep = new Timer(true);
		monitoringReport = new Timer(true);
		updateChassisStatus = new Timer(true);
		loanerNoification = new Timer(true);
		event.getServletContext().log("Start timers.");
		
		//Initial schedule parameters
		int updateDBTime=Integer.parseInt((InitBaseParameters.getDbUpdateTime()));
		int reminderTime=Integer.parseInt((InitBaseParameters.getReminderTime()));
		long weeklyDalay=getOffsetTime();
		long reminderDalay=getOffsetMins(reminderTime);
		long loanerDalay=getOffsetHours();
		long moniDalay=getOffsetMoniMins();
		long monthDalay=getOffsetMonth();
		
/*		updateChassis.schedule(new UpdateChassisInfo(event.getServletContext()),30*60*1000,updateDBTime*60*1000);
		updateAV.schedule(new UpdateAVInfo(event.getServletContext()),10*60*1000,updateDBTime*60*1000);
		sendReminder.schedule(new Reminder(event.getServletContext()),reminderDalay,reminderTime*60*1000);
		weeklyLoginReport.schedule(new WeeklyLoginReport(event.getServletContext()),weeklyDalay,7*24*60*60*1000);
		//monthlyLoginReport.schedule(new MonthLoginReport(event.getServletContext()),monthDalay,30*24*60*60*1000);
	    weeklyResRep.schedule(new WeeklyResourcesReport(event.getServletContext()),weeklyDalay,7*24*60*60*1000);
		monitoringReport.schedule(new MonitoringChassis(event.getServletContext()),moniDalay,60*60*1000);
	    updateChassisStatus.schedule(new UpdateChassisStatus(event.getServletContext()),60*60*1000,updateDBTime*60*1000);
	    loanerNoification.schedule(new LoanerEndNotification(event.getServletContext()),loanerDalay,24*60*60*1000);
*/
	    //Initial ConnectionMap
	    ConnectionMap.setMyConnectionMap((new ConnectionMap()).getResourcesList());
	}
	
	 public long getOffsetTime(){
		  Calendar cal = Calendar.getInstance();
		  
		  int weekday = cal.get(Calendar.DAY_OF_WEEK) - 1;
		  int hour = cal.get(Calendar.HOUR_OF_DAY); 
		  
		  if(weekday==0){
			 if(hour == 0)
				  return 0;
             return (24 * 6 + (24 - hour) ) * 60 * 60 * 1000;
		  }
		  
		  return (24 * (6 - weekday) + (24 - hour)) * 60 * 60 * 1000;
	}
	 
	 public long getOffsetMins(int reminderTime){
		  Calendar cal = Calendar.getInstance();
		  
		  int mins = cal.get(Calendar.MINUTE); 
		  int top = 60/reminderTime;
		  
		  for(int i=0; i<top; i++){
			  int before = i*reminderTime;
			  int after = (i+1)*reminderTime;
			  if(before < mins && after > mins){
				  return (after-mins) * 60 * 1000;
			  }
		  }
		  
		  return 0;
	}
	 
	 public long getOffsetMoniMins(){
		  Calendar cal = Calendar.getInstance();
		  
		  int mins = cal.get(Calendar.MINUTE); 
		  
		  if(mins == 0)
		     return 0;
		  
		  return (60 - mins) * 60 * 1000;
	}
	 
	 public long getOffsetHours(){
		  Calendar cal = Calendar.getInstance();
		  
		  int hour = cal.get(Calendar.HOUR_OF_DAY); 
		  
          if(hour == 0)
		    return 0;
          
          return (24 - hour) * 60 * 60 * 1000;
	}
	 
	 public long getOffsetMonth(){
		  Calendar cal = Calendar.getInstance();
		  
		  int day = cal.get(Calendar.DAY_OF_MONTH);
		  int hour = cal.get(Calendar.HOUR_OF_DAY); 
		  
          if(day == 1 && hour == 0)
		    return 0;
          
          long offsetMonth = (30 -day) * 24 * (24 - hour) * 60 * 60 * 1000; 
          
          if(offsetMonth > 0 )
             return offsetMonth;
          
          return -offsetMonth;
	}
}
