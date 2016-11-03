package com.spirent.convert2xml;

import java.io.IOException;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

import com.spirent.javaconnector.DataBaseConnection;

public class Generate2TreeXML {

	public String BuildXMLDoc(String filter) throws IOException, JDOMException {
		StringWriter strwriter = new StringWriter(); 
		ConvertIprep iprep = new ConvertIprep();
		Element root = new Element("tree");
		root.setAttribute("id", "0");		
		Element treeroot = new Element("item");
		treeroot.setAttribute("text", "Spirent Communication");
		treeroot.setAttribute("id", "stc");
		treeroot.setAttribute("nocheckbox", "1");
		treeroot.setAttribute("call", "1");
		treeroot.setAttribute("select", "1");
		root.addContent(treeroot);
		// Set query string
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String SQLStr = "";
		try {
			conn = DataBaseConnection.getConnection();
			if (conn != null) {
				Element ipreproot = iprep.addRootNode(treeroot);				
				SQLStr = "select TestBedName from iprep_testbed order by TestBedIndex";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(SQLStr);
					
				while (rs.next()) {
					iprep.addTestBedNode(rs.getString("TestBedName"), ipreproot);
				}
				Document Doc = new Document(root);
				XMLOutputter XMLOut = new XMLOutputter();
				XMLOut.output(Doc, strwriter);
			}
		} catch (Exception e) {
			System.out
					.println("Error occourred in iprep Generate2TreeXML.java: "
							+ e.getMessage());
		}finally {
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
				.println("Close DB error occourred in Generate2TreeXML.java: "
						+ e.getMessage());
        	}
        } 	
		return strwriter.toString();
	}
}
