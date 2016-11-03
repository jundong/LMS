/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 * The Class DataProcessor.
 * 
 * Handles "update" part of logic.
 * This class can be used as a base for component specific data processors. 
 *  
 */
public class DataProcessor {
	
	/** The master connector. */
	protected BaseConnector connector;
	
	/** The config. */
	protected DataConfig config;
	
	/** The request. */
	protected DataRequest request;
	
	/** The class factory. */
	protected BaseFactory cfactory;
	
	/**
	 * Instantiates a new data processor.
	 * 
	 * @param connector the connector
	 * @param config the config
	 * @param request the request
	 * @param cfactory the class factory
	 */
	public DataProcessor(BaseConnector connector, DataConfig config, DataRequest request, BaseFactory cfactory){
		this.connector = connector;
		this.config = config;
		this.request = request;
		this.cfactory = cfactory;
	}
	
	/**
	 * Convert incoming parameter name to name of DB field
	 * 
	 * @param name the parameter name
	 * 
	 * @return the DB field name
	 */
	protected String name_data(String name){
		return name;
	}
	
	/**
	 * Sort incoming data, creates a hash of data for each record in incoming request 
	 * 
	 * @param ids the array of record ids, data for which need to be allocated
	 * 
	 * @return the id to record hash
	 */
	protected HashMap<String, HashMap<String,String>> get_post_values(String [] ids){
		HashMap<String, HashMap<String,String>> data = new HashMap<String, HashMap<String,String>>();
		for (int i=0; i<ids.length; i++)
			data.put(ids[i],new HashMap<String, String>());
		
		Iterator<String> it = connector.incoming_data.keySet().iterator();
		while (it.hasNext()){
			String key = it.next();
			if (key.indexOf("_")==-1) continue;
			
			String [] key_details = key.split("_",2);
			data.get(key_details[0]).put(name_data(key_details[1]),connector.incoming_data.get(key));
		}
		
		if (!config.id.name.equals(""))
			for (int i=0; i<ids.length; i++)
				data.get(ids[i]).put(config.id.name,ids[i]);
		
		return data;
	}
	
	/**
	 * Process incoming request
	 * 
	 * Detects the list of the operation in incoming request
	 * Process operations one by one
	 * 
	 * @return the xml string, representing result of operation
	 * 
	 * @throws ConnectorOperationException the connector operation exception
	 * @throws ConnectorConfigException the connector config exception
	 */
	public String process() throws ConnectorOperationException, ConnectorConfigException{
		ArrayList<DataAction> result = new ArrayList<DataAction>();
		
		String ids = connector.incoming_data.get("ids");
		if (ids==null)
			throw new ConnectorOperationException("Incorrect incoming data, ID of incoming records not recognized");
		
		String [] id_keys = ids.split(",");
		HashMap<String, HashMap<String,String>> data = get_post_values(id_keys);
		boolean failed = false;
		
		try {
			if (connector.sql.is_global_transaction())
				connector.sql.begin_transaction();
			
			for (int i=0; i<id_keys.length; i++){
				String id = id_keys[i];
				HashMap<String,String> item_data = data.get(id);
				String status = item_data.get("!nativeeditor_status");
				
				DataAction action = new DataAction(status,id,item_data);
				result.add(action);
				inner_process(action);
			}
		} catch (ConnectorOperationException e) {
			failed = true;
		}

		if (connector.sql.is_global_transaction()){
			if (!failed)
				for (int i=0; i<result.size(); i++){
					String result_status = result.get(i).get_status();
					if (result_status.equals("error") || result_status.equals("invalid")){
						failed = true;
						break;
					}
				}
			if (failed){
				for (int i=0; i<result.size(); i++)
					result.get(i).error();
				connector.sql.rollback_transaction();
			} else {
				connector.sql.commit_transaction();
			}
		}
		
		return output_as_xml(result);
	}

	/**
	 * Convert incoming client side status, to DB operation
	 * 
	 * @param status the status from incoming request
	 * 
	 * @return the operation type
	 * 
	 * @throws ConnectorOperationException the connector operation exception
	 */
	protected OperationType status_to_mode(String status) throws ConnectorOperationException{
		if (status.equals("updated")) return OperationType.Update;
		else if (status.equals("inserted")) return OperationType.Insert;
		else if (status.equals("deleted")) return OperationType.Delete;
		
		throw new ConnectorOperationException("Unknown action type: "+status);
	}
	
	
	/**
	 * Convert state to xml string
	 * 
	 * @param result the list of data actions , created during processing 
	 * 
	 * @return the xml string
	 */
	private String output_as_xml(ArrayList<DataAction> result) {
		StringBuffer out = new StringBuffer();
		out.append("<data>");
		for (int i=0; i<result.size(); i++)
			out.append(result.get(i).to_xml());
		out.append("</data>");
		
		return out.toString(); 
	}

	/**
	 * Inner processing routine, called for each record in incoming request
	 * 
	 * @param action the data action which need to be processed
	 * 
	 * @throws ConnectorConfigException the connector config exception
	 * @throws ConnectorOperationException the connector operation exception
	 */
	private void inner_process(DataAction action) throws ConnectorConfigException, ConnectorOperationException {
		if (connector.sql.is_record_transaction())
			connector.sql.begin_transaction();
		
		try {
			OperationType mode  = status_to_mode(action.get_status());
			if (!connector.access.check(mode))
				action.error();
			else {
				connector.event.trigger().beforeProcessing(action);
				if (!action.is_ready())
					check_exts(action,mode);
				connector.event.trigger().afterProcessing(action);
			}
		} catch (ConnectorConfigException e) {
			action.set_status("error");
			throw e;
		} catch (ConnectorOperationException e) {
			action.set_status("error");
			throw e;
		}
		
		if (connector.sql.is_record_transaction()){
			if (action.get_status().equals("invalid") || action.get_status().equals("error"))
				connector.sql.rollback_transaction();
			else
				connector.sql.commit_transaction();
		}
	}

	/**
	 * Checks if there an external event or SQL code was defined for current action
	 * 
	 * @param action the action
	 * @param mode the operation type
	 * 
	 * @throws ConnectorConfigException the connector config exception
	 * @throws ConnectorOperationException the connector operation exception
	 */
	private void check_exts(DataAction action, OperationType mode) throws ConnectorConfigException, ConnectorOperationException {
		switch(mode){
			case Delete:
				connector.event.trigger().beforeDelete(action);
				break;
			case Insert:
				connector.event.trigger().beforeInsert(action);
				break;
			case Update:
				connector.event.trigger().beforeUpdate(action);
				break;
		}
		
		if (!action.is_ready()){
			String sql = connector.sql.get_sql(mode,action.get_data());
			if (sql!=null && !sql.equals(""))
				((DBDataWrapper)connector.sql).query(sql);
			else {
				action.sync_config(config);
				switch(mode){
					case Delete:
						connector.sql.delete(action, request);
						break;
					case Insert:
						connector.sql.insert(action, request);
						break;
					case Update:
						connector.sql.update(action, request);
						break;
				}
			}
		}
		
		switch(mode){
			case Delete:
				connector.event.trigger().afterDelete(action);
				break;
			case Insert:
				connector.event.trigger().afterInsert(action);
				break;
			case Update:
				connector.event.trigger().afterUpdate(action);
				break;
		}
		
	}
}
