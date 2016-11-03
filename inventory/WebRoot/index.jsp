<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

	<head>
		<base href="<%=basePath%>">
		<title>Spirent Lab Management System</title>
	</head>

	<!-- You may make other changes, but do not change the names  -->
	<!-- of the frames (treeframe and basefrm).                   -->
	<frameset rows="70,*" frameborder=0>
		<frame src="/inventory/header.jsp" name="headerfrm" scrolling="no" noresize>
		<frameset cols="222,*" frameborder=0>
			<frameset rows="65,*" frameborder=0>
				<frame src="/inventory/tree/treemenu.jsp" name="treemenu"noresize scrolling="no">
				<frame src="/inventory/tree/inventorytree.jsp?Site=<%=request.getSession().getAttribute("loginsite")%>" name="treeframe" noresize>
			</frameset>
			<frame src="/inventory/welcome.jsp?Animation=true" name="basefrm">
		</frameset>
	</frameset>
</html>


