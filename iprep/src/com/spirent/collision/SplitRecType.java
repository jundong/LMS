package com.spirent.collision;

public class SplitRecType {
	//type of repeating ¡°day¡±,¡±week¡±,¡±week¡±,¡±month¡±,¡±year¡±
    String type = "";
    
    //how much intervals of ¡°type¡± come between events
    String count = "";
    
    //count2 and day - used to define day of month ( first Monday, third Friday, etc )
    String count2 = "";
    String day = "";  
    
    //comma separated list of affected week days
    String days = "";
    
    //this info is not necessary for calculation, but can be used to correct presentation of recurring details
    String extra = "";
    
    SplitRecType(String rec_type){
    	String[] splitUnderLineList = rec_type.split("_");
    	
    	this.type = splitUnderLineList[0];
    	this.count = splitUnderLineList[1];
    	this.count2 = splitUnderLineList[2];
    	this.day = splitUnderLineList[3];
    	
    	String[] splitNumberSignList = splitUnderLineList[4].split("#");
        if(splitNumberSignList.length == 1){
    	  this.days = splitNumberSignList[0];
        } else if(splitNumberSignList.length == 2){
        	this.days = splitNumberSignList[0];
    	    this.extra = splitNumberSignList[1];
        }
    }
}
