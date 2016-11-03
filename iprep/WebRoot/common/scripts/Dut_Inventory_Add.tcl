##########################################################################################################
# Script Name	:  DUT Inventory Tool (SIT)                                                              #
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
proc add_resource {argc argv} {
    #Loading SNMP package
    package require SmithySDK
    package require mysqlutils
    
    set scantime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]
    
    append chassisIpList  $argv

    set dbName "pv_inventory"
    set ::dbConn [mysql::OpenMySqlDB $dbName]
    set mysql::debugLevel 1
    set opcode ""

    #Clear out the three tables
    if {0} {
        #puts "ERROR: You are about to erase the database. The department info is user defined and must be manually entered."
        #return
        #exit
        mysql::DeleteRecordInTable $::dbConn "dut_inventory"
        mysql::DeleteRecordInTable $::dbConn "dut_inventory_intf"
    }

    #Process one connected physicalchassis at a time
    array set info {}
    array set mainInterfaces {}
    smilib import -file C:/Tcl/lib/smithysdk/mibs/IETF/SNMPv2-MIB.mib
    smilib import -file C:/Tcl/lib/smithysdk/mibs/IETF/SNMPv2-SMI.mib
    #set up mib database and snmp session
    set mibdb [smilib new]
    set sess [snmplib new]

    foreach hostIp $chassisIpList {
        puts "Working with hostip $hostIp"

        #Collect chassis information
        if {[string match "10.14.*" $hostIp]} {
            set site "HNL"
        } elseif {[string match "10.100.*" $hostIp]} {
            set site "CAL"
        } elseif {[string match "10.6.*" $hostIp]} {
            set site "RTP"
        } elseif {[string match "10.47.*" $hostIp]} {
            set site "SNV"
        } elseif {[string match "10.61.*" $hostIp]} {
            set site "CHN"
        }
        
        #configure snmp session based on the given ip address
        $sess configure \
            -version SNMPv2c -address $hostIp -community "public" \
            -readcommunity "public" -writecommunity "private" -db $mibdb
        #$sess configure -logchannel "stdout"
        $sess configure -logchannel ""

        #sysDescr
        set info($hostIp,juniper) 0
        set info($hostIp,cisco) 0
        set info($hostIp,erx) 0
        array set Params [$sess bulk 1.3.6.1.2.1.1] ;#system info
        set info($hostIp,sysDescr)  [lindex [lindex $Params(-varbinds) 0] 2] 

        #system status
        if {$Params(-status) == "noError"} { set info($hostIp,status) "UP" } else { set info($hostIp,status) "DOWN" }

        #Vendor
        if {[string match "*Juniper*" $info($hostIp,sysDescr)]} {
            set info($hostIp,juniper) 1
            set info($hostIp,vendor) "Juniper" 
        } elseif {[string match "*Cisco*" $info($hostIp,sysDescr)]} {
            set info($hostIp,cisco) 1
            set info($hostIp,vendor) "Cisco" 
        } else {
            set info($hostIp,erx) 1
            set info($hostIp,vendor) "Juniper" 
        }

        #sysUpTime
        array set Params [$sess get 1.3.6.1.2.1.1.3.0] ;#system info
        set info($hostIp,sysUpTime)  [lindex [lindex $Params(-varbinds) 0] 2] 

        #sysName
        array set Params [$sess get 1.3.6.1.2.1.1.5.0] ;#system DNS NAME info
        set info($hostIp,sysName)  [lindex [lindex $Params(-varbinds) 0] 2] 

        #enterprises
        array set Params [$sess bulk 1.3.6.1.4.1.9] ;#boot strap info
        set info($hostIp,enterprises)  [lindex [lindex $Params(-varbinds) 0] 2] 

        #iosVersion
        #array set Params [$sess get 1.3.6.1.2.1.47.1.1.1.1.10.2]
        array set Params [$sess get 1.3.6.1.2.1.16.19.2.0]
        set info($hostIp,iosVersion)  [lindex [lindex $Params(-varbinds) 0] 2]

        #iosImage
        array set Params [$sess get 1.3.6.1.2.1.16.19.6.0]
        set info($hostIp,iosImage)  [lindex [lindex $Params(-varbinds) 0] 2]

        #mainInterface
        if {$info($hostIp,cisco)} {
            #for cisco 
            set result [$sess walk 1.3.6.1.2.1.47.1.1.1.1.7]
        } elseif {$info($hostIp,juniper)} {
            #for juniper
            set result [$sess walk 1.3.6.1.2.1.2.2.1.2]
        } else {
            #for erx
            set result [$sess walk 1.3.6.1.2.1.2.2.1.2]
        }
        #if {$info($hostIp,erx)} { set result [$sess walk 1.3.6.1.2.1.2.2.1.2] }
        set totalIntf 0
        foreach item $result {
            #FORMAT: 1.3.6.1.2.1.47.1.1.1.1.7.5 {OCTET STRING} FastEthernet0/0
            if {[lindex $item 2] != {}} {
                if {$info($hostIp,juniper)} {
                    if {![string match "*.*" [lindex $item 2]] && ![string match "*:*" [lindex $item 2]]} {
                        set mainInterfaces($hostIp,$totalIntf) [lindex $item 2]
                        incr totalIntf
                    }
                } elseif {$info($hostIp,cisco)} {
                    incr totalIntf
                    set mainInterfaces($hostIp,$totalIntf) [lindex $item 2]
                }
            }
        }
        set info($hostIp,mainIntfCount) [expr $totalIntf-1]

        #DUT core information. This is what shows in "show inventory"
        #set intfCount 48 
        #set coreItem ""
        #for {set item 1} {$item <= $intfCount} {incr item} {
        #    set result [$sess get 1.3.6.1.2.1.47.1.1.1.1.2.$item]
        #    #set result [$sess bulk 1.3.6.1.2.1.47.1.1.1.1.2.$item]
        #    array set coreInfo $result
        #    #set coreItem($hostIp,$info($hostIp,sysName),$item) "[lindex [lindex $coreInfo(-varbinds) 0] 2]" 
        #    set resp "[lindex [lindex $coreInfo(-varbinds) 0] 2]"
        #    if {$resp != "noSuchInstance" && $resp != "noSuchObject"} { 
        #        append coreItem "[lindex [lindex $coreInfo(-varbinds) 0] 2]; "
        #    }
        #}
#set filename steel_walkmib.txt
#set fid [open $filename "w"]
#foreach vb [$sess walk 1.3.6.1.2.1.47] { puts $fid $vb }
#close $fid
#smilib oidcmp 1.3.6.1.2.1.47 1.3.6.1.2.1.48

        set lastpointidxList {} 
        set lastpointidx  ""
        set itemset 1
        
        #intial point
        set curoid 1.3.6.1.2.1.47.1.1.1.1.2.1
        #get data next to initial point, this is jsut for starting, no processing or collecting
        set nextresult [$sess next $curoid]
        array set nextParams $nextresult
        set nextoid [lindex [lindex $nextParams(-varbinds) 0] 0]

        while {[smilib oidcmp $curoid $nextoid]} { 
            puts "  ***CUROID $curoid, NEXTOID $nextoid"

            #start getting info
            set curresult [$sess get  $curoid]
            array set curParams $curresult
            set lastpointidx [lindex [split $curoid "."] [expr [llength [split $curoid "."]]-1]]
            set databank($hostIp,$itemset,$lastpointidx) [lindex [lindex $curParams(-varbinds) 0] 2]
            if {$itemset == 1} { 
                #to be use as key access later
                lappend lastpointidxList $lastpointidx
            }

            #from curpoint, move to next point
            set nextresult [$sess next $curoid]
            array set nextParams $nextresult
            #update curpoint to the recent 'next'
            set curoid [lindex [lindex $nextParams(-varbinds) 0] 0] ;#oid of next item in this same set
            set curlastpointidx [lindex [split $curoid "."] [expr [llength [split $curoid "."]]-1]]
            set curoidprefix [string range $curoid 0 [expr [string length $curoid] - [expr [string length $curlastpointidx]+2]]]

            #from nextpoint, move to next-next point
            set nextresult [$sess next $curoid]
            array set nextParams $nextresult
            set nextoid [lindex [lindex $nextParams(-varbinds) 0] 0] ;#move oid of next item to next item for the same set
            set nextlastpointidx [lindex [split $nextoid "."] [expr [llength [split $nextoid "."]]-1]]
            set nextoidprefix [string range $nextoid 0 [expr [string length $nextoid] - [expr [string length $nextlastpointidx]+2]]]
            puts "  ###CUROID $curoid, NEXTOID $nextoid"
            #increment itemset as the pattern is changing to new bloock. ie. 1.3.6.1.2.1.47.1.1.1.1.2.xxx to 1.3.6.1.2.1.47.1.1.1.1.3.xxx
            if {[smilib oidcmp $nextoidprefix $curoidprefix] > 0} { 

                #get the data for the last node before moving on.
                set curresult [$sess get  $curoid]
                array set curParams $curresult
                set lastpointidx [lindex [split $curoid "."] [expr [llength [split $curoid "."]]-1]]
                set databank($hostIp,$itemset,$lastpointidx) [lindex [lindex $curParams(-varbinds) 0] 2]

                puts "move to new block...."
                incr itemset 
            }
            if {[smilib oidcmp $nextoid 1.3.6.1.2.1.47.1.2] != -1} { break }
        }
set filename c7200_databank.txt
set fid [open $filename "w"]
        foreach post $lastpointidxList {
            set row ""
            for {set i 1} {$i < $itemset} {incr i} {
                for {set j 1} {$j < $itemset} {incr j} {
                    if {$i==$j} {
                        append row "$databank($hostIp,$i,$post) ($i) "
                    }
                }
            }
            puts $fid $row
        }
close $fid
        return

        set dut($hostIp,-Site) $site
        set dut($hostIp,-Dept) "PV"
        set dut($hostIp,-Status) $info($hostIp,status)
        set dut($hostIp,-Name) $info($hostIp,sysName)
        set dut($hostIp,-Vendor) $info($hostIp,vendor)
        set dut($hostIp,-Enterprise) $info($hostIp,enterprises)
        set dut($hostIp,-Hostname) $hostIp
        set dut($hostIp,-System) $info($hostIp,sysDescr)
        set dut($hostIp,-UpTime) $info($hostIp,sysUpTime)
        set dut($hostIp,-IosVersion) $info($hostIp,iosVersion)
        set dut($hostIp,-IosImage) $info($hostIp,iosImage)
        set dut($hostIp,-Bundles) $coreItem
        set dut($hostIp,-BladeCount) $info($hostIp,mainIntfCount)
        # array "mainInterfaces" has all interfaces info

        if {1} {
            #Check if this chassis IP is already in the table
            set hostname [::mysql::sel $::dbConn \
                "SELECT Hostname FROM dut_inventory WHERE Hostname ='$hostIp'" -list]
            if {$hostname == ""} {
                set opcode "insert"
                #If not in chassis, insert into table
                set results [mysql::InsertDutInventoryRecordToDB $::dbConn "INSERT" "dut_inventory" $hostIp    \
                    Site                    $dut($hostIp,-Site)       \
                    Dept                    $dut($hostIp,-Dept)       \
                    Status                  $dut($hostIp,-Status)     \
                    Name                    $dut($hostIp,-Name)       \
                    Vendor                  $dut($hostIp,-Vendor)     \
                    Enterprise              $dut($hostIp,-Enterprise) \
                    Hostname                $dut($hostIp,-Hostname)   \
                    System                  $dut($hostIp,-System)     \
                    UpTime                  $dut($hostIp,-UpTime)     \
                    BladeCount              $dut($hostIp,-BladeCount) \
                    IosVersion              $dut($hostIp,-IosVersion) \
                    IosImage                $dut($hostIp,-IosImage)   \
                    LastScan                $scantime                 \
                    Bundles                 $dut($hostIp,-Bundles)]
            } else {
                #Already in table, just update the table with new information.
                if {$dut($hostIp,-Status) == "DOWN"} {
                    #Incase, chassis is down, keep previous information. Only mark status down in database.
                    set opcode "skip"
                    set results [::mysql::sel $::dbConn \
                        "UPDATE stc_inventory SET Status ='$dut($hostIp,-Status)' \
                        WHERE Hostname ='$hostIp'"]
                } else {
                    #Else just update the entire table
                    set opcode "update"
                    set results [mysql::InsertDutInventoryRecordToDB $::dbConn "UPDATE" "dut_inventory" $hostIp    \
                        Site                    $dut($hostIp,-Site)       \
                        Dept                    $dut($hostIp,-Dept)       \
                        Status                  $dut($hostIp,-Status)     \
                        Name                    $dut($hostIp,-Name)       \
                        Vendor                  $dut($hostIp,-Vendor)     \
                        Enterprise              $dut($hostIp,-Enterprise) \
                        Hostname                $dut($hostIp,-Hostname)   \
                        System                  $dut($hostIp,-System)     \
                        UpTime                  $dut($hostIp,-UpTime)     \
                        BladeCount              $dut($hostIp,-BladeCount) \
                        IosVersion              $dut($hostIp,-IosVersion) \
                        IosImage                $dut($hostIp,-IosImage)   \
                        LastScan                $scantime                 \
                        Bundles                 $dut($hostIp,-Bundles)]
                }
            }
        }

        #Collect interface information belong to a currently processed DUT 
        set intf($hostIp,-Site)         $dut($hostIp,-Site)
        set intf($hostIp,-Name)         $dut($hostIp,-Name)
        set intf($hostIp,-Hostname)     $dut($hostIp,-Hostname)
        set intf($hostIp,-Dept)         $dut($hostIp,-Dept)

        for {set intfindex 1} {$intfindex <= $dut($hostIp,-BladeCount)} {incr intfindex} {
            set intf($hostIp,-IntfIndex)   $intfindex
          puts "intfindex $intfindex" 
            if {1} {
                #Record information about the dut interfaces
                if {$opcode == "insert"} {
                    set results [mysql::InsertDutInventoryRecordToDB $::dbConn "INSERT" "dut_inventory_intf" $hostIp \
                        Site            $intf($hostIp,-Site)                                          \
                        Dept            $intf($hostIp,-Dept)                                          \
                        Name            $intf($hostIp,-Name)                                          \
                        Hostname        $intf($hostIp,-Hostname)                                      \
                        IntfIndex       $intf($hostIp,-IntfIndex)                                     \
                        IntfType        "TBD"                                                         \
                        LastScan        $scantime                                                     \
                        ResEnd          ""                                                            \
                        IntfDescr       $mainInterfaces($hostIp,$intfindex)]

                } elseif {$opcode == "update"} {
                    set condition "'$hostIp' AND IntfIndex = '$intfindex'"
                    set results [mysql::InsertDutInventoryRecordToDB $::dbConn "UPDATE" "dut_inventory_intf" $condition \
                        Site            $intf($hostIp,-Site)                                          \
                        Dept            $intf($hostIp,-Dept)                                          \
                        Name            $intf($hostIp,-Name)                                          \
                        Hostname        $intf($hostIp,-Hostname)                                      \
                        IntfIndex       $intf($hostIp,-IntfIndex)                                     \
                        IntfType        "TBD"                                                         \
                        LastScan        $scantime                                                     \
                        IntfDescr       $mainInterfaces($hostIp,$intfindex)]
                } else {
                    #Skip; this is the case where the chassis is down.
                }
            } 
        }
        #destroy snmp session belonging to the current DUT
    }

    #$sess destroy
    mysql::CloseMySqlDB $::dbConn
    #unset dut
    #unset intf
}

add_resource  $argc $argv
#add_resource  "1" "10.61.37.12"