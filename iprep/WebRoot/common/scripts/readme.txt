Scripts to scan STC chassis and DUT
===================================


To use these scripts:

1. Put "mysqltcl-3.03" in its contents into your TCL lib fold. For example, if you install TCL in your C drive, it should look like this: C:\Tcl\lib\mysqltcl-3.03
This is the TCL support for msql. 


2. Test if you have mysql in place. Open TCL shell and issue the following command.

% package require mysqltcl
3.03 

3. File "Stc_Inventory_Tool.tcl" is used to scan STC chassis and update the database.
This file contain list of chassis from different sites to scan. Much of information created or updated by this file reflect the information found at:
http://topaz/pv/inventory/main.html Or 
http://topaz/pv/inventory/chassis.asp? Or
http://topaz/dev/inventory/chassis.asp?
They are all point to the same database.


4. File "Dut_Inventory_Tool.tcl" is used to scan DUT with SNMP and update the database. 
Much of information created or updated by this file reflect the information found at:
http://topaz/dev/inventory/dut.asp?


This file is still under development. You need download a free trial software call "SMITHY SDK" to do anything with it. The site is at: http://www.muonics.com/Products/MIBSmithySDK/

You only get 15 days to use it though but you can download a few times.