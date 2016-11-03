##########################################################################################################
# Script Name	:  mysqlutils.tcl                                                                        #
# Script Author :  Saiyoot Nakkhongkham                                                                  #
# Description	:  To provide basic access to MySQL database                                             #
#                                                                                                        #
# Date written  :  08/10/2009                                                                            #
#                                                                                                        #
# Modified      :                                                                                        #
##########################################################################################################


package require mysqltcl
package provide mysqlutils 1.0
namespace eval mysql {
    variable debugLevel 0
}

###
#  Name:    OpenMySqlDB
#  Inputs:  dbname - name of the database to open 
#  Globals: none
#  Outputs: none
#  Description: Open database connection to given database
###
proc mysql::OpenMySqlDB {dbname} {
    puts "\nOpening Sql database ($dbname)..."    
    if {[catch {set dbConn [::mysql::connect -host "10.2.10.139" -user "commonqa" -password "Qahnl000" -db $dbname]} error]} {
        puts "ERROR: $error"
        return
    }
    if {$dbConn == ""} {
        puts "ERROR: Failed to open the database!"
        return
    }
    return $dbConn
}

###
#  Name:    CloseMySqlDB
#  Inputs:  dbConn
#  Globals: none
#  Outputs: none
#  Description: Close a database referenced internally by dbConn
###
proc mysql::CloseMySqlDB {dbConn} {
    if {[catch {::mysql::close $dbConn} error]} {
        puts "ERROR: $error."
    }
}

###
#  Name:    DeleteRecordInTable
#  Inputs:  dbConn - connection object to the opened database 
#           tablename - the table to insert the records to
#  Globals: none
#  Outputs: none
#  Description: Insert information to a given table of the opened database connection
###
proc mysql::DeleteRecordInTable {dbConn tablename} {
    puts "::mysql::sel $::dbConn Delete FROM $tablename"
    set results [::mysql::sel $::dbConn "Delete FROM $tablename"]
}


###
#  Name:    InsertRecordToDB
#  Inputs:  dbConn - connection object to the opened database 
#           tablename - the table to insert the records to
#           args - information to insert; they are to go different columns
#  Globals: none
#  Outputs: none
#  Description: Insert information to a given table of the opened database connection
###
proc mysql::InsertRecordToDB {dbConn tablename args} {
    variable debugLevel
    puts "Inserting data to $tablename..."
    set insrtstmt "INSERT $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            status             { append insrtstmt "Status = '$val'," }
            build              { append insrtstmt "Build = '$val'," }
            servernum          { append insrtstmt "ServerNum = '$val'," }
            poolnum            { append insrtstmt "PoolNum = '$val'," }
            clientnum          { append insrtstmt "ClientNum = '$val'," }
            totalattemptcount  { append insrtstmt "TotalAttemptCount = '$val'," }
            totalboundcount    { append insrtstmt "TotalBoundCount = '$val'," }
            totalfailedcount   { append insrtstmt "TotalFailedCount = '$val',"}
            totalrenewedcount  { append insrtstmt "TotalRenewedCount = '$val',"}
            totalretriedcount  { append insrtstmt "TotalRetriedCount = '$val',"}
            currentboundcount  { append insrtstmt "CurrentBoundCount = '$val',"}
            currentidlecount   { append insrtstmt "CurrentIdleCount = '$val',"}
            attemptrate        { append insrtstmt "AttemptRate = '$val',"}
            bindrate           { append insrtstmt "BindRate = '$val',"}
            date               { append insrtstmt "Date = '$val',"}
            scriptname         { append insrtstmt "ScriptName = '$val',"}
            cookie             { append insrtstmt "Cookie = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    #set results [::mysql::sel $::dbConn $insrtstmt -list]
    
    set results ""
    if {[catch {set results [::mysql::sel $::dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update Record tables: $catcherror"
    }
    return $results 
}


###
#  Name:    InsertInventoryRecordToDB
#  Inputs:  dbConn - connection object to the opened database 
#           command - INSERT or UPDATE
#           tablename - the table to insert the records to
#           args - information to insert; they are to go different columns
#  Globals: none
#  Outputs: none
#  Description: Insert information to a given table of the opened database connection
###
proc mysql::InsertInventoryRecordToDB {dbConn command tablename id args} {
    variable debugLevel
    puts "$command data to $tablename..."
    set insrtstmt "$command $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            hostname                        { append insrtstmt "Hostname = '$val'," }
            backplanehwversion              { append insrtstmt "BackplaneHwVersion = '$val'," }
            controllerhwversion             { append insrtstmt "ControllerHwVersion = '$val'," }
            controllerhwversion             { append insrtstmt "ControllerHwVersion = '$val'," }
            diskfree                        { append insrtstmt "DiskFree = '$val'," }
            diskused                        { append insrtstmt "DiskUsed = '$val'," }
            firmwareversion                 { append insrtstmt "FirmwareVersion = '$val'," }
            model                           { append insrtstmt "Model = '$val'," }
            partnum                         { append insrtstmt "PartNum = '$val'," }
            serialnum                       { append insrtstmt "SerialNum = '$val'," }
            slotcount                       { append insrtstmt "SlotCount = '$val',"}
            totaldisksize                   { append insrtstmt "TotalDiskSize = '$val',"}
            description                     { append insrtstmt "Description = '$val',"}
            firmwareversion                 { append insrtstmt "FirmwareVersion = '$val',"}
            hwrevcode                       { append insrtstmt "HwRevCode = '$val',"}
            model                           { append insrtstmt "Model = '$val',"}
            partnum                         { append insrtstmt "PartNum = '$val',"}
            portcount                       { append insrtstmt "PortCount = '$val',"}
            portgroupcount                  { append insrtstmt "PortGroupCount = '$val',"}
            portgroupsize                   { append insrtstmt "PortGroupSize = '$val',"}
            productfamily                   { append insrtstmt "ProductFamily = '$val',"}
            productid                       { append insrtstmt "ProductId = '$val',"}
            serialnum                       { append insrtstmt "SerialNum = '$val',"}
            testpackages                    { append insrtstmt "TestPackages = '$val',"}
            slotindex                       { append insrtstmt "SlotIndex = '$val',"}
            portgroupindex                  { append insrtstmt "PortGroupIndex = '$val',"}
            portindex                       { append insrtstmt "PortIndex = '$val',"}
            resend                          { append insrtstmt "ResEnd = '$val',"}
            property                        { append insrtstmt "Property = '$val',"}
            so                              { append insrtstmt "SO = '$val',"}
            sostart                         { append insrtstmt "SOStart = '$val',"}
            soend                           { append insrtstmt "SOEnd = '$val',"}
            personalitycardtype             { append insrtstmt "PersonalityCardType = '$val',"}
            transceivertype                 { append insrtstmt "TransceiverType = '$val',"}
            name                            { append insrtstmt "Name = '$val',"}
            status                          { append insrtstmt "Status = '$val',"}
            ownershipstate                  { append insrtstmt "OwnershipState = '$val',"}
            ownerhostname                   { append insrtstmt "OwnerHostname = '$val',"}
            owneruserid                     { append insrtstmt "OwnerUserId = '$val',"}
            ownertimestamp                  { append insrtstmt "OwnerTimestamp = '$val',"}
            vendor                          { append insrtstmt "Vendor = '$val',"}
            ios                             { append insrtstmt "Ios = '$val',"}
            bladecount                      { append insrtstmt "BladeCount = '$val',"}
            intfindex                       { append insrtstmt "IntfIndex = '$val',"}
            intftype                        { append insrtstmt "IntfType = '$val',"}
            intfdescr                       { append insrtstmt "IntfDescr = '$val',"}
            dept                            { append insrtstmt "Dept = '$val',"}
            lastscan                        { append insrtstmt "LastScan = '$val',"}
            site                            { append insrtstmt "Site = '$val',"}
            connection                      { append insrtstmt "Connection = '$val',"}
            connectiontype                  { append insrtstmt "ConnectionType = '$val',"}
            peerhost                        { append insrtstmt "PeerHost = '$val',"}
            peermodule                      { append insrtstmt "PeerModule = '$val',"}
            peerport                        { append insrtstmt "PeerPort = '$val',"}
            failconnects                    { append insrtstmt "FailConnects = '$val',"}
            comments                        { append insrtstmt "Comments = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$command == "UPDATE"} {
        if {$tablename == "stc_inventory_chassis"} {
            append insrtstmt " WHERE Hostname = '$id'"
        } else {
            append insrtstmt " WHERE Hostname = $id"
        }
    }
    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    
    set results ""
    if {[catch {set results [::mysql::sel $::dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update chassis tables: $catcherror"
    }
    return $results 
}

###
#  Name:    InsertChassisInfoToDB
#  Inputs:  dbConn - connection object to the opened database 
#           command - INSERT or UPDATE
#           tablename - the table to insert the records to
#           args - information to insert; they are to go different columns
#  Globals: none
#  Outputs: none
#  Description: Insert information to a given table of the opened database connection
###
proc mysql::InsertChassisInfoToDB {dbConn command tablename id args} {
    variable debugLevel
    puts "$command data to $tablename..."
    set insrtstmt "$command $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            hostname                             { append insrtstmt "Hostname = '$val'," }
            partnum                              { append insrtstmt "PartNum = '$val'," }
            temperaturel1l                       { append insrtstmt "TemperatureL1L = '$val'," }
            temperaturel11                       { append insrtstmt "TemperatureL11 = '$val',"}
            temperaturel12                       { append insrtstmt "TemperatureL12 = '$val',"}
            temperaturel13                       { append insrtstmt "TemperatureL13 = '$val',"}
            temperaturebp1l                      { append insrtstmt "TemperatureBP1L = '$val',"}
            temperaturebp11                      { append insrtstmt "TemperatureBP11 = '$val',"}
            temperaturebp12                      { append insrtstmt "TemperatureBP12 = '$val',"}
            temperaturebp13                      { append insrtstmt "TemperatureBP13 = '$val',"}
            powertop                             { append insrtstmt "PowerTop = '$val',"}
            powermiddle                          { append insrtstmt "PowerMiddle = '$val',"}
            powerbottom                          { append insrtstmt "PowerBottom = '$val',"}
            fanrearleft                          { append insrtstmt "FanRearLeft = '$val',"}
            fanrearmiddle                        { append insrtstmt "FanRearMiddle = '$val',"}
            fanrearright                         { append insrtstmt "FanRearRight = '$val',"}
            fanfrontleft                         { append insrtstmt "FanFrontLeft = '$val',"}
            fanfrontmiddle                       { append insrtstmt "FanFrontMiddle = '$val',"}
            fanfrontright                        { append insrtstmt "FanFrontRight = '$val',"}
            lastscan                             { append insrtstmt "LastScan = '$val',"}
            site                                 { append insrtstmt "Site = '$val',"}
            temperaturel2l                       { append insrtstmt "TemperatureL2L = '$val'," }
            temperaturel21                       { append insrtstmt "TemperatureL21 = '$val',"}
            temperaturel22                       { append insrtstmt "TemperatureL22 = '$val',"}
            temperaturel23                       { append insrtstmt "TemperatureL23 = '$val',"}
            temperaturesw1l                      { append insrtstmt "TemperatureLSWL = '$val',"}
            temperaturesw11                      { append insrtstmt "TemperatureLSW1 = '$val',"}
            temperaturesw12                      { append insrtstmt "TemperatureLSW2 = '$val',"}
            temperaturesw13                      { append insrtstmt "TemperatureLSW3 = '$val',"}
            innertoprear                         { append insrtstmt "InnerTopRear = '$val',"}
            innertopcenter                       { append insrtstmt "InnerTopCenter = '$val',"}
            innertopfront                        { append insrtstmt "InnerTopFront = '$val',"}
            innerbottomrear                      { append insrtstmt "InnerBottomRear = '$val',"}
            innerbottomcenter                    { append insrtstmt "InnerBottomCenter = '$val',"}
            innerbottomfront                     { append insrtstmt "InnerBottomFront = '$val',"}
            outertoprear                         { append insrtstmt "OuterTopRear = '$val',"}
            outertopcenter                       { append insrtstmt "OuterTopCenter = '$val',"}
            outertopfront                        { append insrtstmt "OuterTopFront = '$val',"}
            outerbottomrear                      { append insrtstmt "OuterBottomRear = '$val',"}
            outerbottomcenter                    { append insrtstmt "OuterBottomCenter = '$val',"}
            outerbottomfront                     { append insrtstmt "OuterBottomFront = '$val',"}            
            controller1                          { append insrtstmt "Controller1 = '$val',"}
            controller2                          { append insrtstmt "Controller2 = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$command == "UPDATE"} {
        if {$tablename == "stc_information"} {
            append insrtstmt " WHERE Hostname = '$id'"
        } else {
            append insrtstmt " WHERE Hostname = $id"
        }
    }
    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    #set results [::mysql::sel $::dbConn $insrtstmt -list]
    
    set results ""
    if {[catch {set results [::mysql::sel $::dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update chassis information tables: $catcherror"
    }
    return $results 
}

proc mysql::InsertDutInventoryRecordToDB {dbConn command tablename id args} {
    variable debugLevel
#    puts "$command data to $tablename..."
    set insrtstmt "$command $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            hostname                        { append insrtstmt "Hostname = '$val'," }
            backplanehwversion              { append insrtstmt "BackplaneHwVersion = '$val'," }
            controllerhwversion             { append insrtstmt "ControllerHwVersion = '$val'," }
            controllerhwversion             { append insrtstmt "ControllerHwVersion = '$val'," }
            diskfree                        { append insrtstmt "DiskFree = '$val'," }
            diskused                        { append insrtstmt "DiskUsed = '$val'," }
            firmwareversion                 { append insrtstmt "FirmwareVersion = '$val'," }
            model                           { append insrtstmt "Model = '$val'," }
            partnum                         { append insrtstmt "PartNum = '$val'," }
            serialnum                       { append insrtstmt "SerialNum = '$val'," }
            slotcount                       { append insrtstmt "SlotCount = '$val',"}
            totaldisksize                   { append insrtstmt "TotalDiskSize = '$val',"}
            description                     { append insrtstmt "Description = '$val',"}
            firmwareversion                 { append insrtstmt "FirmwareVersion = '$val',"}
            hwrevcode                       { append insrtstmt "HwRevCode = '$val',"}
            model                           { append insrtstmt "Model = '$val',"}
            partnum                         { append insrtstmt "PartNum = '$val',"}
            portcount                       { append insrtstmt "PortCount = '$val',"}
            portgroupcount                  { append insrtstmt "PortGroupCount = '$val',"}
            portgroupsize                   { append insrtstmt "PortGroupSize = '$val',"}
            productfamily                   { append insrtstmt "ProductFamily = '$val',"}
            productid                       { append insrtstmt "ProductId = '$val',"}
            serialnum                       { append insrtstmt "SerialNum = '$val',"}
            testpackages                    { append insrtstmt "TestPackages = '$val',"}
            slotindex                       { append insrtstmt "SlotIndex = '$val',"}
            portgroupindex                  { append insrtstmt "PortGroupIndex = '$val',"}
            portindex                       { append insrtstmt "PortIndex = '$val',"}
            name                            { append insrtstmt "Name = '$val',"}
            status                          { append insrtstmt "Status = '$val',"}
            ownershipstate                  { append insrtstmt "OwnershipState = '$val',"}
            ownerhostname                   { append insrtstmt "OwnerHostname = '$val',"}
            owneruserid                     { append insrtstmt "OwnerUserId = '$val',"}
            ownertimestamp                  { append insrtstmt "OwnerTimestamp = '$val',"}
            vendor                          { append insrtstmt "Vendor = '$val',"}
            ios                             { append insrtstmt "Ios = '$val',"}
            bladecount                      { append insrtstmt "BladeCount = '$val',"}
            intfindex                       { append insrtstmt "IntfIndex = '$val',"}
            intftype                        { append insrtstmt "IntfType = '$val',"}
            intfdescr                       { append insrtstmt "IntfDescr = '$val',"}
            dept                            { append insrtstmt "Dept = '$val',"}
            site                            { append insrtstmt "Site = '$val',"}
            enterprise                      { append insrtstmt "Enterprise = '$val',"}
            system                          { append insrtstmt "System = '$val',"}
            uptime                          { append insrtstmt "UpTime = '$val',"}
            iosversion                      { append insrtstmt "IosVersion = '$val',"}
            iosimage                        { append insrtstmt "IosImage = '$val',"}
            bundles                         { append insrtstmt "Bundles = '$val',"}
            invname                         { append insrtstmt "InvName = '$val',"}
            invdescr                        { append insrtstmt "InvDescr = '$val',"}
            invpid                          { append insrtstmt "InvPid = '$val',"}
            invvid                          { append insrtstmt "InvVid = '$val',"}
            invsn                           { append insrtstmt "InvSN = '$val',"}
            invvendor                       { append insrtstmt "InvVendor = '$val',"}
            lastscan                        { append insrtstmt "lastscan = '$val',"}
            resend                          { append insrtstmt "resend = '$val',"}
            connectiontype                  { append insrtstmt "ConnectionType = '$val',"}
            peerhost                        { append insrtstmt "PeerHost = '$val',"}
            peermodule                      { append insrtstmt "PeerModule = '$val',"}
            peerport                        { append insrtstmt "PeerPort = '$val',"}
            comments                        { append insrtstmt "Comments = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$command == "UPDATE"} {
        if {$tablename == "dut_inventory"} {
            append insrtstmt " WHERE Hostname = '$id'"
        } else {
            append insrtstmt " WHERE Hostname = $id"
        }
    }
    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    #set results [::mysql::sel $::dbConn $insrtstmt -list]
    
    set results ""
    if {[catch {set results [::mysql::sel $::dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update DUT tables: $catcherror"
    }
    return $results 
}
proc mysql::InsertAVLInventoryRecordToDB {dbConn command tablename id args} {
    variable debugLevel
#    puts "$command data to $tablename..."
    set insrtstmt "$command $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            defaultdomainname       { append insrtstmt "defaultDomainName = '$val'," }
            macaddress              { append insrtstmt "macAddress = '$val'," }
            defaultgateway          { append insrtstmt "defaultGateway = '$val'," }
            dnsserverlist           { append insrtstmt "dnsServerList = '$val'," }
            hostname                { append insrtstmt "hostname = '$val'," }
            ipaddress               { append insrtstmt "ipAddress = '$val'," }
            subnetmask              { append insrtstmt "subnetMask = '$val'," }
            usedhcp                 { append insrtstmt "useDhcp = '$val'," }
            dispatcherversion       { append insrtstmt "dispatcherVersion = '$val'," }
            hassslaccelerator       { append insrtstmt "hasSslAccelerator = '$val',"}
            interfacelist           { append insrtstmt "interfaceList = '$val',"}
            is64bit                 { append insrtstmt "is64bit = '$val',"}
            memoryperunit           { append insrtstmt "memoryPerUnit = '$val',"}
            memorysize              { append insrtstmt "memorySize = '$val',"}
            modelnumber             { append insrtstmt "modelNumber = '$val',"}
            numberofunits           { append insrtstmt "numberOfUnits = '$val',"}
            osversion               { append insrtstmt "osVersion = '$val',"}
            reservelist             { append insrtstmt "reserveList = '$val',"}
            returncode              { append insrtstmt "returnCode = '$val',"}
            errormessage            { append insrtstmt "errorMessage = '$val',"}
            returnedfiles           { append insrtstmt "returnedFiles = '$val',"}
            serialnumber            { append insrtstmt "serialNumber = '$val',"}
            softwareversion         { append insrtstmt "softwareVersion = '$val',"}
            buildversion            { append insrtstmt "buildVersion = '$val',"}
            systemtime              { append insrtstmt "systemTime = '$val',"}
            numofinterface          { append insrtstmt "numOfInterface = '$val',"} 
            model                   { append insrtstmt "model = '$val',"}
            portgroupindex          { append insrtstmt "portgroupindex = '$val',"}
            portindex               { append insrtstmt "portindex = '$val',"}
            user                    { append insrtstmt "user = '$val',"}
            portgroupdescr          { append insrtstmt "portgroupdescr = '$val',"}
            portgrouptype           { append insrtstmt "portgrouptype = '$val',"}
            dept                    { append insrtstmt "dept = '$val',"}
            connection              { append insrtstmt "connection = '$val',"}
            activesoftware          { append insrtstmt "activesoftware = '$val',"}
            site                    { append insrtstmt "site = '$val',"}
            lastscan                { append insrtstmt "lastscan = '$val',"}
            resend                  { append insrtstmt "ResEnd = '$val',"}
            connectiontype                  { append insrtstmt "ConnectionType = '$val',"}
            peerhost                        { append insrtstmt "PeerHost = '$val',"}
            peermodule                      { append insrtstmt "PeerModule = '$val',"}
            peerport                        { append insrtstmt "PeerPort = '$val',"}
            comments                        { append insrtstmt "Comments = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$command == "UPDATE"} {
        if {$tablename == "avl_appliances"} {
            append insrtstmt " WHERE ipaddress = '$id'"
        } else {
            append insrtstmt " WHERE ipaddress = $id"
        }
    }
    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    #set results [::mysql::sel $::dbConn $insrtstmt -list]
    
    set results ""
    if {[catch {set results [::mysql::sel $::dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update Avalanche tables: $catcherror"
    }
    return $results 
}

proc mysql::InsertReservationRecordToDB {dbConn command tablename id args} {
    variable debugLevel
#    puts "$command data to $tablename..."
    set insrtstmt "$command $tablename SET "
    foreach {attr val} $args {
        switch -- [string tolower $attr] {
            uid                     { append insrtstmt "uid = '$val'," }
            rec_index               { append insrtstmt "rec_index = '$val'," }
            description             { append insrtstmt "description = '$val'," }
            dtstart                 { append insrtstmt "dtstart = '$val'," }
            dtend                   { append insrtstmt "dtend = '$val'," }
            resources               { append insrtstmt "resources = '$val'," }
            organizer               { append insrtstmt "organizer = '$val'," }
            timeoffset              { append insrtstmt "timeoffset = '$val'," }
            snotification           { append insrtstmt "snotification = '$val',"}
            enotification           { append insrtstmt "enotification = '$val',"}
            rec_type                { append insrtstmt "rec_type = '$val',"}
            event_length            { append insrtstmt "event_length = '$val',"}
            event_pid               { append insrtstmt "event_pid = '$val',"}
            default {
                UnknownFieldWarning $attr $val
            }
        }
    }
    #remove the last comma from the statement
    set insrtstmt [string trimright $insrtstmt ","]

    if {$command == "UPDATE"} {
        if {$tablename == "events_ex"} {
            append insrtstmt " WHERE uid = '$uid'"
        } else {
            append insrtstmt " WHERE uid = $uid"
        }
    }
    
    if {$debugLevel > 0} {
        puts $insrtstmt
    }
    #set results [::mysql::sel $dbConn $insrtstmt -list]
    
    set results ""
    if {[catch {set results [::mysql::sel $dbConn $insrtstmt -list]} catcherror]} {
        puts "Error happened to update Reservation tables: $catcherror"
    }
    return $results 
}


###
#  Name: UnknownFieldWarning
#  Inputs:  attr - user supplied attribute name (ie -name)
#           val - user supplied value
#  Globals: none
#  Outputs: none
#  Description: Displays a warning to the screen that the given attribute is unknown (here)
###
proc mysql::UnknownFieldWarning {attr val} {
    puts "WARNING: Unknown field attribute $attr with value $val."
}

#set dbName "p222_testcheckoff"
#set table "dhcp_scale_results"
#
#set dbConn [mysql::OpenMySqlDB $dbName]
#set results [mysql::InsertRecordToDB $dbConn $table \
#        Build                   678910      \
#        ServerNum               0           \
#        TotalAttemptCount       1           \
#        TotalBoundCount         2           \
#        TotalFailedCount        3           \
#        TotalRenewedCount       4           \
#        TotalRetriedCount       5           \
#        CurrentBoundCount       6           \
#        CurrentIdleCount        7           \
#        AttemptRate             8           \
#        BindRate                9           \
#        ScriptName              x.tcl       \
#        Date                    [clock format [clock seconds] -format "%d%m%Y %H:%M:%S"] \
#        Cookie                  SAME]
#mysql::CloseMySqlDB $dbConn

#set dbConn [::mysql::connect -host topaz -user pvuser -db $::dbName]
#puts [::mysql::state $dbConn]
#set sqlStmt "SELECT * FROM dhcp_scale_results"
#set results [::mysql::sel $::dbConn $sqlStmt -list]
#puts $results
#set sqlStmt "INSERT dhcp_scale_results SET \
#        Build                   = '678910',
#        ServerNum               = '0',
#        TotalAttemptCount       = '1',
#        TotalBoundCount         = '2',
#        TotalFailedCount        = '3',
#        TotalRenewedCount       = '4',
#        TotalRetriedCount       = '5',
#        CurrentBoundCount       = '6',
#        CurrentIdleCount        = '7',
#        AttemptRate             = '8',
#        BindRate                = '9',
#        ScriptName              = 'will see',
#        Date                    = 'March',
#        Cookie                  = 'SAME'"
#puts $sqlStmt
#set results [::mysql::sel $::dbConn $sqlStmt -list]
#::mysql::close $dbConn
