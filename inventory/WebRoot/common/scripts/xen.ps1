# In order to run this script on a PC, you must:
# 1. Install power shell from Micropsoft
# 2. Install powerCLI from VMware
# 3. Install MySQL .Net Connector (D:\work\vm_automation\mysql_powershell)
#    http://database-programming.suite101.com/article.cfm/connecting_to_mysql_from_powershell
# Tutorial: http://keithhill.spaces.live.com/blog/cns!5A8D2641E0963A97!811.entry?sa=795154726

#Loading the MySQL .NET Connector
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
#define a connection string
$connectionString = "server=10.2.10.139;uid=commonqa;pwd=Qahnl000;database=pv_inventory;"
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

#create SQL command
$sql = "SELECT * FROM vm_host WHERE ExistInPool != 'Y'"
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
#use $command to create a data adapter object
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)

#create dataset variable
$dataSet = New-Object System.Data.DataSet
#uses data adapter to fill the dataset 
$recordCount = $dataAdapter.Fill($dataSet, "vmhost")
#$dataSet.Tables["vmhost"]
$dataSet.Tables["vmhost"] | Format-Table
#$dataSet.Tables["vmhost"] | Format-List

#http://weblogs.asp.net/adweigert/archive/2007/10/10/powershell-try-catch-finally-comes-to-life.aspx
function Try
{
    param
    (
        [ScriptBlock]$Command = $(throw "The parameter -Command is required."),
        [ScriptBlock]$Catch   = { throw $_ },
        [ScriptBlock]$Finally = {}
    )
    
    & {
        $local:ErrorActionPreference = "SilentlyContinue"
        
        trap
        {
            trap
            {
                & {
                    trap { throw $_ }
                    &$Finally
                }
                
                throw $_
            }
            
            $_ | & { &$Catch }
        }
        
        &$Command
    }

    & {
        trap { throw $_ }
        &$Finally
    }
}

function objToString
{ param ($obj, $str)
    $objstring = [string]$obj -replace '@{', ""
    $objstring = [string]$objstring -replace '=', ""
    $objstring = [string]$objstring -replace $str, ""
    [string]$objstring -replace '}', ""
}


#deal with single item list
$XenVMServer = $dataSet.Tables["vmhost"] | where-object {$_.VMServerName -eq "XenServer 5.5.0"}
$VMServerIp = $XenVMServer | select VMHost

#Use name to avoid Certificate Chain Broken for Connect-XenServe
$VMServerName = $XenVMServer | select Name 
$VMServerUsername = $XenVMServer | select Username 
$VMServerPassword = $XenVMServer | select Password
echo "This is the list of VMware servers to process."
$VMServerIp
$connection.Close()

while (1) {
    #process one VM server at a time
    for ($vmsidx=0; $vmsidx -lt $VMServerIp.length; $vmsidx++) {
        $Message = ""        
        #Step 1: Launch vSphere PowerCLI and connect to a VMware Server
        $serverip = objToString $VMServerIp[$vmsidx] VMHost
        $servername = objToString $VMServerName[$vmsidx] Name 
        $serverusername = objToString $VMServerUsername[$vmsidx] Username
        $serverpassword = objToString $VMServerPassword[$vmsidx] Password
        $scantime = get-date -uformat "%a, %b %d, %Y %r"
        Try {
            echo "-Server $serverip -User $serverusername -Password $serverpassword"
            $srvprop = Connect-XenServer -Server $serverip -User $serverusername -Password $serverpassword
            #Connect-XenServer -Server 10.95.90.11 -User root -Password spirent 
            echo $srvprop; #$srvprop contains name of server, port, and user

            #Step 2: Get VM server details
            if ($serverip -eq "10.95.90.11") {
                #This server has a pool of server inside it.
                echo "Processing server inside pool of $serverip" 
                $intfaddress = Get-XenServer:Host | select address
                $intfhostname = Get-XenServer:Host | select hostname
                $intfenabled = Get-XenServer:Host | select enabled
                #process each server residing in this pool
                for ($intfidx=0; $intfidx -lt $intfaddress.length; $intfidx++) {
                    $intfmessage = "" 
                    $intfip = objToString $intfaddress[$intfidx] address
                    if ((objToString $intfenabled[$intfidx] enabled) -eq "True") {
                        $intfmessage += "PowerState='"; $intfmessage += "PoweredOn" 
                    } else {
                        $intfmessage += "PowerState='"; $intfmessage += "PoweredOff" 
                    }
                    $intfmessage += "'"
                    $intfmessage += ", LastScan = '$scantime'"
                    $connection.Open()
                    $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
                    $sql = "UPDATE vm_host SET $intfmessage WHERE VMHost = '$intfip'"
                    #Print the statement out
                    $sql
                    $command.Connection = $connection
                    $command.CommandText = $sql
                    $command.ExecuteReader()
                    $connection.Close() 
                }
            } else {
                if ((objToString (Get-XenServer:Host | select enabled) enabled) -eq "True") {
                    $Message += "PowerState='"; $Message += "PoweredOn" 
                } else {
                    $Message += "PowerState='"; $Message += "PoweredOff" 
                }
                $Message += "', "
            }

            #Step 4: Get VM server’s physical NICs. 
            $Nics = Get-XenServer:Network
            $Message += "TotalNumberOfNIC='"; $Message += $Numofnics = $Nics.length
            

            #Step 5: Get VM names under the server instance and the total counts. Store the VM names.
            $Vmlist = Get-XenServer:VM -properties @{ is_a_template="false" }
            $Message += "', TotalVMNumber='"; $Message += $Vmlist.length
            $Message += "'"
            $Message += ", LastScan = '$scantime'"

            #This is where we update the the server information into DB
            $connection.Open()
            $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
            $sql = "UPDATE vm_host SET $Message WHERE VMHost = '$serverip'"

            #Print the statement out
            $sql

            $command.Connection = $connection
            $command.CommandText = $sql
            $command.ExecuteReader()
            $connection.Close()
            if ($serverip -like "10.14.*") {
                $site = "HNL"
            } elseif ($serverip -like "10.95.*") {
                $site = "CAL"
            } elseif ($serverip -like "10.27.*") {
                $site = "RTP"
            } elseif ($serverip -like "10.47.*") {
                $site = "SNV"
            } elseif ($serverip -like "10.61.*") {
                $site = "CHN"
            } 
            #This is where we update the the VM client information into DB
            for ($i=0; $i -lt $Vmlist.length-1; $i++) {
                $Message = ""
                $VmName = objToString ($Vmlist[$i] | select-object name_label) name_label
                $Message += "ClientName='"; $Message += objToString ($Vmlist[$i] | select-object name_label) name_label
                $Message += "', RunState='"; $Message += objToString ($Vmlist[$i] | select-object power_state) power_state
                $Message += "', NumberOfCPU='"; $Message += objToString ($Vmlist[$i] | select-object VCPUs_max) VCPUs_max
                $Message += "', VMHost = '$serverip'"
                $Message += ", Site = '$site'"
                $Message += ", Dept = 'PV'"
                $Message += ", LastScan = '$scantime'"
                #$Message += ", VMHostName = '$servername'"

                #This line got wrong value of memory, skip for now.
                #$Message += "', Memory='"; $Message += [long](objToString ($Vmlist[$i] | select-object memory_target) memory_target)/1024; $Message += " GB"

                #This is where we update the the server information into DB
                $connection.Open()
                $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand

                #Use update here because I used REPLACE to create items.
                $sql = "UPDATE vm_client SET $Message WHERE VMHost = '$serverip' AND ClientName = '$VmName'"

                #Use REPLACE here to create items. This will wipe out portions of records. 
                #WARNING: Must use this only with new IP address.
                #$sql = "REPLACE INTO vm_client SET $Message"

                #Print out client level update
                $sql
                $command.Connection = $connection
                $command.CommandText = $sql
                $command.ExecuteReader()
                $connection.Close()
            }
            Remove-Item variable:Nics
            Remove-Item variable:vmlist
            $connection.Close()
            Disconnect-XenServer -Server $serverip

        } -Catch {
            echo "Cannot handle the error (will mark server as down): $_"
            #throw $_
            $Message += "PowerState='PoweredOff'"
            $Message += ", LastScan = '$scantime'"
            $connection.Open()
            $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
            $sql = "UPDATE vm_host SET $Message WHERE VMHost = '$serverip'"

            echo "Updating server level"
            $sql
            $command.Connection = $connection
            $command.CommandText = $sql
            $command.ExecuteReader()
            $connection.Close()
        }
    }
    echo "Wait for 1 day to udpate again"
    Start-Sleep -s 86400
}













