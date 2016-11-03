package com.spirent.javaconnector;

import java.util.ArrayList;

import com.spirent.scheduler.ConnectorBehavior;
import com.spirent.scheduler.FilteringRule;

/**
 * @author spirent
 *
 */
public class FilterBehavior extends ConnectorBehavior {
	private String name;
	private String value;
	private String operation;
	private String[] portList;
	
	  public FilterBehavior(String name, String value)
	  {
	    this.name = name;
	    this.value = value;
	    this.operation = "";
	  }
	  
	  public FilterBehavior(String name, String[] portList, String operation)
	  {
	    this.name = name;
	    this.portList = portList;
	    this.operation = operation;
	  }

	  public FilterBehavior(String name, String value, String operation)
	  {
	    this.name = name;
	    this.value = value;
	    this.operation = operation;
	  }
	
    public void beforeFilter(ArrayList<FilteringRule> filters){
    	if (portList != null){
    		for (int index = 0; index < portList.length; index++)
    		{
        	   filters.add( new FilteringRule(getName(),"%"+portList[index]+"%",getOperation()));
    		} 
    	} 
    	else 
		{
			 filters.add( new FilteringRule(getName(),getValue(),getOperation()));
		}
     }

	public String getName() {
		return name;
	}

	public String getValue() {
		return value;
	}

	public String getOperation() {
		return operation;
	}
}
