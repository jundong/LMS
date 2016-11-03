/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.sql.Connection;
import java.util.HashMap;

/**
 * The Class TreeGridConnector.
 */
public class TreeGridConnector extends GridConnector {
	
	/**
	 * Instantiates a new tree grid connector.
	 * 
	 * @param db the db connection
	 */
	public TreeGridConnector(Connection db){
		this(db,DBType.Custom);
	}

	/**
	 * Instantiates a new tree grid connector.
	 * 
	 * @param db the db connection
	 * @param db_type the db type
	 */
	public TreeGridConnector(Connection db, DBType db_type){
		this(db,db_type, new TreeGridFactory());
	}
	
	/**
	 * Instantiates a new tree grid connector.
	 * 
	 * @param db the db connection
	 * @param db_type the db type
	 * @param a_factory the class factory, which will be used by object
	 */
	public TreeGridConnector(Connection db, DBType db_type, BaseFactory a_factory){
		super(db,db_type,a_factory);
		event.attach(new TreeGridBehavior(config));
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.GridConnector#parse_request()
	 */
	@Override
	protected void parse_request() {
		super.parse_request();
		
		String id = http_request.getParameter("id");
		if (id!=null)
			request.set_relation(id);
		else
			request.set_relation("0");
		
		request.set_limit("","");
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.BaseConnector#render_set(com.dhtmlx.connector.ConnectorResultSet)
	 */
	@Override
	protected String render_set(ConnectorResultSet result)
			throws ConnectorOperationException {
		
		StringBuffer output = new StringBuffer();
		int index = 0;
		HashMap<String,String> values;
		while ( (values = result.get_next()) != null){
			TreeGridDataItem data = (TreeGridDataItem)cfactory.createDataItem(values, config, index);
			if (data.get_id()==null)
				data.set_id(uuid());
			
			event.trigger().beforeRender(data);
			
			if (data.has_kids()==-1 && dynloading)
				data.set_kids(1);
			
			data.to_xml_start(output);
			
			if (data.has_kids()==-1 || ( data.has_kids()!=0 && !dynloading)){
				DataRequest sub_request = new DataRequest(request);
				sub_request.set_relation(data.get_id());
				output.append(render_set(sql.select(sub_request)));
			}
		
			data.to_xml_end(output);
			index++;
		}
		return output.toString();
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.GridConnector#xml_start()
	 */
	@Override
	protected String xml_start() {
		return "<rows parent='"+request.get_relation()+"'>";
	}
	
	
	
}
