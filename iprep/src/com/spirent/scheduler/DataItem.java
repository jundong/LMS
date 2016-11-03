/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.util.HashMap;

// TODO: Auto-generated Javadoc
/**
 * The Class DataItem.
 * 
 * Wrapper around the fetched data. Controls how the data transforms into the xml string. 
 */
public class DataItem {
	
	/** The hash of data. */
	protected HashMap<String,String> data;
	
	/** The config. */
	protected DataConfig config;
	
	/** The index of record. */
	protected int index;
	
	/** The skip flag. */
	protected boolean skip;
	
	/**
	 * Instantiates a new data item.
	 * 
	 * @param data the hash of data
	 * @param config the config
	 * @param index the index of record
	 */
	public DataItem(HashMap<String,String> data, DataConfig config, int index){
		skip = false;
		this.index = index;
		this.data = data;
		this.config = config;
	}
	
	/**
	 * Gets the value of the field
	 * 
	 * @param name the name of the field
	 * 
	 * @return the value of the field
	 */
	public String get_value(String name){
		return data.get(name);
	}
	
	/**
	 * Sets value of the field
	 * 
	 * @param name the name of the field
	 * @param value the value of the field
	 */
	public void set_value(String name, String value){
		data.put(name, value);
	}
	
	/**
	 * Gets the id of the record
	 * 
	 * @return the id of the record
	 */
	public String get_id(){
		return get_value(config.id.name);
	}
	
	/**
	 * Sets the new id for the record
	 * 
	 * @param value the new id for the record
	 */
	public void set_id(String value){
		set_value(config.id.name, value);
	}
	
	/**
	 * Gets the index of the record
	 * 
	 * @return the index of the record
	 */
	public int get_index(){
		return index;
	}
	
	/**
	 * Mark current record to be skipped ( not included in xml response )
	 */
	public void skip(){
		skip = true;
	}
	
	/**
	 * Convert data item to xml representation
	 * 
	 * @param out the output buffer
	 */
	public void to_xml(StringBuffer out){
		to_xml_start(out);
		to_xml_end(out);
	}
	
	/**
	 * Starting part of xml representation
	 * 
	 * @param out the output buffer
	 */
	public void to_xml_start(StringBuffer out){
		out.append("<item");
		for (int i=0; i<config.data.size(); i++){
			out.append(" ");
			out.append(config.data.get(i).name);
			out.append("='");
			out.append(get_value(config.data.get(i).name));
			out.append("'");
		}
		out.append(">");
	}
	
	/**
	 * Ending part of xml representation.
	 * 
	 * @param out the output buffer
	 */
	public void to_xml_end(StringBuffer out){
		out.append("</item>");
	}
}
