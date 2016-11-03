##########################################################################################################
# Script Name	:  STC Inventory Tool (SIT)                                                              #
# Script Author :  Saiyoot Nakkhongkham                                                                  #
# Description	:  Connect to the chassis and read out all haward related information                    #
#                                                                                                        #
# Hardware Req	:  List of STC chassis IP addresses                                                      #
#                                                                                                        #
# Software Req  :  STC bios package need to be installed in the default directory.                       #
# Files Req	    :  Honoulu PV TCL framework                                                              #
# Est. Time Req :  Up to a few minutes or so depending on how many chaissis is used                      #
# Date written  :  08/10/2009                                                                            #
#                                                                                                        #
# Modified      :                                                                                        #
##########################################################################################################

#package require mysqlutils
set mydirectory "D:/work/stc_scripts/Curr_Access/ISDE_China/LRS/inventory/WebRoot/common/scripts"
source "$mydirectory/mysqlutils.tcl"
package require mime
package require smtp 

proc SendOutOfDateMail {subject_hdr} {
    set file_with_message "$::mydirectory/watchdogemail.txt"
    set msg [mime::initialize -canonical text/html -file $file_with_message]
    smtp::sendmessage $msg \
        -header [list Subject $subject_hdr] \
        -header [list From saiyoot.nakkhongkham@spirent.com] \
        -header [list To saiyoot.nakkhongkham@spirent.com] \
        -servers SPCHONEXC01.AD.SPIRENTCOM.COM
}

proc GoWatchDog {Site} {
    #Collect scanning time
    set nowtime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]
    set dbName "pv_inventory"
    puts "Open database..."
    set ::dbConn [mysql::OpenMySqlDB $dbName]
    set mysql::debugLevel 0

    set lastScanList [::mysql::sel $::dbConn "SELECT DISTINCT LastScan FROM stc_inventory_chassis WHERE Site = '$Site'" -list]
    puts "mylastcanlist: $lastScanList"
    foreach scanTime $lastScanList {
        set lastscan [lindex $scanTime 0]
        set lastscan [clock scan $lastscan]
        set curtime [clock scan $nowtime]
        set diff [expr $curtime - $lastscan]
        #puts "diff: $diff"
        if {$diff > 86400} {
            set numofday [expr ceil([expr $diff/86400])]
            set subject_hdr "The $Site scan is out of date by $numofday day(s)."
            SendOutOfDateMail $subject_hdr
        } 
    }
    puts "Close database...."
    mysql::CloseMySqlDB $::dbConn
}

while {1} {
    GoWatchDog "HNL"
    GoWatchDog "RTP"
    GoWatchDog "CHN"
    GoWatchDog "SNV"
    GoWatchDog "CAL"
    after [expr 86400*1000]
}
