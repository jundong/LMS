<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="authentication.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">

	<head>
		<base href="<%=basePath%>">
		<title>iPREP Lab Management System</title>
	</head>

	<!-- You may make other changes, but do not change the names  -->
	<!-- of the frames (treeframe and basefrm).                   -->
	<frameset rows="70,*" frameborder=no>
		<frame src="/iprep/header.jsp" name="headerfrm" scrolling="no" noresize>
		<frameset cols="333,*" frameborder=no>
			<frameset rows="65,*" frameborder=no>
				<frame src="/iprep/tree/treemenu.jsp" name="treemenu" scrolling="no">
				<frame src="/iprep/tree/inventorytree.jsp?Site=<%=request.getSession().getAttribute("loginsite")%>" name="treeframe" scrolling="auto">
			</frameset>
			<frame src="/iprep/welcome.jsp?Animation=true" name="basefrm">
		</frameset>
	</frameset>
</html>


