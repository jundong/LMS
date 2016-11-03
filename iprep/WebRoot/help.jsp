<%@ page language="java"
	import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection"
	pageEncoding="UTF-8"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Help</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
		<style>
body {
	background-color: white;
	font-size: 10pt;
	font-family: verdana, helvetica
}
</style>
	</head>

	<body>
		<div class="content">
			<h5>
				Spirent PV Inventory/Reservation System
			</h5>
			<p>
				The purpose of this inventory site is to document information
				regarding Spirent TestCenter hardware and software information into
				one location.
			</p>
			<p>
				The inventory system consists of several components as illustrated
				by the following flow diagram. The functionality of these components
				covers the searching of hardware and software information, recording
				of information, and displaying of information via Spirent intranet
				web site.
			</p>
			<p>
				The following sections explain the role of each component.
			</p>
			<p>
				<img src="/iprep/common/imgs/componects.gif"
					alt="Inventory Components">
			</p>
			<p>
				<b>Note</b>: Resources related with STC and DUT are ready for using.
				However, works related to DUT with PC and VM is currently under
				construction.
			</p>

			<h5>
				Hardware Equipment
			</h5>
			<p>
				The inventory system collects real-time hardware and software
				information from Spirent’s equipment. The types of hardware
				supported by the inventory are STC, DUT, and PC.
			</p>


			<p>
				Each of these hardware types are assumed to have proper networking
				management or software interface installed to allow access from PV
				inventory program.
			</p>

			<p>
				For STC hardware equipment, the equipments are expected to have
				Sprient TestCenter software (both IL/BLL) installed. Each must be
				assigned with active working IP. Such hardware equipment will be
				connected by PV TCL program to read inventory information.
			</p>

			<p>
				The DUT, such as CISCO or Juniper routers, is also expected to have
				SNMP installed in the router. PV TCL program uses SNMP to
				communicate with this equipment. Note that SNMP is a network
				management protocol allowing network administrator to learn or
				control networking equipment remotely.
			</p>

			<p>
				For PC, work is still under construction.
			</p>

			<h5>
				TCL Interface
			</h5>

			<p>
				This is a TCL inventory program written by PV department in
				Honolulu. Given a list of IP addresses of the chassis to be
				inventory, the program connects to the chassis (STC or DUT) with the
				given IP address.
			</p>

			<p>
				For STC chassis, the TCL program utilizes STC BLL to collect
				information.
			</p>

			<p>
				For DUT hardware, the TCL program utilizes the SNMP. The source
				codes of both of the program are located at:
			</p>

			<p>
				/PV_Scripts/mainline/Phoenix_PV_Files/Curr_Access/Tools/SIT/.
			</p>

			<p>
				The program is currently and actively running from a Honolulu PV PC
				called a20050803 by Spirent PV department based in Honolulu. The
				information collected by the system is being updated dynamically,
				every 6 hours.
			</p>
			<p>
				Hardware and software information from the following geographical
				sites are being collected by the TCL interface:
			</p>
			<ul>
				<li>
					Calabasas (CAL)
				</li>
				<li>
					China (CHN)
				</li>
				<li>
					Honolulu (HNL)
				</li>
				<li>
					Sunnyvale (SNV)
				</li>
				<li>
					Raleigh (RTP)
				</li>
			</ul>


			<p>
				<b>TODO</b>: The entire list of IP address belonging to STC and DUT
				hardware should be collected for the inventory system. The current
				list is still impartial.
			</p>

			<h5>
				Inventory Database
			</h5>

			<p>
				This is a place holder for the information collected by the PV TCL
				program. Information regarding STC and DUT are collected and stored
				into this MySQL database. The database design comprised of many
				tables shown below, specifically designed for DUT and STC. The name
				of this database is called “pv_inventory” located on topaz server.
			</p>
			<img src="/iprep/common/imgs/database.gif"
				alt="Inventory Database">

			<h5>
				Web Interface
			</h5>
			<p>
				A few web programs written via ASP and JAVA scripts are used to
				access and display information from the inventory database. There
				are two types of information being displayed by the web interface:
				information about STC and information about DUT.
			</p>
			<p>
				Information about STC is retrieved via the tree view and the chassis
				searchable page. User can search or navigate for STC inventory
				information such as Spirent chassis, slot, and port through these
				pages.
			</p>

			<p>
				Tree view page:
				<A href="/iprep/index.jsp">Spirent Lab Management System</A>.
			</p>

			<p>
				Chassis and DUT searchable page:
				<b>Query Menu Button</b>
			</p>

			<p>
				For PC and VM, work is still under construction.
			</p>

			<h5>
				JavaScript Tree View
			</h5>
			<p>
				This is a JavaScript web program used to create the tree view for
				convenient navigation of STC information. The tree view works by
				reading Data Base which located in the PV web server (topaz). When
				loading the tree it will query DB and generated a formated XML file
				to draw the tree.
			</p>

			<img src="/iprep/common/imgs/treeview.gif"
				alt="Inventory Components">
			<p>
				All nodes within this tree view contain link to chassis, slot, port,
				dut or dut port pages. Clicking on the node can conveniently take
				user to different level of inventory page.
			</p>
			<p>
				Moreover, this tree view may be further customized. The reason to
				customize the tree view is in a case when there are large numbers of
				chassis, slots, ports, DUTs, or PCs to maintain. With a lot of nodes
				to create, loading the tree view may take a considerable amount of
				time. To remedy the problem, the tree view may be customized into
				individual site or all sites via the admin program.
			</p>

			<h5>
				Query Interface
			</h5>
			<p>
				The inventory system supports all level of searching for STC and
				DUT, including chassis, slot, port, vm, vmclient, dut and dut port.
				After select resource type and search condition item, you can input
				the condition to search your resource. A user can type in the string
				or part of string into the text field provided.
				<br>
				In this page user also can export the search result to a cvs file
				and export inventory tree view data.
			</p>
			<img src="/iprep/common/imgs/queryinterface.gif"
				alt="Query Interface">

			<h5>
				Login System
			</h5>
			<p>
				Using LDAP server to authenticate users when they login this system.
				If you're the first time to login this system, you'll jump to
				register page and provide your correct full name for authentication.
				In this page if you also provide the password, you can login this
				LRS as the same as in login page. If you're the authentication user,
				you can automatically login this site in next time.
				<br>
				<b>Note</b>: Here full name you can refer to outlook system.
			</p>

			<h5>
				Administration System
			</h5>
			<p>
				Users have three ranks:
			</p>
			<ul>
				<li>
					User
				</li>
				<li>
					Prime
				</li>
				<li>
					Admin
				</li>
			</ul>

			<img src="/iprep/common/imgs/administration.gif"
				alt="Administration">
			<p>
				<br>
			</p>

			<h5>
				Reservation System
			</h5>
			<p>
				"Admin" and "Prime" rank users can overwrite reservations in
				"Reserve" page and with a notification to the reservation owner,
				"User" rank users can add/update/delete themselves reservations in
				"Reserve" page with a notification, but don't have the privilege to
				overwrite others.
			</p>
			<h5>
				Comments
			</h5>
			<p>
				Questions, concerns, or requests regarding the information contain
				in this site should be directed to Saiyoot Nakkhongkham or Jundong
				Xu.
			</p>
		</div>
	</body>

</html>
