package com.spirent.convert2xml;

import org.jdom.Element;

public class ConvertAV {

	public Element addAVNode(String site, Element treenode) {
		Element avroot = new Element("item");
		avroot.setAttribute("text", "AV");
		avroot.setAttribute("id", site.toLowerCase() + "av");
		//chassisroot.setAttribute("nocheckbox", "1");
		treenode.addContent(avroot);

		return avroot;
	}

	public Element addAVIPNode(String hostname, Element treenode) {
		Element aviproot = new Element("item");
		aviproot.setAttribute("text", hostname);
		aviproot.setAttribute("id", hostname);
		treenode.addContent(aviproot);

		return aviproot;
	}

	public void addAVPortNode(String hostname, 
			int portindex, Element treenode) {

		Element portroot = new Element("item");

	    portroot.setAttribute("text", "Port " + portindex);
		portroot.setAttribute("id", "CK///" + hostname + "/" + portindex);
		treenode.addContent(portroot);
	}
}
