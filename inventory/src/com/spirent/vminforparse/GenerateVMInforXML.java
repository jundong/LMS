package com.spirent.vminforparse;

import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

import com.spirent.initparameters.InitBaseParameters;

public class GenerateVMInforXML {
	String resource = "";
	String username = "";
	String password = "";
	
	public GenerateVMInforXML (String resource, String username, String password){
		this.resource = resource; 
		this.username = username; 
		this.password = password;
	}
	public GenerateVMInforXML (){
	}
	public void generateServerList() throws IOException, JDOMException {
        try {
        	Element root = new Element("hypervisors");
        	Document Doc = new Document(root);
        	
        	Element server = addServerNode(root);
        	addServerInfor(server);
        	
    		XMLOutputter XMLOut = new XMLOutputter();
    		StringWriter strwriter = new StringWriter();
    		XMLOut.output(Doc, strwriter);
    		
    		FileWriter fw=new FileWriter(InitBaseParameters.getTclPath() + "vm/server.xml");
    		fw.write(strwriter.toString());
    		fw.close();
    	 	              	        	
		} catch (Exception e) {
			System.out
					.println("Error occourred in GenerateVMInforXML.java: "
							+ e.getMessage());
		}
	}
	
	public Element addServerNode(Element root){
		Element server = new Element("server");
		root.addContent(server);

		return server;
	}
	public void addServerInfor(Element server){
		Element name = new Element("name");
		name.setText(getResource());
		server.addContent(name);
		
		Element id = new Element("id");
		id.setText(getUsername());
		server.addContent(id);
		
		Element password = new Element("password");
		password.setText(getPassword());
		server.addContent(password);		
	}
	public void addServerInfor(Element server, String resource, String username, String password){
		Element name = new Element("name");
		name.setText(resource);
		server.addContent(name);
		
		Element id = new Element("id");
		id.setText(username);
		server.addContent(id);
		
		Element pw = new Element("password");
		pw.setText(password);
		server.addContent(pw);		
	}
	public String getResource() {
		return resource;
	}
	public String getUsername() {
		return username;
	}
	public String getPassword() {
		return password;
	}
}
