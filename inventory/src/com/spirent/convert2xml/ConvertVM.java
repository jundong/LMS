package com.spirent.convert2xml;

import org.jdom.Element;

public class ConvertVM {
	public Element addVMNode(String site, Element treenode) {
		Element vmroot = new Element("item");
		vmroot.setAttribute("text", "VM");
		//vmroot.setAttribute("nocheckbox", "1");
		vmroot.setAttribute("id", site.toLowerCase() + "vm");
		treenode.addContent(vmroot);

		return vmroot;
	}

	public Element addVMServerIPNode(String hostname, Element treenode) {
		Element vmiproot = new Element("item");
		vmiproot.setAttribute("text", hostname);
		vmiproot.setAttribute("id", hostname);
		treenode.addContent(vmiproot);

		return vmiproot;
	}
	
	public Element addBladNode(String bladname, String site, Element treenode) {
		Element vmbladiproot = new Element("item");
		vmbladiproot.setAttribute("text", bladname);
		vmbladiproot.setAttribute("id", bladname+"/"+site);
		treenode.addContent(vmbladiproot);

		return vmbladiproot;
	}

	public Element addVMClientNode(String hostname, Element treenode) {
		Element subvmroot = new Element("item");
		subvmroot.setAttribute("text", hostname);
		subvmroot.setAttribute("id", "CK///" + hostname);
		treenode.addContent(subvmroot);

		return subvmroot;
	}
}
