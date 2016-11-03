package com.spirent.convert2xml;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom.Element;

import com.spirent.javaconnector.DataBaseConnection;

public class ConvertDUT {
	public Element addDUTNode(String site, Element treenode) {
		Element dutroot = new Element("item");
		dutroot.setAttribute("text", "DUT");
		//dutroot.setAttribute("nocheckbox", "1");
		dutroot.setAttribute("id", site.toLowerCase() + "dut");
		treenode.addContent(dutroot);

		return dutroot;
	}

	public Element addDUTIPNode(String hostname, Element treenode) {
		Element dutiproot = new Element("item");
		String sql = "select DutPid from dut_inventory where DutIpAddress="+"'"+hostname+"'";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String chassisModel = "";
		try {
			conn = DataBaseConnection.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if(rs.next()){
				chassisModel =rs.getString("DutPid");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		dutiproot.setAttribute("text", hostname + "(" + chassisModel + ")");
		dutiproot.setAttribute("id", hostname);
		treenode.addContent(dutiproot);

		return dutiproot;
	}

	public Element addDUTBladNode(String hostname, int bladindex, Element treenode) {
		Element dutbladroot = new Element("item");
		dutbladroot.setAttribute("text", "Blade "+bladindex );
		dutbladroot.setAttribute("id", hostname + "//" + bladindex);
		treenode.addContent(dutbladroot);

		return dutbladroot;
	}
	
	public Element addDUTPortNode(String hostname, String invName, Element treenode) {
		Element portroot = new Element("item");
		portroot.setAttribute("text", invName);
		portroot.setAttribute("id", "CK///" + hostname + "//" + invName.trim());
		treenode.addContent(portroot);

		return portroot;
	}
}
