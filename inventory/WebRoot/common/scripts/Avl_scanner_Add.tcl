##########################################################################################################
# Script Name	:  Avalanche Inventory Tool                                                              #
# Script Author :  Saiyoot Nakkhongkham
# Description	:  Connect to the chassis and read out all haward related information                    #
#                                                                                                        #
# Hardware Req	:  List of Avalanche chassis IP addresses                                                #
#                                                                                                        #
# Software Req  :  AV bll/bios package need to be installed in the default directory.                    #
# Files Req	    :                                                                                        #
# Est. Time Req :  Up to a few minutes or so depending on how many chaissis is used                      #
# Date written  :  03/23/2010                                                                            #
#                                                                                                        #
# Modified      :  Jundong.Xu                                                                                      #
##########################################################################################################
proc add_resource {argc argv} {
    puts "\nLoad the SPI_AV package..."
    variable auto_path
    # Load the SPI_AV package
    #set auto_path [linsert $auto_path 0 "C:/Program Files/Spirent communications/Spirent TestCenter 3.50/Layer 4-7 Application/TclAPI"]
    set auto_path [linsert $auto_path 0 "C:/Program Files (x86)/Spirent Communications/Spirent TestCenter 3.50/Layer 4-7 Application/TclAPI"]
    package forget SPI_AV
    package require SPI_AV
    package require mysqlutils
    
    SPI_AV::InitializeAPI
    SPI_AV::AddLicense "-Demo"
    
    append IpAddress  $argv
    
    #Collect scanning time
    set scantime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]

    set dbName "pv_inventory"
    set ::dbConn [mysql::OpenMySqlDB $dbName]
    set mysql::debugLevel 0
    set opcode ""

    #Process one connected physicalchassis at a time
    puts "Working with hostip $IpAddress"

    ## Before accessing or reserving appliance/portgroups, create cluster for the appliance/portgoups
    set clientUnits [list]
    lappend clientUnits "$IpAddress;0" ;#   ip; cookie
    puts "create cluster...."
    #set clientClusterID [SPI_AV::ClusterController::CreateCluster "client" "LRSClientCluster" $clientUnits]
    puts "get admin config"        
    if [catch {array set adminConfig [SPI_AV::GetAdminConfig  $IpAddress]} err] {
        continue
    }
    puts "get number of interface"
    set adminConfig(numofinterface) [SPI_AV::GetNumInterfaces $IpAddress]
    #for {set i 0} {$i < $adminConfig(numofinterface)} {incr i} {
    #    lappend interfaceList "$adminConfig(interfaceList,$i,description)"
    #}
    set interfaceList ""
    if {$adminConfig(modelNumber) == 2900 } {
        set adminConfig(numofinterface) [expr $adminConfig(numofinterface) + 1]
    }
    if {$adminConfig(modelNumber) == 3100 } {
        set adminConfig(numofinterface) [expr $adminConfig(numofinterface) + 2]
    }
    #parray adminConfig

    #Set site based on IP prefix range
    if {[string match "10.14.*" $IpAddress]} {
        set site "HNL"
    } elseif {[string match "10.100.*" $IpAddress]} {
        set site "CAL"
    } elseif {[string match "10.6.*" $IpAddress]} {
        set site "RTP"
    } elseif {[string match "10.47.*" $IpAddress]} {
        set site "SNV"
    } elseif {[string match "10.61.*" $IpAddress]} {
        set site "CHN"
    }
    
    #Check if this chassis IP is already in the table
    set chassis [::mysql::sel $::dbConn \
        "SELECT Hostname FROM avl_appliances WHERE ipaddress ='$IpAddress'" -list]
    if {$chassis == ""} {
        set opcode "INSERT"
        
        set results [mysql::InsertAVLInventoryRecordToDB $::dbConn "$opcode" "avl_appliances" $IpAddress    \
        macAddress                  $adminConfig(adminNetworkConfig,macAddress)               \
        defaultGateway              $adminConfig(adminNetworkConfig,defaultGateway)           \
        hostname                    $adminConfig(adminNetworkConfig,hostname)                 \
        ipAddress                   $IpAddress                \
        subnetMask                  $adminConfig(adminNetworkConfig,subnetMask)               \
        useDhcp                     $adminConfig(adminNetworkConfig,useDhcp)                  \
        dispatcherVersion           $adminConfig(dispatcherVersion)        \
        hasSslAccelerator           $adminConfig(hasSslAccelerator)        \
        memoryPerUnit               $adminConfig(memoryPerUnit)            \
        memorySize                  $adminConfig(memorySize)               \
        modelNumber                 $adminConfig(modelNumber)              \
        numberOfUnits               $adminConfig(numberOfUnits)            \
        osVersion                   $adminConfig(osVersion)                \
        reserveList                 $adminConfig(reserveList)              \
        returnCode                  $adminConfig(returnCode)               \
        returnedFiles               $adminConfig(returnedFiles)            \
        serialNumber                $adminConfig(serialNumber)             \
        softwareVersion             $adminConfig(softwareVersion)          \
        buildVersion                [SPI_AV::Version]                      \
        systemTime                  $adminConfig(systemTime)               \
        numOfInterface              $adminConfig(numofinterface)           \
        dept                        "TBD"                                  \
        lastscan                    $scantime                              \
        site                        $site]
        
        for {set i 0} {$i < $adminConfig(numofinterface)} {incr i} {
            if {$adminConfig(modelNumber) == 290 || $adminConfig(modelNumber) == 2700} {
                set portgroupdescr $adminConfig(interfaceList,$i,description)
                if {$i <= 1} {
                    set user $adminConfig(reserveList,0,)
                    set portgroupindex "0"
                } else {
                    set user $adminConfig(reserveList,1,)
                    set portgroupindex "1"
                }
                set portgrouptype "1 Gigabit"     
            } elseif {$adminConfig(modelNumber) == 2900 || $adminConfig(modelNumber) == 3100} {
                if [catch {set user $adminConfig(reserveList,$i,)} err] {
                    set user ""
                }
                set portgroupindex $i
                if {$i < 8} {
                    set portgroupdescr $adminConfig(interfaceList,$i,description)
                    set portgrouptype "1 Gigabit"
                } else {
                    set portgrouptype "10 Gigabit"
                    set portgroupdescr ""
                }
            }

            set results [mysql::InsertAVLInventoryRecordToDB $::dbConn "$opcode" "avl_portgroups" $IpAddress    \
            ipAddress                   $IpAddress               \
            model                       $adminConfig(modelNumber)              \
            portgroupindex              $portgroupindex                        \
            portindex                   $i                                     \
            user                        $user                                  \
            portgroupdescr              $portgroupdescr                        \
            portgrouptype               $portgrouptype                         \
            activesoftware              ""                                     \
            dept                        "TBD"                                  \
            lastscan                    $scantime                              \
            site                        $site                                  \
            resend                      ""                                     \
            connection                  "TBD"   ]
        }        
    } else {
        set opcode "UPDATE"
        
        set results [mysql::InsertAVLInventoryRecordToDB $::dbConn "$opcode" "avl_appliances" $IpAddress    \
        macAddress                  $adminConfig(adminNetworkConfig,macAddress)               \
        defaultGateway              $adminConfig(adminNetworkConfig,defaultGateway)           \
        hostname                    $adminConfig(adminNetworkConfig,hostname)                 \
        ipAddress                   $IpAddress                \
        subnetMask                  $adminConfig(adminNetworkConfig,subnetMask)               \
        useDhcp                     $adminConfig(adminNetworkConfig,useDhcp)                  \
        dispatcherVersion           $adminConfig(dispatcherVersion)        \
        hasSslAccelerator           $adminConfig(hasSslAccelerator)        \
        memoryPerUnit               $adminConfig(memoryPerUnit)            \
        memorySize                  $adminConfig(memorySize)               \
        modelNumber                 $adminConfig(modelNumber)              \
        numberOfUnits               $adminConfig(numberOfUnits)            \
        osVersion                   $adminConfig(osVersion)                \
        reserveList                 $adminConfig(reserveList)              \
        returnCode                  $adminConfig(returnCode)               \
        returnedFiles               $adminConfig(returnedFiles)            \
        serialNumber                $adminConfig(serialNumber)             \
        softwareVersion             $adminConfig(softwareVersion)          \
        buildVersion                [SPI_AV::Version]                      \
        systemTime                  $adminConfig(systemTime)               \
        numOfInterface              $adminConfig(numofinterface)           \
        lastscan                    $scantime                              \
        site                        $site]
        
        for {set i 0} {$i < $adminConfig(numofinterface)} {incr i} {
            if {$adminConfig(modelNumber) == 290 || $adminConfig(modelNumber) == 2700} {
                set portgroupdescr $adminConfig(interfaceList,$i,description)
                if {$i <= 1} {
                    set user $adminConfig(reserveList,0,)
                    set portgroupindex "0"
                } else {
                    set user $adminConfig(reserveList,1,)
                    set portgroupindex "1"
                }
                set portgrouptype "1 Gigabit"     
            } elseif {$adminConfig(modelNumber) == 2900 || $adminConfig(modelNumber) == 3100} {
                if [catch {set user $adminConfig(reserveList,$i,)} err] {
                    set user ""
                }
                set portgroupindex $i
                if {$i < 8} {
                    set portgroupdescr $adminConfig(interfaceList,$i,description)
                    set portgrouptype "1 Gigabit"
                } else {
                    set portgrouptype "10 Gigabit"
                    set portgroupdescr ""
                }
            }

            set results [::mysql::sel $::dbConn "SELECT DISTINCT * FROM avl_portgroups \
                WHERE ipaddress ='$IpAddress' AND portgroupindex = '$portgroupindex' AND portindex = '$i'" -list]
            if {$results == ""} {
                #speical case handling the event where port information is deleted from portgroup table.
                set command "INSERT"
            } else {
                set command "UPDATE"
            }
            
            set condition "'$IpAddress' AND portgroupindex = '$portgroupindex' AND portindex='$i' "
            set results [mysql::InsertAVLInventoryRecordToDB $::dbConn "$command" "avl_portgroups"  $condition   \
            ipAddress                   $IpAddress                \
            model                       $adminConfig(modelNumber)              \
            portgroupindex              $portgroupindex                        \
            portindex                   $i                                     \
            user                        $user                                  \
            portgroupdescr              $portgroupdescr                        \
            portgrouptype               $portgrouptype                         \
            lastscan                    $scantime                              \
            ConnectionType      ""                                                             \
            PeerHost            ""                                                             \
            PeerModule          ""                                                             \
            PeerPort            ""                                                             \
            Comments            ""                                                             \
            site                        $site]
        }  
    }

    catch {unset adminConfig}
    catch {SPI_AV::CleanUp}

    mysql::CloseMySqlDB $::dbConn
    
    #return 
}

add_resource  $argc $argv
#add_resource  "1" "10.61.40.22"
#add_resource  "1" "10.47.24.9"