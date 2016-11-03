/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */

package com.spirent.javaconnector;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.scheduler.ConnectorServlet;
import com.spirent.scheduler.SchedulerConnector;



// TODO: Auto-generated Javadoc
/**
 * The Class SchedulerBasicConnector.
 */
public class SchedulerBasicConnector extends ConnectorServlet {

	/* (non-Javadoc)
	 * @see com.dhtmlx.connector.ConnectorServlet#configure()
	 */
	  private String columnName = "";
	  private String portList = "";
	  private String port = "";
	  private String operator = "LIKE";
	  private String username = "";
     
	  public String getColumnName() {
			return columnName;
		}
		public void setColumnName(String columnName) {
			this.columnName = columnName;
		}
		public String getOperator() {
			return operator;
		}
		public void setOperator(String operator) {
			this.operator = operator;
		}
		
		public String getPortList() {
			return portList;
		}
		public void setPortList(String portList) {
			this.portList = portList;
		}
		
	  public void doGet(HttpServletRequest req, HttpServletResponse res)
	    throws ServletException, IOException
	  {   
		  setColumnName(req.getParameter("columnName"));
		  setPort(req.getParameter("Port")); 
		  setUsername(req.getParameter("username"));
		  
		  if (req.getSession().getAttribute("resources") != null){
		      setPortList(req.getSession().getAttribute("resources").toString());
		      req.getSession().removeAttribute("resources");
		  } else {
			  setPortList("");
		  }
		  
		  if (req.getParameter("operator") != null){
			  setOperator(req.getParameter("operator")); 
		  }
		  
         super.doGet(req, res);
	  }
	
	@Override
	protected void configure() {
		Connection conn = null;
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				SchedulerConnector sconn = new SchedulerConnector(conn);
				if (getPort() != null) {
					   String filter = "%" + getPort() + "%";
					   sconn.event.attach(new SchedulerRecBehavior(sconn));
				       sconn.event.attach(new FilterBehavior(getColumnName(), filter, getOperator()));
				} else if (getPortList() != null && !getPortList().equals("")){
					String[] splitPortList = getPortList().split(",");
					sconn.event.attach(new SchedulerRecBehavior(sconn));
					sconn.event.attach(new FilterBehavior(getColumnName(), splitPortList, getOperator()));
				} else if (getUsername() != null){
					sconn.event.attach(new SchedulerRecBehavior(sconn));
					sconn.event.attach(new FilterBehavior(getColumnName(), getUsername(), "="));
				}
				sconn.render_table("events_ex","uid","dtstart,dtend,description,resources,organizer,timeoffset,rec_type,event_pid,event_length","","");
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in SchedulerBasicConnector.java: "
							+ e.getMessage());
		}finally {
        	try {
        		if(conn != null){
        			DataBaseConnection.freeConnection(conn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in SchedulerBasicConnector.java: "
						+ e.getMessage());
        	}
        }
	}
	public String getPort() {
		return port;
	}
	public void setPort(String port) {
		this.port = port;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
}
