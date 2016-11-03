##########################################################################################################
# Script Name	:  STC CVTInfo Tool                                                           #
# Script Author :  Jundong Xu                                                                 #
# Description	:  Connect to the chassis and read out all Temperature, Voltage, Current and Fan related information                    #
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

puts "\nPackaging SpirentTestCenter..."
package require SpirentTestCenter
package require mysqlutils

#while {1} {
    #Collect scanning time
    set scantime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]

    set dbName "pv_inventory"
    set ::dbConn [mysql::OpenMySqlDB $dbName]
    set mysql::debugLevel 0
    set opcode ""

    #Get all hosts in DB and add in chassisIpList
    set chassisIpList [::mysql::sel $::dbConn "SELECT Hostname FROM stc_inventory_chassis where Status like '%UP%'" -list]
    #set chassisIpList "10.61.36.100"
    #Connect to all chassis at once
    set offlineChassisIpList ""
    foreach chassisIp $chassisIpList {
        if {[catch {stc::connect $chassisIp} error]} {
            puts "Unable to connect to $chassisIp. $error"
            lappend offlineChassisIpList "$chassisIp"
        } else {
            puts "Connected to $chassisIp."
        }
    }

    #Get all connected physicalchassis
    set physicalChassisManager [stc::get system1 -children-physicalchassismanager]
    set physicalChassisList [stc::get $physicalChassisManager -children-physicalchassis]

    #Process one connected physicalchassis at a time
    foreach physicalChassis $physicalChassisList {
        set chassisInfo(Hostname) [stc::get $physicalChassis -Hostname]
        if {[string first $chassisInfo(Hostname) $offlineChassisIpList] != "-1"} {
            set insrtstmt "DELETE FROM stc_information WHERE Hostname='$chassisInfo(Hostname)'"   
            set results [::mysql::sel $::dbConn $insrtstmt]
            
            continue
        }
        
        set chassisInfo(Site) ""
        if {[string match "10.14.*" $chassisInfo(Hostname)]} {
            set chassisInfo(Site) "Honolulu"
        } elseif {[string match "10.100.*" $chassisInfo(Hostname)]} {
            set chassisInfo(Site) "Calabasas"
        } elseif {[string match "10.6.*" $chassisInfo(Hostname)]} {
            set chassisInfo(Site) "Raleigh"
        } elseif {[string match "10.47.*" $chassisInfo(Hostname)]} {
            set chassisInfo(Site) "Sunyvale"
        } elseif {[string match "10.61.*" $chassisInfo(Hostname)]} {
            set chassisInfo(Site) "Beijing"
        }
        
        #All required data
        set chassisInfo(L1L) "0"
        set chassisInfo(L11) "0"
        set chassisInfo(L12) "0"
        set chassisInfo(L13) "0"
        set chassisInfo(BP1L) "0"
        set chassisInfo(BP11) "0"        
        set chassisInfo(BP12) "0"
        set chassisInfo(BP13) "0"
        set chassisInfo(top) "0"
        set chassisInfo(middle) "0"
        set chassisInfo(bottom) "0"
        set chassisInfo(rl) ""
        set chassisInfo(rm) ""
        set chassisInfo(rr) ""        
        set chassisInfo(fl) ""
        set chassisInfo(fm) ""
        set chassisInfo(fr) ""
        
        #5U chassis information
        set chassisInfo(L2L) "0"
        set chassisInfo(L21) "0"
        set chassisInfo(L22) "0"
        set chassisInfo(L23) "0"
        set chassisInfo(SW1L) "0"
        set chassisInfo(SW11) "0"        
        set chassisInfo(SW12) "0"
        set chassisInfo(SW13) "0"
        set chassisInfo(otr) "0"
        set chassisInfo(otc) "0"
        set chassisInfo(otf) "0"
        set chassisInfo(obr) ""
        set chassisInfo(obc) ""
        set chassisInfo(obf) ""        
        set chassisInfo(itr) ""
        set chassisInfo(itc) ""
        set chassisInfo(itf) ""
        set chassisInfo(ibr) "0"
        set chassisInfo(ibc) "0"
        set chassisInfo(ibf) "0"
        set chassisInfo(con1) ""
        set chassisInfo(con2) ""
         
        set chassisInfo(PartNum) [stc::get $physicalChassis -PartNum]
        puts $chassisInfo(Hostname)
        
        #Collect chassis temperature information
        set hTemp [stc::get $physicalChassis -children-PhysicalChassisTempStatus]
        array set tempProps [stc::get $hTemp]        
        puts "\nTemperature sensor info...\n"     
        for {set i 0} {$i < [llength $tempProps(-SensorList)]} {incr i} {
            set szName [lindex $tempProps(-SensorList) $i]
            set iTemp [lindex $tempProps(-SensorTempList) $i]
            
            if {$szName == "L1-L"} {
                set chassisInfo(L1L) $iTemp
            } elseif {$szName == "L1-1"} {
                set chassisInfo(L11) $iTemp
            } elseif {$szName == "L1-2"} {
                set chassisInfo(L12) $iTemp
            } elseif {$szName == "L1-3"} {
                set chassisInfo(L13) $iTemp
            } elseif {$szName == "BP1-L"} {
                set chassisInfo(BP1L) $iTemp
            } elseif {$szName == "BP1-1"} {
                set chassisInfo(BP11) $iTemp
            } elseif {$szName == "BP1-2"} {
                set chassisInfo(BP12) $iTemp
            } elseif {$szName == "BP1-3"} {
                set chassisInfo(BP13) $iTemp
            } elseif {$szName == "L2-L"} {
                set chassisInfo(L2L) $iTemp
            } elseif {$szName == "L2-1"} {
                set chassisInfo(L21) $iTemp
            } elseif {$szName == "L2-2"} {
                set chassisInfo(L22) $iTemp
            } elseif {$szName == "L2-3"} {
                set chassisInfo(L23) $iTemp
            } elseif {$szName == "SW1-L"} {
                set chassisInfo(SW1L) $iTemp
            } elseif {$szName == "SW1-1"} {
                set chassisInfo(SW11) $iTemp
            } elseif {$szName == "SW1-2"} {
                set chassisInfo(SW12) $iTemp
            } elseif {$szName == "SW1-3"} {
                set chassisInfo(SW13) $iTemp
            }
        }
        
        #Collect chassis power supply information
        set hPower [stc::get $physicalChassis -children-PhysicalChassisPowerSupplyStatus]
        array set powerProps [stc::get $hPower]
        puts "\nPower supply info...\n"
        for {set i 0} {$i < [llength $powerProps(-PowerSupplyList)]} {incr i} {
            set szName [lindex $powerProps(-PowerSupplyList) $i]
            set iStatus [lindex $powerProps(-PowerSupplyStatusList) $i]
            
            if {$szName == "top"} {
                set chassisInfo(top) $iStatus
            } elseif {$szName == "middle"} {
                set chassisInfo(middle) $iStatus
            } elseif {$szName == "bottom"} {       
                set chassisInfo(bottom) $iStatus
            }
        }
        
        #Collect chassis fan information
        set hFanList [stc::get $physicalChassis -children-PhysicalChassisFan]
        puts "\nFan info...\n"   
        foreach hFan $hFanList {
            array set fanProps [stc::get $hFan]
            
            if {$fanProps(-FanName) == "rear left"} {
                set chassisInfo(rl) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "rear middle"} {
                set chassisInfo(rm) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "rear right"} {
                set chassisInfo(rr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "front left"} {
                set chassisInfo(fl) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "front middle"} {
                set chassisInfo(fm) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "front right"} {
                set chassisInfo(fr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer top rear"} {
                set chassisInfo(otr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer top center"} {
                set chassisInfo(otc) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer top front"} {
                set chassisInfo(otf) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer bottom rear"} {
                set chassisInfo(obr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer bottom center"} {
                set chassisInfo(obc) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Outer bottom front"} {
                set chassisInfo(obf) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner top rear"} {
                set chassisInfo(itr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner top center"} {
                set chassisInfo(itc) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner top front"} {
                set chassisInfo(itf) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner bottom rear"} {
                set chassisInfo(ibr) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner bottom center"} {
                set chassisInfo(ibc) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Inner bottom front"} {
                set chassisInfo(ibf) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Controller (1 of 2)"} {
                set chassisInfo(con1) $fanProps(-FanState)
            } elseif {$fanProps(-FanName) == "Controller (2 of 2)"} {
                set chassisInfo(con2) $fanProps(-FanState)
            } 
        }
        
        #Insert chassis information into DB
        #Check if this chassis IP is already in the table
        set chassis [::mysql::sel $::dbConn \
            "SELECT Hostname FROM stc_information WHERE Hostname ='$chassisInfo(Hostname)'" -list]
        if {$chassis == ""} {
                set results [mysql::InsertChassisInfoToDB $::dbConn "INSERT" "stc_information" $chassisInfo(Hostname)    \
                    Hostname                 $chassisInfo(Hostname)                                                      \
                    PartNum                  $chassisInfo(PartNum)                                                       \
                    TemperatureL1L           $chassisInfo(L1L)                                                           \
                    TemperatureL11           $chassisInfo(L11)                                                           \
                    TemperatureL12           $chassisInfo(L12)                                                           \
                    TemperatureL13           $chassisInfo(L13)                                                           \
                    TemperatureBP1L          $chassisInfo(BP1L)                                                          \
                    TemperatureBP11          $chassisInfo(BP11)                                                          \
                    TemperatureBP12          $chassisInfo(BP12)                                                          \
                    TemperatureBP13          $chassisInfo(BP13)                                                          \
                    PowerTop                 $chassisInfo(top)                                                           \
                    PowerMiddle              $chassisInfo(middle)                                                        \
                    PowerBottom              $chassisInfo(bottom)                                                        \
                    FanRearLeft              $chassisInfo(rl)                                                            \
                    FanRearMiddle            $chassisInfo(rm)                                                            \
                    FanRearRight             $chassisInfo(rr)                                                            \
                    FanFrontLeft             $chassisInfo(fl)                                                            \
                    FanFrontMiddle           $chassisInfo(fm)                                                            \
                    FanFrontRight            $chassisInfo(fr)                                                            \
                    LastScan                 $scantime                                                                   \
                    OuterTopRear             $chassisInfo(otr)                                                           \
                    OuterTopCenter           $chassisInfo(otc)                                                           \
                    OuterTopFront            $chassisInfo(otf)                                                           \
                    OuterBottomRear          $chassisInfo(obr)                                                           \
                    OuterBottomCenter        $chassisInfo(obc)                                                           \
                    OuterBottomFront         $chassisInfo(obf)                                                           \
                    TemperatureL2L           $chassisInfo(L2L)                                                           \
                    TemperatureL21           $chassisInfo(L21)                                                           \
                    TemperatureL22           $chassisInfo(L22)                                                           \
                    TemperatureL23           $chassisInfo(L23)                                                           \
                    TemperatureSW1L          $chassisInfo(SW1L)                                                          \
                    TemperatureSW11          $chassisInfo(SW11)                                                          \
                    TemperatureSW12          $chassisInfo(SW12)                                                          \
                    TemperatureSW13          $chassisInfo(SW13)                                                          \
                    InnerTopRear             $chassisInfo(itr)                                                           \
                    InnerTopCenter           $chassisInfo(itc)                                                           \
                    InnerTopFront            $chassisInfo(itf)                                                           \
                    InnerBottomRear          $chassisInfo(ibr)                                                           \
                    InnerBottomCenter        $chassisInfo(ibc)                                                           \
                    InnerBottomFront         $chassisInfo(ibf)                                                           \
                    Controller1              $chassisInfo(con1)                                                          \
                    Controller2              $chassisInfo(con2)                                                          \
                    Site                     $chassisInfo(Site)]
        } else {
                set results [mysql::InsertChassisInfoToDB $::dbConn "UPDATE" "stc_information" $chassisInfo(Hostname)    \
                    Hostname                 $chassisInfo(Hostname)                                                      \
                    PartNum                  $chassisInfo(PartNum)                                                       \
                    TemperatureL1L           $chassisInfo(L1L)                                                           \
                    TemperatureL11           $chassisInfo(L11)                                                           \
                    TemperatureL12           $chassisInfo(L12)                                                           \
                    TemperatureL13           $chassisInfo(L13)                                                           \
                    TemperatureBP1L          $chassisInfo(BP1L)                                                          \
                    TemperatureBP11          $chassisInfo(BP11)                                                          \
                    TemperatureBP12          $chassisInfo(BP12)                                                          \
                    TemperatureBP13          $chassisInfo(BP13)                                                          \
                    PowerTop                 $chassisInfo(top)                                                           \
                    PowerMiddle              $chassisInfo(middle)                                                        \
                    PowerBottom              $chassisInfo(bottom)                                                        \
                    FanRearLeft              $chassisInfo(rl)                                                            \
                    FanRearMiddle            $chassisInfo(rm)                                                            \
                    FanRearRight             $chassisInfo(rr)                                                            \
                    FanFrontLeft             $chassisInfo(fl)                                                            \
                    FanFrontMiddle           $chassisInfo(fm)                                                            \
                    FanFrontRight            $chassisInfo(fr)                                                            \
                    LastScan                 $scantime                                                                   \
                    OuterTopRear             $chassisInfo(otr)                                                           \
                    OuterTopCenter           $chassisInfo(otc)                                                           \
                    OuterTopFront            $chassisInfo(otf)                                                           \
                    OuterBottomRear          $chassisInfo(obr)                                                           \
                    OuterBottomCenter        $chassisInfo(obc)                                                           \
                    OuterBottomFront         $chassisInfo(obf)                                                           \
                    TemperatureL2L           $chassisInfo(L2L)                                                           \
                    TemperatureL21           $chassisInfo(L21)                                                           \
                    TemperatureL22           $chassisInfo(L22)                                                           \
                    TemperatureL23           $chassisInfo(L23)                                                           \
                    TemperatureSW1L          $chassisInfo(SW1L)                                                          \
                    TemperatureSW11          $chassisInfo(SW11)                                                          \
                    TemperatureSW12          $chassisInfo(SW12)                                                          \
                    TemperatureSW13          $chassisInfo(SW13)                                                          \
                    InnerTopRear             $chassisInfo(itr)                                                           \
                    InnerTopCenter           $chassisInfo(itc)                                                           \
                    InnerTopFront            $chassisInfo(itf)                                                           \
                    InnerBottomRear          $chassisInfo(ibr)                                                           \
                    InnerBottomCenter        $chassisInfo(ibc)                                                           \
                    InnerBottomFront         $chassisInfo(ibf)                                                           \
                    Controller1              $chassisInfo(con1)                                                          \
                    Controller2              $chassisInfo(con2)                                                          \
                    Site                     $chassisInfo(Site)]     
        }
    }

    mysql::CloseMySqlDB $::dbConn

    #TODO: We should extract item in "offlineChassisIpList" from the chssisIPList
    foreach chassisIp $chassisIpList {
        if {[string first $chassisIp $offlineChassisIpList] != "-1"} {
            continue
        } 
        if {[catch {stc::disconnect $chassisIp} error]} {
            puts "Error disconnecting from $chassisIp. $error"
        } else {
            puts "Disconnected from $chassisIp."
        }
    }
    
    foreach item [stc::get system1 -children] {
        stc::delete $item
    }
    #stc::apply 
#}

