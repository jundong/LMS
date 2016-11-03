package com.spirent.ldap;
//This class is no longer used.
public class GenerateDN {
    private String[] Site = {"Beijing", "Calabasas", "Crawley", "Eatontown", "Fort Worth", 
    		"Honolulu", "Ottawa", "Paignton", "Paris", "Plano", "Raleigh", 
    		"Rockvile", "Sunnyvale"};
    private String[] contractorSite = {"Beijing", "Calabasas", "Crawley", "Eatontown", "Fort Worth", 
    		"Germantown", "Honolulu", "Ottawa", "Paignton", "Paris", "Plano", "Raleigh", "Sunnyvale"};    
    
    private String userName = "";
    
	public String getUserName() {
		return userName;
	}
    
	public GenerateDN(String username) {
		this.userName = username;
	}
	
	public String[] GenerateBindDN(){
		String[] DN = new String[26];
		
		for (int i = 0; i < getSite().length; i++){
		    String tmp = "CN="+getUserName()+",OU=Users,OU="+Site[i]+",DC=AD,DC=SPIRENTCOM,DC=COM";
		    DN[i] = tmp;
		}
		for (int i = 0; i < getContractorSite().length; i++){
		    String tmp = "CN="+getUserName()+",OU="+Site[i]+",OU=Contractors,DC=AD,DC=SPIRENTCOM,DC=COM";
		    DN[13+i] = tmp;
		}		
        return DN;
	}

	public String[] getSite() {
		return Site;
	}

	public String[] getContractorSite() {
		return contractorSite;
	}
}
