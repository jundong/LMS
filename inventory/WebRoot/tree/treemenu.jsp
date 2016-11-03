<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/strict.dtd">--%>
<html>
	<head>
		<base href="<%=basePath%>">

		<title>Inventory Tree Menu</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<link rel="STYLESHEET" type="text/css"
			href="/inventory/common/css/dhtmlxtree.css" />
		<%--<link rel="stylesheet" href="/inventory/common/css/style.css"
			type="text/css" media="screen" />--%>			

		<script type="text/javascript">
    			function getReservation(){
			     var selectedList = parent.treeframe.tree.getAllChecked(); 
			     var portList = new Array(); 
			     if (selectedList == "") {
                     alert("please select resources.");
                     return ;
                  } else {
                    var temList = selectedList.split(",");
                    var index=0;
                    for (var i=0; i<temList.length; i++) {
                       if (temList[i].search("CK") != -1) {
                          var splitip = temList[i].split("///");
                          portList[index] = splitip[1];
                          index++;
                       }
                    }
                  }
                  
                  tree_menu_form.portList.value=portList;
                  tree_menu_form.action="/inventory/scheduler/scheduler.jsp";
                  tree_menu_form.target="basefrm";
			      tree_menu_form.submit(); 
			      //window.open("/inventory/scheduler/scheduler.jsp?portList="+portList, "basefrm");     
			}

    		function myReservations(){
    		      tree_menu_form.portList.value="myreservations";
                  tree_menu_form.action="/inventory/scheduler/scheduler.jsp";
                  tree_menu_form.target="basefrm";
			      tree_menu_form.submit(); 
			      //window.open('/inventory/scheduler/scheduler.jsp', 'basefrm') 
			}
    </script>
	</head>

	<body>
		<div class="content">
			<div class="menu-field">
				<form name="tree_menu_form" method="post">
					<table style="font-size: 15px; font-family: "Tahoma, Arial, Helvetica, Tahoma, serif, CourierNew;" >
						<tr>
							<td>
								<input type="button" value="Expand All"
									onclick="parent.treeframe.tree.openAllItems(0);"
									style="width: 100px; font-size: 12px;" />
							</td>
							<td>
								<input type="button" value="Collapse All"
									onclick="parent.treeframe.tree.closeAllItems();"
									style="width: 100px; font-size: 12px;" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="button" value="My Reservations"
									onclick="myReservations();"
									style="width: 100px; font-size: 12px;" />
							</td>
							<td>
								<input type="button" value="Reserve" onclick="getReservation();"
									style="width: 100px; font-size: 12px;" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" name="portList" value="" />
							</td>
							<td>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>
</html>
