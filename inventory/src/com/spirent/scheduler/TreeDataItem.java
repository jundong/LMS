/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.scheduler;

import java.util.HashMap;

/**
 * The Class TreeDataItem.
 */
public class TreeDataItem extends DataItem {
	
	/** The kids flag */
	private int kids = -1;
	
	/** The checkbox state */
	private boolean check = false;
	
	/** The "closed folder" image  */
	private String im0 = null;
	
	/** The "opened folder" image */
	private String im1 = null;
	
	/** The "leaf" image */
	private String im2 = null;
	 
	/**
	 * Instantiates a new tree data item.
	 * 
	 * @param data the data
	 * @param config the config
	 * @param index the index
	 */
	public TreeDataItem(HashMap<String,String> data, DataConfig config, int index){
		super(data,config,index);
	}
	
	/**
	 * Gets the parent id.
	 * 
	 * @return the parent id
	 */
	public String get_parent_id(){
		return get_value(config.relation_id.name);
	}
	
	/**
	 * Gets the checkbox state
	 * 
	 * @return the checkbox state
	 */
	public boolean get_check_state(){
		return check;
	}
	
	/**
	 * Sets the checkbox state
	 * 
	 * @param new_state the new checkbox state
	 */
	public void set_check_state(boolean new_state){
		check=new_state;
	}
	
	/**
	 * Sets the image of the item
	 * 
	 * @param image_path the new image of the item
	 */
	public void set_image(String image_path){
		set_image(image_path,image_path,image_path);
	}
	
	/**
	 * Sets the new image of the item
	 * 
	 * @param folder_closed the "closed folder" image
	 * @param folder_open the "opened folder" image
	 * @param leaf the "leaf" image
	 */
	public void set_image(String folder_closed, String folder_open, String leaf){
		im0 = folder_closed;
		im1 = folder_open;
		im2 = leaf;
	}
	
	/**
	 * Gets the count of child items
	 * 
	 * @return the count of child items
	 */
	public int has_kids(){
		return kids;
	}
	
	/**
	 * Sets the count of child items
	 * 
	 * @param count the count of child items
	 */
	public void set_kids(int count){
		kids = count;
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.DataItem#to_xml_end(java.lang.StringBuffer)
	 */
	@Override
	public void to_xml_end(StringBuffer out) {
		if (!skip)
			out.append("</item>");
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.DataItem#to_xml_start(java.lang.StringBuffer)
	 */
	@Override
	public void to_xml_start(StringBuffer out) {
		if (!skip){
			out.append("<item id='"+get_id()+"' text='"+get_value(config.text.get(0).name)+"' ");
			if (kids>0)
				out.append("child='"+Integer.toString(kids)+"' ");
			if (im0!=null)
				out.append("im0='"+im0+"' ");
			if (im1!=null)
				out.append("im1='"+im1+"' ");
			if (im2!=null)
				out.append("im2='"+im2+"' ");
			
			if (check)
				out.append("checked='true' ");
			
			out.append(">");
		}
	}
	
	
}
