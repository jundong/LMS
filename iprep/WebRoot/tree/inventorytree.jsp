<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="../authentication.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title>InventoryTree</title>
		<link rel="STYLESHEET" type="text/css"
			href="/iprep/common/css/dhtmlxtree.css" />
		<script src="/iprep/common/dhtmlxcommon.js"></script>
		<script src="/iprep/common/dhtmlxtree.js"></script>
	</head>
	<body>
		<div class="content">
			<script type="text/javascript" charset="utf-8">
	              function tonclick(id){
	                    var selectStr = tree.getItemText(id);
	                    
	                    if (selectStr == "Spirent Communication"){
	                        window.open("/iprep/welcome.jsp","basefrm");
	                    }
				        else if ((selectStr == "iPREP")) {
				           window.open("/iprep/tree/iprepsummary.jsp","basefrm");
				        }
				        else  {
				        	if(selectStr != null && selectStr != "") {
				          		window.open("/iprep/tree/iprep.jsp?TestBedName="+selectStr,"basefrm");
				            }
				            else {
				            	window.open("/iprep/welcome.jsp","basefrm");
				            }
				        } 
			      };
			
			</script>
			<div id="inventory_tree"
				style="width: 500px; height: 100%; background-color: #f5f5f5; border: 0px solid Silver; overflow: hidden; margin: 0px;">
			</div>

			<script>	
			var queryStr = window.location.search.substr(1);	 	
			tree=new dhtmlXTreeObject("inventory_tree","100%","100%",0);
			tree.setSkin('dhx_skyblue');
			tree.setImagePath("/iprep/common/imgs/csh_vista/");
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
