<%@ page language="java" import="java.util.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection" pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<!--------------------------------------------------------------->
<!-- Copyright (c) 2006 by Conor O'Mahony.                     -->
<!-- For enquiries, please email GubuSoft@GubuSoft.com.        -->
<!-- Please keep all copyright notices below.                  -->
<!-- Original author of TreeView script is Marcelino Martins.  -->
<!--------------------------------------------------------------->
<!-- This document includes the TreeView script.  The TreeView -->
<!-- script can be found at http://www.TreeView.net.  The      -->
<!-- script is Copyright (c) 2006 by Conor O'Mahony.           -->
<!--------------------------------------------------------------->

 <head>
 <title>Home</title>
 <base href="<%=basePath%>">
		<link rel="stylesheet" href="/iprep/common/css/style.css" type="text/css"
			media="screen" />
  <style>
   body {
     background-color: white;
     font-size: 10pt;
     font-family: verdana,helvetica}
  </style> 
 </head>

 <body bgcolor="white">

  <h4>Spirent TestCenter Inventory Information</h4>
  <p>The purpose of this inventory site is to document information regarding Spirent TestCenter hardware and 
  software information into one location. 
  The information listed within this site is being updated periodically. This site is maintained by Spirent PV department
  based in Honolulu. Questions, concerns, or requests regarding the information contain in this site should be directed to 
  <a href="mailto:saiyoot@spirentcom.com">Saiyoot Nakkhongkham</a> or <a href="mailto:jundong.xu@spirentcom.com">Jundong Xu.</a></p>
  <p>Hardware and software information from the following geographical sites can be queried from the database of this inventory:</p>
  <ul>
   <li>CAL</li>
   <li>CHN</li>
   <li>HNL</li>
   <li>SNV</li>
   <li>RTP</li>
  </ul>
  <p>Using this link 
  <a href="/iprep/tree/chassis.jsp?Site=ALL">Chassis</a> 
  to show all STC inventory. And using this link 
  <a href="/iprep/tree/dut.jsp?Site=ALL">DUT</a>
  to show all DUT inventory. You should bookmark both of them.</p>

  <h5>How the Inventory System Works</h5>
  <p> Follow this help page for a complete documentation of the inventory system: 
  <A href="/iprep/help.jsp">Help</A>.

  <h5>Administrative Information</h5>
  <p>In a case where there are a number of chassis, slots, ports, DUTs, or PCs to maintian, loading the treeview may take longer.
  To remedy the problem, the treeview may be customized into individual site or all sites via the 
  <a href="/iprep/admin.jsp">Administer</a> page.

  <h5>Tips to Use This Site</h5>
  <ul>
   <li>Avoid refresh once the treeview is displayed. Clicking browser refresh will cause the treeview be redrawn.</li>
   <li>Use Internet Explorer 7.0.</li>
  </ul>

  <h5>Future Works</h5>
  <p>The future work is to integrate PC and VM to this site. </p> 

 </body>

</html>
