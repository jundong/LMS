<%@ page language="java"
	import="java.util.*"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.spirent.utilization.ConnectionMap"%>
<%@ include file="../authentication.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head> 
	<title>Scheduler</title>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
	<script src="/iprep/common/scheduler.js" type="text/javascript" charset="utf-8"></script>
	<script src="/iprep/common/recurring.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" href="/iprep/common/css/scheduler.css" type="text/css" media="screen" title="no title" charset="utf-8"/>
	<link rel="stylesheet" href="/iprep/common/css/recurring.css" type="text/css" media="screen" title="no title" charset="utf-8"/>
	<script src="/iprep/common/collision.js" type="text/javascript" charset="utf-8"></script>
	<script src="/iprep/common/serialize.js" type="text/javascript" charset="utf-8"></script>
<%
    String username = (String) request.getSession().getAttribute("username");
    String levels = (String) request.getSession().getAttribute("levels"); 
    String type = request.getParameter("type");
    String portList = request.getParameter("portList");
    if (portList != null) {
      if (!portList.equals("myreservations")) {
          portList = (new ConnectionMap()).getConnectionResource(portList);
          request.getSession().setAttribute("resources", portList);
       } 
    }
%>
   
</head>
	
<style type="text/css" media="screen">
	html, body{
		margin:0px;
		padding:0px;
		height:100%;
		overflow:hidden;
	}	
</style>

<script type="text/javascript" charset="utf-8">
//Global variables
var queryStr = window.location.search.substr(1);
var isChangeInOnClick = false;

//collision detection

    function formatResources(resources){
        resources = resources.replace(/[\r\n]/i, "");
        var splitResources = resources.split(",");
        var evResources = "";
        if (splitResources.length == 1) {
            evResources = splitResources[0];
        } else {
            evResources = splitResources[0] + ",";
	        for (var index=1; index<splitResources.length-1; index++){
	               evResources = evResources + "\n" +  splitResources[index] + ",";
	        }
	        evResources = evResources + "\n" +  splitResources[splitResources.length-1];
        }
        return evResources;
    }
    
	function init() {
		
		scheduler.templates.event_text=function(start, end, event){
           return "<b>Purpose: </b><br>"+event.text+"<br>"+"<b>User: </b><br>"+event.organizer+"<br>"+"<b>Resources: </b><br>"+event.resources;
        }
		
		//Scheduler configurations
		scheduler.config.lightbox.sections=[	
			{name:"description", height:40, type:"textarea" , map_to:"text", focus:true},			
			{name:"organizer", height:15, type:"organizer", map_to:"organizer" },
			{name:"resources", height:60, type:"textarea", map_to:"resources" },
			{name:"recurring", height:115, type:"recurring", map_to:"rec_type", button:"recurring"},
			{name:"time", height:40, type:"time", map_to:"auto"}
		]	
		scheduler.config.xml_date="%Y-%m-%d %H:%i";
		scheduler.config.multi_day = true;
		scheduler.config.details_on_create=true;
		scheduler.config.details_on_dblclick=true;        
		scheduler.config.server_utc = true;	
		scheduler.config.readonly_form = false;
		scheduler.config.dblclick_create = true;
		scheduler.config.drag_resize = true;
        scheduler.config.drag_move = true;
        scheduler.config.edit_on_create = true;
		//scheduler.config.readonly = false;
		
		//Scheduler labels
		scheduler.locale.labels.section_resources="Resources";
		scheduler.locale.labels.section_organizer="User";
		scheduler.locale.labels.new_organizer="<%=username%>";
		
		//Refresh all Lab Session schedulers when Lab Session updated
		scheduler.config.update_render=true;
		
		//Attach Scheduler events
		scheduler.attachEvent("onBeforeDrag",function(id){
		   if (isChangeInOnClick){
		      isChangeInOnClick = false;
		      scheduler.config.readonly_form = false;
		   }

           if (scheduler.config.readonly_form)
		   {
		       return false;
		   } 
		   
		   if (id) {
			   if (scheduler.getEvent(id).organizer != "<%=username%>"){
				   if ("2" == "<%=levels%>"){
				       return false;
				   }	  
			   }
		   }
		   
		   return true;
		});
		
		scheduler.attachEvent("onClick",function(id){
		   if (isChangeInOnClick){
		      isChangeInOnClick = false;
		      scheduler.config.readonly_form = false;
		   }
		   if (scheduler.config.readonly_form )
		   {
		       return false;
		   } 
		   if (id){
			   if (scheduler.getEvent(id).organizer != "<%=username%>"){
				   if ("2" == "<%=levels%>"){
				       isChangeInOnClick = true;
				       scheduler.config.readonly_form = true;
				       return false;
				   }	  
			   }
		   }
		      return true;
		});
		
		//Filter Scheduler's Lab Session
		if ("<%=type%>" != "null"){
		     
			scheduler.config.readonly_form = true;
			scheduler.config.dblclick_create = false;
			
			//Init Scheduler with current date
		    scheduler.init('scheduler_here',new Date(),"week");
		    
            var filterStr = "&" + queryStr + "&columnName=resources";
            scheduler.load("events.do?uid="+scheduler.uid()+filterStr);
        } else if("<%=portList%>" == "myreservations"){
		    //scheduler.config.readonly_form = true;
		    scheduler.config.dblclick_create = false;
		    
			//Init Scheduler with current date
		    scheduler.init('scheduler_here',new Date(),"week");   
            scheduler.load("events.do?uid="+scheduler.uid() + "&username=" + "<%=username%>" + "&columnName=organizer");
        } else {
             scheduler.locale.labels.new_resources = formatResources("<%=portList%>");
			 //Init Scheduler with current date
		     scheduler.init('scheduler_here',new Date(),"week");
		    
             scheduler.load("events.do?uid="+scheduler.uid()+ "&columnName=resources");
             
	            var evID = scheduler.uid();
				scheduler._loading=true;
				
				var start = new Date();
				//start.setHours(0);
				start.setMinutes(0);
				start.setSeconds(0);
	
				var end = new Date();
				var endHours = (start.getHours()+1>=24) ? (start.getHours()-23) : (start.getHours()+1);
				end.setHours(endHours);
				end.setMinutes(0);
				end.setSeconds(0);
				
				scheduler.addEvent(start, end,scheduler.locale.labels.new_event,evID,{resources:scheduler.locale.labels.new_resources,organizer:scheduler.locale.labels.new_organizer,timeoffset:(new Date()).getTimezoneOffset()});
				scheduler.callEvent("onEventCreated",[evID,scheduler.getEvent(evID)]);
				scheduler._loading=false;
				scheduler._new_event = new Date();
				scheduler.showLightbox(evID);			
        } 
			
		var dp = new dataProcessor("events.do");
		dp.init(scheduler);
	}
</script>

<body onload="init();">
	<div id="scheduler_here" class="dhx_cal_container" style='width:100%; height:100%;'>
		<div class="dhx_cal_navline">
			<div class="dhx_cal_prev_button">&nbsp;</div>
			<div class="dhx_cal_next_button">&nbsp;</div>
			<div class="dhx_cal_today_button"></div>
			<div class="dhx_cal_date"></div>
			<div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>
			<div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>
			<div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>
		</div>
		<div class="dhx_cal_header">
		</div>
		<div class="dhx_cal_data">
		</div>		
	</div>
</body>