/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * The Class BaseConnector.
 * 
 * Class represents universal connector. 
 * It has not any component specific functionality, 
 * but can handler and parse common elements of incoming request.  
 */
public class BaseConnector {
	
	/** common http request object */
	protected static HttpServletRequest global_http_request;
	
	/** common http response object */
	protected static HttpServletResponse global_http_response;
	
	/** active http request object */
	protected HttpServletRequest http_request;
	
	/** active http response object */
	protected HttpServletResponse http_response;
	
	/** The incoming_data. */
	public HashMap<String,String> incoming_data;
	
	/** The data configuration */
	protected DataConfig config;
	
	/** The parsed incoming request. */
	protected DataRequest request;
	
	/** The factory of related classes */
	protected BaseFactory cfactory;
	
	/** Flag of dynamic loading mode */
	protected boolean dynloading;
	
	/** Size of dynamic loading */
	protected int dynloading_size;
	
	/** Used encoding */
	private String encoding;
	
	/** Flag of update mode */
	private boolean editing;
	
	/** DB connection */
	private Connection db;
	
	/** Seed for auto id generation */
	private int id_seed;
	
	/** Used DB type */
	protected DBType db_type;
	
	/** Execution timer. */
	private long exec_time;
	
	/** Access Manager instance */
	public AccessManager access;
	
	/** Data Wrapper instance */
	public DataWrapper sql;
	
	/** Event extension */
	public ConnectorBehavior event;
	
	/**
	 * Creates a DataWrapper object, based on provided settings
	 * 
	 * @param db_type type of used DB
	 * @param a_factory class factory, used by connector
	 * 
	 * @return the data wrapper
	 */
	private DataWrapper resolve_data_wrapper(DBType db_type, BaseFactory a_factory){
		this.db_type = db_type;
		switch (db_type){
		case PostgreSQL:
			return new PGSQLDBDataWrapper();
		case Oracle:
			return new OracleDBDataWrapper();
		case MSSQL:
			return new MSSQLDBDataWrapper();
		case Custom:
			return a_factory.createDataWrapper();
		default:
			return new MySQLDBDataWrapper();
		}
	}
	
	/**
	 * Instantiates a new base connector.
	 * 
	 * @param db DB connecton
	 */
	public BaseConnector(Connection db){
		this(db,DBType.Custom);
	}

	/**
	 * Instantiates a new base connector.
	 * 
	 * @param db DB connection
	 * @param db_type type of used DB
	 */
	public BaseConnector(Connection db, DBType db_type){
		this(db,db_type,new BaseFactory());
	}
	
	/**
	 * Instantiates a new base connector.
	 * 
	 * @param db DB connection
	 * @param db_type type of used DB
	 * @param a_factory class factory
	 */
	public BaseConnector(Connection db, DBType db_type, BaseFactory a_factory){
		init_self(db,resolve_data_wrapper(db_type,a_factory),a_factory);
	}
	
	/**
	 * Initialize self , after creation
	 * 
	 * @param db DB connection
	 * @param dw type of used DB
	 * @param a_factory class factory
	 */
	private void init_self(Connection db, DataWrapper dw, BaseFactory a_factory){
		servlet(global_http_request, global_http_response);
		
		exec_time = System.currentTimeMillis();
		encoding = "utf-8";
		
		config = new DataConfig();
		request = new DataRequest();
		event = new ConnectorBehavior();
		access = new AccessManager();
		cfactory = a_factory;
		
		sql = dw; 
		sql.init((Object)db,config);
		
		this.db = db;
	}
	
	/**
	 * Gets the connection
	 * 
	 * @return the connection
	 */
	protected Connection get_connection(){
		return db;
	}
	
	/**
	 * Build xml response for specified table in DB
	 * 
	 * @param table the name of table
	 * @param id the name of id field
	 * @param fields the name of data fields
	 */
	public void render_table(String table, String id, String fields){
		render_table(table, id, fields, "", "");
	}
	
	/**
	 * Build xml response for specified table in DB
	 * 
	 * @param table the name of table
	 * @param id the name of id field
	 * @param fields the name of data fields
	 * @param extra the name of extra fields
	 */
	public void render_table(String table, String id, String fields, String extra){
		render_table(table, id, fields, extra, "");
	}
	
	/**
	 * Build xml response for specified table in DB
	 * 
	 * @param table the name of table
	 * @param id the name of id field
	 * @param fields the name of data fields
	 * @param extra the name of extra fields
	 * @param relation_id the name of relation field
	 */
	public void render_table(String table, String id, String fields, String extra, String relation_id){
		config.init(id,fields, extra, relation_id);
		try{
			request.set_source(table);
		} catch (ConnectorConfigException e){
			LogManager.getInstance().log("Error during render_table execution");
			LogManager.getInstance().log(e.getMessage());
		}
		render();
	}
	
	/**
	 * Get unique ID
	 * 
	 * @return the unique id
	 */
	protected String uuid(){
		return System.currentTimeMillis()+"_"+Integer.toString(id_seed++);
	}
	
	/**
	 * Render_sql.
	 * 
	 * @param sql the sql query
	 * @param id the name of id field
	 * @param fields the name of data fields
	 */
	public void render_sql(String sql, String id, String fields){
		render_sql(sql, id, fields, "", "");
	}
	
	/**
	 * Render_sql.
	 * 
	 * @param sql the sql query
	 * @param id the name of id field
	 * @param fields the name of data fields
	 * @param extra the name of extra fields
	 */
	public void render_sql(String sql, String id, String fields, String extra){
		render_sql(sql, id, fields, extra, "");
	}	
	
	/**
	 * Build xml response for specified sql query in DB
	 * 
	 * @param sql the sql query
	 * @param id the name of id field
	 * @param fields the name of data fields
	 * @param extra the name of extra fields
	 * @param relation_id the name of relation field
	 */
	public void render_sql(String sql, String id, String fields, String extra, String relation_id){
		config.init(id,fields,extra,relation_id);
		try{
			request.parse_sql(sql);
		} catch (ConnectorConfigException e){
			LogManager.getInstance().log("Error during render_sql execution");
			LogManager.getInstance().log(e.getMessage());
		}
		render();
	}
	
	/**
	 * Build xml response, based on specified config and data
	 * 
	 * @param config the data config
	 * @param request the data request
	 * 
	 * @return the xml string
	 */
	public String render_connector(DataConfig config, DataRequest request){
		this.config.copy(config);
		this.request.copy(request);
		return render();
	}
	
	/**
	 * Build xml response, based on previously provided configuration
	 * 
	 * All top level render methods, call this one, after parsing provided configuration
	 * 
	 * @return the xml string
	 */
	public String render(){
		parse_request();
		if (editing){
			DataProcessor dp = cfactory.createDataProcessor(this, config, request, cfactory);
			String result;
			try {
				result = dp.process();
			} catch (ConnectorOperationException e) {
				LogManager.getInstance().log("Error during data processing");
				LogManager.getInstance().log(e.getMessage());
				result="<data>Operation error</data>";
			} catch (ConnectorConfigException e) {
				LogManager.getInstance().log("Error during configuration parsing");
				LogManager.getInstance().log(e.getMessage());
				result="<data>Configuration error</data>";
			}
			output_as_xml(result);
			return result;
		} else {
			event.trigger().beforeSort(request.get_sort_by());
			event.trigger().beforeFilter(request.get_filters());
			try{
				return output_as_xml(sql.select(request));
			} catch(ConnectorOperationException e){
				LogManager.getInstance().log("Error during data selecting");
				LogManager.getInstance().log(e.getMessage());
				return "";
			}
		}
	}
	
	/**
	 * Ensure, that used field name can't be used for sql injection
	 * 
	 * @param str the field name to be checked
	 * 
	 * @return field name with all malicious chars removed
	 */
	protected String safe_field_name(String str){
		return str.split("[ \n\t;]+")[0];
	}
	
	/**
	 * Link connector to active request and response
	 * 
	 * @param request the http request
	 * @param response the http response
	 */
	public void servlet(HttpServletRequest request, HttpServletResponse response){
		http_request = request;
		http_response = response;
	};
	
	/**
	 * Parse http request
	 * 
	 * Methods sets "dynloading", "editing" flags and fill request object with info 
	 * about requested sorting|filtering options.
	 *  
	 */
	@SuppressWarnings("unchecked")
	protected void parse_request(){
		if (dynloading)
			request.set_limit(0, dynloading_size);
			
		if (http_request.getParameter("editing")!=null)
			editing = true;
		
		if (http_request.getParameter("ids")!=null)
			editing = true;
		
		//sorting
		HashMap<String,String> data = new HashMap<String,String>();
		
		Map map = http_request.getParameterMap();
		Iterator it = map.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry pair = (Map.Entry)it.next();
			String key = pair.getKey().toString();
			int index = key.indexOf("[");
			if (index!=-1){
				String subkey = key.substring(index+1,key.length()-1);
				String key_name = key.substring(0, index);
				if (key_name.equals("dhx_filter"))
					request.set_filter(resolve_parameter(safe_field_name(subkey)),http_request.getParameter(key));
				else if (key_name.equals("dhx_sort"))
					request.set_sort(resolve_parameter(safe_field_name(subkey)),http_request.getParameter(key));
			} else
				data.put(key, http_request.getParameter(key));
		}
		
		incoming_data=data;
	}
	
	/**
	 * Resolve incoming http parameter
	 * 
	 * Translate name of incoming parameter to the name of related DB field
	 * 
	 * @param name the name of http parameter
	 * 
	 * @return the DB field name
	 */
	protected String resolve_parameter(String name){
		return name;
	}
	
	/**
	 * Render DB result set as XML string
	 * 
	 * @param result the DB result
	 * 
	 * @return the xml string
	 * 
	 * @throws ConnectorOperationException the connector operation exception 
	 */
	protected String render_set(ConnectorResultSet result) throws ConnectorOperationException{
		StringBuffer output = new StringBuffer();
		int index = 0;
		HashMap<String,String> values;
		while ( (values = result.get_next()) != null){
			DataItem data = cfactory.createDataItem(values, config, index);
			if (data.get_id()==null)
				data.set_id(uuid());
			
			event.trigger().beforeRender(data);
			data.to_xml(output);
			index++;
		}
		return output.toString();
	}

	/**
	 * Output xml string with correct headers
	 * 
	 * @param data the xml string
	 */
	protected void output_as_xml(String data){
		http_response.reset();
		http_response.addHeader("Content-type", "text/xml;charset=" + encoding);
		
		try {
		java.io.Writer out = http_response.getWriter();
		out.write("<?xml version='1.0' encoding='"+encoding+"' ?>");
		out.write(data);
		out.close();
		
		http_response.flushBuffer();
		} catch (IOException e){
			LogManager.getInstance().log("Error during data outputing");
			LogManager.getInstance().log(e.getMessage());
		}
		end_run();
	}
	
	/**
	 * Convert DB result set to string and add xml elements  defined by other configuration options
	 * 
	 * @param result the DB result
	 * 
	 * @return the xml string
	 * 
	 * @throws ConnectorOperationException the connector operation exception
	 */
	protected String output_as_xml(ConnectorResultSet result) throws ConnectorOperationException{
		StringBuffer out = new StringBuffer();
		
		String xml = render_set(result);
		out.append(xml_start());
		
		event.trigger().beforeOutput(out, http_request);
		
		out.append(xml);
		out.append(xml_end());
		
		output_as_xml(out.toString());
		return out.toString();
	}
	
	/**
	 * Finish connector execution
	 * 
	 * The method not stops execution, it just called at the end of processing to measure execution time
	 */
	protected void end_run(){
		LogManager.getInstance().log("Done in",Long.toString(System.currentTimeMillis()-exec_time)+"ms");
		LogManager.getInstance().close();
	}
	
	/**
	 * Sets used xml encoding.
	 * 
	 * @param name the encoding name
	 */
	public void set_encoding(String name){
		encoding = name;
	}
	
	/**
	 * Set size of dynamic loading
	 * 
	 * @param size the size
	 */
	public void dynamic_loading(int size){
		dynloading=(size!=0);
		dynloading_size=size;
	}
	
	/**
	 * Enable dynamic loading
	 * 
	 * Dynamic loading size set to 30 by default
	 * 
	 * @param state the mode, true will enable dyn. loading, false will disable it
	 */
	public void dynamic_loading(boolean state){
		dynloading=state;
		dynloading_size=state?30:0;
	}
	
	/**
	 * enable logging
	 * 
	 * @param path the path to the log file
	 * @param output_to_client if mode is set, error data will be sent to client side , 
	 * which provides a simpler debugging, but not safe for production environment
	 */
	public void enable_log(String path, boolean output_to_client){
		java.io.FileWriter log=null;
		try {
			log = new java.io.FileWriter(path, true);
		} catch (IOException e) {
			e.printStackTrace();
		}
		LogManager.getInstance().enable_log(log,output_to_client);
	}
	
	/**
	 * Checks if current mode is a select mode.
	 * 
	 * @return true, if current mode is a select mode
	 */
	public boolean is_select_mode(){
		parse_request();
		return !editing;
	}
	
	/**
	 * Get opening top level xml tag
	 * 
	 * @return the xml string
	 */
	protected String xml_start(){
		return "<data>";
	}
	
	/**
	 * Get closing top level xml tag
	 * 
	 * @return the xml string
	 */
	protected String xml_end(){
		return "</data>";
	}
	
	
}
