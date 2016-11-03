/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
package com.spirent.javaconnector;

import com.spirent.scheduler.ConnectorBehavior;
import com.spirent.scheduler.ConnectorOperationException;
import com.spirent.scheduler.DBDataWrapper;
import com.spirent.scheduler.DataAction;
import com.spirent.scheduler.LogManager;
import com.spirent.scheduler.SchedulerConnector;


// TODO: Auto-generated Javadoc
/**
 * The Class SchedulerRecBehavior.
 */
public class SchedulerRecBehavior extends ConnectorBehavior {
	
	/** The connector. */
	SchedulerConnector connector;
	
	/**
	 * Instantiates a new scheduler rec behavior.
	 * 
	 * @param connector the connector
	 */
	public SchedulerRecBehavior(SchedulerConnector connector){
		this.connector = connector;
	}
	
	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.ConnectorBehavior#beforeProcessing(com.dhtmlx.connector.DataAction)
	 */
	@Override
	public void beforeProcessing(DataAction action) {
		String status = action.get_status();
		String type = action.get_value("rec_type");
		String pid = action.get_value("event_pid");
		if (pid == null){
			action.set_value("event_pid", "0");
		}

       try {
			//when series changed or deleted we need to remove all linked events
			if ((status.equals("deleted") || status.equals("updated")) && !type.isEmpty()){
				((DBDataWrapper)connector.sql).query("DELETE FROM events_ex WHERE uid='"+((DBDataWrapper)connector.sql).escape(action.get_id())+"'");
			}
			if (status.equals("deleted") && !pid.isEmpty() && !pid.equals("0")){
				((DBDataWrapper)connector.sql).query("UPDATE events_ex SET rec_type='none' WHERE uid='"+((DBDataWrapper)connector.sql).escape(action.get_id())+"'");
				action.success();
			}
		} catch (ConnectorOperationException e) {
			LogManager.getInstance().log("Reccuring event error \n"+e.getMessage());
			System.out.println("Reccuring event error \n"+e.getMessage());
		}
		
		super.beforeProcessing(action);
	}

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.ConnectorBehavior#afterProcessing(com.dhtmlx.connector.DataAction)
	 */
	@Override
	public void afterProcessing(DataAction action) {
		String status = action.get_status();
		String type = action.get_value("rec_type");
		if (status.equals("inserted") && type.equals("none"))
			action.set_status("deleted");
		else
			super.afterProcessing(action);
	}

	
}
