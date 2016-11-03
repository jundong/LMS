/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.sql.Connection;

/**
 * The Class SchedulerConnector.
 */
public class SchedulerConnector extends BaseConnector {
	
	/**
	 * Instantiates a new scheduler connector.
	 * 
	 * @param db the db connection
	 */
	public SchedulerConnector(Connection db){
		this(db,DBType.Custom);
	}

	/**
	 * Instantiates a new scheduler connector.
	 * 
	 * @param db the db connection
	 * @param db_type the db type
	 */
	public SchedulerConnector(Connection db, DBType db_type){
		this(db,db_type, new SchedulerFactory());
	}
	
	/**
	 * Instantiates a new scheduler connector.
	 * 
	 * @param db the db connection
	 * @param db_type the db type
	 * @param a_factory the class factory, which will be used by object
	 */
	public SchedulerConnector(Connection db, DBType db_type, BaseFactory a_factory){
		super(db,db_type,a_factory);
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.BaseConnector#parse_request()
	 */
	@Override
	protected void parse_request() {
		super.parse_request();
		
		String to = http_request.getParameter("to");
		String from = http_request.getParameter("from");
		if (to!=null && !to.equals(""))
			request.set_filter(config.text.get(0).name,to,"<");
		if (from!=null && !from.equals(""))
			request.set_filter(config.text.get(1).name,from,">");
	}
	
	
}
