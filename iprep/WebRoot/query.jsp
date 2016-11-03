<%@ page language="java"
	import="java.util.*,java.io.*,java.sql.*,com.spirent.javaconnector.DataBaseConnection,com.spirent.formatstring.*,com.spirent.stream.StreamGobbler"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" 
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	String webPath = this.getServletConfig().getServletContext()
			.getRealPath("/")
			+ "common\\scripts\\";   
			
    String loginUser = (String)request.getSession().getAttribute("username");
%>

<%
				String calstate = "";
				String chnstate = "";
				String hnlstate = "";
				String rtpstate = "";
				String snvstate = "";
				String allstate = "";
				String disableState = "";
					
				String conditionItem = "";	
				String conditionValue = "";
				String divId = "chassis";
				
				String isQuery = request.getParameter("isQuery");
				
				String []style = {"","style=\"display: none\"",
				"style=\"display: none\"","style=\"display: none\"",
				"style=\"display: none\"","style=\"display: none\"",
				"style=\"display: none\"","style=\"display: none\"",
				"style=\"display: none\"","style=\"display: none\"",
				"style=\"display: none\""};
				   
			 	String []types = {"","","selected","","","","","","","",""};
			%>
			
			<%
				String redirect = request.getParameter("redirect");
				if(redirect != null) {
					String Site = request.getParameter("checkedSite");
		            String[] splitSite = Site.split(",");
		            for (int i=0; i<splitSite.length; i++) {
						if (splitSite[i].equals("CAL")) {
						    calstate = "checked";
						} else if (splitSite[i].equals("CHN")) {
						    chnstate = "checked";
						} else if (splitSite[i].equals("HNL")) {
						    hnlstate = "checked";
						} else if (splitSite[i].equals("RTP")) {
						    rtpstate = "checked";
						} else if (splitSite[i].equals("SNV")) {
						    snvstate = "checked";
						} else if (splitSite[i].equals("ALL")) {
						    allstate = "checked";
						}
				    }
				    
				    String type = request.getParameter("type");
				    if(!type.isEmpty() && !type.trim().equals("Chassis")) {
				    	style[0] = "style=\"display: none\"";
				    	types[2] = "";
				    	if(type.equals("DUT")) {
				    		style[1] = "";
				    		types[5] = "selected";
				    		divId = "dut";
				    	} else if (type.equals("STCModule")) {
				    		style[2] = "";
				    		types[3] = "selected";
				    		divId = "module";
				    	} else if (type.equals("DUTIntf")) {
				    		style[3] = "";
				    		types[6] = "selected";
				    		divId = "dutintf";
				    	} else if (type.equals("STCPortGroup")) {
				    		style[4] = "";
				    		types[4] = "selected";
				    		divId = "portgroup";
				    	} else if (type.equals("VMware")) {
				    		style[5] = "";
				    		types[8] = "selected";
				    		divId = "vmware";
				    	} else if (type.equals("VMwareClient")) {
				    		style[6] = "";
				    		types[9] = "selected";
				    		divId = "vmwareclient";
				    	} else if (type.equals("Appliance")) {
				    		style[7] = "";
				    		types[0] = "selected";
				    		divId = "appliance";
				    	} else if (type.equals("AVPortGroup")) {
				    		style[8] = "";
				    		types[1] = "selected";
				    		divId = "avportgroup";
				    	} else if (type.equals("PC")) {
				    		style[9] = "";
				    		types[7] = "selected";
				    		divId = "pc";
				    	} else if (type.equals("STCProperty")) {
				    		style[10] = "";
				    		types[10] = "selected";
				    		divId = "stcproperty";
				    	}
				    	
				    }
				    
				    
				    conditionItem = request.getParameter("conditionItem");
					conditionValue = request.getParameter("conditionValue");
				}
			 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Search Resource</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />
		<script language="javascript">
		function stopFunc() {
		 if (window.ActiveXObject)
		 {
			document.execCommand("stop");
		 } 
		 else
		 {
		 	window.stop();
		 }
			setCheck('<%=divId%>','<%=conditionItem%>',0);
		}
		function setCheck(divId, selectValue,flag)
		{
				var selects = document.getElementById(divId).getElementsByTagName("select"); 
				for(var i=0;i<selects[0].options.length;i++)
				{
					if(selects[0].options[i].value == selectValue) {
						selects[0].options[i].selected = true; 
						break;
					}
				}
				if(flag == 0) {
					var btnArr = document.getElementsByName('test')
					for(var i=0;i<btnArr.length;i++) {
						btnArr[i].disabled = false;
					}
				}
		}
		
		setTimeout("setCheck('<%=divId%>','<%=conditionItem%>',1)", 5);
		
		function submitForm(flag)
		{
			var sites = document.form1.elements;

			if(flag == 2) {
				var uri = 'queryresource.do?type=Chassis&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form2.action = uri;
				document.form2.submit();
			} else if (flag == 3) {
				var uri = 'queryresource.do?type=DUT&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form3.action = uri;
				document.form3.submit();
			} else if (flag == 4) {
				var uri = 'queryresource.do?type=STCModule&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form4.action = uri;
				document.form4.submit();
			} else if (flag == 5) {
				var uri = 'queryresource.do?type=DUTIntf&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form5.action = uri;
				document.form5.submit();
			} else if (flag == 6) {
				var uri = 'queryresource.do?type=STCPortGroup&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form6.action = uri;
				document.form6.submit();
			} else if (flag == 7) {
				var uri = 'queryresource.do?type=VMware&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form7.action = uri;
				document.form7.submit();
			} else if (flag == 8) {
				var uri = 'queryresource.do?type=VMwareClient&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form8.action = uri;
				document.form8.submit();
			} else if (flag == 9) {
				var uri = 'queryresource.do?type=Appliance&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form9.action = uri;
				document.form9.submit();
			} else if (flag == 10) {
				var uri = 'queryresource.do?type=AVPortGroup&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form10.action = uri;
				document.form10.submit();
			} else if (flag == 11) {
				var uri = 'queryresource.do?type=PC&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form11.action = uri;
				document.form11.submit();
			} else if (flag == 12) {
				var uri = 'queryresource.do?type=STCProperty&CAL=' + sites[0].checked + 
				'&CHN=' + sites[1].checked +
				'&HNL=' + sites[2].checked +
				'&RTP=' + sites[3].checked +
				'&SNV=' + sites[4].checked +
				'&ALL=' + sites[5].checked;
				document.form12.action = uri;
				document.form12.submit();
			}
			return true;
		}
		
	function isQueryExport()
	{
		window.open("/iprep/download.jsp?filename=ExportResults", "_self");
	}
	
	function isInventoryExport()
	{
		window.open("/iprep/download.jsp?filename=ExportInventory", "_self");
	}
	
			 function display(type){
			    switch(type){
			       case "stc":
			         document.getElementById("chassis").style.display="";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;
			       case "stcmodule":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
				     document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";	
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";	         
			         break;
			       case "stcport":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
				     document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";	
			         document.getElementById("pc").style.display="none";	
			         document.getElementById("stcproperty").style.display="none";         
			         break;
			       case "dut":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;		
			       case "dutmodule":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;
			       case "vm":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;
			       case "vmclient":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;	
			         case "av":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;	
			         case "avport":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="none";
			         break;		
			         case "pc":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="";
			         document.getElementById("stcproperty").style.display="none";
			         break;	
			         case "stcproperty":
			         document.getElementById("chassis").style.display="none";
			         document.getElementById("dut").style.display="none";
			         document.getElementById("module").style.display="none";
			         document.getElementById("dutintf").style.display="none";
			         document.getElementById("portgroup").style.display="none";
			         document.getElementById("vmware").style.display="none";
			         document.getElementById("vmwareclient").style.display="none";
			         document.getElementById("appliance").style.display="none";
			         document.getElementById("avportgroup").style.display="none";
			         document.getElementById("pc").style.display="none";
			         document.getElementById("stcproperty").style.display="";
			         break;				         
			       default:
			         break;         
			    }
			 }
			 
			 function refreshBtn() {
			 	var btnArr = document.getElementsByName('test')
				for(var i=0;i<btnArr.length;i++) {
					btnArr[i].disabled = false;
				}
			 }
			 
</script>

	</head>
	
			 <%if(!divId.isEmpty() && !conditionItem.isEmpty()) {%>
	<body onload="return setCheck('<%=divId%>','<%=conditionItem%>',0);">
	<%} else { %>
	<body onload="return refreshBtn();">
<%} %>	
		<div class="content">
			<a HREF="/iprep/help.jsp">Document</a>&nbsp;&nbsp;
			<hr>
			<b>Search Resource</b>
			<hr>
			<table BORDER="0" CELLPADDING="0" CELLSPACING="0" width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						<div>
							<form method="post" name="form1" action="query.jsp">
								<div style="float:left">
								<input type="checkbox" <%=disableState %> name="CAL"
									value=CAL <%=calstate%> />
								Calabasas
								</div>
								<div style="float:left">
								<input type="checkbox" <%=disableState %> name="CHN"
									value=CHN <%=chnstate%> />
								Beijing
								</div>
								<div style="float:left">
								<input type="checkbox" <%=disableState %> name="HNL"
									value=HNL <%=hnlstate%> />
								Honolulu
								</div>
								<div style="float:left">
								<input type="checkbox" <%=disableState %> name="RTP"
									value=RTP <%=rtpstate%> />
								Raleigh
								</div>
								<div style="float:left">
								<input type="checkbox" <%=disableState %> name="SNV"
									value=SNV <%=snvstate%> />
								Sunnyvale
								</div>
								<div style="float:left">
								<input type="checkbox" name="ALL"
									value=ALL <%=allstate%> />
								All
								</div>
							</form>
						</div>
					</td>
					<td>
					</td>
				</tr>
				<tr bgcolor="#FFFFFF" height="10px">
					<td>
					</td>
					<td>
					</td>
				</tr>				
				<tr bgcolor="#C2D5FC">
					<td>
						<div name="type" id="type">
							Resource Type&nbsp;&nbsp;&nbsp;:
							<select name="resourcetype"
								onchange="display(this.options[this.options.selectedIndex].value);">
								<option value="av" <%=types[0]%> >
									Avalanche
								</option>
								<option value="avport" <%=types[1]%>>
									Av Ports
								</option>
								<option value="stc" <%=types[2]%>>
									Chassis
								</option>
								<option value="stcmodule" <%=types[3]%>>
									STC Module
								</option>
								<option value="stcport" <%=types[4]%>>
									STC Port Groups
								</option>
								<option value="dut" <%=types[5]%>>
									DUT
								</option>
								<option value="dutmodule" <%=types[6]%>>
									DUT Blade
								</option>
								<option value="pc" <%=types[7]%>>
								    PC
								</option>
								<option value="vm" <%=types[8]%>>
									VM
								</option>
								<option value="vmclient" <%=types[9]%>>
									VM Client
								</option>
								<option value="stcproperty" <%=types[10]%>>
									STC Property
								</option>
							</select>
						</div>
					</td>
					<td>
					</td>
				</tr>
				<tr bgcolor="#C2D5FC">
					<td>
						<div <%=style[0]%> name="chassis" id="chassis">
							<form method="post" align="left" name="form2"
								action="queryresource.do?type=Chassis">
								Search Condition:
								<select name="conditionItem">
									<option value="Hostname" selected>
										Chassis
									</option>
									<option value="Status">
										Status
									</option>
									<option value="PartNum">
										Part Number
									</option>
									<option value="ControllerHwVersion">
										Controller
									</option>
									<option value="FirmwareVersion">
										Firmware
									</option>
									<option value="SerialNum">
										Serial Number
									</option>
									<option value="SlotCount">
										Slot Count
									</option>
									<option value="Property">
										Property
									</option>
									<option value="SO">
										Sale Order
									</option>
									<option value="DiskUsed">
										Disk Used
									</option>
									<option value="DiskFree">
										Disk Free
									</option>
									<option value="TotalDiskSize">
										Total Disk
									</option>
									<option value="BackPlaneHwVersion">
										Back Plane
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>" 
									style="width: 120px" />
								<input type="button" value="Search Chassis" disabled name="test" onclick="return submitForm(2);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[1]%> name="dut" id="dut">
							<form method="post" align="left" name="form3"
								action="queryresource.do?type=DUT">
								Search Condition:
								<select name="conditionItem">
									<option value="DutIpAddress" selected>
										IP Address
									</option>
									<option value="DutName">
										DUT Name
									</option>
									<option value="Vendor">
										Vendor
									</option>
									<option value="IosVersion">
										SW Version
									</option>
									<option value="IosImage">
										SW Image
									</option>
									<option value="SN">
										Chassis SN
									</option>
									<option value="DutPid">
										Chassis Model
									</option>
									<option value="DutChassisDescr">
										Chassis Desc
									</option>	
									<option value="EnginePN">
										Engine Model
									</option>
									<option value="EngineDescr">
										Engine Desc
									</option>
									<option value="EngineSN">
										Engine SN
									</option>																																												
									<option value="BladeCount">
										Blade Count
									</option>
									<option value="Status">
										Status
									</option>	
									<option value="Notes">
										Notes
									</option>																	
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search DUT" disabled name="test" onclick="return submitForm(3);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[2]%> name="module" id="module">
							<form method="post" align="left" name="form4"
								action="queryresource.do?type=STCModule">
								Search Condition:
								<select name="conditionItem">
									<option value="Hostname" selected>
										Chassis
									</option>
									<option value="SlotIndex">
										Slot
									</option>
									<option value="ProductFamily">
										Product Family
									</option>
									<option value="PartNum">
										Part Number
									</option>
									<option value="Description">
										Description
									</option>
									<option value="FirmwareVersion">
										Firmware
									</option>
									<option value="SerialNum">
										Serial Number
									</option>
									<option value="ProductId">
										Product Id
									</option>
									<option value="PortCount">
										Ports
									</option>
									<option value="PortGroupCount">
										Port Groups
									</option>
									<option value="Property">
										Property
									</option>
									<option value="SO">
										Sale Order
									</option>
									<option value="HwRevCode">
										HwRevCode
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search Test Modules" disabled name="test" onclick="return submitForm(4);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[3]%> name="dutintf" id="dutintf">
							<form method="post" align="left" name="form5"
								action="queryresource.do?type=DUTIntf"  >
								Search Condition:
								<select name="conditionItem" onchange="this.options[this.options.selectedIndex].selected=true">
									<option value="DutIpAddress" selected>
										IP Address
									</option>
									<option value="DutName">
										DUT Name
									</option>
									<option value="IntfName">
										Interface Name
									</option>
									<option value="ModuleSN">
										Interface SN
									</option>									
									<option value="IntfDescr">
										Blade Description
									</option>
									<option value="Pid">
										Blade Model
									</option>
									<option value="Connection">
										Connection
									</option>									
									<option value="Notes">
										Notes
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search DUT Intf" disabled name="test" onclick="return submitForm(5);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[4]%> name="portgroup" id="portgroup">
							<form method="post" align="left" name="form6"
								action="queryresource.do?type=STCPortGroup">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="Hostname">
										Chassis
									</option>
									<option value="SlotIndex">
										Slot
									</option>
									<option value="PortGroupIndex">
										Port Groups
									</option>
									<option value="PortIndex">
										Port Index
									</option>								
									<option value="Connection">
										Connection
									</option> 
									<option value="PersonalityCardType">
										Personality
									</option>
									<option value="TransceiverType">
										Transceiver
									</option>																		
									<option value="Name">
										Name
									</option>
									<option value="Status">
										Status
									</option>
									<option value="FirmwareVersion">
										Firmware
									</option>
									<option value="OwnershipState">
										Ownership State
									</option>
									<option value="OwnerHostName">
										Owner Host name
									</option>
									<option value="OwnerUserId">
										Owner User ID
									</option>
									<option value="OwnerTimestamp">
										Owner Timestamp
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search Port Groups" disabled name="test" onclick="return submitForm(6);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[5]%> name="vmware" id="vmware">
							<form method="post" align="left" name="form7"
								action="queryresource.do?type=VMware">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="VMHost">
										Server
									</option>
									<option value="VMServerName">
										Server Name
									</option>
									<option value="TotalVMNumber">
										VM Numbers
									</option>
									<option value="Manufacturer">
										Manufacturer
									</option>
									<option value="CPU">
										CPU
									</option>
									<option value="Processor">
										Processor
									</option>
									<option value="MemoryCapacity">
										Memory Capacity
									<option value="TotalNumberOfNIC">
										NIC Numbers
									</option>
									<option value="PowerState">
										Status
									</option>	
									<option value="Notes">
										Notes
									</option>																			
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search VMware" disabled name="test" onclick="return submitForm(7);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[6]%> name="vmwareclient" id="vmwareclient">
							<form method="post" align="left" name="form8"
								action="queryresource.do?type=VMwareClient">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="VMClient">
										Client IP
									</option>
									<option value="RunState">
										Status
									</option>
									<option value="ClientName">
										Client Name
									</option>
									<option value="GuestOS">
										Guest OS
									</option>
									<option value="NumberOfCPU">
										CPU Numbers
									</option>								
									<option value="Memory">
										Memory
									</option>
									<option value="VMHost">
										Server
									</option>	
									<option value="VMHostName">
										Server Name
									</option>	
									<option value="UserName">
										UserName
									</option>																	
									<option value="Notes">
										Notes
									</option>																																																				
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search VMware Client" disabled name="test" onclick="return submitForm(8);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>
						
						<div <%=style[7]%> name="appliance" id="appliance">
							<form method="post" align="left" name="form9"
								action="queryresource.do?type=Appliance">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="ipaddress">
										Avalanche
									</option>
									<option value="hostname">
										Name
									</option>
									<option value="modelnumber">
										Model Number
									</option>
									<option value="softwareversion">
										Software Version
									</option>
									<option value="osversion">
										OS Version
									</option>
									<option value="serialnumber">
										Serial Number
									</option>
									<option value="macaddress">
										MAC Address
									</option>
									<option value="defaultgateway">
										Default Gateway
									</option>
									<option value="subnetmask">
										Subnet Mask
									</option>
									<option value="usedhcp">
										Used DHCP
									</option>
									<option value="memorysize">
										Memory Size
									</option>
									<option value="numberofunits">
										Units Number
									</option>
									<option value="buildversion">
										Build Version
									</option>
									<option value="memoryperunit">
										Memory Per Unit
									</option>
									<option value="interfacelist">
										Interface List
									</option>
									<option value="hassslaccelerator">
										Has SSL Accelerator
									</option>
									<option value="dispatcherversion">
										Dispatcher Version
									</option>
									<option value="returncode">
										Return Code
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search Avalanche" disabled name="test" onclick="return submitForm(9);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>
						
						<div <%=style[8]%> name="avportgroup" id="avportgroup">
							<form method="post" align="left" name="form10"
								action="queryresource.do?type=AVPortGroup">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="ipaddress">
										Avalanche
									</option>
									<option value="model">
										Model
									</option>
									<option value="portindex">
										Port
									</option>
									<option value="portgroupindex">
										Port Group
									</option>
									<option value="portgroupdescr">
										Port Group Description
									</option>
									<option value="portgrouptype">
										Port Group Type
									</option>
									<option value="user">
										User
									</option>
									<option value="activesoftware">
										Active Software
									</option>
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search Av Port" disabled name="test" onclick="return submitForm(10);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>

						<div <%=style[9]%> name="pc" id="pc">
							<form method="post" align="left" name="form11"
								action="queryresource.do?type=PC">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="IPAddress">
										Address
									</option>
									<option value="DNSHostName">
										DNS Host Name
									</option>
									<option value="Manufacturer">
										Manufacturer
									</option>
									<option value="Model">
										Model
									</option>
									<option value="CPUName">
										CPU
									</option>
									<option value="NumberOfProcessors">
										Processors Number
									</option>
									<option value="OSName">
										OS
									</option>	
									<option value="ServicePack">
										Service Pack
									</option>																																				
									<option value="UserName">
										User Name
									</option>									
									<option value="HDSize">
										HD Size
									</option>
									<option value="Ram">
										Ram
									</option>								
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search PC" disabled name="test" onclick="return submitForm(11);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>	
						
						<div <%=style[10]%> name="stcproperty" id="stcproperty">
							<form method="post" align="left" name="form12"
								action="queryresource.do?type=STCProperty">
								Search Condition:
								<select name="conditionItem" selected>
									<option value="SN">
										SN
									</option>
									<option value="Property">
										Property
									</option>
									<option value="SO">
										Sales Order
									</option>
									<option value="SOStart">
										SO Start
									</option>
									<option value="SOEnd">
										SO End
									</option>																
								</select>
								<input type="text" name="conditionValue" maxlength="50" value="<%=conditionValue%>"
									style="width: 120px" />
								<input type="button" value="Search Property" disabled name="test" onclick="return submitForm(12);"/>
								<input type="button" value="Stop Search" onclick="return stopFunc();" />
							</form>
						</div>																			
					</td>
					<td>
						<div>
							<form>
								<input type="button" border="0" value="Export Search Results"
									onclick="isQueryExport();" style="width: 150px" />
								<input type="button" border="0" value="Export Inventory"
									onclick="isInventoryExport();" style="width: 150px" />
							</form>
						</div>
					</td>
				</tr>
			</table>
			<hr>
			<%
				String type = request.getParameter("type");
				
				Connection conn = null;
		        Statement stmt = null;
		        ResultSet rs = null;
		        
				try {
					conn = DataBaseConnection.getConnection();    
                    if(conn != null){  
						stmt = conn.createStatement();
						String SQLstmt = "";
	                    //String Site = (String) request.getSession().getAttribute("loginsite");			
						if (type == null) {
							type = "";
						} 
	                    if (request.getSession().getAttribute("SQLstmt") != null) {
							SQLstmt = (String) request.getSession().getAttribute("SQLstmt");
	                        rs = stmt.executeQuery(SQLstmt);
						}	
			%>
			<%
				if (type.equals("Chassis")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Chassis, Status, Part Number, Controller, Firmware, Serial Number, Property, SO#, SO Start, SO End, Slot Count, Disk Used, Disk Free, Total Disk Size, Back Plane, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Chassis&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Part&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Controller&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;&nbsp;
					</td>
					<td>
						Serial&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Property&nbsp;&nbsp;
					</td>
					<td>
						SO#&nbsp;&nbsp;
					</td>
					<td>
						SO&nbsp;Start&nbsp;&nbsp;
					</td>
					<td>
						SO&nbsp;End&nbsp;&nbsp;
					</td>						
					<td>
						Slot&nbsp;Count&nbsp;&nbsp;
					</td>
					<td>
						Disk&nbsp;Used&nbsp;&nbsp;
					</td>
					<td>
						Disk&nbsp;Free&nbsp;&nbsp;
					</td>
					<td>
						Total&nbsp;Disk&nbsp;Size&nbsp;&nbsp;
					</td>
					<td>
						Back&nbsp;Plane&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>

				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
							System.out.println(rs.getString("Notes"));
							System.out.println(rs.getString("Hostname"));
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("Hostname")
										+ ", "
										+ (new FormatString()).formatPortInfor(rs
												.getString("Status")) + ", "
										+ rs.getString("PartNum") + ", "
										+ rs.getString("ControllerHwVersion") + ", "
										+ rs.getString("FirmwareVersion") + ", "
										+ rs.getString("SerialNum") + ", "
										+ rs.getString("Property") + ", "
										+ rs.getString("SO") + ", "
										+ rs.getString("SOStart") + ", "
										+ rs.getString("SOEnd") + ", "
										+ rs.getString("SlotCount") + ", "
										+ rs.getString("DiskUsed") + ", "
										+ rs.getString("DiskFree") + ", "
										+ rs.getString("TotalDiskSize") + ", "
										+ rs.getString("BackPlaneHwVersion") + ", "
										+ rs.getString("Notes").replace(",", " ") + ", "
										+ (new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue()) + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td><%=x + 1%>
					</td>
					<td>
						<a
							HREF="/iprep/tree/chassis.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/update.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/slot.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Hostname")%>&nbsp;&nbsp;</a>
					</td>
					<td><%=(new FormatString()).formatPortInfor(rs
										.getString("Status"))%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("PartNum")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("ControllerHwVersion")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("FirmwareVersion")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("SerialNum")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/chassisproperty.jsp?Ip=<%=rs.getString("Hostname")%>&Property=<%=rs.getString("Property")%>&SOEnd=<%=rs.getString("SOEnd")%>&SO=<%=rs.getString("SO")%>&SOStart=<%=rs.getString("SOStart")%>&LoanerNotificationDate=<%=rs.getString("LoanerNotificationDate")%>&SN=<%=rs.getString("SerialNum")%>&ResourceType=<%=rs.getString("ControllerHwVersion")%>"><%=rs.getString("Property")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("SO")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("SOStart")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("SOEnd")%>&nbsp;&nbsp;
					</td>						
					<td><%=rs.getString("SlotCount")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("DiskUsed")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("DiskFree")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("TotalDiskSize")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("BackPlaneHwVersion")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?ChIP=<%=rs.getString("Hostname")%>&ChNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>						
					<td><%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>

				<%
					                x = x + 1;
							}
							if(fos != null)
								fos.close();
				%>
			</table>
			<%
				} else if (type.equals("STCModule")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Chassis, Slot, Status, ProductFamily, PartNum, Description, Firmware, SerialNum, Property, SO#, SO Start, SO End, ProductId, Ports, PortGroups, HwRevCode, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Chassis&nbsp;&nbsp;
					</td>
					<td>
						Slot&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Product&nbsp;Family&nbsp;&nbsp;
					</td>
					<td>
						PartNum&nbsp;&nbsp;
					</td>
					<td>
						Description&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;&nbsp;
					</td>
					<td>
						SerialNum&nbsp;&nbsp;
					</td>
					<td>
						Property&nbsp;&nbsp;
					</td>
					<td>
						SO#&nbsp;&nbsp;
					</td>
					<td>
						SO&nbsp;Start&nbsp;&nbsp;
					</td>
					<td>
						SO&nbsp;End&nbsp;&nbsp;
					</td>						
					<td>
						ProductId&nbsp;&nbsp;
					</td>
					<td>
						Ports&nbsp;&nbsp;
					</td>
					<td>
						PortGroups&nbsp;&nbsp;
					</td>
					<td>
						HwRevCode&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("Hostname")
										+ ", "
										+ rs.getString("SlotIndex")
										+ ", "
										+ (new FormatString()).formatPortInfor(rs
												.getString("Status")) + ", "
										+ rs.getString("ProductFamily") + ", "
										+ rs.getString("PartNum") + ", "
										+ rs.getString("Description") + ", "
										+ rs.getString("FirmwareVersion") + ", "
										+ rs.getString("SerialNum") + ", "
										+ rs.getString("Property") + ", "
										+ rs.getString("SO") + ", "
										+ rs.getString("SOStart") + ", "
										+ rs.getString("SOEnd") + ", "										
										+ rs.getString("ProductId") + ", "
										+ rs.getString("PortCount") + ", "
										+ rs.getString("PortGroupCount") + ", "
										+ rs.getString("HwRevCode") + ", "
										+ rs.getString("Notes").replace(",", " ") + ", "
										+ (new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue()) + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
				<td>
				<%=x + 1%>&nbsp;&nbsp;
				</td>
				<td>
				<a HREF="/iprep/tree/chassis.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<a HREF="/iprep/update.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<%=rs.getString("Hostname")%>&nbsp;&nbsp;
				</td>
				<td>
					<a HREF="/iprep/tree/port.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>"><%=rs.getString("SlotIndex")%>&nbsp;&nbsp;</a>
				</td>
				<td>
				<%=(new FormatString()).formatPortInfor(rs.getString("Status"))%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("ProductFamily")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PartNum")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("Description")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("FirmwareVersion")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("SerialNum")%>&nbsp;&nbsp;
				</td>
				<td>
					<a HREF="/iprep/update/chassisproperty.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>&Property=<%=rs.getString("Property")%>&SOEnd=<%=rs.getString("SOEnd")%>&SO=<%=rs.getString("SO")%>&SOStart=<%=rs.getString("SOStart")%>&LoanerNotificationDate=<%=rs.getString("LoanerNotificationDate")%>&SN=<%=rs.getString("SerialNum")%>&ResourceType=<%=rs.getString("ProductFamily")%>"><%=rs.getString("Property")%>&nbsp;&nbsp;</a>
				</td>
				<td>
					<%=rs.getString("SO")%>&nbsp;&nbsp;
				</td>
				<td>
					<%=rs.getString("SOStart")%>&nbsp;&nbsp;
				</td>
				<td>
					<%=rs.getString("SOEnd")%>&nbsp;&nbsp;
				</td>					
				<td>
				<%=rs.getString("ProductId")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PortCount")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("PortGroupCount")%>&nbsp;&nbsp;
				</td>
				<td>
				<%=rs.getString("HwRevCode")%>&nbsp;&nbsp;
				</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?ChSlotIP=<%=rs.getString("Hostname")%>&SlotIndex=<%=rs.getString("SlotIndex")%>&ChSlotNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>					
				<td>
				<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
				</td>
				</tr>
				<%
				                 	x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("STCPortGroup")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Chassis, Slot, PortGroup, PortIdx, Connection, Name, Status, Firmware, OwnershipState, OwnerHostname, OwnerUserId, OwnerTimestamp, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER=0 CELLPADDING="0" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Chassis&nbsp;&nbsp;
					</td>
					<td>
						Slot&nbsp;&nbsp;
					</td>
					<td>
						PortGroup&nbsp;&nbsp;
					</td>
					<td>
						PortIdx&nbsp;&nbsp;
					</td>
					<td>
						ResEnd&nbsp;&nbsp;
					</td>	
					<td>
						ResBy&nbsp;&nbsp;
					</td>										
					<td>
						Connection&nbsp;&nbsp;
					</td>
					<td>
						Personality&nbsp;&nbsp;
					</td>
					<td>
						Transceiver&nbsp;&nbsp;
					</td>
					<td>
						Name&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;&nbsp;
					</td>
					<td>
						OwnershipState&nbsp;&nbsp;
					</td>
					<td>
						OwnerHostname&nbsp;&nbsp;
					</td>
					<td>
						OwnerUserId&nbsp;&nbsp;
					</td>
					<td>
						OwnerTimestamp&nbsp;&nbsp;
					</td>
										<td>
						Notes&nbsp;&nbsp;
					</td>
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>

				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("Hostname")
										+ ", "
										+ rs.getString("SlotIndex")
										+ ", "
										+ rs.getString("PortGroupIndex")
										+ ", "
										+ rs.getString("PortIndex")
										+ ","
										+ rs.getString("Connection")
										+ ", "
										+ rs.getString("Name")
										+ ", "
										+ (new FormatString()).formatPortInfor(rs
												.getString("Status")) + ", "
										+ rs.getString("FirmwareVersion") + ", "
										+ rs.getString("OwnershipState") + ", "
										+ rs.getString("OwnerHostname") + ", "
										+ rs.getString("OwnerUserId") + ", "
										+ rs.getString("OwnerTimestamp") + ","
										+ rs.getString("Notes").replace(",", " ") + ","
										+ (new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue()) + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/port.jsp?Ip=<%=rs.getString("Hostname")%>"><%=rs.getString("Hostname")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/port.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>"><%=rs.getString("SlotIndex")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("PortGroupIndex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("PortIndex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).chassisResEnd(rs.getString("Hostname"), rs.getString("SlotIndex"), rs.getString("PortIndex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=(new FormatString()).chassisResBy(rs.getString("Hostname"), rs.getString("SlotIndex"), rs.getString("PortIndex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>									
					<td>
						<A
							HREF="/iprep/update/connection.jsp?Ip=<%=rs.getString("Hostname")%>&Slot=<%=rs.getString("SlotIndex")%>&PortIndex=<%=rs.getString("PortIndex")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>"><%=rs.getString("Connection")%>&nbsp;&nbsp;</A>
					</td>
					<td>
						<%=rs.getString("PersonalityCardType")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).formatTransceiver(rs
									.getString("TransceiverType"))%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=(new FormatString()).formatPortInfor(rs
									.getString("Name"))%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).formatPortInfor(rs
									.getString("Status"))%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("FirmwareVersion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%String owerShipState = (new FormatString()).formatPortInfor(rs
									.getString("OwnershipState"));
						  if(owerShipState.trim().equals("AVAILABLE")){
									%>
									<B><font color="#00FF00"><%=owerShipState %></font></B>
									<%} else{ %>
									<%=owerShipState %>
									<%} %>
					</td>
					<td>
						<%=rs.getString("OwnerHostname")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("OwnerUserId")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("OwnerTimestamp")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?ChPortIP=<%=rs.getString("Hostname")%>&ChSlotPortIndex=<%=rs.getString("SlotIndex")%>&ChPortIndex=<%=rs.getString("PortIndex")%>&ChPortNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
				                    	x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("DUT")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, DUT Name, IP Address, Vendor, Chassis Model, Chassis Desc, Chassis SN, Engine Model, Engine Desc,Engine SN,Blade Count, SW Version, SW Image,Status, Notes, Last Scan, User, Password, En./Conf.PW"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						DUT&nbsp;Name&nbsp;&nbsp;
					</td>					
					<td>
						IP&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Vendor&nbsp;&nbsp;
					</td>
					<td>
						Chassis&nbsp;Model&nbsp;&nbsp;
					</td>	
					<td>
						Chassis&nbsp;Desc&nbsp;&nbsp;
					</td>	
					<td>
						Chassis&nbsp;SN&nbsp;&nbsp;
					</td>
					<td>
						Engine&nbsp;Model&nbsp;&nbsp;
					</td>
					<td>
						Engine&nbsp;Desc&nbsp;&nbsp;
					</td>	
					<td>
						Engine&nbsp;SN&nbsp;&nbsp;
					</td>																																
					<td>
						Blade&nbsp;Count&nbsp;&nbsp;
					</td>				
					<td>
						SW&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						SW&nbsp;Image&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>
					<td>
						Serial Port Access&nbsp;&nbsp;
					</td>					
					<td>
						Notes&nbsp;&nbsp;
					</td>	
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>	
					<td>
						User&nbsp;&nbsp;
					</td>	
					<td>
						Password&nbsp;&nbsp;
					</td>	
					<td>
						En./Conf.PW&nbsp;&nbsp;
					</td>					
				</tr>
				<%
					int x = 0;
							String color = "";
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
										+ rs.getString("EnginePN") + ", "
										+ rs.getString("EngineDescr").replace(",", " ") + ", "
										+ rs.getString("EngineSN") + ", "
										+ rs.getString("BladeCount") + ", "
										+ rs.getString("IosVersion") + ", "
										+ rs.getString("IosImage") + ", "
										+ rs.getString("Status") + ", "
										+ rs.getString("Notes").replace(",", " ") + ", "										
										+ rs.getString("LastScan").replace(",", " ") + ","
										+ rs.getString("LoginName") + ", "
										+ rs.getString("LoginPassword") + ", "
										+ rs.getString("LoginEnabledPassword") + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/tree/dut.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/update.jsp?DUTIp=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("DutName")%>&nbsp;&nbsp;
					</td>					
					<td>
						<a
							HREF="/iprep/tree/dutIntf.jsp?Ip=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("DutIpAddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/dut.jsp?Vendor=<%=rs.getString("Vendor")%>"><%=rs.getString("Vendor")%>&nbsp;&nbsp;</a>
					</td>
					<td><%=rs.getString("DutPid")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("DutChassisDescr")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("SN")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EnginePN")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EngineDescr")%>&nbsp;&nbsp;
					</td>	
					<td><%=rs.getString("EngineSN")%>&nbsp;&nbsp;
					</td>	
					<td>
                           <%=rs.getString("BladeCount")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("IosVersion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("IosImage")%>&nbsp;&nbsp;
					</td>																																						
					<td>
						<%=rs.getString("Status")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?DutSerialIp=<%=rs.getString("DutIpAddress")%>"><%=rs.getString("SerialPortAccess")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<a HREF="/iprep/update/notes.jsp?DutIp=<%=rs.getString("DutIpAddress")%>&DutNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("LoginName")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("LoginPassword")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("LoginEnabledPassword")%>&nbsp;&nbsp;
					</td>					
				</tr>
				<%
					               x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("DUTIntf")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept,  DUT Name, IP Address,Blade Model, Interface Description, Interface Name, Connection, Interface SN, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						DUT&nbsp;Name&nbsp;&nbsp;
					</td>						
					<td>
						IP&nbsp;Address&nbsp;&nbsp; 
					</td>
					<td>
						Blade&nbsp;Model&nbsp;&nbsp;
					</td>						
					<td>
						Interface&nbsp;Description&nbsp;&nbsp;
					</td>								
					<td>
						Interface&nbsp;Name&nbsp;&nbsp;
					</td>
					<td>
						Connection&nbsp;&nbsp;
					</td>	
					<td>
						Interface&nbsp;SN&nbsp;&nbsp;
					</td>									
					<td>
						ResEnd&nbsp;&nbsp;
					</td>
					<td>
						ResBy&nbsp;&nbsp;
					</td>					
					<td>
						Notes&nbsp;&nbsp;
					</td>
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>	
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos
										.write((Integer.toString(x + 1) + ", "
												+ rs.getString("Site") + ", "
												+ rs.getString("Dept") + ", "
												+ rs.getString("DutName") + ", "												
												+ rs.getString("DutIpAddress") + ", "
												+ rs.getString("Pid") + ", "	
												+ rs.getString("IntfDescr").replace(",", " ") + ", "																								
												+ rs.getString("IntfName") + ", "
												+ rs.getString("Connection") + ", "
												+ rs.getString("ModuleSN") + ", "													
												+ rs.getString("Notes").replace(",", " ") + ", "											
												+ rs.getString("LastScan").replace(",", " ") + "\n")
												.getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update.jsp?DUTIp=<%=rs.getString("DutIpAddress")%>" ><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("DutName")%>&nbsp;&nbsp;
					</td>					
					<td>
						<a HREF="/iprep/tree/dutIntf.jsp?Ip=<%=rs.getString("DutIpAddress")%>" ><%=rs.getString("DutIpAddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("Pid")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("IntfDescr")%>&nbsp;&nbsp;
					</td>										
					<td>
						<%=rs.getString("IntfName")%>&nbsp;&nbsp;
					</td>	
					<td>
						<a HREF="/iprep/update/dutconnection.jsp?DutIpAddress=<%=rs.getString("DutIpAddress")%>&ModuleIndex=<%=rs.getString("ModuleIndex")%>&IntfName=<%=rs.getString("IntfName")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>" ><%=rs.getString("Connection")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("ModuleSN")%>&nbsp;&nbsp;
					</td>															
					<td>
						<%=(new FormatString()).dutResEnd(rs.getString("DutIpAddress"), rs.getString("IntfName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).dutResBy(rs.getString("DutIpAddress"), rs.getString("IntfName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>								
					<td>
						<a HREF="/iprep/update/notes.jsp?DUTIntfName=<%=rs.getString("IntfName")%>&DUTIntfIp=<%=rs.getString("DutIpAddress")%>&DUTIntfNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>	
				</tr>
				<%
					              x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("VMware")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Server, IP, VM Name, Status, Manufacturer, Model, Processor, CPU,Memory Capacity, HD, NIC Numbers, VM Numbers, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Server&nbsp;&nbsp;
					</td>
					<td>
						IP&nbsp;&nbsp;
					</td>
					<td>
						VM&nbsp;Name&nbsp;&nbsp;
					</td>	
					<td>
						Status&nbsp;&nbsp;
					</td>									
					<td>
						Manufacturer&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;&nbsp;
					</td>
					<td>
						Processor&nbsp;&nbsp;
					</td>										
					<td>
						CPU&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;Capacity&nbsp;&nbsp;
					</td>	
					<td>
					   HD	
					</td>
					<td>
					    NIC Numbers	
					</td>						
					<td>
					    VM Numbers	
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					    																		
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1) + ", "
										+ rs.getString("Site") + ", "
										+ rs.getString("Dept") + ", "
										+ rs.getString("Name") + ", "
										+ rs.getString("VMHost") + ","
                                        + rs.getString("VMServerName") + ", "
                                        + rs.getString("PowerState") + ","										
										+ rs.getString("Manufacturer") + ", "
										+ rs.getString("Model") + ", "	
										+ rs.getString("Processor") + ", "																			
										+ rs.getString("CPU") + ", "
										+ rs.getString("MemoryCapacity") + ", "
										+ rs.getString("HD") + ", "										
										+ rs.getString("TotalNumberOfNIC") + ","	
										+ rs.getString("TotalVMNumber") + ","	
										+ rs.getString("Notes").replace(",", " ") + ","										
										+ rs.getString("LastScan").replace(",", " ") + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/tree/vmhost.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/update.jsp?VMIp=<%=rs.getString("VMHost")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("Name")%>"><%=rs.getString("Name")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("Name")%>"><%=rs.getString("VMHost")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("VMServerName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("PowerState")%>&nbsp;&nbsp;
					</td>								
					<td>
						<%=rs.getString("Manufacturer")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("Model")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Processor")%>&nbsp;&nbsp;
					</td>									
					<td>
						<%=rs.getString("CPU")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("MemoryCapacity")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("HD")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("TotalNumberOfNIC")%>&nbsp;&nbsp;
					</td>						
					<td>
						<%=rs.getString("TotalVMNumber")%>&nbsp;&nbsp;
					</td>	
					<td>
						<a HREF="/iprep/update/notes.jsp?Ip=<%=rs.getString("VMHost")%>&IpNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>										
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
				                	x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("VMwareClient")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Server, IP, Name, Client DNS, Client, Guest OS, Status, CPU Numbers, Memory, UserName, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Server&nbsp;&nbsp;
					</td>						
					<td>
						IP&nbsp;&nbsp;
					</td>	
					<td>
						Name&nbsp;&nbsp;
					</td>					
					<td>
						ClientDNS&nbsp;&nbsp;
					</td>										
					<td>
						Client&nbsp;&nbsp;
					</td>	
					<td>
						Guest&nbsp;OS&nbsp;&nbsp;
					</td>												
					<td>
						Status&nbsp;&nbsp;
					</td>															
					<td>
						CPU&nbsp;Numbers&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;&nbsp;
					</td>	
					<td>
						ResEnd&nbsp;&nbsp;
					</td>	
					<td>
						ResBy&nbsp;&nbsp;
					</td>	
					<td>
						UserName&nbsp;&nbsp;
					</td>																								
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("VMHostName")
										+ ", "
										+ rs.getString("VMHost")
										+ ", "										
										+ rs.getString("ClientName")
										+ ", "
										+ rs.getString("VMClientDNS")
										+ ", "										
										+ rs.getString("VMClient")
										+ ", "
										+ rs.getString("GuestOS")
										+ ", "
										+ rs.getString("RunState")
										+ ", "										
										+ rs.getString("NumberOfCPU")
										+ ", "
										+ rs.getString("Memory")
										+", "
										+ rs.getString("UserName")										
										+ ", "			
										+ rs.getString("Notes").replace(",", " ")										
										+ ", "																		
										+ rs.getString("LastScan").replace(",", " ") + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/tree/vmhost.jsp?Site=<%=rs.getString("Site")%>"><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/update.jsp?VMIp=<%=rs.getString("VMHost")%>"><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>"><%=rs.getString("VMHostName")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<a HREF="/iprep/tree/cssummary.jsp?VMHostName=<%=rs.getString("VMHostName")%>"><%=rs.getString("VMHost")%>&nbsp;&nbsp;</a>
					</td>	
					<td>
						<%=rs.getString("ClientName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("VMClientDNS")%>&nbsp;&nbsp;
					</td>																			
					<td>
						<%=rs.getString("VMClient")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("GuestOS")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("RunState")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("NumberOfCPU")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Memory")%>&nbsp;&nbsp;
					</td>																	
					<td>
                        <%=(new FormatString()).vpResEnd(rs.getString("ClientName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).vpResBy(rs.getString("ClientName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("UserName")%>&nbsp;&nbsp;
					</td>																	
					<td>
						<a HREF="/iprep/update/notes.jsp?ClientIp=<%=rs.getString("VMClient")%>&ClientNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
			                		x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("Appliance")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Avalanche, Name, Model Number, Firmware Version, OS Version, Serial Number, MAC Address, Default Gateway, Subnet Mask, Used DHCP, Interfaces Number, Memory Size, Units Number, Memory Per Unit, Has SSL Accelerator, Dispatcher Version, Return Code, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Avalanche&nbsp;&nbsp;
					</td>
					<td>
						Name&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Firmware&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						OS&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						Serial&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						MAC&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Default&nbsp;Gateway&nbsp;&nbsp;
					</td>
					<td>
						Subnet&nbsp;Mask&nbsp;&nbsp;
					</td>
					<td>
						Used&nbsp;DHCP&nbsp;&nbsp;
					</td>
					<td>
						Interfaces&nbsp;Number&nbsp;&nbsp;
					</td>					
					<td>
						Memory&nbsp;Size&nbsp;&nbsp;
					</td>
					<td>
						Units&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Memory&nbsp;Per&nbsp;Unit&nbsp;&nbsp;
					</td>
					<td>
						Has&nbsp;SSL&nbsp;Accelerator&nbsp;&nbsp;
					</td>
					<td>
						Dispatcher&nbsp;Version&nbsp;&nbsp;
					</td>
					<td>
						Return&nbsp;Code&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("ipaddress")
										+ ", "
										+ rs.getString("hostname")
										+ ", "
										+ rs.getString("modelnumber")
										+ ", "
										+ rs.getString("softwareversion")
										+ ", "
										+ rs.getString("osversion")
										+ ", "
										+ rs.getString("serialnumber")
										+ ", "
										+ rs.getString("macaddress")
										+ ", "
										+ rs.getString("defaultgateway")
										+ ", "
										+ rs.getString("subnetmask")
										+ ", "
										+ rs.getString("usedhcp")
										+ ", "
										+ rs.getString("numofinterface")
										+ ", "										
										+ rs.getString("memorysize")
										+ ", "
										+ rs.getString("numberofunits")
										+ ", "	
										+ rs.getString("memoryperunit")
										+ ", "																																																												
										+ rs.getString("hassslaccelerator")
										 + ", "
										+ rs.getString("dispatcherversion") 
										+ ", "
										+ rs.getString("returncode") 
										+ ", "	
										+ rs.getString("Notes").replace(",", " ")										
										+ ", "
										+ (new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue()) + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/tree/av.jsp?Site=<%=rs.getString("site")%>"><%=rs.getString("site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/update.jsp?AVIp=<%=rs.getString("ipaddress")%>"><%=rs.getString("dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>"><%=rs.getString("ipaddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("hostname")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("modelnumber")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("softwareversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("osversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("serialnumber")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("macaddress")%>&nbsp;&nbsp;
					</td>
					<td><%=rs.getString("defaultgateway")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("subnetmask")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("usedhcp")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("numofinterface")%>&nbsp;&nbsp;
					</td>								
					<td>
						<%=rs.getString("memorysize")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("numberofunits")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("memoryperunit")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("hassslaccelerator")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("dispatcherversion")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("returncode")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?AVIp=<%=rs.getString("ipaddress")%>&AVNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>					
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
				                	x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("AVPortGroup")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, Avalanche, Model Number, Port, Connection, Port Group, Port Group Description, Port Group Type, User, Active Software, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						Avalanche&nbsp;&nbsp;
					</td>
					<td>
						Model&nbsp;Number&nbsp;&nbsp;
					</td>
					<td>
						Port&nbsp;&nbsp;
					</td>	
					<td>
						ResEnd&nbsp;&nbsp;
					</td>	
					<td>
						ResBy&nbsp;&nbsp;
					</td>															
					<td>
						Port&nbsp;Group&nbsp;&nbsp;
					</td>
					<td>
						Active&nbsp;Software&nbsp;&nbsp;
					</td>					
					<td>
						Port&nbsp;Group&nbsp;Description&nbsp;&nbsp;
					</td>
					<td>
						Port&nbsp;Group&nbsp;Type&nbsp;&nbsp;
					</td>
					<td>
						Connection&nbsp;&nbsp;
					</td>					
					<td>
						User&nbsp;&nbsp;
					</td>
					<td>
						Notes&nbsp;&nbsp;
					</td>					
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("ipaddress")
										+ ", "
										+ rs.getString("model")
										+ ", "
										+ rs.getString("portindex")
										+ ", "									
										+ rs.getString("connection")
										+ ", "										
										+ rs.getString("portgroupindex")
										+ ", "
										+ rs.getString("portgroupdescr")
										+ ", "
										+ rs.getString("portgrouptype")
										+ ", "
										+ rs.getString("user")
										+ ", "
										+ rs.getString("activesoftware")
										+ ", "
										+ rs.getString("Notes").replace(",", " ")										
										+ ", "
										+ (new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue()) + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("site")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update.jsp?AVIp=<%=rs.getString("ipaddress")%>"><%=rs.getString("dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a
							HREF="/iprep/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>"><%=rs.getString("ipaddress")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=rs.getString("model")%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/tree/avport.jsp?Ip=<%=rs.getString("ipaddress")%>&Index=<%=rs.getString("portindex")%>"><%=rs.getString("portindex")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<%=(new FormatString()).avResEnd(rs.getString("ipaddress"), rs.getString("portindex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=(new FormatString()).avResBy(rs.getString("ipaddress"), rs.getString("portindex"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>												
					<td>
						<%=rs.getString("portgroupindex")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("activesoftware")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("portgroupdescr")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("portgrouptype")%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/update/avconnection.jsp?Ip=<%=rs.getString("ipaddress")%>&PortGroupIndex=<%=rs.getString("portgroupindex")%>&PortIndex=<%=rs.getString("portindex")%>&RadioConnection=<%=rs.getString("ConnectionType")%>&PeerHost=<%=rs.getString("PeerHost")%>&PeerModule=<%=rs.getString("PeerModule")%>&PeerPort=<%=rs.getString("PeerPort")%>&Comments=<%=rs.getString("Comments")%>"><%=rs.getString("connection")%>&nbsp;&nbsp;</a>
					</td>					
					<td>
						<%=rs.getString("user")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?AVPortIp=<%=rs.getString("ipaddress")%>&AVPortGP=<%=rs.getString("portgroupindex")%>&AVPort=<%=rs.getString("portindex")%>&AVPortNotes=<%=rs.getString("Notes")%>"><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>						
					<td>
						<%=(new FormatString()).formatLastScan(rs.getString("LastScan"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					               x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("PC")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, Dept, DNS Host Name, IP Address, Manufacturer, Model, CPU, OS, Service Pack, Processors Number, Ram, HD Size, Status, User Name, Notes, Last Scan"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						Dept&nbsp;&nbsp;
					</td>
					<td>
						DNS&nbsp;Host&nbsp;Name&nbsp;&nbsp;
					</td>					
					<td>
						IP&nbsp;Address&nbsp;&nbsp;
					</td>
					<td>
						Manufacturer&nbsp;&nbsp;
					</td>	
					<td>
						Model&nbsp;&nbsp;
					</td>	
					<td>
						CPU&nbsp;&nbsp;
					</td>	
					<td>
						OS&nbsp;&nbsp;
					</td>																							
					<td>
						Service&nbsp;Pack&nbsp;&nbsp;
					</td>	
					<td>
						Processors&nbsp;Number&nbsp;&nbsp;
					</td>	
					<td>
						Ram&nbsp;&nbsp;
					</td>														
					<td>
						HD&nbsp;Size&nbsp;&nbsp;
					</td>
					<td>
						Status&nbsp;&nbsp;
					</td>	
					<td>
						ResEnd&nbsp;&nbsp;
					</td>																																
					<td>
						ResBy&nbsp;&nbsp;
					</td>	
					<td>
						UserName&nbsp;&nbsp;
					</td>	
					<td>
						Notes&nbsp;&nbsp;
					</td>																															
					<td>
						Last&nbsp;Scan&nbsp;&nbsp;
					</td>
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("Dept")
										+ ", "
										+ rs.getString("DNSHostName")
										+ ", "
										+ rs.getString("IPAddress")
										+ ", "
										+ rs.getString("Manufacturer")
										+ ", "
										+ rs.getString("Model")
										+ ", "										
										+ rs.getString("CPUName")
										+ ", "										
										+ rs.getString("OSName")
										+ ", "
										+ rs.getString("ServicePack")
										+ ", "
										+ rs.getString("NumberOfProcessors")
										+ ", "										
										+ rs.getString("Ram")
										+ ", "
										+ rs.getString("HDSize")
										+ ", "
										+ rs.getString("Status")										
										+ ", "
										+ rs.getString("UserName")
										+ ", "
										+ rs.getString("Notes").replace(",", " ")
										+ ", "										
										+ rs.getString("LastScan") + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
						<a
							HREF="/iprep/tree/pc.jsp?Site=<%=rs.getString("Site")%>" ><%=rs.getString("Site")%>&nbsp;&nbsp;</a>
					</td>
					<td>
						<a HREF="/iprep/update.jsp?PCIp=<%=rs.getString("DNSHostName")%>" ><%=rs.getString("Dept")%>&nbsp;&nbsp;</a>
					</td>
					<td>
                        <%=rs.getString("DNSHostName")%>&nbsp;&nbsp;
					</td>	
					<td>
                        <%=rs.getString("IPAddress")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Manufacturer")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("Model")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("CPUName")%>&nbsp;&nbsp;
					</td>																											
					<td>
						<%=rs.getString("OSName")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("ServicePack")%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("NumberOfProcessors")%>&nbsp;&nbsp;
					</td>														
					<td>
						<%=rs.getString("Ram")%>&nbsp;&nbsp;
					</td>
					<td>
						<%=rs.getString("HDSize")%>&nbsp;&nbsp;
					</td>						
					<td>
						<%=rs.getString("Status")%>&nbsp;&nbsp;
					</td>																		
					<td>
                        <%=(new FormatString()).vpResEnd(rs.getString("DNSHostName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>
					<td>
						<%=(new FormatString()).vpResBy(rs.getString("DNSHostName"), Integer.valueOf(request.getSession().getAttribute("timeoffset").toString()).intValue())%>&nbsp;&nbsp;
					</td>					
					<td>
						<%=rs.getString("UserName")%>&nbsp;&nbsp;
					</td>
					<td>
						<a HREF="/iprep/update/notes.jsp?DNSHostName=<%=rs.getString("DNSHostName")%>&DNSHostNotes=<%=rs.getString("Notes")%>" ><%=rs.getString("Notes")%>&nbsp;&nbsp;</a>
					</td>																
					<td>
						<%=rs.getString("LastScan")%>&nbsp;&nbsp;
					</td>
				</tr>
				<%
					           x = x + 1;
							}
							fos.close();
				%>
			</table>
			<%
				}else if (type.equals("STCProperty")) {
						StreamGobbler fileObj = new StreamGobbler(webPath);
						FileOutputStream fos = fileObj.fileOS(loginUser);
						if (fos != null) {
							fos
									.write(("Row, Site, SN, Property, Sales Order, SO Start, SO End"
											+ "\n").getBytes());
						}
			%>
			<table BORDER="0" CELLPADDING="1" CELLSPACING="0" align="left"
				width="100%">
				<tr bgcolor="#C2D5FC">
					<td>
						Row&nbsp;&nbsp;
					</td>
					<td>
						Site&nbsp;&nbsp;
					</td>
					<td>
						SN&nbsp;&nbsp;
					</td>
					<td>
						Property&nbsp;&nbsp;
					</td>
					<td>
						Sales&nbsp;Order&nbsp;&nbsp;
					</td>					
					<td>
						SO&nbsp;Start&nbsp;&nbsp;
					</td>
					<td>
						SO&nbsp;End&nbsp;&nbsp;
					</td>	
				</tr>
				<%
					int x = 0;
							String color = "";
							while (rs.next()) {
								fos.write((Integer.toString(x + 1)
										+ ", "
										+ rs.getString("Site")
										+ ", "
										+ rs.getString("SN")
										+ ", "
										+ rs.getString("Property")
										+ ", "
										+ rs.getString("SO")
										+ ", "
										+ rs.getString("SOStart")
										+ ", "
										+ rs.getString("SOEnd")
								        + "\n").getBytes());
								if (x % 2 == 0) {
									color = "#FFFFFF";
								} else {
									color = "#C2D5FC";
								}
				%>

				<tr bgcolor=<%=color%>>
					<td>
						<%=x + 1%>&nbsp;&nbsp;
					</td>
					<td>
                       <%=rs.getString("Site")%>
					</td>
					<td>
                        <%=rs.getString("SN")%>
					</td>	
					<td>
                        <%=rs.getString("Property")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("SO")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("SOStart")%>&nbsp;&nbsp;
					</td>	
					<td>
						<%=rs.getString("SOEnd")%>&nbsp;&nbsp;
					</td>																											
				</tr>
				<%
					           x = x + 1;
							}
							if (fos != null)
								fos.close();
				%>
			</table>
			<%
				}
			%>												
			<%
                  }
				} catch (Exception e) {
					System.out.println("Error occourred in query.jsp: "
							+ e.getMessage() + e.toString());
					e.printStackTrace();
				}  finally {

			        	try {
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
							.println("Close DB error occourred in query.jsp: "
									+ e.getMessage());
			        	}
			        }
			%>
		</div>
	</body>
</html>


