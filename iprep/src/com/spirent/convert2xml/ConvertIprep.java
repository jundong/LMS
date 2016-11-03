package com.spirent.convert2xml;

import org.jdom.Element;

public class ConvertIprep {

	public Element addRootNode(Element treenode) {
		Element root = new Element("item");
		root.setAttribute("text", "iPREP");
		root.setAttribute("id", "iPREP");
		treenode.addContent(root);
		return root;
	}

	public Element addTestBedNode(String testBedName, Element treenode) {
		Element testBed = new Element("item");
		testBed.setAttribute("text", testBedName);
		testBed.setAttribute("id", testBedName);
		treenode.addContent(testBed);
		return testBed;
	}
}
