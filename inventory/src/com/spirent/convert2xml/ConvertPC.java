package com.spirent.convert2xml;

import org.jdom.Element;

public class ConvertPC {
	public Element addPCNode(String site, Element treenode) {
		Element pcroot = new Element("item");
		pcroot.setAttribute("text", "PC");
		pcroot.setAttribute("id", site.toLowerCase() + "pc");
		treenode.addContent(pcroot);

		return pcroot;
	}

	public Element addPCIPNode(String status, String hostname, Element treenode) {
		Element pciproot = new Element("item");
		if (status.equals("DOWN")){
			pciproot.setAttribute("text", hostname+"(DOWN)");
		} else {
		    pciproot.setAttribute("text", hostname);
		}
		pciproot.setAttribute("id", "CK///" + hostname);
		treenode.addContent(pciproot);

		return pciproot;
	}
}
