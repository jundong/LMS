<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title>InventoryTree</title>
		<link rel="STYLESHEET" type="text/css"
			href="/inventory/common/css/dhtmlxtree.css" />
		<script src="/inventory/common/dhtmlxcommon.js"></script>
		<script src="/inventory/common/dhtmlxtree.js"></script>
	</head>
	<body>
		<div class="content">
			<script type="text/javascript" charset="utf-8">
	              function tonclick(id){
	                    var selectStr = tree.getItemText(id);
	                    
	                    if (selectStr.search("Spirent") != -1){
	                        window.open("/inventory/welcome.jsp","basefrm");
	                    }
				        else if ((selectStr == "Calabasas")||(selectStr == "Beijing")||(selectStr == "Honolulu")||(selectStr == "Raleigh")||(selectStr == "Sunnyvale")) {
				           window.open("/inventory/tree/chassis.jsp?Site="+id,"basefrm");
				        }
				        else if (selectStr == "AV") {
				           window.open("/inventory/tree/av.jsp?Site="+tree.getParentId(id),"basefrm");
				        } 
				        else if (tree.getItemText(tree.getParentId(id)).search("AV") != -1){
				              window.open("/inventory/tree/avportsummary.jsp?Ip="+selectStr,"basefrm");
				        }
				        else if (selectStr == "STC") {
				           window.open("/inventory/tree/chassis.jsp?Site="+tree.getParentId(id),"basefrm");
				        } 
				        else if (tree.getItemText(tree.getParentId(id)).search("STC") != -1){
				              window.open("/inventory/tree/chslotsummary.jsp?Ip="+id,"basefrm");
				        }
				        else if (selectStr.search("Slot") != -1) {
				          var splitSlot = id.split("//");
				          window.open("/inventory/tree/slotportsummary.jsp?Ip="+splitSlot[0]+"&Slot="+splitSlot[1],"basefrm");	           
				        }
				        else if (selectStr.search("Port") != -1) {
				          if (id.split("//").length == 3) {
					          var splitIP = id.split("///");
					          var splitSlot = splitIP[1].split("//");
					          var splitPort = splitSlot[1].split("/");
					          window.open("/inventory/pspage.jsp?Ip="+splitSlot[0]+"&Slot="+splitPort[0]+"&Index="+splitPort[1],"basefrm");	           
				          } else {
				              var splitIP = id.split("///");
					          var splitPort = splitIP[1].split("/");
					          window.open("/inventory/aspage.jsp?Ip="+splitPort[0]+"&Index="+splitPort[1],"basefrm");	           
				          }
				        }
				        else if (selectStr == "VM") {
				           window.open("/inventory/tree/vmhost.jsp?Site="+tree.getParentId(id),"basefrm");
				        }
				        else if (selectStr == "Standalone" || selectStr == "BladeServer") {
				           var splitip = id.split("/"); 
				           window.open("/inventory/tree/vmhost.jsp?Site="+splitip[1]+"&BladName="+splitip[0],"basefrm");
				        }
				        else if (tree.getItemText(tree.getParentId(id)) == "Standalone" || tree.getItemText(tree.getParentId(id)) == "BladeServer") {
				           window.open("/inventory/tree/cssummary.jsp?VMHostName="+selectStr,"basefrm");
				        }	
				        else if (tree.getItemText(tree.getParentId(tree.getParentId(id))) == "Standalone" || tree.getItemText(tree.getParentId(tree.getParentId(id))) == "BladeServer") {
				           window.open("/inventory/vspage.jsp?ClientName="+selectStr,"basefrm");
				        }				        			        			        
				        else if (selectStr == "DUT") {
				           window.open("/inventory/tree/dut.jsp?Site="+tree.getParentId(id),"basefrm");
				        } 
				        else if (tree.getItemText(tree.getParentId(id)).search("DUT") != -1){
				        	  var dut_temp = selectStr.split("(");
				        	  var dut_ip = dut_temp[0];
				              window.open("/inventory/tree/dutsummary.jsp?Ip="+dut_ip,"basefrm");
				        }
				        else if (selectStr.search("Blade") != -1){
				          var splitIP = id.split("//");
				          window.open("/inventory/tree/bladeportsummary.jsp?Ip="+splitIP[0]+"&ModuleIndex="+splitIP[1],"basefrm");
				        } 
				        else if (tree.getItemText(tree.getParentId(id)).search("Blade") != -1){
				          var splitIP = id.split("///");
					      var splitPort = splitIP[1].split("//");
				          window.open("/inventory/dspage.jsp?Ip="+splitPort[0]+"&Port="+splitPort[1],"basefrm");
				        }
                        else if (selectStr == "PC") {
				           window.open("/inventory/tree/pc.jsp?Site="+tree.getParentId(id),"basefrm");
				        }
				        else if (tree.getItemText(tree.getParentId(id)) == "PC") {
				           var splitIP = id.split("///");
				           window.open("/inventory/pcspage.jsp?DNSHostName="+splitIP[1],"basefrm");
				        }					        
				        else {
				           window.open("/inventory/welcome.jsp","basefrm");
				        }     
			      };
			
			</script>
			<div id="inventory_tree"
				style="width: 260px; height: 100%; background-color: #f5f5f5; border: 0px solid Silver; overflow: hidden; margin: 0px;">
			</div>

			<script>	
			var queryStr = window.location.search.substr(1);	 	
			tree=new dhtmlXTreeObject("inventory_tree","100%","100%",0);
			tree.setSkin('dhx_skyblue');
			tree.setImagePath("/inventory/common/imgs/csh_vista/");
			tree.enableCheckBoxes(1);
			tree.enableIEImageFix(true);
			tree.def_img_x="0px";
			tree.setOnClickHandler(tonclick);
			tree.enableThreeStateCheckboxes(true);
			tree.setXMLAutoLoading("treeevents.do");
			tree.loadXML("treeevents.do?id=0&"+queryStr);	  	
	        </script>
		</div>
	</body>
</html>
