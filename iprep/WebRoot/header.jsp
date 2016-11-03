<%@ page language="java"
	import="java.util.*"
	pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<% 
   	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
   String levels = request.getSession().getAttribute("levels").toString();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>Inventory Header</title>
		<link rel="stylesheet" href="/iprep/common/css/style.css"
			type="text/css" media="screen" />

        <div class="header">
            <a class="logo" href="http://www.spirent.com" target="_top" title="Spirent">
            	<img src="/iprep/common/imgs/iPrepLogo.png" width="125" height="70" />
            </a>
            <div class="tittle-inventory">iPREP Lab Management System</div>
            <div class="menu-field">
            
          <script type="text/javascript">
            //var selectedList = top.treeframe.tree.getAllChecked(); 
            //alert(selectedList);
            
			function queryResource(){
			    headerform.action="/iprep/query.jsp?isQuery=true";
			    headerform.target="basefrm";
			    headerform.submit();  
			}

			function addResource(){
			    headerform.action="/iprep/update/updateTestBed.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}

			function deleteResource(){
			    headerform.action="/iprep/delete.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}

			function reports(){
				 var selectedList = top.treeframe.tree.getAllChecked();
			     var portList = new Array(); 
			     //var uniqueList = new Array();
			     
			     if (selectedList == "") {
                     headerform.portList.value = "";
                  } else {                 
	                 var temList = selectedList.split(",");
	                 var index=0;
	                 for (var i=0; i<temList.length; i++) {
	                    if (temList[i].search("CK") != -1) {
	                       var splitip = temList[i].split("///");             
	                       portList[index] =  splitip[1];
	                       index++;
	                    }
	                }
	                headerform.portList.value = portList;
                }
                			    
			    headerform.action="/iprep/reports.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}
						
			function adminSystem(){
			    headerform.action="/iprep/admin.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}

			function preferences(){
			    headerform.action="/iprep/preference.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}

			function contact(){
			    headerform.action="/iprep/contact.jsp";
			    headerform.target="basefrm";
			    headerform.submit();  
			}	
						
			function logoutSystem(){
			    headerform.action="/iprep/login.jsp?isLogout=true";
			    headerform.target="_top";
			    headerform.submit();  
			}												
        </script>
        
             <form method=post name="headerform" >
             <%int temp=0;
               if(temp != 0) {%>
               	    <input class="buttonquery" type="button" value="" onclick="javascript:queryResource();"/>
               <%} %>
                <%  if (levels.equals("1") || levels.equals("0")) { %>
                    <input class="buttonadd" type="button" value="" onclick="javascript:addResource();"/>
                    <input class="buttondelete" type="button" value="" onclick="javascript:deleteResource();"/>
                    <input class="buttonreports" type="button" value="" onclick="javascript:reports();"/>
                      <%  if (levels.equals("0")) { %>
                    <input class="buttonadmin" type="button" value="" onclick="javascript:adminSystem();"/>
                <% }} %>
                <input class="buttonpreferences" type="button" value="" onclick="javascript:preferences();"/>
                <input class="buttoncontact" type="button" value="" onclick="javascript:contact();"/>
                <input class="buttonlogout" type="button" value="" onclick="javascript:logoutSystem();"/> 
                <input class="buttonlogout" type="hidden" name="portList" value=""/>
                </form>
            </div>
        </div>
	</head>
</html>