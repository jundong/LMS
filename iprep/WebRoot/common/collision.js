(function(){

var temp_section,temp_time;
var before;

scheduler.config.collision_limit = 1;	
scheduler.attachEvent("onBeforeDrag",function(id){
	var pr = scheduler._props?scheduler._props[this._mode]:null;
	if (pr && id){
		temp_section = this.getEvent(id)[pr.map_to];
		temp_time = this.getEvent(id).start_date;
	}
	return true;  
});
scheduler.attachEvent("onBeforeLightbox",function(id){
	var ev = scheduler.getEvent(id);
	before = [ev.start_date, ev.end_date];
	return true;
});
scheduler.attachEvent("onEventChanged",function(id){
	if (!id) return true;
	var ev = scheduler.getEvent(id);
	if (!collision_check(ev)){
		if (!before) return false;
		ev.start_date = before[0];
		ev.end_date = before[1];
		ev._timed=this.is_one_day_event(ev);
	};
	return true;
});
scheduler.attachEvent("onBeforeEventChanged",function(ev,e,is_new){
	return collision_check(ev);
});
scheduler.attachEvent("onEventSave",function(id,data){
    var ev = scheduler.getEvent(id);
    var ret = true;
    if(data.rec_type == ""){
        var save_start = ev.start_date;
        var save_end = ev.end_date;
        var save_resources = ev.resources;
        
        ev.start_date = data.start_date;
        ev.end_date = data.end_date;
        ev.resources = ev.resources;
        
        ret = collision_check(ev);
        
        ev.start_date = save_start;
        ev.end_date = save_end;
        ev.resources = save_resources;
    } else {
        var save_start = ev.start_date;
        var save_end = ev.end_date;
        var save_rectype = ev.rec_type;
        var save_resources = ev.resources;
        var save_eventlength = ev.event_length;
        
        ev.resources = data.resources;
        ev.rec_type = data.rec_type;
        ev.end_date = data._end_date;
        if(data._start_date != null){
            ev.start_date = data._start_date;
        } else {
            ev.start_date = data.start_date;
        }
        ev.event_length = (data.end_date.valueOf() - data.start_date.valueOf())/1000;
        
        var dateObj = [];
        var recType=parseRecType(ev.rec_type);
        if(recType.type == "day"){
            dateObj = parseDaily(ev);
        } else if(recType.type == "week"){
            dateObj = parseWeekly(ev);
        } else if(recType.type == "month"){
            dateObj = parseMonthly(ev);
        } else if(recType.type == "year"){
            dateObj = parseYearly(ev);
        } 
        
        for(var i=0; i<dateObj.length; i++){
            ev.start_date = dateObj[i].start_date;
            ev.end_date = dateObj[i].end_date;
            ret = collision_check(ev);
            
            if(!ret) break;    
        }
        
        ev.start_date = save_start;
        ev.end_date = save_end;
        ev.rec_type = save_rectype;
        ev.resources = save_resources;
        ev.event_length = save_eventlength;
    }
    return ret;
});
function collision_check(ev){
	var evs = scheduler.getEvents(ev.start_date, ev.end_date);
	var single = true;	
	single = !isConllisionResource(ev, evs);	
	//if (!single) return !scheduler.callEvent("onEventCollision",[ev,evs]);
	return single;
};

function isConllisionResource(ev, evs){
   var cid = ev.id.toString().split("#");
   var resources = [];
   var oganizer = [];
   var isContention = false;
   var contentionIndex = 0;
   var currentRes = (ev.resources.replace(/\s*/gm, "")).split(",");
   for (var e in evs) {
     var lid = evs[e].id.toString().split("#");
     if (lid[0] != cid[0]){   
          var res = (evs[e].resources.replace(/\s*/gm, "")).split(",");
          for (var curIndex in currentRes){
             for (var evIndex in res){
                  if (currentRes[curIndex] == res[evIndex]){
                     resources[contentionIndex] = res[evIndex];
                     oganizer[contentionIndex] = evs[e].organizer; 
                     contentionIndex++;
                     isContention = true;                  
                  }
            }
         }
     }
   }
   
   if (isContention){
      var list = "";
      if (resources.length >= 13) {
	      for (var index=0; index < 12; index++){
	         list = list + "\n"+ "Resource: " + resources[index].replace(/[\r\n]/i, "") + " has been reserved by " + oganizer[index];
	      }
	      var skipitems = resources.length-13;
	      list = list + "\n"+ "......   skip "+skipitems+" items";
	      list = list + "\n"+ "Resource: " + resources[resources.length-1].replace(/[\r\n]/i, "") + " has been reserved by " + oganizer[index];
      } else {
          for (var index=0; index < resources.length; index++){
	         list = list + "\n"+ "Resource: " + resources[index].replace(/[\r\n]/i, "") + " has been reserved by " + oganizer[index];
	      }
      }
      list = list + "\n \n" + "Please select different time period."
      alert(list);
   }
   
   return isContention;
};
function parseDaily(ev){
   var dateObj=[];
   var recType=parseRecType(ev.rec_type);
        if(recType.extra == "" || recType.extra == "no"){
                while(ev.start_date<ev.end_date){
                        var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
                        dateObj.push({start_date:ev.start_date, end_date:end_date});
                        ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"day");
                }
        } else {
                var times=recType.extra;
                while(ev.start_date<ev.end_date){
                        var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
                        dateObj.push({start_date:ev.start_date, end_date:end_date});
                        if(times--<1){
                           break;
                        }
                        ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"day");
                }
        }
    return dateObj;
};
function parseWeekly(ev){
   var dateObj=[];
   var recType=parseRecType(ev.rec_type);
   if(recType.extra == "" || recType.extra == "no"){
		while(ev.start_date<ev.end_date){
			if(recType.days == ""){
				var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
				dateObj.push({start_date:ev.start_date, end_date:end_date});
				ev.start_date=scheduler.date.add(ev.start_date,recType.count*7,"day");
			} else {
				var splitDays = recType.days.split(",");
				for(var i=0; i<splitDays.length; i++){
                     var offsetweekday=getOffsetWeekDay(ev.start_date, splitDays[i]);
                     var start_date=scheduler.date.add(ev.start_date,offsetweekday/1,"day");
                     var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
                     dateObj.push({start_date:start_date, end_date:end_date});

					if(end_date >= ev.end_date){
						break;
					}	
				}
                ev.start_date=scheduler.date.add(ev.start_date,recType.count*7,"day");
			}
		}
	} else {
		var times=recType.extra;
		while(ev.start_date<ev.end_date){
			if(recType.days == ""){
				var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
				dateObj.push({start_date:ev.start_date, end_date:end_date});
				if(--times<1){
					   break;
				}
				ev.start_date=scheduler.date.add(ev.start_date,recType.count*7,"day");
			} else {
				var splitDays = recType.days.split(",");
				for(var i=0; i<splitDays.length; i++){
                     var offsetweekday=getOffsetWeekDay(ev.start_date, splitDays[i]);
                     var start_date=scheduler.date.add(ev.start_date,offsetweekday/1,"day");
                     var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
                     dateObj.push({start_date:start_date, end_date:end_date});

					if(end_date >= ev.end_date || --times<1){
						break;
					}		
				}	
				if(times<1){
					   break;
				}
                ev.start_date=scheduler.date.add(ev.start_date,recType.count*7,"day");
			}
		}
	}
	return dateObj;
};
function parseMonthly(ev){
   var dateObj=[];
   var recType=parseRecType(ev.rec_type);
   if(recType.extra == "" || recType.extra == "no"){
		if(recType.count2 == "" && recType.day == ""){
			while(ev.start_date<ev.end_date){
                var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
                dateObj.push({start_date:ev.start_date, end_date:end_date});
				ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"month");
			}
		} else {
			while(ev.start_date<ev.end_date){
				var offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
				var start_date=scheduler.date.add(ev.start_date,offsetDay/1,"day");
				var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
				dateObj.push({start_date:start_date, end_date:end_date});
				
				ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"month");
				offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
				if(scheduler.date.add(ev.start_date,offsetDay/1,"day") >= ev.end_date){
					break;
				}
			}
		}
	} else {
		var times=recType.extra;
		while(ev.start_date<ev.end_date){
			if(recType.count2 == "" && recType.day == ""){
                var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
                dateObj.push({start_date:ev.start_date, end_date:end_date});
				if(--times<1){
				   break;
				}
                ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"month");
			} else {
				while(ev.start_date<ev.end_date){
					var offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
					var start_date=scheduler.date.add(ev.start_date,offsetDay/1,"day");
					var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
					dateObj.push({start_date:start_date, end_date:end_date});
					
					ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"month");
					offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
					if(scheduler.date.add(ev.start_date,offsetDay,"day") >= ev.end_date || --times<1){
						break;
					}
				}
			}				
		}
	}
    return dateObj;
};
function parseYearly(ev){
   var dateObj=[];
   var recType=parseRecType(ev.rec_type);
   if(recType.extra == "" || recType.extra == "no"){
		if(recType.count2 == "" && recType.day == ""){
			while(ev.start_date<ev.end_date){
				var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
				dateObj.push({start_date:ev.start_date, end_date:end_date});
				ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"year");
			}
		} else {
			while(ev.start_date<ev.end_date){
				var offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
				var start_date=scheduler.date.add(ev.start_date,offsetDay/1,"day");
				var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
				dateObj.push({start_date:start_date, end_date:end_date});
				
				ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"year");
				offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
				if(scheduler.date.add(ev.start_date,offsetDay/1,"day") >= ev.end_date){
					break;
				}
			}
		}
	} else {
		var times=recType.extra;
		while(ev.start_date<ev.end_date){
			if(recType.count2 == "" && recType.day == ""){
                var end_date=scheduler.date.add(ev.start_date,ev.event_length/60,"minute");
                dateObj.push({start_date:ev.start_date, end_date:end_date});
				if(--times<1){
				   break;
				}
                ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"year");
			} else {
				while(ev.start_date<ev.end_date){
					var offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
					var start_date=scheduler.date.add(ev.start_date,offsetDay/1,"day");
					var end_date=scheduler.date.add(start_date,ev.event_length/60,"minute");
					dateObj.push({start_date:start_date, end_date:end_date});
					
					ev.start_date=scheduler.date.add(ev.start_date,recType.count/1,"year");
					offsetDay=getOffsetDay(ev.start_date, recType.count2, recType.day);
					if(scheduler.date.add(ev.start_date,offsetDay/1,"day") >= ev.end_date || --times<1){
						break;
					}
				}
			}				
		}
	}
    return dateObj;
}
function getOffsetWeekDay(date, weekday){
	  var offsetDay = 0;
	  if(weekday==0){
		  if(date.getDay()==0){
			  offsetDay=0;
		  } else if(date.getDay()==1){
			  offsetDay=6;
		  } else if(date.getDay()==2){
			  offsetDay=5;
		  } else if(date.getDay()==3){
			  offsetDay=4;
		  } else if(date.getDay()==4){
			  offsetDay=3;
		  } else if(date.getDay()==5){
			  offsetDay=2;
		  } else if(date.getDay()==6){
			  offsetDay=1;
		  }
	  } else if(weekday==1){
		  if(date.getDay()==0){
			  offsetDay=1;
		  } else if(date.getDay()==1){
			  offsetDay=0;
		  } else if(date.getDay()==2){
			  offsetDay=6;
		  } else if(date.getDay()==3){
			  offsetDay=5;
		  } else if(date.getDay()==4){
			  offsetDay=4;
		  } else if(date.getDay()==5){
			  offsetDay=3;
		  } else if(date.getDay()==6){
			  offsetDay=2;
		  }
	  } else if(weekday==2){
		  if(date.getDay()==0){
			  offsetDay=2;
		  } else if(date.getDay()==1){
			  offsetDay=1;
		  } else if(date.getDay()==2){
			  offsetDay=0;
		  } else if(date.getDay()==3){
			  offsetDay=6;
		  } else if(date.getDay()==4){
			  offsetDay=5;
		  } else if(date.getDay()==5){
			  offsetDay=4;
		  } else if(date.getDay()==6){
			  offsetDay=3;
		  }
	  } else if(weekday==3){
		  if(date.getDay()==0){
			  offsetDay=3;
		  } else if(date.getDay()==1){
			  offsetDay=2;
		  } else if(date.getDay()==2){
			  offsetDay=1;
		  } else if(date.getDay()==3){
			  offsetDay=0;
		  } else if(date.getDay()==4){
			  offsetDay=6;
		  } else if(date.getDay()==5){
			  offsetDay=5;
		  } else if(date.getDay()==6){
			  offsetDay=4;
		  }
	  } else if(weekday==4){
		  if(date.getDay()==0){
			  offsetDay=4;
		  } else if(date.getDay()==1){
			  offsetDay=3;
		  } else if(date.getDay()==2){
			  offsetDay=2;
		  } else if(date.getDay()==3){
			  offsetDay=1;
		  } else if(date.getDay()==4){
			  offsetDay=0;
		  } else if(date.getDay()==5){
			  offsetDay=6;
		  } else if(date.getDay()==6){
			  offsetDay=5;
		  }
	  } else if(weekday==5){
		  if(date.getDay()==0){
			  offsetDay=5;
		  } else if(date.getDay()==1){
			  offsetDay=4;
		  } else if(date.getDay()==2){
			  offsetDay=3;
		  } else if(date.getDay()==3){
			  offsetDay=2;
		  } else if(date.getDay()==4){
			  offsetDay=1;
		  } else if(date.getDay()==5){
			  offsetDay=0;
		  } else if(date.getDay()==6){
			  offsetDay=6;
		  }
	  } else {
		  if(date.getDay()==0){
			  offsetDay=6;
		  } else if(date.getDay()==1){
			  offsetDay=5;
		  } else if(date.getDay()==2){
			  offsetDay=4;
		  } else if(date.getDay()==3){
			  offsetDay=3;
		  } else if(date.getDay()==4){
			  offsetDay=2;
		  } else if(date.getDay()==5){
			  offsetDay=1;
		  } else if(date.getDay()==6){
			  offsetDay=0;
		  }
	  }
	  
	  return offsetDay;
};
function getOffsetDay(date, weekday, internalWeek){
	  var offsetDay = 0;
	  if(weekday==0){
		  if(date.getDay()==0){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==1){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=1+(internalWeek-1)*7;
		  }
	  } else if(weekday==1){
		  if(date.getDay()==0){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==2){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=2+(internalWeek-1)*7;
		  }
	  } else if(weekday==2){
		  if(date.getDay()==0){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==3){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=3+(internalWeek-1)*7;
		  }
	  } else if(weekday==3){
		  if(date.getDay()==0){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==4){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=4+(internalWeek-1)*7;
		  }
	  } else if(weekday==4){
		  if(date.getDay()==0){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==5){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=5+(internalWeek-1)*7;
		  }
	  } else if(weekday==5){
		  if(date.getDay()==0){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=internalWeek*7;
		  } else if(date.getDay()==6){
			  offsetDay=6+(internalWeek-1)*7;
		  }
	  } else {
		  if(date.getDay()==0){
			  offsetDay=6+(internalWeek-1)*7;
		  } else if(date.getDay()==1){
			  offsetDay=5+(internalWeek-1)*7;
		  } else if(date.getDay()==2){
			  offsetDay=4+(internalWeek-1)*7;
		  } else if(date.getDay()==3){
			  offsetDay=3+(internalWeek-1)*7;
		  } else if(date.getDay()==4){
			  offsetDay=2+(internalWeek-1)*7;
		  } else if(date.getDay()==5){
			  offsetDay=1+(internalWeek-1)*7;
		  } else if(date.getDay()==6){
			  offsetDay=internalWeek*7;
		  }
	  }
	  
	  return offsetDay;
};
function parseRecType(rec_type){
   var recTypeObj={type:"", count:"", count2:"", day:"", days:"", extra:""};
   var splitUnderLineList = rec_type.split("_");
  
   recTypeObj.type = splitUnderLineList[0];
   recTypeObj.count = splitUnderLineList[1];
   recTypeObj.count2 = splitUnderLineList[2];
   recTypeObj.day = splitUnderLineList[3];
       
   var splitNumberSignList = splitUnderLineList[4].split("#");
   if(splitNumberSignList.length == 1){
          recTypeObj.days = splitNumberSignList[0];
   } else if(splitNumberSignList.length == 2){
        recTypeObj.days = splitNumberSignList[0];
            recTypeObj.extra = splitNumberSignList[1];
   }
  
   return recTypeObj;
};
})();