# In order to run this script on a PC, you must:
# 1. Install power shell from Micropsoft
# 2. Install powerCLI from VMware
# 3. Install MySQL .Net Connector (D:\work\vm_automation\mysql_powershell)
#    http://database-programming.suite101.com/article.cfm/connecting_to_mysql_from_powershell
# Tutorial: http://keithhill.spaces.live.com/blog/cns!5A8D2641E0963A97!811.entry?sa=795154726
#    http://www.computerperformance.co.uk/powershell/powershell_math.htm
#
#Loading the MySQL .NET Connector
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
#define a connection string
$connectionString = "server=10.2.10.139;uid=commonqa;pwd=Qahnl000;database=pv_inventory;"
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

#create SQL command
#$sql = "SELECT * FROM vm_host_copy WHERE Site = 'HNL'"
$sql = "SELECT * FROM vm_host"
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



function objToString
{ param ($obj, $str)
    $objstring = [string]$obj -replace '@{', ""
    $objstring = [string]$objstring -replace '=', ""
    $objstring = [string]$objstring -replace $str, ""
    [string]$objstring -replace '}', ""
}

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





#deal with single item list
$NonXenVMServer = $dataSet.Tables["vmhost"] | where-object {$_.VMServerName -ne "XenServer 5.5.0"}
$VMServerIp = $NonXenVMServer | select VMHost
$VMServerUsername = $NonXenVMServer | select Username 
$VMServerPassword = $NonXenVMServer | select Password

echo "This is the list of VMware servers to process."
$VMServerIp
$connection.Close()

while (1) {
    #process one VM server at a time
    for ($vmsidx=0; $vmsidx -lt $VMServerIp.length; $vmsidx++) {
        $Message = ""        
        #Step 1: Launch vSphere PowerCLI and connect to a VMware Server
        $serverip = objToString $VMServerIp[$vmsidx] VMHost
        $serverusername = objToString $VMServerUsername[$vmsidx] Username
        $serverpassword = objToString $VMServerPassword[$vmsidx] Password
        $scantime = get-date -uformat "%a, %b %d, %Y %r"
        Try {
            $srvprop = Connect-VIServer -Server $serverip -Protocol https -User $serverusername -Password $serverpassword
            echo $srvprop; #$srvprop contains name of server, port, and user

            #Step 2: Get VM server details
            $Message += "PowerState='"; $Message += objToString (get-vmhost | select  PowerState) PowerState
            $Message += "', Manufacturer='"; $Message += objToString (get-vmhost | select  Manufacturer) Manufacturer
            $Message += "', Model='"; $Message += objToString (get-vmhost | select  Model) Model
            $Message += "', Processor='"; $Message += objToString (get-vmhost | select  NumCpu) NumCpu; $Message += " CPU"
            $Message += "', CPU='"; $Message += objToString (get-vmhost | select  ProcessorType) ProcessorType
            #$Message += "', CpuTotalMhz='"; $Message += objToString (get-vmhost | select  CpuTotalMhz) CpuTotalMhz; #not in db
            $Message += "', MemoryCapacity='"; $Message += [System.Math]::Round([int](objToString (get-vmhost | select  MemoryTotalMB) MemoryTotalMB)/1024, 2); $Message += " GB"
            $Message += "', VMVersion='"; $Message += objToString (get-vmhost | select  Version) Version

            $Vmlist = get-vm; $VMHost = objToString ($Vmlist[0] | select-object Host) Host 
            #$Message += "', VMServerName='"; $Message += VMHost; #sometimes this gives out IP address
            #$Message += "', VMServerName='"; $Message += objToString (get-vmhost | select  Name) Name; # this line returns IP address too :(
            
            #Step 3: Get VM server’s HD size. Skip zero capacity HD.
            #$prn = Get-Datastore | fl
            #echo $prn
            $datastore = Get-Datastore | where-object {$_.Name -eq "datastore1"}
            $Message += "', HD='"; $Message += [System.Math]::Round([int](objToString ($datastore | select-object CapacityMB) CapacityMB)/1024, 2); $Message += " GB"
            #$Message += "', Name='"; $Message += objToString (Get-Datastore | select-object Name -first 1) Name; #not in db

            #Step 4: Get VM server’s physical NICs. 
            $Nics = Get-VMHostNetworkAdapter -Physical
            $Message += "', TotalNumberOfNIC='"; $Message += $Numofnics = $Nics.length
            #for ($i=0; $i -lt $Nics.length-1; $i++) {
            #    echo $Nics[$i] | select-object Name, DhcpEnabled, BitRatePerSec
            #}
            

            #Step 5: Get VM names under the server instance and the total counts. Store the VM names.
            $Vmlist = get-vm 
            $Message += "', TotalVMNumber='"; $Message += $Vmlist.length
            $Message += "'"
            $Message += ", LastScan = '$scantime'"
            #This is where we update the the server information into DB
            $connection.Open()
            $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
            $sql = "UPDATE vm_host SET $Message WHERE VMHost = '$serverip'"

            echo "Updating server level"
            $sql
            $command.Connection = $connection
            $command.CommandText = $sql
            $command.ExecuteReader()
            $connection.Close()

            #This is where we update the the VM client information into DB
            for ($i=0; $i -lt $Vmlist.length-1; $i++) {
                $Message = ""
                $Message += "ClientName='"; $Message += objToString ($Vmlist[$i] | select-object Name) Name
                $VMHost = objToString ($Vmlist[$i] | select-object Host) Host 
                #$Message += "', VMHostName='"; $Message += VMHost ;# can't get the name yet (now in ip address format)
                $Message += "', RunState='"; $Message += objToString ($Vmlist[$i] | select-object PowerState) PowerState
                $Message += "', NumberOfCPU='"; $Message += objToString ($Vmlist[$i] | select-object NumCpu) NumCpu
                $Message += "', Memory='"; $Message += [System.Math]::Round([int](objToString ($Vmlist[$i] | select-object MemoryMB) MemoryMB)/1024, 2); $Message += " GB"

                $VmName = objToString ($Vmlist[$i] | select Name) Name
                $Message += "', GuestOS='"; $Message += objToString (Get-VMGuest -VM (Get-VM -Name $VmName) | select-object OSFullname) OSFullname
                #$IPAddress = Get-VMGuest -VM (Get-VM -Name $VmName) | select-object IPAddress
                #$Message += "', VMClient='"; $Message += $IPAddress.IPAddress[0] ;# IP address is in list form

                $Message += "', ClientName='"; $Message += objToString (Get-VMGuest -VM (Get-VM -Name $VmName) | select-object VmName) VmName 
                $Message += "'"
                $Message += ", LastScan = '$scantime'"
                #This is where we update the the server information into DB
                $connection.Open()
                $command = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
                $sql = "UPDATE vm_client SET $Message WHERE VMHost = '$serverip' AND ClientName = '$VmName'"

                #echo "Updating client level."
                #$sql
                $command.Connection = $connection
                $command.CommandText = $sql
                $command.ExecuteReader()
                $connection.Close()
            }
            Remove-Item variable:Nics
            Remove-Item variable:vmlist
            $connection.Close()
            Disconnect-VIServer -Server $serverip -Confirm:$false

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
