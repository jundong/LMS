package com.spirent.query;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class QueryResource extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		try {
			String CAL = request.getParameter("CAL");
			String CHN = request.getParameter("CHN");
			String HNL = request.getParameter("HNL");
			String RTP = request.getParameter("RTP");
			String SNV = request.getParameter("SNV");
			String ALL = request.getParameter("ALL");
			
			String checkedSite = "";
			if (CAL != null && !CAL.equals("false")) {
			    checkedSite = checkedSite + "CAL" + ",";
			}
			if (CHN != null && !CHN.equals("false")) {
			    checkedSite = checkedSite + "CHN" + ",";
			}
			if (HNL != null && !HNL.equals("false")) {
			    checkedSite = checkedSite + "HNL" + ",";
			}
			if (RTP != null && !RTP.equals("false")) {
			    checkedSite = checkedSite + "RTP" + ",";
			}
			if (SNV != null && !SNV.equals("false")) {
			    checkedSite = checkedSite + "SNV" + ",";
			}
			if (ALL != null && !ALL.equals("false")) {
			    checkedSite = "ALL" + ",";
			}
			
			String type = request.getParameter("type");
			String Site = checkedSite;
			if (Site == null || Site.equals("")){
				Site = (String) request.getSession().getAttribute("loginsite");
			}
			String conditionItem = request.getParameter("conditionItem");
			String conditionValue = request.getParameter("conditionValue");
			String SQLstmt="";
			
			String[] splitSite = Site.split(",");
			if (Site.contains("ALL")){ 
				Site = "ALL";
			}else if (splitSite.length == 1){
				Site = splitSite[0];
			}else if (splitSite.length == 2){
				Site = splitSite[0] + "' OR Site='" + splitSite[1];
			}else if (splitSite.length == 3){
				Site = splitSite[0] + "' OR Site='" + splitSite[1] + "' OR Site='" + splitSite[2];				
			}else if (splitSite.length == 4){
				Site = splitSite[0] + "' OR Site='" + splitSite[1] + "' OR Site='" + splitSite[2] + "' OR Site='" + splitSite[3];
			}else if (splitSite.length == 5){
				Site = splitSite[0] + "' OR Site='" + splitSite[1] + "' OR Site='" + splitSite[2] + "' OR Site='" + splitSite[3] + "' OR Site='" + splitSite[4];
			}

			if (type.equals("Chassis")){
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM stc_inventory_chassis WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,Hostname";
				} else {
					SQLstmt = "SELECT * FROM stc_inventory_chassis WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "') ORDER BY Site,Hostname";
				}
				
            } else if (type.equals("DUT")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM dut_inventory WHERE "
							+ conditionItem + " LIKE '%" + conditionValue.trim()
							+ "%' ORDER BY Site,DutIpAddress";
				} else {
					SQLstmt = "SELECT * FROM dut_inventory WHERE "
							+ conditionItem + " LIKE '%" + conditionValue.trim()
							+ "%' AND (Site='" + Site
							+ "')  ORDER BY Site,DutIpAddress";
				}
				
			} else 	if (type.equals("STCModule")){
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM stc_inventory_testmodule WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,Hostname,SlotIndex";
				} else {
					SQLstmt = "SELECT * FROM stc_inventory_testmodule WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY Site,Hostname,SlotIndex";
				}
				
            } else if (type.equals("DUTIntf")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM dut_inventory_intf WHERE "
							+ conditionItem + " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,DutIpAddress,  ModuleIndex, IntfName";
				} else {
					SQLstmt = "SELECT * FROM dut_inventory_intf WHERE "
							+ conditionItem + " LIKE '%"
							+ conditionValue.trim() + "%' AND (Site='"
							+ Site + "')  ORDER BY Site,DutIpAddress,  ModuleIndex, IntfName";
				}
				
			} else 	if (type.equals("STCPortGroup")){
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM stc_inventory_portgroup WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,Hostname,SlotIndex,PortIndex";
				} else {
					SQLstmt = "SELECT * FROM stc_inventory_portgroup WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY Site,Hostname,SlotIndex,PortIndex";
				}
				
            } else 	if (type.equals("VMware")){
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM vm_host WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,VMHost";
				} else {
					SQLstmt = "SELECT * FROM vm_host WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY Site,VMHost";
				}
				
            } else if (type.equals("VMwareClient")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM vm_client WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,ClientName";
				} else {
					SQLstmt = "SELECT * FROM vm_client WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY Site,ClientName";
				}
				
			} else 	if (type.equals("Appliance")){
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM avl_appliances WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY site,ipaddress";
				} else {
					SQLstmt = "SELECT * FROM avl_appliances WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY site,ipaddress";
				}
				
            } else if (type.equals("AVPortGroup")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM avl_portgroups WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY site,ipaddress";
				} else {
					SQLstmt = "SELECT * FROM avl_portgroups WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY site,ipaddress";
				}
				
			} else if (type.equals("PC")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM lab_pcs WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY Site,IPAddress";
				} else {
					SQLstmt = "SELECT * FROM lab_pcs WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY Site,IPAddress";
				}
				
			} else if (type.equals("STCProperty")){  
				if (Site.equals("ALL")) {
					SQLstmt = "SELECT * FROM stc_property WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' ORDER BY SN";
				} else {
					SQLstmt = "SELECT * FROM stc_property WHERE "
							+ conditionItem
							+ " LIKE '%"
							+ conditionValue.trim()
							+ "%' AND (Site='"
							+ Site + "')  ORDER BY SN";
				}
				
			} 
			request.getSession().setAttribute("SQLstmt", SQLstmt);
			response.sendRedirect("/iprep/query.jsp?type="+type+"&checkedSite="+checkedSite+"&redirect=true&conditionValue=" + conditionValue
					+ "&conditionItem=" + conditionItem);
		} catch (Exception e) {
			System.out.println("Error occourred in QueryResource.java: "
							+ e.getMessage());
			response.sendRedirect("/iprep/query.jsp");
		}
   }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

	}
}
