#Load package mysqlutils
package require mysqlutils
namespace eval lrs {
    #dbname
    variable lsr_dbname "pv_inventory"
    variable lsr_conn ""
    variable lsr_reservationID ""
}

proc lrs::login {} {
    variable lsr_conn
    variable lsr_dbname
    set lsr_conn [mysql::OpenMySqlDB $lsr_dbname]
    if {$lsr_conn == ""} {
        return false
    }
    return true
}

proc lrs::getTimeOffset {seconds} {
    set utcTime [clock format $seconds -gmt true -format {%Y-%m-%d %H:%M:%S}]
    set utcSeconds [clock scan $utcTime]
    set intervalSeconds [expr $utcSeconds - $seconds]
    set timeOffset [expr $intervalSeconds / 60]
    return $timeOffset
}

proc lrs::convertToUTC {date} {
    set seconds [clock scan $date]
    set utcDate [clock format $seconds -gmt true -format {%Y-%m-%d %H:%M:%S}]
    return $utcDate
}

proc lrs::formatResources {resources} {
    set resources  [string map {\r "" \n ""} $resources]
    set resources  [string map {, ",\n"} $resources]
    return $resources
}

proc lrs::generateUID {} {
    variable lsr_conn
    variable lsr_reservationID 
    #Get uid in db
    set maxUID [::mysql::sel $lsr_conn "SELECT MAX(uid) FROM events_ex" -list]
    set lsr_reservationID [expr $maxUID + 1]
    #return $lsr_reservationID
}

proc lrs::reserve {username startdate enddate description resources timeoffset uid} {
    variable lsr_conn
    set startdate [lrs::convertToUTC $startdate]
    set enddate [lrs::convertToUTC $enddate]
    set utcTime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]
    set isConflict [lrs::detectiveConflict $startdate $enddate $resources]
    set isConflict "false"
    if {$isConflict == "false"} {
        set results [mysql::InsertReservationRecordToDB $lsr_conn "INSERT" "events_ex" $uid   \
                uid                     $uid               \
                description             $description \
                dtstart                 $startdate \
                dtend                   $enddate \
                resources               $resources \
                organizer               $username \
                timeoffset              $timeoffset \
                snotification           "0" \
                enotification           "0" \
                rec_type                "" \
                event_length            "0" \
                event_pid               "0"]
	
	        set results [mysql::InsertReservationRecordToDB $lsr_conn "INSERT" "events_rec" $uid   \
                uid                     $uid               \
		rec_index               "1" \
                description             $description \
                dtstart                 $startdate \
                dtend                   $enddate \
                resources               $resources \
                organizer               $username \
                timeoffset              $timeoffset \
                snotification           "0" \
                enotification           "0"]
        
        puts "Add reservation successfully."

        #here will trigger notification function to send a email to user to tell him the reservation added successfully
        set email [::mysql::sel $lsr_conn "SELECT mail FROM users WHERE username='$username'"  -list]
        set body "Thank you for using Spirent Lab Management System.\n \
                  You have reserved the following resources:\n \
		User: $username \n \
		Purpose: $description \n \
		Resources: $resources \n \
		Start Date: $startdate \n \
		End Date: $enddate \n \
                Reservation ID: $uid \n \
		To cancel, extend, or to make another reservation, please click: http://englabmanager/inventory/index.jsp.";
                                                
        lrs::send_simple_message $email "Spirent Lab Management System Notification" $body
        
    } else {
        puts "Because resources conflicted, so this reservation didn't add into LRS."
        #here will trigger notification function to send a email to user to tell him the reservation cancelled
    }
}

proc lrs::release {reservationID} {
    variable lsr_conn
    set insrtstmt "DELETE FROM events_ex WHERE uid='$reservationID'"
    set results [::mysql::sel $lsr_conn $insrtstmt]
    
    set insrtstmt "DELETE FROM events_rec WHERE uid='$reservationID'"
    set results [::mysql::sel $lsr_conn $insrtstmt]
    
    puts $results
}

proc lrs::detectiveConflict {startdate enddate curResources} {
    variable lsr_conn
    
    set insrtstmt "SELECT resources FROM events_rec WHERE STRCMP(dtstart, '"
    append insrtstmt "$enddate')=-1 AND "
    append insrtstmt "STRCMP(dtend, '"
    append insrtstmt "$startdate')=1"
    
    #Get conflict reservation resources in db
    set resourcesList [::mysql::sel $lsr_conn $insrtstmt -list]
    if {$resourcesList == ""} {
        return false
    }
    
    set curResources [list "$curResources"]
    set curResources [string map {\r "" \n ""} $curResources]
    foreach resources $resourcesList {
        set resources [list "$resources"]
        set resources [string map {\r "" \n ""} $resources]
        foreach resource [split $resources ","] {
            foreach curResource [split $curResources ","] {
                if {$resource == $curResource} {
                    return true
                }
            }
        }
    }
    return false
}

proc lrs::send_simple_message {recipient subject body } {
    package require smtp
    package require mime

    set token [mime::initialize -canonical text/plain \
	-string $body]
    mime::setheader $token Subject $subject
    smtp::sendmessage $token \
	-recipients $recipient -servers "smtp.spirentcom.com"  -originator "lms@spirentcom.com"  -debug "0"
    mime::finalize $token
}

##lrs::send_simple_message "Jundong.Xu@spirentcom.com" "This is the subject." "This is the message."
#set mysql::debugLevel 1
set username "jxu"
set startdate "2010-06-26 09:00:00"
set enddate "2010-06-26 13:00:00"
set description "my tcl testing for LRS"
##
set resources "10.14.18.19//1/1"
set resources [lrs::formatResources $resources]
set seconds [clock seconds]
set timeoffset [lrs::getTimeOffset $seconds]
##
lrs::login
#lrs::generateUID
#lrs::reserve $username $startdate $enddate $description $resources $timeoffset $lrs::lsr_reservationID
#puts $lrs::lsr_reservationID
#lrs::release "686"

