set filename "[info script].txt"
set fid [open $filename w]
set scantime [clock format [clock seconds] -gmt true -format {%Y-%m-%d %H:%M:%S}]
#$env(LMS_DIR) is directory where the file is in the server or any local machine
if {[catch {source [file join $env(LMS_DIR) "Stc_Inventory_Tool.tcl"]} err1]} {
     puts $fid "$scantime: Fail to sourced $env(LMS_DIR) Stc_Inventory_Tool.tcl"
     puts $fid "$scantime: $err1."
     close $fid
     exit
} else {
     puts $fid "$scantime: Succesfully sourced $env(LMS_DIR) Stc_Inventory_Tool.tcl"
}
if {[catch {GoScan "CAL"} err2]} {
    puts $fid "$scantime: $err2."
    close $fid
} else {
    puts $fid "$scantime: Succesfully scanned."
close $fid
}

