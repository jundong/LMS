// -----------------------------------------------------------------------------
// LDAPSearchExample.java
// -----------------------------------------------------------------------------

/*
 * =============================================================================
 * Copyright (c) 1998-2009 Jeffrey M. Hunter. All rights reserved.
 * 
 * All source code and material located at the Internet address of
 * http://www.idevelopment.info is the copyright of Jeffrey M. Hunter and
 * is protected under copyright laws of the United States. This source code may
 * not be hosted on any other site without my express, prior, written
 * permission. Application to host any of the material elsewhere can be made by
 * contacting me at jhunter@idevelopment.info.
 *
 * I have made every effort and taken great care in making sure that the source
 * code and other content included on my web site is technically accurate, but I
 * disclaim any and all responsibility for any loss, damage or destruction of
 * data or any other property which may arise from relying on it. I will in no
 * case be liable for any monetary damages arising from such loss, damage or
 * destruction.
 * 
 * As with any code, ensure to test this code in a development environment 
 * before attempting to run it in production.
 * =============================================================================
 */
package com.spirent.ldap;
import netscape.ldap.*;

import java.util.Enumeration;

/**
 * -----------------------------------------------------------------------------
 * Used to provide an example that demonstrates how to use the Netscape LDAP
 * SDK for Java. In this example, we perform a simple search.
 * 
 * To compile this program:
 *      javac -classpath "$JAVALIB/ldapjdk.jar:." LDAPSearchExample.java
 * 
 * To call this program:
 *      java -classpath "$JAVALIB/ldapjdk.jar:." LDAPSearchExample <host> <port> <authdn> <authpw> <baseDN> <filter>
 *      
 * Example call:
 *      java -classpath "$JAVALIB/ldapjdk.jar:." LDAPSearchExample ldap.idevelopment.info 389 "" "" "o=airius.com" "(cn=*carter)"
 * -----------------------------------------------------------------------------
 * @version 1.0
 * @author  Jeffrey M. Hunter  (jhunter@idevelopment.info)
 * @author  http://www.idevelopment.info
 * -----------------------------------------------------------------------------
 */

public class LDAPSearchExample {

    //private String host       = "10.61.18.119";
    private String host       = "10.61.0.10";
    private int port          = 389;
    private String authid     = "cn=Manager,dc=spirent,dc=com";
    private String authpw     = "secret";
    private LDAPConnection ld = null;
    private String email      = "";

    /**
     * Used to print the usage for running this program from the command-line.
     * This method will normally be called when the user doesn't pass in the
     * correct number of arguments.
     */
    public static void printUsage() {
        String str = null;
        str = "java LDAPSearchExample <host> <port> <authdn> <authpw> <baseDN> <filter>";
        System.out.println(str);
    }

    /**
     * Constructor used to create this object.  Responsible for setting
     * this object's attributes used to login to the LDAP server as well as
     * the search string and baseDN.
     * @param args An array of strings that were passed into the main method
     *             of this program by the user. The proper attributes to this 
     *             object will be assigned from this array.
     */
    public LDAPSearchExample() {
        ld = new LDAPConnection();
    }
    
    public LDAPSearchExample(String host, int port, String authid, String authpw) {
    	this.host    = host;
        this.port    = port;
        this.authid  = authid;
        this.authpw  = authpw;
    	ld = new LDAPConnection();
   }
    
    public LDAPSearchExample(String authid, String authpw) {
        this.authid  = authid;
        this.authpw  = authpw;
    	ld = new LDAPConnection();
   }

    /**
     * Key method for this program. This method will perform the actual search
     * from the LDAP directory given the parameters provided by the user.
     */
    public boolean performSearch() {
        try {
            // Connect to the LDAP Server
            // System.out.println("Host: "+getHost()+"  Authid: "+getAuthid()+"  Authpw: "+getAuthpw());
            ld.connect(getHost(), getPort(), getAuthid(), getAuthpw());
   
            // String findDN = "CN=Xu\\, Jundong,OU=Users,OU=Beijing,DC=AD,DC=SPIRENTCOM,DC=COM";
            LDAPEntry foundEntry = null;
            String getAttrs[] = {"mail"};
            
            foundEntry = ld.read(getAuthid(), getAttrs );

            LDAPAttributeSet foundAttrs = foundEntry.getAttributeSet();
            int size = foundAttrs.size();
            Enumeration enumAttrs = foundAttrs.getAttributes();

            while ( enumAttrs.hasMoreElements() ) {
                 LDAPAttribute anAttr = ( LDAPAttribute )enumAttrs.nextElement();
                // String attrName = anAttr.getName();
                // System.out.println( "\t" + attrName );
                 Enumeration enumVals = anAttr.getStringValues();
                 while ( enumVals.hasMoreElements() ) {
                      String aVal = ( String )enumVals.nextElement();
                      setEmail(aVal);
                     // System.out.println( "\t\t" + aVal );
                 }
            }
            
        } catch (LDAPException e) {
            System.out.println(e.toString());
            return false;
        }

        // Finally, disconnect from the LDAP server
        if ( (ld != null) && ld.isConnected() ) {
            try {
                ld.disconnect();
                return true;
            } catch (LDAPException e) {
                System.out.println(e.toString());
                return false;
            }
        }
        return true;
    }

    /**
     * Method used to print the names and values of attributes of an entry.
     * 
     * @param entry The entry that contains the attributes
     * @param attrs An array of attribute names to display
     */
    public void printEntry(LDAPEntry entry, String[] attrs) {
    
        System.out.println("DN: " + entry.getDN());

        // Now, use the array to look through the attributes. It would also
        // have been possible to enumerate the attributes using getAttributes(),
        // but by passing them in this way, we have control of the display 
        // order. After printing all of the attributes using this method, I will
        // also provide a section below on how to enumerate the attributes using
        // the getAttributes() method.
  
        System.out.println();
        System.out.println("  Iterate through all attributes using hard-coded array");

        for (int i=0; i < attrs.length; i++) {
            LDAPAttribute attr = entry.getAttribute(attrs[i]);
            if (attr == null) {
                System.out.println("    [" + attrs[i] + ": not present]");
                continue;
            }
    
            Enumeration enumVals = attr.getStringValues();
            boolean hasVals = false;
            while ( (enumVals != null) && (enumVals.hasMoreElements()) ) {
                String val = (String) enumVals.nextElement();
                System.out.println("    [" + attrs[i] + ": " + val + "]");
                hasVals = true;
            }
            if (!hasVals) {
                System.out.println("    [" + attrs[i] + ": has no values]");
            }
        }


        // Now lets print out all of the attributes (again) using the 
        // getAttributes() method from an LDAPEntry. It is easy to print out
        // all attribute names and values in this way, but we don't really
        // have control of the display order.

        System.out.println();
        System.out.println("  Iterate through all attributes using getAttributes()");

        LDAPAttributeSet entryAttrs = entry.getAttributeSet();
        System.out.println("  Found " + entryAttrs.size() + " attributes.");
        Enumeration attrEnum = entryAttrs.getAttributes();
        while ( (attrEnum != null) && (attrEnum.hasMoreElements()) ){

            // Get the attribute
            LDAPAttribute attr = (LDAPAttribute) attrEnum.nextElement();

            if (attr == null) {
                System.out.println("    [" + attr.getName() + ": not present]");
                continue;
            }

            Enumeration enumVals = attr.getStringValues();
            boolean hasVals = false;
            while ( (enumVals != null) && (enumVals.hasMoreElements()) ) {
                String val = (String) enumVals.nextElement();
                System.out.println("    [" + attr.getName() + ": " +  val + "]");
                hasVals = true;
            }
            if (!hasVals) {
                System.out.println("    [" + attr.getName() + ": has no values]");
            }
        }
        
        System.out.println("---------------------------------------------");
    }

    /**
     * Method that overrides the toString() method of the core Object class.
     * This method is used to print an object, which in this case, will print
     * the LDAP server login and search parameters provided by the user from
     * the command-line.
     */
    public String toString() {
        String str = null;

        str = "Host   : " + this.host + "\n" +
              "Port   : " + this.port + "\n" +
              "AuthDN : " + this.authid + "\n" +
              "AuthPW : " + this.authpw;
        return(str);
    }

	public String getHost() {
		return host;
	}

	public int getPort() {
		return port;
	}
	
	public String getAuthid() {
		return authid;
	}

	public String getAuthpw() {
		return authpw;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
