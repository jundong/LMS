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

puts "\nPackaging SpirentTestCenter..."
package require SpirentTestCenter
package require mysqlutils
#----------------
# compare list a with b
#----------------
proc ListComp {a b} {
    set diff {}
    foreach i $a {
        if {[lsearch -exact $b $i]==-1} {
            lappend diff $i
        }
    }
  return $diff
}
proc GoScan {Site} {
    set filename "$Site.txt"
    set fid [open $filename w]
    #Collect scanning time
    set scantime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]
    puts $fid "$scantime Scaning chassis for $Site site."

    set dbName "pv_inventory"
    puts $fid "$scantime Open database..."
    set ::dbConn [mysql::OpenMySqlDB $dbName]
    set mysql::debugLevel 0
    set opcode ""

    #Clear out the three tables
    if {0} {
        puts $fid "$scantime ERROR: You are about to erase the database. The department info is user defined and must be manually entered."
        return
        exit
        mysql::DeleteRecordInTable $::dbConn "stc_inventory_chassis"
        mysql::DeleteRecordInTable $::dbConn "stc_inventory_portgroup"
        mysql::DeleteRecordInTable $::dbConn "stc_inventory_testmodule"
    }

    #Get all hosts in DB and add in chassisIpList
    #set chassisIpList [::mysql::sel $::dbConn "SELECT Hostname FROM stc_inventory_chassis" -list]
    set chassisIpList [::mysql::sel $::dbConn "SELECT Hostname FROM stc_inventory_chassis WHERE Site = '$Site'" -list]
    #puts $fid "$chassisIpList"
    #set chassisIpList [list 10.6.2.118]
    foreach chassisIp $chassisIpList {
        if {[catch {stc::connect $chassisIp} error]} {
            puts $fid "$scantime Unable to connect to $chassisIp. $error"
            set physicalChassisManager [stc::get system1 -children-physicalchassismanager]
            set physicalChassis [stc::get $physicalChassisManager -children-physicalchassis]
            stc::delete $physicalChassis
            stc::apply
            #The chassis IP is already in the table, just update the failed counts
            set failCount [::mysql::sel $::dbConn "SELECT FailConnects FROM stc_inventory_chassis WHERE Hostname ='$chassisIp'" -list]
            ::mysql::sel $::dbConn \
                "UPDATE stc_inventory_chassis SET LastScan ='$scantime', Status ='CHASSIS_STATUS_DOWN', FailConnects ='[expr $failCount+1]' WHERE Hostname ='$chassisIp'"

        } else {
            puts "$scantime Connected to $chassisIp."
            puts $fid "$scantime Connected to $chassisIp."
            #Get all connected physicalchassis
            set physicalChassisManager [stc::get system1 -children-physicalchassismanager]
            set physicalChassis [stc::get $physicalChassisManager -children-physicalchassis]
            
            #Process one connected physicalchassis at a time
            #Collect chassis information
            array set physicalChassisInfo [stc::get $physicalChassis]
            set hostIp $physicalChassisInfo(-Hostname)
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
        
            puts $fid "$scantime Working with hostip $hostIp"
            #We don't really need to move the info to this array but do it just incase we a clean dump later.
            set chassisInfo($hostIp,-Status)                  $physicalChassisInfo(-Status)
            set chassisInfo($hostIp,-BackplaneHwVersion)      $physicalChassisInfo(-BackplaneHwVersion)
            set chassisInfo($hostIp,-ControllerHwVersion)     $physicalChassisInfo(-ControllerHwVersion)
            set chassisInfo($hostIp,-DiskFree)                $physicalChassisInfo(-DiskFree)
            set chassisInfo($hostIp,-DiskUsed)                $physicalChassisInfo(-DiskUsed)
            set chassisInfo($hostIp,-FirmwareVersion)         $physicalChassisInfo(-FirmwareVersion)
            set chassisInfo($hostIp,-Model)                   $physicalChassisInfo(-Model)
            set chassisInfo($hostIp,-PartNum)                 $physicalChassisInfo(-PartNum)
            set chassisInfo($hostIp,-SerialNum)               $physicalChassisInfo(-SerialNum)
            set chassisInfo($hostIp,-SlotCount)               $physicalChassisInfo(-SlotCount)
            set chassisInfo($hostIp,-TotalDiskSize)           $physicalChassisInfo(-TotalDiskSize)
            #parray chassisInfo
            if {1} {
                #Check if this chassis IP is already in the table
                set chassis [::mysql::sel $::dbConn \
                    "SELECT Hostname FROM stc_inventory_chassis WHERE Hostname ='$hostIp'" -list]
                if {$chassis == ""} {
                    set opcode "insert"
                    #If not in chassis, insert into table
                    set results [mysql::InsertInventoryRecordToDB $::dbConn "INSERT" "stc_inventory_chassis" $hostIp    \
                        Hostname                $hostIp                                      \
                        Status                  $chassisInfo($hostIp,-Status)                \
                        BackplaneHwVersion      $chassisInfo($hostIp,-BackplaneHwVersion)    \
                        ControllerHwVersion     $chassisInfo($hostIp,-ControllerHwVersion)   \
                        DiskFree                $chassisInfo($hostIp,-DiskFree)              \
                        DiskUsed                $chassisInfo($hostIp,-DiskUsed)              \
                        FirmwareVersion         $chassisInfo($hostIp,-FirmwareVersion)       \
                        Model                   $chassisInfo($hostIp,-Model)                 \
                        PartNum                 $chassisInfo($hostIp,-PartNum)               \
                        SerialNum               $chassisInfo($hostIp,-SerialNum)             \
                        SlotCount               $chassisInfo($hostIp,-SlotCount)             \
                        TotalDiskSize           $chassisInfo($hostIp,-TotalDiskSize)         \
                        FailConnects            0                                            \
                        Dept                    "TBD"                                        \
                        Property                "TBD"                                        \
                        SO                      ""                                           \
                        SOStart                 ""                        \
                        SOEnd                   ""                        \
                        LastScan               $scantime                                     \
                        Site                    $site]
                } else {
                    #Already in table, just update the table with new information.
                    if {$chassisInfo($hostIp,-Status) == "CHASSIS_STATUS_DOWN"} {
                        #Incase, chassis is down, keep previous information. Only mark status down in database.
                        set opcode "skip"
                        set results [::mysql::sel $::dbConn \
                            "UPDATE stc_inventory_chassis SET Status ='$chassisInfo($hostIp,-Status)' \
                            WHERE Hostname ='$chassis'"]
        
                        set results [::mysql::sel $::dbConn "SELECT DISTINCT SlotIndex FROM stc_inventory_testmodule WHERE Hostname ='$chassis'" -list]
                        foreach index $results {
                            #the update takes place only if slots and ports exist.
                            set condition "'$hostIp' AND SlotIndex = '$index'"
                            set results [mysql::InsertInventoryRecordToDB $::dbConn "UPDATE" "stc_inventory_testmodule" $condition Status "MODULE_STATUS_UNKNOWN"]
                            set results [mysql::InsertInventoryRecordToDB $::dbConn "UPDATE" "stc_inventory_portgroup" $condition Status "MODULE_STATUS_UNKNOWN"]
                        }
                    } else {
                        #Else just update the entire table
                        set opcode "update"
                        set results [mysql::InsertInventoryRecordToDB $::dbConn "UPDATE" "stc_inventory_chassis" $hostIp    \
                            Hostname                $hostIp                                      \
                            Status                  $chassisInfo($hostIp,-Status)                \
                            BackplaneHwVersion      $chassisInfo($hostIp,-BackplaneHwVersion)    \
                            ControllerHwVersion     $chassisInfo($hostIp,-ControllerHwVersion)   \
                            DiskFree                $chassisInfo($hostIp,-DiskFree)              \
                            DiskUsed                $chassisInfo($hostIp,-DiskUsed)              \
                            FirmwareVersion         $chassisInfo($hostIp,-FirmwareVersion)       \
                            Model                   $chassisInfo($hostIp,-Model)                 \
                            PartNum                 $chassisInfo($hostIp,-PartNum)               \
                            SerialNum               $chassisInfo($hostIp,-SerialNum)             \
                            SlotCount               $chassisInfo($hostIp,-SlotCount)             \
                            TotalDiskSize           $chassisInfo($hostIp,-TotalDiskSize)         \
                            LastScan                $scantime                                    \
                            Site                    $site]
                    }
                }
            }
        
            #Update serial number for chassis or controller card in property table
            set SN "$chassisInfo($hostIp,-SerialNum)"
            set RT "CONTROLLER $chassisInfo($hostIp,-ControllerHwVersion)"
            set property_recset [::mysql::sel $::dbConn "SELECT SN,Site,Property,SO,SOStart,SOEnd FROM stc_property WHERE SN ='$SN'" -list]
            if {$property_recset == ""} {
                #If the board with the serial number doesn't exist in property table, insert this info as bases. User can change this info on the web.
                set Prop "Permarnent"
                set res [::mysql::sel $::dbConn "INSERT stc_property SET SN='$SN',Site='$site',ResourceType='$RT',Property='Permanent',SO='00000'" -list]
            } else {
                #If the board with the same serial number exist in property table, check if the property is the same as what in the chassis table.
                #If they are different, overwrite the chassis table with the contents from the property table. The chassis was moved here.
                set PRO [lindex [lindex $property_recset 0] 2]
                set SO [lindex [lindex $property_recset 0] 3]
                set SOS [lindex [lindex $property_recset 0] 4]
                set SOE [lindex [lindex $property_recset 0] 5]
                set chassis_recset [::mysql::sel $::dbConn "SELECT SerialNum,Site,Property,SO,SOStart,SOEnd FROM stc_inventory_chassis WHERE SerialNum ='$SN'" -list]
                if {[ListComp $chassis_recset $property_recset] != ""} {
                    set sn [::mysql::sel $::dbConn \
                    "UPDATE stc_inventory_chassis SET Property='$PRO',SO='$SO',SOStart='$SOS',SOEnd='$SOE' WHERE SerialNum='$SN'" -list]
                }
            }
        
            #Collect test module(s) (the slot), information belong to a currently processed chassis
            set physicalTestModuleList [stc::get $physicalChassis -children-physicaltestmodule]
            foreach physicalTestModule $physicalTestModuleList {
                array set physicalTestModuleInfo [stc::get $physicalTestModule]
                #We don't really need to move the info to this array, but do it just incase we need a clean dump later.
                set index $physicalTestModuleInfo(-Index)
                set testModuleInfo($hostIp,$index,-Status)                     $physicalTestModuleInfo(-Status)
                set testModuleInfo($hostIp,$index,-Description)                $physicalTestModuleInfo(-Description)
                set testModuleInfo($hostIp,$index,-FirmwareVersion)            $physicalTestModuleInfo(-FirmwareVersion)
                set testModuleInfo($hostIp,$index,-HwRevCode)                  $physicalTestModuleInfo(-HwRevCode)
                set testModuleInfo($hostIp,$index,-Model)                      $physicalTestModuleInfo(-Model)
                set testModuleInfo($hostIp,$index,-PartNum)                    $physicalTestModuleInfo(-PartNum)
                set testModuleInfo($hostIp,$index,-PortCount)                  $physicalTestModuleInfo(-PortCount)
                set testModuleInfo($hostIp,$index,-PortGroupCount)             $physicalTestModuleInfo(-PortGroupCount)
                set testModuleInfo($hostIp,$index,-PortGroupSize)              $physicalTestModuleInfo(-PortGroupSize)
                set testModuleInfo($hostIp,$index,-ProductFamily)              $physicalTestModuleInfo(-ProductFamily)
                set testModuleInfo($hostIp,$index,-ProductId)                  $physicalTestModuleInfo(-ProductId)
                set testModuleInfo($hostIp,$index,-SerialNum)                  $physicalTestModuleInfo(-SerialNum)
                set testModuleInfo($hostIp,$index,-TestPackages)               $physicalTestModuleInfo(-TestPackages)
                set testModuleInfo($hostIp,$index,-Index)                      $physicalTestModuleInfo(-Index)
                if {1} {
                    #Update serial number for chassis or controller card in property table
                    set SN "$testModuleInfo($hostIp,$index,-SerialNum)"
                    set RT "$testModuleInfo($hostIp,$index,-ProductFamily)"
                    set property_recset [::mysql::sel $::dbConn "SELECT SN,Site,Property,SO,SOStart,SOEnd FROM stc_property WHERE SN ='$SN'" -list]
                    if {$property_recset == ""} {
                        #If the board with the serial number doesn't exist in property table, insert this info as bases. User can change this info on the web.
                        set Prop "Permarnent"
                        set res [::mysql::sel $::dbConn "INSERT stc_property SET SN='$SN',Site='$site',ResourceType='$RT',Property='Permanent',SO='00000'" -list]
                    } else {
                        #If the board with the same serial number exist in property table, check if the property is the same as what in the chassis table.
                        #If they are different, overwrite the chassis table with the contents from the property table. The chassis was moved here.
                        set PRO [lindex [lindex $property_recset 0] 2]
                        set SO [lindex [lindex $property_recset 0] 3]
                        set SOS [lindex [lindex $property_recset 0] 4]
                        set SOE [lindex [lindex $property_recset 0] 5]
                        set chassis_recset [::mysql::sel $::dbConn "SELECT SerialNum,Site,Property,SO,SOStart,SOEnd FROM stc_inventory_testmodule WHERE SerialNum ='$SN'" -list]
                        if {[ListComp $chassis_recset $property_recset] != ""} {
                            set sn [::mysql::sel $::dbConn \
                            "UPDATE stc_inventory_testmodule SET Property='$PRO',SO='$SO',SOStart='$SOS',SOEnd='$SOE' WHERE SerialNum='$SN'" -list]
                        }
                    }
        
                    #Record information about the slot
                    if {$opcode == "insert"} {
                        set results [mysql::InsertInventoryRecordToDB $::dbConn "INSERT" "stc_inventory_testmodule" $hostIp \
                            Hostname            $hostIp                                          \
                            Description         $testModuleInfo($hostIp,$index,-Description)     \
                            FirmwareVersion     $testModuleInfo($hostIp,$index,-FirmwareVersion) \
                            HwRevCode           $testModuleInfo($hostIp,$index,-HwRevCode)       \
                            Model               $testModuleInfo($hostIp,$index,-Model)           \
                            PartNum             $testModuleInfo($hostIp,$index,-PartNum)         \
                            PortCount           $testModuleInfo($hostIp,$index,-PortCount)       \
                            PortGroupCount      $testModuleInfo($hostIp,$index,-PortGroupCount)  \
                            PortGroupSize       $testModuleInfo($hostIp,$index,-PortGroupSize)   \
                            ProductFamily       $testModuleInfo($hostIp,$index,-ProductFamily)   \
                            ProductId           $testModuleInfo($hostIp,$index,-ProductId)       \
                            SerialNum           $testModuleInfo($hostIp,$index,-SerialNum)       \
                            TestPackages        $testModuleInfo($hostIp,$index,-TestPackages)    \
                            SlotIndex           $testModuleInfo($hostIp,$index,-Index)           \
                            Dept                    "TBD"                                        \
                            Property            "TBD"                                            \
                            SO                  ""                                               \
                            SOStart             ""                            \
                            SOEnd               ""                            \
                            Status              $testModuleInfo($hostIp,$index,-Status)          \
                            LastScan            $scantime                                        \
                            Site                $site]
                    } elseif {$opcode == "update"} {
                        set results [::mysql::sel $::dbConn "SELECT DISTINCT SerialNum,PortCount,PortGroupCount FROM stc_inventory_testmodule \
                            WHERE Hostname ='$chassis' AND SlotIndex = '$index'" -list]
                        if {$results == ""} {
                            #speical case handling the event where slot information is deleted from testmodule table.
                            set command "INSERT"
                        } else {
                            set SerialNum [lindex [lindex $results 0] 0]
                            set PortCount [lindex [lindex $results 0] 1]
                            set LiveSerialNum $testModuleInfo($hostIp,$index,-SerialNum)
                            set LivePortCount $testModuleInfo($hostIp,$index,-PortCount)
                            if {$physicalTestModuleInfo(-Status) != "MODULE_STATUS_UNKNOWN"} {
                                #Check to see SN is the same or total number of board are the same. Anyhow, Slot with same SN should also have had the same portcount.
                                if {$PortCount == $LivePortCount} {
                                    set command "UPDATE"
                                } else {
                                    #delete the previous slot and port records that do have have either same SN or portcount belonging to LIVE card.
                                    set results [::mysql::sel $::dbConn "DELETE FROM stc_inventory_testmodule WHERE Hostname ='$chassis' AND SlotIndex = '$index'" -list]
                                    set results [::mysql::sel $::dbConn "DELETE FROM stc_inventory_portgroup WHERE Hostname ='$chassis' AND SlotIndex = '$index'" -list]
                                    set command "INSERT"
                                }
                            }
                        }
        
                        set condition "'$hostIp' AND SlotIndex = '$index'"
                        if {$physicalTestModuleInfo(-Status) != "MODULE_STATUS_UNKNOWN"} {
                            set results [mysql::InsertInventoryRecordToDB $::dbConn "$command" "stc_inventory_testmodule" $condition \
                                Hostname            $hostIp                                          \
                                Description         $testModuleInfo($hostIp,$index,-Description)     \
                                FirmwareVersion     $testModuleInfo($hostIp,$index,-FirmwareVersion) \
                                HwRevCode           $testModuleInfo($hostIp,$index,-HwRevCode)       \
                                Model               $testModuleInfo($hostIp,$index,-Model)           \
                                PartNum             $testModuleInfo($hostIp,$index,-PartNum)         \
                                PortCount           $testModuleInfo($hostIp,$index,-PortCount)       \
                                PortGroupCount      $testModuleInfo($hostIp,$index,-PortGroupCount)  \
                                PortGroupSize       $testModuleInfo($hostIp,$index,-PortGroupSize)   \
                                ProductFamily       $testModuleInfo($hostIp,$index,-ProductFamily)   \
                                ProductId           $testModuleInfo($hostIp,$index,-ProductId)       \
                                SerialNum           $testModuleInfo($hostIp,$index,-SerialNum)       \
                                TestPackages        $testModuleInfo($hostIp,$index,-TestPackages)    \
                                SlotIndex           $testModuleInfo($hostIp,$index,-Index)           \
                                Status              $testModuleInfo($hostIp,$index,-Status)          \
                                LastScan            $scantime                                        \
                                Site                $site]
                        } else {
                            #if slot is down, update only the status field, this is to preserve what was in the table
                            set results [mysql::InsertInventoryRecordToDB $::dbConn "UPDATE" "stc_inventory_testmodule" $condition \
                                Status                $testModuleInfo($hostIp,$index,-Status)]
                            #This will change status of all ports in this slot to down 
                            set results [mysql::InsertInventoryRecordToDB $::dbConn "UPDATE" "stc_inventory_portgroup" $condition \
                                Status                $testModuleInfo($hostIp,$index,-Status)]
                        }
                    } else {
                        #Skip; this is the case where the chassis is down.
                    }
                } 
        
                set physicalPortGroupList [stc::get $physicalTestModule -children-physicalportgroup]
                foreach physicalPortGroup $physicalPortGroupList {
                    array set physicalPortGroupInfo [stc::get $physicalPortGroup]
                    #We don't really need to move the info to this array, but do it just incase we need a clean dump later.
                    set portGroupIndex $physicalPortGroupInfo(-Index)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-Name)             $physicalPortGroupInfo(-Name)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-Status)           $physicalPortGroupInfo(-Status)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-Firmware)         $physicalPortGroupInfo(-TestPackageVersion)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-OwnershipState)   $physicalPortGroupInfo(-OwnershipState)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerHostname)    $physicalPortGroupInfo(-OwnerHostname)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerUserId)      $physicalPortGroupInfo(-OwnerUserId)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerTimestamp)   $physicalPortGroupInfo(-OwnerTimestamp)
                    set portGroupInfo($hostIp,$index,$portGroupIndex,-Index)            $physicalPortGroupInfo(-Index)
        
                    #get a list of physical ports in a CCPU
                    set portGroupChildren [stc::get $physicalPortGroup -Children-physicalport]
                    foreach port $portGroupChildren {
                        set portindex [stc::get $port -Index]
                        if {1} {
                            if {$opcode == "insert"} {
                                #Record information about the ports of this slot
                                set results [mysql::InsertInventoryRecordToDB $::dbConn "INSERT" "stc_inventory_portgroup" $hostIp \
                                    Hostname            $hostIp                                         \
                                    SlotIndex           $index                                          \
                                    PortGroupIndex      $portGroupInfo($hostIp,$index,$portGroupIndex,-Index)          \
                                    PortIndex           $portindex                                                     \
                                    ResEnd              ""                                                   \
                                    Name                $portGroupInfo($hostIp,$index,$portGroupIndex,-Name)           \
                                    Status              $portGroupInfo($hostIp,$index,$portGroupIndex,-Status)         \
                                    FirmwareVersion     $portGroupInfo($hostIp,$index,$portGroupIndex,-Firmware)       \
                                    OwnershipState      $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnershipState) \
                                    OwnerHostname       $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerHostname)  \
                                    OwnerUserId         $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerUserId)    \
                                    OwnerTimestamp      $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerTimestamp) \
                                    Dept                "TBD"                                                          \
                                    Connection          "TBD"                                                          \
                                    LastScan            $scantime                                                      \
                                    ConnectionType      ""                                                             \
                                    PeerHost            ""                                                             \
                                    PeerModule          ""                                                             \
                                    PeerPort            ""                                                             \
                                    Comments            ""                                                             \
                                    Site                $site]
                            } elseif {$opcode == "update"} {
                                set results [::mysql::sel $::dbConn "SELECT DISTINCT * FROM stc_inventory_portgroup \
                                    WHERE Hostname ='$chassis' AND SlotIndex = '$index' AND PortGroupIndex ='$portGroupIndex' AND PortIndex = '$portindex'" -list]
                                if {$results == ""} {
                                    #speical case handling the event where port information is deleted from portgroup table.
                                    set command "INSERT"
                                } else {
                                    set command "UPDATE"
                                }
        
                                set condition "'$hostIp' AND SlotIndex = '$index' \
                                    AND PortGroupIndex = '$portGroupIndex' AND PortIndex = '$portindex' "
                                set results [mysql::InsertInventoryRecordToDB $::dbConn "$command" "stc_inventory_portgroup" $condition \
                                    Hostname            $hostIp                                         \
                                    SlotIndex           $index                                          \
                                    PortGroupIndex      $portGroupInfo($hostIp,$index,$portGroupIndex,-Index)          \
                                    PortIndex           $portindex                                                     \
                                    Name                $portGroupInfo($hostIp,$index,$portGroupIndex,-Name)           \
                                    Status              $portGroupInfo($hostIp,$index,$portGroupIndex,-Status)         \
                                    FirmwareVersion     $portGroupInfo($hostIp,$index,$portGroupIndex,-Firmware)       \
                                    OwnershipState      $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnershipState) \
                                    OwnerHostname       $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerHostname)  \
                                    OwnerUserId         $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerUserId)    \
                                    OwnerTimestamp      $portGroupInfo($hostIp,$index,$portGroupIndex,-OwnerTimestamp) \
                                    LastScan            $scantime                                                      \
                                    Site                $site]
                            } else {
                                #Skip; this is the case where the chassis is down.
                            }
                        } 
                    }
                }
            }
            
            if {[catch {stc::disconnect $chassisIp} error]} {
                puts $fid "$scantime Error disconnecting from $chassisIp. $error"
                stc::delete $physicalChassis
            } else {
                puts "$scantime Disconnected from $chassisIp."
                puts $fid "$scantime Disconnected from $chassisIp."
                stc::delete $physicalChassis

            }

            catch {unset physicalChassisInfo}
            catch {unset physicalTestModuleInfo}
            catch {unset chassisInfo}
            catch {unset testModuleInfo}
            catch {unset portGroupInfo}
            catch {unset results}              
        }
    }
    puts $fid "$scantime Close database...."
    close $fid
    mysql::CloseMySqlDB $::dbConn
}
