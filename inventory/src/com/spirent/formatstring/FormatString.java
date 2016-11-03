package com.spirent.formatstring;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Pattern;

import com.spirent.javaconnector.DataBaseConnection;

public class FormatString {
	public String formatDateInfor(String str) {
		if (str.contains("0000-00-00")) {
			return " ";
		} 
		return str;
	}
	
	public String formatOSinfor(String str) {
		if (str.contains("XP")) {
			str = "XP";
		}
		return str;
	}
	
	public String formatPortInfor(String str) {
		if (str.contains("Physical")) {
			String[] split = str.split(" ");
			str = "PrtGrp " + split[1];
		} else if (str.isEmpty()){
			
		} else {
			String[] split = str.split("_");
			str = split[2];
		} 

		return str;
	}

	public String chassisResEnd(String ChassisAddr, String SlotIndex, String PortIndex, int timeoffset) {
		Connection chassisconn = null;
		ResultSet chassisrs = null;
		Statement stmt = null;
		String resEnd = "";
		String sqlStr = "";
		String upd = "";
		try {
			chassisconn = DataBaseConnection.getConnection();
			if (chassisconn != null) {
				stmt = chassisconn.createStatement();
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();	
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				String resource = "";
				resource = ChassisAddr + "//" + SlotIndex + "/" + PortIndex;
				
				sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
				chassisrs = stmt.executeQuery(sqlStr);
				if (chassisrs.next()) {
					resEnd = chassisrs.getString("dtend");
					
					if (resEnd == null){
						resEnd = "";
					} else {
						String[] splitStr = resEnd.split("\\.");
						resEnd = splitStr[0];
					}
				} 
				
				if (resEnd.equals("")) {
					sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE resources LIKE '%" + resource + "%'";
					chassisrs = stmt.executeQuery(sqlStr);
					
					if (chassisrs.next()) {
						resEnd = chassisrs.getString("dtend");
						
						if (resEnd == null){
							resEnd = "";
						} else {
							String[] splitStr = resEnd.split("\\.");
							resEnd = splitStr[0];
						}
					}				
				}
				
				if (!resEnd.equals("")){			
					resEnd = getCanlender(resEnd, -timeoffset);
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> chassisResEnd: "
							+ e.getMessage());
		} finally {
        	try {
        		if(chassisrs != null){
        			chassisrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(chassisconn != null){
        			DataBaseConnection.freeConnection(chassisconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> chassisResEnd: "
						+ e.getMessage());
        	}
        } 
		return resEnd;
	}	
	
	public String chassisResBy(String ChassisAddr, String SlotIndex, String PortIndex, int timeoffset) {
		Connection chassisconn = null;
		ResultSet chassisrs = null;
		Statement stmt = null;
		String resBy = "";
		String sqlStr = "";
		try {
			chassisconn = DataBaseConnection.getConnection();
			if (chassisconn != null) {
				stmt = chassisconn.createStatement();
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();	
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				String resource = "";
				resource = ChassisAddr + "//" + SlotIndex + "/" + PortIndex;
				
				sqlStr = "SELECT MAX(dtend) AS dtend, organizer FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
				chassisrs = stmt.executeQuery(sqlStr);
				if (chassisrs.next()) {
					resBy = chassisrs.getString("organizer");
					
					if (resBy == null){
						resBy = "";
					}
				} 
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> chassisResBy: "
							+ e.getMessage());
		} finally {
        	try {
        		if(chassisrs != null){
        			chassisrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(chassisconn != null){
        			DataBaseConnection.freeConnection(chassisconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> chassisResBy: "
						+ e.getMessage());
        	}
        } 
		return resBy;
	}	
	
	public String avResEnd(String AvAddr, String PortIndex, int timeoffset) {
		Connection avconn = null;
		ResultSet avrs = null;
		Statement stmt = null;
		String resEnd = "";
		String sqlStr = "";
		String upd = "";
		try {
			avconn = DataBaseConnection.getConnection();
			if (avconn != null) {
				stmt = avconn.createStatement();
				String resource = "";
				resource = AvAddr + "/" + PortIndex;
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();	
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
	
				avrs = stmt.executeQuery(sqlStr);
				if (avrs.next()) {
					resEnd = avrs.getString("dtend");
					
					if (resEnd == null){
						resEnd = "";
					} else {
						String[] splitStr = resEnd.split("\\.");
						resEnd = splitStr[0];
					}
				} 
				
				if (resEnd.equals("")) {
					sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE resources LIKE '%" + resource + "%'";
					avrs = stmt.executeQuery(sqlStr);
					
					if (avrs.next()) {
						resEnd = avrs.getString("dtend");
						
						if (resEnd == null){
							resEnd = "";
						} else {
							String[] splitStr = resEnd.split("\\.");
							resEnd = splitStr[0];
						}
					}
				}
				
				if (!resEnd.equals("")){			
					resEnd = getCanlender(resEnd, -timeoffset);
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> avResEnd: "
							+ e.getMessage());
		} finally {
        	try {
        		if(avrs != null){
        			avrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(avconn != null){
        			DataBaseConnection.freeConnection(avconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> avResEnd: "
						+ e.getMessage());
        	}
        } 
		return resEnd;
	}
	
	public String avResBy(String AvAddr, String PortIndex, int timeoffset) {
		Connection avconn = null;
		ResultSet avrs = null;
		Statement stmt = null;
		String resBy = "";
		String sqlStr = "";
		try {
			avconn = DataBaseConnection.getConnection();
			if (avconn != null) {
				stmt = avconn.createStatement();
				String resource = "";
				resource = AvAddr + "/" + PortIndex;
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();	
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				sqlStr = "SELECT MAX(dtend) AS dtend, organizer FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
	
				avrs = stmt.executeQuery(sqlStr);
				if (avrs.next()){
					resBy = avrs.getString("organizer");
					
					if (resBy == null){
						resBy = "";
					}
				} 
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> avResBy: "
							+ e.getMessage());
		}finally {
        	try {
        		if(avrs != null){
        			avrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(avconn != null){
        			DataBaseConnection.freeConnection(avconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> avResBy: "
						+ e.getMessage());
        	}
        }  
		return resBy;
	}	

	public String dutResEnd(String dutAddr, String PortIndex, int timeoffset) {
		Connection dutconn = null;
		ResultSet dutrs = null;
		Statement stmt = null;
		String resEnd = "";
		String sqlStr = "";
		try {
			dutconn = DataBaseConnection.getConnection();
			if (dutconn != null) {
				stmt = dutconn.createStatement();
				String resource = "";
				resource = dutAddr + "//" + PortIndex;
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();	
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
	
				dutrs = stmt.executeQuery(sqlStr);
				if (dutrs.next()) {
					resEnd = dutrs.getString("dtend");
					
					if (resEnd == null){
						resEnd = "";
					} else {
						String[] splitStr = resEnd.split("\\.");
						resEnd = splitStr[0];
					}
				} 
	            if (resEnd.equals("")) {
					sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE resources LIKE '%" + resource + "%'";
					dutrs = stmt.executeQuery(sqlStr);
					
					if (dutrs.next()) {
						resEnd = dutrs.getString("dtend");
						
						if (resEnd == null){
							resEnd = "";
						} else {
							String[] splitStr = resEnd.split("\\.");
							resEnd = splitStr[0];
						}
					}
				}
				
				if (!resEnd.equals("")){			
					resEnd = getCanlender(resEnd, -timeoffset);
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> dutResEnd: "
							+ e.getMessage());
		}finally {
        	try {
        		if(dutrs != null){
        			dutrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(dutconn != null){
        			DataBaseConnection.freeConnection(dutconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> dutResEnd: "
						+ e.getMessage());
        	}
        }
		return resEnd;
	}
	
	public String dutResBy(String dutAddr, String PortIndex, int timeoffset) {
		Connection dutconn = null;
		ResultSet dutrs = null;
		Statement stmt = null;
		String resBy = "";
		String sqlStr = "";
		try {
			dutconn = DataBaseConnection.getConnection();
			if (dutconn != null) {
				stmt = dutconn.createStatement();
				String resource = "";
				resource = dutAddr + "//" + PortIndex;
				
				int serverTimeOffset = (new Date()).getTimezoneOffset();	
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
			    
				sqlStr = "SELECT MAX(dtend) AS dtend, organizer FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
	
				dutrs = stmt.executeQuery(sqlStr);
				if (dutrs.next()) {
					resBy = dutrs.getString("organizer");
					
					if (resBy == null){
						resBy = "";
					}
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> dutResBy: "
							+ e.getMessage());
		} finally {
        	try {
        		if(dutrs != null){
        			dutrs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(dutconn != null){
        			DataBaseConnection.freeConnection(dutconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> dutResBy: "
						+ e.getMessage());
        	}
        }
		return resBy;
	}	
	
	public String vpResEnd(String vpName, int timeoffset) {
		Connection vpconn = null;
		ResultSet vprs = null;
		Statement stmt = null;
		String resEnd = "";
		String sqlStr = "";
		try {
			vpconn = DataBaseConnection.getConnection();
			if (vpconn != null) {
				stmt = vpconn.createStatement();
				String resource = vpName;
	
				int serverTimeOffset = (new Date()).getTimezoneOffset();
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
	
				sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
				vprs = stmt.executeQuery(sqlStr);
				if (vprs.next()) {
					resEnd = vprs.getString("dtend");
					if (resEnd == null){
						resEnd = "";
					} else {
						String[] splitStr = resEnd.split("\\.");
						resEnd = splitStr[0];
					}
				}
				
	            if (resEnd.equals("")) {
					sqlStr = "SELECT MAX(dtend) AS dtend FROM events_ex WHERE resources LIKE '%" + resource + "%'";
					vprs = stmt.executeQuery(sqlStr);
					if (vprs.next()) {
						resEnd = vprs.getString("dtend");
						if (resEnd == null){
							resEnd = "";
						} else {
							String[] splitStr = resEnd.split("\\.");
							resEnd = splitStr[0];
						}
					}
				}
				
				if (!resEnd.equals("")){			
					resEnd = getCanlender(resEnd, -timeoffset);
				}
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> vpResEnd: "
							+ e.getMessage());
		}  finally {
        	try {
        		if(vprs != null){
        			vprs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(vpconn != null){
        			DataBaseConnection.freeConnection(vpconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> vpResEnd: "
						+ e.getMessage());
        	}
        }
		return resEnd;
	}	
	
	public String vpResBy(String vpName, int timeoffset) {
		Connection vpconn = null;
		ResultSet vprs = null;
		Statement stmt = null;
		String resBy = "";
		String sqlStr = "";
		try {
			vpconn = DataBaseConnection.getConnection();
			if (vpconn != null) {
				stmt = vpconn.createStatement();
				String resource = vpName;
	
				int serverTimeOffset = (new Date()).getTimezoneOffset();
			    SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    Calendar cal = Calendar.getInstance();
			    Date date = cal.getTime();
			    String currentlyGMT = getCanlender(df.format(date), serverTimeOffset);
	
				sqlStr = "SELECT MAX(dtend) AS dtend, organizer FROM events_ex WHERE (STRCMP(dtstart, '" +currentlyGMT + "')='-1' OR STRCMP(dtstart, '" + currentlyGMT + "')='0') AND (STRCMP(dtend, '" + currentlyGMT + "')='1' OR STRCMP(dtend, '" + currentlyGMT + "')='0') AND resources LIKE '%" + resource + "%'";
				vprs = stmt.executeQuery(sqlStr);
				if (vprs.next()) {
					resBy = vprs.getString("organizer");
					if (resBy == null){
						resBy = "";
					} 
				} 
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in FormatString.java -> vpResBy: "
							+ e.getMessage());
		}finally {
        	try {
        		if(vprs != null){
        			vprs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(vpconn != null){
        			DataBaseConnection.freeConnection(vpconn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in FormatString.java -> vpResBy: "
						+ e.getMessage());
        	}
        }
		return resBy;
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
	 
		public String formatLastScan(String lastscan, int timeoffset) {
			if (lastscan.contains("0000-00-00")) {
				return " ";
			} 
			if (!lastscan.equals("")){
				lastscan = getCanlender(lastscan, -timeoffset);
			}
			
			return lastscan;
		}

		public String getSite(String resource, String siteCol) {
			 String site = "";
			 if (!siteCol.equals("")){
			     if (Pattern.matches("^10.14.*", resource)){
			    	 site = "HNL";
			     } else if (Pattern.matches("^10.100.*", resource)){
			    	 site = "CAL";
			     } else if (Pattern.matches("^10.61.*", resource)){
			    	 site = "CHN";
			     } else if (Pattern.matches("^10.47.*",resource)){
			    	 site = "SNV";
			     } else if (Pattern.matches("^10.6.*", resource)){
			    	 site = "RTP";
			     }
			 }
			return site;
		}
		
		public String formatTransceiver(String transceiver) {
			if (transceiver.contains("MODULE_")){
				transceiver = transceiver.replace("MODULE_", "");
			}
			return transceiver;
		}
}
