package com.spirent.collision;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.spirent.javaconnector.DataBaseConnection;

public class ValidEventsInfor {
	    int uid = 0;
		String description = "";
		String organizer = "";
		String dtstart = "";
		String dtend = "";
		String resources = "";
		int timeoffset = 0;
		//String rec_type = "";
		//int event_length = 0;
		
		public ValidEventsInfor(int uid, String description, String organizer, String dtstart, String dtend, String resources, int timeoffset){
			this.uid = uid;
			this.description = description;
			this.organizer = organizer; 
			this.dtstart = dtstart; 
			this.dtend = dtend;
			this.resources = resources;
			this.timeoffset = timeoffset;
		}
		
		public ValidEventsInfor(){
		}
		
		public void validDaily(ValidEventsInfor eventInfor, String rec_type, int event_length){
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					
					SplitRecType splitRecType = new SplitRecType(rec_type);
					int index=1;
					String dtend=eventInfor.dtend;
					if(splitRecType.extra.equals("")||splitRecType.extra.equals("no")){
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
							insertRecDB(eventInfor, index, stmt);
							index++;
							eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));
							eventInfor.setDtend(dtend);
						}
					} else {
						//dtend=getOffsetDate("", dtend, 0, 1);
						int times=Integer.parseInt(splitRecType.extra);
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
							insertRecDB(eventInfor, index, stmt);
							index++;
							if(times--<1){
							   break;
							}
							eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));	
							eventInfor.setDtend(dtend);
						}
					}
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->validDaily: "+e.getMessage());
			} finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->validDaily: "
							+ e.getMessage());
	        	}
	        } 
		}
		
		public void validWeekly(ValidEventsInfor eventInfor, String rec_type, int event_length){
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					
					SplitRecType splitRecType = new SplitRecType(rec_type);
					int index=1;
					String dtend=eventInfor.dtend;
					if(splitRecType.extra.equals("")||splitRecType.extra.equals("no")){
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							String dtstart=eventInfor.dtstart;
							if(splitRecType.days.equals("")){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count)*7, 0));
								eventInfor.setDtend(dtend);
							} else {
								String[] splitDays = splitRecType.days.split(",");
								for(int i=0; i<splitDays.length; i++){
		                            int offsetweekday=getOffsetWeekDay(dtstart, Integer.parseInt(splitDays[i]));
									eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, offsetweekday, 0));
									eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
		                            
									insertRecDB(eventInfor, index, stmt);
									index++;
									if(dtend.compareTo(eventInfor.dtend) <= 0){
										break;
									}	
								}
								eventInfor.setDtstart(dtstart);
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count)*7, 0));
								eventInfor.setDtend(dtend);
							}
						}
					} else {
						//dtend=getOffsetDate("", dtend, 0, 1);
						int times=Integer.parseInt(splitRecType.extra);
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							String dtstart=eventInfor.dtstart;
							if(splitRecType.days.equals("")){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								if(--times<1){
									   break;
								}
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count)*7, 0));
								eventInfor.setDtend(dtend);
							} else {
								String[] splitDays = splitRecType.days.split(",");
								for(int i=0; i<splitDays.length; i++){
		                            int offsetweekday=getOffsetWeekDay(dtstart, Integer.parseInt(splitDays[i]));
									eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, offsetweekday, 0));
									eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
		                            
									insertRecDB(eventInfor, index, stmt);
									index++;
									if(dtend.compareTo(eventInfor.dtend)<=0 || --times<1){
										break;
									}	
								}	
								if(times<1){
									   break;
									}
								eventInfor.setDtstart(dtstart);
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count)*7, 0));
								eventInfor.setDtend(dtend);
							}
						}
					}
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->validWeekly: "+e.getMessage());
			}finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->validWeekly: "
							+ e.getMessage());
	        	}
	        } 
		}
		
		public void validMonthly(ValidEventsInfor eventInfor, String rec_type, int event_length){
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					
					SplitRecType splitRecType = new SplitRecType(rec_type);
					int index=1;
					String dtend=eventInfor.dtend;
					if(splitRecType.extra.equals("")||splitRecType.extra.equals("no")){
						if(splitRecType.count2.equals("")&&splitRecType.day.equals("")){
							while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));
								eventInfor.setDtend(dtend);
							}
						} else {
							while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
								String dtstart=eventInfor.dtstart;
								int offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
								eventInfor.setDtstart(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0));
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, Integer.parseInt(splitRecType.count), 0));
								offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
								if(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0).compareTo(dtend) >= 0){
									break;
								}
								eventInfor.setDtend(dtend);
							}
						}
					} else {
						//dtend=getOffsetDate("", dtend, 0, 1);
						int times=Integer.parseInt(splitRecType.extra);
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							if(splitRecType.count2.equals("")&&splitRecType.day.equals("")){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								if(--times<1){
								   break;
								}
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));	
								eventInfor.setDtend(dtend);
							} else {
								while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
									String dtstart=eventInfor.dtstart;
									int offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
									eventInfor.setDtstart(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0));
									eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
									insertRecDB(eventInfor, index, stmt);
									index++;
									eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, Integer.parseInt(splitRecType.count), 0));
									offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
									if(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0).compareTo(dtend) >= 0 || --times<1){
										break;
									}
									eventInfor.setDtend(dtend);
								}
							}				
						}
					}
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->validMonthly: "+e.getMessage());
			} finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->validMonthly: "
							+ e.getMessage());
	        	}
	        } 
		}
		
		public void validYearly(ValidEventsInfor eventInfor, String rec_type, int event_length){
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					
					SplitRecType splitRecType = new SplitRecType(rec_type);
					int index=1;
					String dtend=eventInfor.dtend;
					if(splitRecType.extra.equals("")||splitRecType.extra.equals("no")){
						if(splitRecType.count2.equals("")&&splitRecType.day.equals("")){
							while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));
								eventInfor.setDtend(dtend);
							}
						} else {
							while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
								String dtstart=eventInfor.dtstart;
								int offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
								eventInfor.setDtstart(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0));
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, Integer.parseInt(splitRecType.count), 0));
								offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
								if(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0).compareTo(dtend) >= 0){
									break;
								}
								eventInfor.setDtend(dtend);
							}
						}
					} else {
						//dtend=getOffsetDate("", dtend, 0, 1);
						int times=Integer.parseInt(splitRecType.extra);
						while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
							if(splitRecType.count2.equals("")&&splitRecType.day.equals("")){
								eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
								insertRecDB(eventInfor, index, stmt);
								index++;
								if(--times<1){
								   break;
								}
								eventInfor.setDtstart(getOffsetDate(splitRecType.type, eventInfor.dtstart, Integer.parseInt(splitRecType.count), 0));	
								eventInfor.setDtend(dtend);
							} else {
								while(eventInfor.dtstart.compareTo(eventInfor.dtend) < 1){
									String dtstart=eventInfor.dtstart;
									int offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
									eventInfor.setDtstart(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0));
									eventInfor.setDtend(getOffsetDate(splitRecType.type, eventInfor.dtstart, 0, event_length));
									insertRecDB(eventInfor, index, stmt);
									index++;
									eventInfor.setDtstart(getOffsetDate(splitRecType.type, dtstart, Integer.parseInt(splitRecType.count), 0));
									offsetDay=getOffsetDay(eventInfor.dtstart, Integer.parseInt(splitRecType.count2), Integer.parseInt(splitRecType.day));
									if(getOffsetDate("day", eventInfor.dtstart, offsetDay, 0).compareTo(dtend) >= 0 || --times<1){
										break;
									}
									eventInfor.setDtend(dtend);
								}
							}				
						}
					}
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->validYearly: "+e.getMessage());
			} finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->validYearly: "
							+ e.getMessage());
	        	}
	        } 
		}
		
		public void validNormal(ValidEventsInfor eventInfor, String rec_type, int event_length){
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
				    
					insertRecDB(eventInfor, 1, stmt);
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->validNormal: "+e.getMessage());
			} finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->validNormal: "
							+ e.getMessage());
	        	}
	        } 
		}
		
		 public String getOffsetDate(String type, String dateString, int offset, int hourOffset){
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
			 
			  if(type.equals("year")){
				  cal.add(Calendar.YEAR, offset);
			  } else if(type.equals("month")){
				  cal.add(Calendar.MONTH, offset);
			  } else if(type.equals("day") || type.equals("week")){
				  cal.add(Calendar.DAY_OF_MONTH, offset);
			  }
			  
			  cal.add(Calendar.MINUTE, hourOffset/60);
			  
			  date = cal.getTime();
			  
			  return df.format(date);
		}
		 
		 public int getOffsetDay(String dateString, int weekday, int internalWeek){
			  int offsetDay = 0;
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
			  
			  if(weekday==0){
				  if(date.getDay()==0){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==1){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=1+(internalWeek-1)*7;
				  }
			  } else if(weekday==1){
				  if(date.getDay()==0){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==2){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=2+(internalWeek-1)*7;
				  }
			  } else if(weekday==2){
				  if(date.getDay()==0){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==3){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=3+(internalWeek-1)*7;
				  }
			  } else if(weekday==3){
				  if(date.getDay()==0){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==4){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=4+(internalWeek-1)*7;
				  }
			  } else if(weekday==4){
				  if(date.getDay()==0){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==5){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=5+(internalWeek-1)*7;
				  }
			  } else if(weekday==5){
				  if(date.getDay()==0){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=internalWeek*7;
				  } else if(date.getDay()==6){
					  offsetDay=6+(internalWeek-1)*7;
				  }
			  } else {
				  if(date.getDay()==0){
					  offsetDay=6+(internalWeek-1)*7;
				  } else if(date.getDay()==1){
					  offsetDay=5+(internalWeek-1)*7;
				  } else if(date.getDay()==2){
					  offsetDay=4+(internalWeek-1)*7;
				  } else if(date.getDay()==3){
					  offsetDay=3+(internalWeek-1)*7;
				  } else if(date.getDay()==4){
					  offsetDay=2+(internalWeek-1)*7;
				  } else if(date.getDay()==5){
					  offsetDay=1+(internalWeek-1)*7;
				  } else if(date.getDay()==6){
					  offsetDay=internalWeek*7;
				  }
			  }
			  
			  return offsetDay;
		}
		 
		 public int getOffsetWeekDay(String dateString, int weekday){
			  int offsetDay = 0;
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
			  
			  if(weekday==0){
				  if(date.getDay()==0){
					  offsetDay=0;
				  } else if(date.getDay()==1){
					  offsetDay=6;
				  } else if(date.getDay()==2){
					  offsetDay=5;
				  } else if(date.getDay()==3){
					  offsetDay=4;
				  } else if(date.getDay()==4){
					  offsetDay=3;
				  } else if(date.getDay()==5){
					  offsetDay=2;
				  } else if(date.getDay()==6){
					  offsetDay=1;
				  }
			  } else if(weekday==1){
				  if(date.getDay()==0){
					  offsetDay=1;
				  } else if(date.getDay()==1){
					  offsetDay=0;
				  } else if(date.getDay()==2){
					  offsetDay=6;
				  } else if(date.getDay()==3){
					  offsetDay=5;
				  } else if(date.getDay()==4){
					  offsetDay=4;
				  } else if(date.getDay()==5){
					  offsetDay=3;
				  } else if(date.getDay()==6){
					  offsetDay=2;
				  }
			  } else if(weekday==2){
				  if(date.getDay()==0){
					  offsetDay=2;
				  } else if(date.getDay()==1){
					  offsetDay=1;
				  } else if(date.getDay()==2){
					  offsetDay=0;
				  } else if(date.getDay()==3){
					  offsetDay=6;
				  } else if(date.getDay()==4){
					  offsetDay=5;
				  } else if(date.getDay()==5){
					  offsetDay=4;
				  } else if(date.getDay()==6){
					  offsetDay=3;
				  }
			  } else if(weekday==3){
				  if(date.getDay()==0){
					  offsetDay=3;
				  } else if(date.getDay()==1){
					  offsetDay=2;
				  } else if(date.getDay()==2){
					  offsetDay=1;
				  } else if(date.getDay()==3){
					  offsetDay=0;
				  } else if(date.getDay()==4){
					  offsetDay=6;
				  } else if(date.getDay()==5){
					  offsetDay=5;
				  } else if(date.getDay()==6){
					  offsetDay=4;
				  }
			  } else if(weekday==4){
				  if(date.getDay()==0){
					  offsetDay=4;
				  } else if(date.getDay()==1){
					  offsetDay=3;
				  } else if(date.getDay()==2){
					  offsetDay=2;
				  } else if(date.getDay()==3){
					  offsetDay=1;
				  } else if(date.getDay()==4){
					  offsetDay=0;
				  } else if(date.getDay()==5){
					  offsetDay=6;
				  } else if(date.getDay()==6){
					  offsetDay=5;
				  }
			  } else if(weekday==5){
				  if(date.getDay()==0){
					  offsetDay=5;
				  } else if(date.getDay()==1){
					  offsetDay=4;
				  } else if(date.getDay()==2){
					  offsetDay=3;
				  } else if(date.getDay()==3){
					  offsetDay=2;
				  } else if(date.getDay()==4){
					  offsetDay=1;
				  } else if(date.getDay()==5){
					  offsetDay=0;
				  } else if(date.getDay()==6){
					  offsetDay=6;
				  }
			  } else {
				  if(date.getDay()==0){
					  offsetDay=6;
				  } else if(date.getDay()==1){
					  offsetDay=5;
				  } else if(date.getDay()==2){
					  offsetDay=4;
				  } else if(date.getDay()==3){
					  offsetDay=3;
				  } else if(date.getDay()==4){
					  offsetDay=2;
				  } else if(date.getDay()==5){
					  offsetDay=1;
				  } else if(date.getDay()==6){
					  offsetDay=0;
				  }
			  }
			  
			  return offsetDay;
		}
		 
			public String getUTCDate(String dateString, int minOffset){
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
				  
				  cal.add(Calendar.MINUTE, minOffset);
				  
				  date = cal.getTime();
				  
				  return df.format(date);
			}
		
		public void insertRecDB(ValidEventsInfor eventInfor, int index, Statement stmt) {
			try{
				String dtstart = getUTCDate(eventInfor.dtstart, eventInfor.timeoffset);
				String dtend = getUTCDate(eventInfor.dtend, eventInfor.timeoffset);
				
				String insertDB = "insert into events_rec value('"+eventInfor.uid+"', '"+index+"', '"+eventInfor.description+"', '"+dtstart+"', '"+dtend+"', '"+eventInfor.resources+"', '"+eventInfor.organizer+"', '"+eventInfor.timeoffset+"', '0', '0')";
				stmt.execute(insertDB);
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->insertRecDB: "+e.getMessage());
			} 
	    }
			
		public void deleteRecDB(String uid) {
			Connection conn = null;
			Statement stmt = null;
			try {					
				conn = DataBaseConnection.getConnection();
				if (conn != null) {
					stmt = conn.createStatement();
					
					String updateDB = "update events_ex set snotification='0', enotification='0' where uid='" + uid +"'";
					stmt.execute(updateDB);
					
					String deleteDB = "delete from events_rec where uid='"+uid+"'";
					stmt.execute(deleteDB);
				}
			} catch (Exception e) {
				System.out.println("Exception occurs in ValidEventsInfor.java->deleteRecDB: ");
				e.printStackTrace();
			}finally {
	        	try {
	        		if(stmt != null){
	        			stmt.close();
	        		}
	        		if(conn != null){
	        			DataBaseConnection.freeConnection(conn); 
	        		}
	        	} catch (Exception e) {      
	    			System.out
					.println("Close DB error occourred in ValidEventsInfor.java->deleteRecDB: "
							+ e.getMessage());
	        	}
	        } 
	    }
		
		public void setDtstart(String dtstart) {
			this.dtstart = dtstart;
		}

		public void setDtend(String dtend) {
			this.dtend = dtend;
		}
}
