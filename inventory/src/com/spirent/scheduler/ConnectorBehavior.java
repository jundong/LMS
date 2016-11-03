/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import com.spirent.collision.ValidEventsInfor;
import com.spirent.notification.Notification;

/**
 * The Class ConnectorBehavior.
 * 
 * Class represents the system of server side events, which can be used to configure 
 * how connector must process select and update requests. 
 */
public class ConnectorBehavior {
	
	/** The master behavior instance */
	private ConnectorBehavior instance;
	
	/**
	 * Instantiates a new connector behavior.
	 */
	public ConnectorBehavior(){
		instance = null;
		//instance = this;
	}
	
	/**
	 * Attach new behavior
	 * 
	 * @param custom the custom behavior
	 */
	public void attach(ConnectorBehavior custom){
		if (instance!=null)
			instance.attach(custom);
		else
			instance=custom;
	}
	
	/**
	 * Trigger event
	 * 
	 * @return the active behavior
	 */
	public ConnectorBehavior trigger(){
		return this;
		//return instance;
	}
	
	//event handlers below
	
	/**
	 * Before sort event
	 * 
	 * Occurs in selection mode, when incoming request parsed and before data selection from DB
	 */
	public void beforeSort(ArrayList<SortingRule> sorters){
		if (instance!=null)
			instance.beforeSort(sorters);
	}
	
	/**
	 * Before filter event
	 * 
	 * Occurs in selection mode, when incoming request parsed and before data selection from DB
	 */
	public void beforeFilter(ArrayList<FilteringRule> filters){
		if (instance!=null)
			instance.beforeFilter(filters);
	}

	/**
	 * Before render event
	 * 
	 * Occurs in selection mode. Event logic called for rendering of each item. 
	 * Related data item is provided as parameter of the called method. 
	 * 
	 * @param data the data item
	 */
	public void beforeRender(DataItem data) {
		if (instance!=null)
			instance.beforeRender(data);
	}

	/**
	 * Before processing event
	 * 
	 * Occurs in update mode, before execution any DB operations.
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void beforeProcessing(DataAction action) {
		if (instance!=null)
			instance.beforeProcessing(action);
	}

	/**
	 * After processing event
	 * 
	 * Occurs in update mode, after execution any DB operations.
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method.
	 * 
	 * @param action the data action
	 */
	public void afterProcessing(DataAction action) {
		if (instance!=null)
			instance.afterProcessing(action);
	}

	/**
	 * Before delete event
	 * 
	 * Occurs in update mode, before deleting record from DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void beforeDelete(DataAction action) {
		if (instance!=null)
			instance.beforeDelete(action);
	}

	/**
	 * Before insert event
	 * 
	 * Occurs in update mode, before inserting record in DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void beforeInsert(DataAction action) {
		if (instance!=null)
			instance.beforeInsert(action);
	}

	/**
	 * Before update event
	 * 
	 * Occurs in update mode, before updating record in DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void beforeUpdate(DataAction action) {
		if (instance!=null)
			instance.beforeUpdate(action);
	}

	/**
	 * After delete event
	 * 
	 * Occurs in update mode, after deleting record from DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action 
	 */
	public void afterDelete(DataAction action) {
		ValidEventsInfor eventInfor=new ValidEventsInfor(Integer.parseInt(action.get_new_id()), action.get_value("description"), action.get_value("organizer"), action.get_value("dtstart"), action.get_value("dtend"), action.get_value("resources"), Integer.parseInt(action.get_value("timeoffset")));
		eventInfor.deleteRecDB(action.get_new_id());
		(new Notification()).sendNotification(action);
		if (instance!=null)
			instance.afterDelete(action);
	}

	/**
	 * After insert event
	 * 
	 * Occurs in update mode, after inserting record in DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void afterInsert(DataAction action) {
		String dtstart = getOffsetDate(action.get_value("dtstart"), -Integer.parseInt(action.get_value("timeoffset")));
		String dtend = getOffsetDate(action.get_value("dtend"), -Integer.parseInt(action.get_value("timeoffset")));
		ValidEventsInfor eventInfor=new ValidEventsInfor(Integer.parseInt(action.get_new_id()), action.get_value("description"), action.get_value("organizer"), dtstart, dtend, action.get_value("resources"), Integer.parseInt(action.get_value("timeoffset")));
		if(action.get_value("rec_type").equals("")){
			eventInfor.validNormal(eventInfor, "", 0);
		} else if(action.get_value("rec_type").contains("day")){
			eventInfor.validDaily(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("week")){
			eventInfor.validWeekly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("month")){
			eventInfor.validMonthly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("year")){
			eventInfor.validYearly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else {
		}
		(new Notification()).sendNotification(action);
		if (instance!=null)
			instance.afterInsert(action);
	}

	/**
	 * After update event
	 * 
	 * Occurs in update mode, after updating record in DB
	 * Event logic called for each updated record. 
	 * Related data action is provided as parameter of the called method. 
	 * 
	 * @param action the data action
	 */
	public void afterUpdate(DataAction action) {
		String dtstart = getOffsetDate(action.get_value("dtstart"), -Integer.parseInt(action.get_value("timeoffset")));
		String dtend = getOffsetDate(action.get_value("dtend"), -Integer.parseInt(action.get_value("timeoffset")));
		ValidEventsInfor eventInfor=new ValidEventsInfor(Integer.parseInt(action.get_new_id()), action.get_value("description"), action.get_value("organizer"), dtstart, dtend, action.get_value("resources"), Integer.parseInt(action.get_value("timeoffset")));
		//eventInfor.updateDB(action.get_new_id());
		eventInfor.deleteRecDB(action.get_new_id());
		if(action.get_value("rec_type").equals("")){
			eventInfor.validNormal(eventInfor, "", 0);
		} else if(action.get_value("rec_type").contains("day")){
			eventInfor.validDaily(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("week")){
			eventInfor.validWeekly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("month")){
			eventInfor.validMonthly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else if(action.get_value("rec_type").contains("year")){
			eventInfor.validYearly(eventInfor, action.get_value("rec_type"), Integer.parseInt(action.get_value("event_length")));
		} else {
		}
		(new Notification()).sendNotification(action);
		if (instance!=null)
			instance.afterUpdate(action);
	}

	/**
	 * Before output event
	 * 
	 * Event occurs before rendering output of connector. 
	 * It can be used to inject any extra data in the output
	 * 
	 * @param out xml string 
	 * @param http_request the http request
	 */
	public void beforeOutput(StringBuffer out, HttpServletRequest http_request) {
		if (instance!=null)
			instance.beforeOutput(out, http_request);
	}
	
	public String getOffsetDate(String dateString, int minOffset){
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
}
