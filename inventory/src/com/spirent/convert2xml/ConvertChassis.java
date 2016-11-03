package com.spirent.convert2xml;

import org.jdom.Element;

public class ConvertChassis {
	public Element addRootNode(Element treenode) {
		Element treeroot = new Element("item");
		treeroot.setAttribute("text", "Spirent Communication");
		treeroot.setAttribute("id", "stc");
		treeroot.setAttribute("nocheckbox", "1");
		treeroot.setAttribute("call", "1");
		treeroot.setAttribute("select", "1");
		treenode.addContent(treeroot);

		return treeroot;
	}

	public Element addSiteNode(String site, Element treenode) {
		String fullname = site;
		if (site.equals("CAL")){
			fullname = "Calabasas";
		} 
		else if (site.equals("CHN")){
			fullname = "Beijing";
		}
		else if (site.equals("HNL")){
			fullname = "Honolulu";
		}
		else if (site.equals("RTP")){
			fullname = "Raleigh";
		}
		else if (site.equals("SNV")){
			fullname = "Sunnyvale";
		}
		
		Element siteroot = new Element("item");
		siteroot.setAttribute("text", fullname);
		siteroot.setAttribute("id", site);
		siteroot.setAttribute("nocheckbox", "1");
		treenode.addContent(siteroot);

		return siteroot;
	}

	public Element addChassisNode(String site, Element treenode) {
		Element chassisroot = new Element("item");
		chassisroot.setAttribute("text", "STC");
		chassisroot.setAttribute("id", site.toLowerCase() + "stc");
		//chassisroot.setAttribute("nocheckbox", "1");
		treenode.addContent(chassisroot);

		return chassisroot;
	}

	public Element addChassisIPNode(String hostname, Element treenode) {
		Element chassisiproot = new Element("item");
		chassisiproot.setAttribute("text", hostname);
		chassisiproot.setAttribute("id", hostname);
		treenode.addContent(chassisiproot);

		return chassisiproot;
	}

	public Element addSlotNode(String hostname, int slotindex, Element treenode) {
		Element slotroot = new Element("item");
		slotroot.setAttribute("text", "Slot " + slotindex);
		slotroot.setAttribute("id", hostname + "//" + slotindex);
		treenode.addContent(slotroot);

		return slotroot;
	}

	public void addPortNode(String hostname, int slotindex,
			int portindex, Element treenode, String status) {

		Element portroot = new Element("item");
		if (status.equals("MODULE_STATUS_DOWN")) {
			portroot.setAttribute("text", "Port " + portindex + "(Offline)");
		} else {
			portroot.setAttribute("text", "Port " + portindex);
		}
		portroot.setAttribute("id", "CK///" + hostname + "//" + slotindex
				+ "/" + portindex);
		treenode.addContent(portroot);
	}
}
