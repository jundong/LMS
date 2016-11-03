' ========================================================
'
'	Title:			WMI Script to collect PC information 
'	Author:			Saiyoot Nakkhongkham and Jundong Xu
'	Date created:	5 May 2010
'	Date Modified:	5 May 2010
'	File Name:		
'	Description:	Performs a simple WMI lookup and write information to DB 
'				
' ========================================================

Option Explicit

'----- Declare Variables -----
Dim objShell, strComputer, StrDomain, StrUser, objNetwork, Message
Dim objWMIService, colItems, objItem, strDomainUsername, strPassword, strSite, objFSO

'----- Get object -----
Set objShell = CreateObject("Wscript.Shell")
Set objNetwork = CreateObject("WScript.Network")
Set objFSO = CreateObject("Scripting.FileSystemObject")


'-------------------------
'----- Begin Routine -----
'-------------------------
Do While 1

    '----- Create Output File -----
    Dim objFile
    Set objFile = objFSO.CreateTextFile(".\PC_Report.txt", 2)
    Dim conn, DSNtemp, rs, SQLstmt, objRecordSet
    Set conn = CreateObject("ADODB.Connection")

    DSNtemp="Driver={MySQL ODBC 3.51 Driver};Server=10.2.10.139; Port=3306; Option=0; Database=pv_inventory; UID=commonqa; PWD=Qahnl000;"
    conn.ConnectionString = DSNtemp
    conn.Open

    strDomainUsername = "SPIRENTCOM\CommonQa"
    strPassword = "Qahnl000"
    'strDomainUsername = "SPIRENTCOM\scmthot"
    'strPassword = "thot26"

    set objRecordSet = conn.Execute("SELECT DNSHostName FROM lab_pcs ORDER BY IPAddress")
    Do Until objRecordSet.EOF
        strComputer = Trim(objRecordSet("DNSHostName"))
        'Popup message
        'WScript.Echo strComputer

        'Except handling
        On Error Resume Next
        Err.Clear
        
        Set objWMIService = CreateObject("WbemScripting.SWbemLocator").ConnectServer _
                               (strComputer, "root\cimv2", strDomainUsername, strPassword)
        'Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 'when locally tested

        If Err.Number <> 0 Then
            'Popup message
            'WScript.Echo strComputer
            'Execption handling logic when the PC is DOWN.
            Message = Message & "Status='" & "DOWN" & "',"
            Message = Message & "LastScan='" & FormatDateTime(Now()) & "'" 'last block in message
            Set rs = conn.Execute("UPDATE lab_pcs SET " & Message & " WHERE DNSHostName='" & strComputer & "'")
        Else
            'Execption handling logic when the PC is UP.
            Message = Message & "Status='" & "UP" & "', "

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem")
            For Each objItem In colItems
                Message = Message & "Manufacturer='" & objItem.Manufacturer & "', "
                Message = Message & "Model='" & objItem.Model & "', "
                Message = Message & "Ram='" & Round(objItem.TotalPhysicalMemory/1073741824) & " GB', "
                'If objItem.UserName <> "null" Then 'when someone is logged on else when is not
                '    Message = Message & "UserName='" & Mid(objItem.UserName, InStr(objItem.UserName, "\")+1, Len(objItem.UserName)) & "', "
                'Else
                '    Message = Message & "UserName='N/A', "
                'End If
                Message = Message & "NumberOfProcessors='" & objItem.NumberOfProcessors & "', "
                Exit For
            Next

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor")
            For Each objItem In colItems
                Message = Message & "CPUName='" & Trim(objItem.Name) & "', "
                Exit For 'we only need one type 
            Next

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk")
            For Each objItem In colItems
                If objItem.MediaType = 12 Then 'local fixed disk
                    If objItem.DeviceID = "C:" Then
                        Message = Message & "HD='" & objItem.Name & "', "
                        Message = Message & "HDSize='" & Round(objItem.Size/1073741824) & " GB', "

                    End If
                End If
            Next

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem")
            For Each objItem In colItems
                Message = Message & "OSName='" & Mid(objItem.Name, 1, InStr(objItem.Name, "|C:\WINDOWS|")-1) & "', "
                Message = Message & "ServicePack='" & objItem.CSDVersion & "', "
            Next

            'Getting current logged on user. Dirty hack but seems to be consistent.
            Dim strUserName, status, found
            found = "false"
            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Process Where Name='explorer.exe' OR Name='rdpclip.exe' OR Name='McTray.exe' OR  Name='shstat.exe' OR  Name='ACIntUser.EXE' OR  Name='WZQKPICK.EXE'")
            For Each objItem In colItems
                status = objItem.GetOwner(strUserName)
                If stutus = 0 Then
                    Message = Message & "UserName='" & strUserName & "', "
                    found = "true"
                    Exit For
                End If
            Next
            If found = "false" Then
                Message = Message & "UserName='N/A', "
            End If

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")
            For Each objItem In colItems
                If objItem.IPEnabled = "True" AND objItem.DNSHostName <> "null" AND objItem.DHCPEnabled = "True" AND objItem.FullDNSRegistrationEnabled = "True" Then
                    Message = Message & "DNSHostName='" & objItem.DNSHostName & "', "
                    Message = Message & "IPAddress='" & Join(objItem.IPAddress, ",") & "', "
                    'this loop gives reduntdant IPs for some reason
                    Exit For
                End If
            Next

            Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_TimeZone")
            For Each objItem In colItems
                If InStr(objItem.StandardName, "Hawaiian") THEN
                    strSite = "HNL"
                Elseif InStr(objItem.StandardName, "China") THEN
                    strSite = "CHN"
                Elseif InStr(objItem.StandardName, "Eastern") THEN
                    strSite = "RTP"
                Elseif InStr(objItem.StandardName, "Pacific") THEN
                    strSite = "CAL"
                End If
                Message = Message & "Site='" & strSite & "', "
            Next

            Message = Message & "LastScan='" & FormatDateTime(Now()) & "'" 'last block in message

            'Because we query the IP from the table, saying that the record is already exits, use UPDATE command
            Set rs = conn.Execute("UPDATE lab_pcs SET " & Message & " WHERE DNSHostName='" & strComputer & "'")

        End If 'Error hanlding If
        objFile.Write strComputer & ": UPDATE lab_pcs SET " & Message & " WHERE DNSHostName='" & strComputer & "'" & vbCrLf & vbCrLf
        Set SQLstmt = nothing 
        Message = "" 
        objRecordSet.MoveNext
    Loop

    objRecordSet.Close
    conn.Close
    Set conn = nothing
    objFile.Close

    'WScript.Echo "Loop"
    WScript.Sleep(1000*60*60)
    'WScript.Sleep(1000*1*1)
Loop


'----- End Script -----
WScript.Quit

