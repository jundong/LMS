<%@ page contentType="text/html;charset=gb2312"
	import="com.spirent.downupload.*,java.io.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.stream.StreamGobbler"%>
<%
	String webPath = this.getServletConfig().getServletContext()
			.getRealPath("/")
			+ "common\\scripts\\";
	String loginUser = (String)request.getSession().getAttribute("username");
	String filename = request.getParameter("filename");

	if (filename.equals("ExportInventory")) {
	    filename = "ExportInventory_"+loginUser+".csv";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		FileOutputStream fos = null;
		try { 
			int x = 1;
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				stmt = conn.createStatement();
	
				StreamGobbler fileObj = new StreamGobbler(webPath);
				fos = fileObj.inventoryOS(loginUser);
	
				String SQLstmt = "";
	
				if (request.getSession().getAttribute("loginsite").equals(
						"ALL")) {
					SQLstmt = "select stc.Hostname, stc.Status, stc.PartNum, stc.FirmwareVersion, stc.SerialNum, stc.Property, modu.ProductFamily, modu.PartNum as moduPartNum, modu.FirmwareVersion as moduFirmwareVersion, modu.SerialNum as moduSerialNum, modu.ProductId, modu.PortCount, modu.HwRevCode, modu.Site, modu.Dept, modu.LastScan from stc_inventory_testmodule modu inner join stc_inventory_chassis stc on stc.Hostname=modu.Hostname order by modu.Site, modu.Hostname";
				} else {
					SQLstmt = "select stc.Hostname, stc.Status, stc.PartNum, stc.FirmwareVersion, stc.SerialNum, stc.Property, modu.ProductFamily, modu.PartNum as moduPartNum, modu.FirmwareVersion as moduFirmwareVersion, modu.SerialNum as moduSerialNum, modu.ProductId, modu.PortCount, modu.HwRevCode, modu.Site, modu.Dept, modu.LastScan from stc_inventory_testmodule modu inner join stc_inventory_chassis stc on stc.Hostname=modu.Hostname and modu.Site='"+request.getSession().getAttribute("loginsite")+"' order by modu.Site, modu.Hostname";
				}
				
	            fos.write(("Chassis and Module Inventory Information"+ "\n").getBytes());
				fos.write(("Row, Site, Dept, Chassis, Status, PartNumber, Firmware, SerialNumber, Property, ModuleProductFamily, ModulePartNumber, ModuleFirmware, ModuleSerialNum, ModuleProductID, ModulePortsCount, ModuleHwRevCode, LastScan"+ "\n").getBytes());
				rs = stmt.executeQuery(SQLstmt);
				
				while (rs.next()) {
					fos.write((Integer.toString(x + 1) + ", "
							+ rs.getString("Site") + ", "
							+ rs.getString("Dept") + ", "
							+ rs.getString("Hostname") + ", "
							+ rs.getString("Status") + ", "
							+ rs.getString("PartNum") + ", "
							+ rs.getString("FirmwareVersion") + ", "
							+ rs.getString("SerialNum") + ", "
							+ rs.getString("Property") + ", "
							+ rs.getString("ProductFamily") + ", "
							+ rs.getString("moduPartNum") + ", "
							+ rs.getString("moduFirmwareVersion") + ", "
							+ rs.getString("moduSerialNum") + ", "
							+ rs.getString("ProductId") + ", "
							+ rs.getString("PortCount") + ", "
							+ rs.getString("HwRevCode") + ", "
							+ rs.getString("LastScan") +  "\n").getBytes());
					x++;
				}
	
				if (request.getSession().getAttribute("loginsite").equals(
						"ALL")) {
					SQLstmt = "select dut.Site, dut.Dept, dut.DutName, dut.DutIpAddress, dut.Vendor, dut.DutPid, dut.DutChassisDescr, dut.SN, dut.BladeCount, dut.IosVersion, dut.Status, dut.Notes, intf.Pid, intf.IntfDescr, intf.IntfName, intf.Connection, intf.ModuleSN, intf.LastScan from dut_inventory dut inner join dut_inventory_intf intf on dut.DutIpAddress=intf.DutIpAddress order by intf.Site, intf.DutIpAddress, intf.IntfName";
				} else {
					SQLstmt = "select dut.Site, dut.Dept, dut.DutName, dut.DutIpAddress, dut.Vendor, dut.DutPid, dut.DutChassisDescr, dut.SN, dut.BladeCount, dut.IosVersion, dut.Status, dut.Notes, intf.Pid, intf.IntfDescr, intf.IntfName, intf.Connection, intf.ModuleSN, intf.LastScan from dut_inventory dut inner join dut_inventory_intf intf on dut.DutIpAddress=intf.DutIpAddress and dut.Site='"
							+ request.getSession()
									.getAttribute("loginsite")
							+ "' order by intf.Site, intf.DutIpAddress, intf.IntfName";
				}
				
	            fos.write(("\n\n\nDUT Inventory Information"+ "\n").getBytes());
				fos.write(("Row, Site, Dept, DUT Name, IP Address, Vendor, Chassis Model, Chassis Desc, Chassis SN, Blade Count, SW Version, Status, Notes, Blade Model, Interface Desc, Interface Name, Connection, Interface SN, Last Scan" + "\n").getBytes());
				rs = stmt.executeQuery(SQLstmt);
				while (rs.next()) {
					fos.write((Integer.toString(x + 1) + ", "
							+ rs.getString("Site") + ", "
							+ rs.getString("Dept") + ", "
							+ rs.getString("DutName") + ", "
							+ rs.getString("DutIpAddress") + ", "
							+ rs.getString("Vendor") + ", "
							+ rs.getString("DutPid") + ", "
							+ rs.getString("DutChassisDescr").replace(",", " ") + ", "
							+ rs.getString("SN") + ", "
							+ rs.getString("BladeCount") + ", "
							+ rs.getString("IosVersion") + ", "
							+ rs.getString("Status") + ", "
							+ rs.getString("Notes").replace(",", " ") + ", "
							+ rs.getString("Pid") + ", "
							+ rs.getString("IntfDescr").replace(",", " ") + ", "
							+ rs.getString("IntfName") + ", "
							+ rs.getString("Connection") + ", "
							+ rs.getString("ModuleSN") + ", "
							+ rs.getString("LastScan").replace(",", " ") + "\n").getBytes());
					x++;
				}
	
				if (request.getSession().getAttribute("loginsite").equals(
						"ALL")) {
					SQLstmt = "select Site, Dept, Name, VMHost, VMServerName, Manufacturer, Model, Processor, CPU, MemoryCapacity, HD, TotalNumberOfNIC, TotalVMNumber, Notes, LastScan from vm_host  order by Site, VMHost";
				} else {
					SQLstmt = "select Site, Dept, Name, VMHost, VMServerName, Manufacturer, Model, Processor, CPU, MemoryCapacity, HD, TotalNumberOfNIC, TotalVMNumber, Notes, LastScan from vm_host where Site='"+request.getSession().getAttribute("loginsite")+"' order by Site, VMHost";
				}
	
	            fos.write(("\n\n\nVM Server Inventory Information"+ "\n").getBytes());
				fos.write(("Row, Site, Dept, ServerName, ServerIP, VMServerName, Manufacturer, Model, Processor, CPU, MemoryCapacity, HD, TotalNumberOfNIC, TotalVMNumber, Notes, LastScan" + "\n").getBytes());
				rs = stmt.executeQuery(SQLstmt);
				while (rs.next()) {
					fos.write((Integer.toString(x + 1) + ", "
							+ rs.getString("Site") + ", "
							+ rs.getString("Dept") + ", "
							+ rs.getString("Name") + ", "
							+ rs.getString("VMHost") + ", "
							+ rs.getString("VMServerName") + ", "
							+ rs.getString("Manufacturer") + ", "
							+ rs.getString("Model") + ", "						
							+ rs.getString("Processor") + ", "
							+ rs.getString("CPU") + ", "
							+ rs.getString("MemoryCapacity") + ", "
							+ rs.getString("HD") + ", "
							+ rs.getString("TotalNumberOfNIC") + ", "
							+ rs.getString("TotalVMNumber") + ", "	
							+ rs.getString("Notes").replace(",", " ") + ", "	
							+ rs.getString("LastScan").replace(",", " ") + "\n").getBytes());
					x++;
				}
	
				if (request.getSession().getAttribute("loginsite").equals(
						"ALL")) {
					SQLstmt = "select site, dept, ipaddress, modelnumber, softwareversion, osversion, serialnumber, buildversion, hassslaccelerator from  avl_appliances order by site, ipaddress";
				} else {
					SQLstmt = "select site, dept, ipaddress, modelnumber, softwareversion, osversion, serialnumber, buildversion, hassslaccelerator from  avl_appliances where site='"+request.getSession().getAttribute("loginsite")+"' order by site, ipaddress";
				}
	
	            fos.write(("\n\n\nAvalanche Appliance Inventory Information"+ "\n").getBytes());
			    fos.write(("Row, Site, Dept, AV, ModelNumber, FirmwareVersion, OSVersion, SerialNumber, Buildversion, HasSSLAccelerator" + "\n").getBytes());
				rs = stmt.executeQuery(SQLstmt);
				while (rs.next()) {
					fos.write((Integer.toString(x + 1) + ", "
							+ rs.getString("site") + ", "
							+ rs.getString("dept") + ", "
							+ rs.getString("ipaddress") + ","
							+ rs.getString("modelnumber") + ", "
							+ rs.getString("softwareversion") + ", "
							+ rs.getString("osversion") + ","
							+ rs.getString("serialnumber") + ", "
							+ rs.getString("buildversion") + ", "
							+ rs.getString("hassslaccelerator")	+ "\n").getBytes());
					x++;
				}
	
				if (request.getSession().getAttribute("loginsite").equals(
						"ALL")) {
					SQLstmt = "select Site, Dept, DNSHostName, IPAddress, Manufacturer, Model, CPUName, OSName, ServicePack, NumberOfProcessors, Ram, HDSize, Status, Notes, LastScan from lab_pcs order by DNSHostName";
				} else {
					SQLstmt = "select Site, Dept, DNSHostName, IPAddress, Manufacturer, Model, CPUName, OSName, ServicePack, NumberOfProcessors, Ram, HDSize, Status, Notes, LastScan from lab_pcs where Site='"+request.getSession().getAttribute("loginsite")+"' order by DNSHostName";
				}
				
				fos.write(("\n\n\nLab PC Inventory Information"+ "\n").getBytes());
				fos.write(("Row, Site, Dept, DNSHostName, PCAddress, Manufacturer, Model, CPUName, OSName, ServicePack, NumberOfProcessors, Ram, HDSize, Status, Notes, LastScan" + "\n")
							.getBytes());
				rs = stmt.executeQuery(SQLstmt);
				while (rs.next()) {
					fos.write((Integer.toString(x + 1) + ", "
							+ rs.getString("Site") + ", "
							+ rs.getString("Dept") + ", "
							+ rs.getString("DNSHostName") + ", "
							+ rs.getString("IPAddress") + ", "
							+ rs.getString("Manufacturer") + ", "
							+ rs.getString("Model") + ", "
							+ rs.getString("CPUName") + ", "
							+ rs.getString("OSName") + ", "
							+ rs.getString("ServicePack") + ", "
							+ rs.getString("NumberOfProcessors") + ", "
							+ rs.getString("Ram") + ", "
							+ rs.getString("HDSize") + ", "
							+ rs.getString("Status") + ", "
							+ rs.getString("Notes").replace(",", " ") + ", "
							+ rs.getString("LastScan") + "\n").getBytes());
					x++;
				}
			}
		} catch (Exception e) {
			System.out.print("Exception occurs in download.jsp: "+e.getMessage());
		} finally {
        	try {
        	    if(fos != null) {
        	       fos.close();
        	    }
        		if(rs != null){
        			rs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(conn != null){
        			DataBaseConnection.freeConnection(conn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in download.jsp: "
						+ e.getMessage());
        	}
        } 
	} else {
	    filename = "ExportResults_"+loginUser+".csv";
	}

	SmartUpload su = new SmartUpload();
	su.initialize(pageContext);
	su.setContentDisposition(null);
	su.downloadFile("/common/scripts/" + filename);
	out.clear();
	out = pageContext.pushBody();
%>


