package com.spirent.javaconnector;

/*
 * Copyright (c) 2009 - DHTMLX, All rights reserved
 */
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirent.convert2xml.Generate2TreeXML;

// TODO: Auto-generated Javadoc
/**
 * The Class TreeBasicConnector.
 */
public class TreeBasicConnector extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		Generate2TreeXML j2xml = new Generate2TreeXML();
		try {
			String str = j2xml.BuildXMLDoc(request.getParameter("Site"));
			out.println(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}