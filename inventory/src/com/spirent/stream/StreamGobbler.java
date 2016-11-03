package com.spirent.stream;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.spirent.initparameters.InitBaseParameters;

public class StreamGobbler {
    InputStream is;
    String path;
    String infor;
    
    public StreamGobbler(InputStream is, String infor, String path)
    {
        this.is = is;
        this.infor = infor;
        this.path = path;
    }
    
    public StreamGobbler(String path)
    {
        this.path = path;
    }
    
    public void run()
    {
        try
        {
        	FileWriter fw=new FileWriter(getPath() + "AddResource.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");    
            	System.out.println(line);
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();     
              }
    }

	public InputStream getIs() {
		return is;
	}

	public String getPath() {
		return path;
	}

	public String getInfor() {
		return infor;
	}
	
    public FileOutputStream fileOS(String loginUser)
    {   
    	FileOutputStream  fos = null;
        try
        {
            File file = new File(getPath() + "ExportResults_"+loginUser+".csv");
            if (file.exists()) {
                file.delete();
                file.createNewFile();
            } else {
            	file.createNewFile();
            }
            fos = new FileOutputStream(file); 
            
        } catch (IOException ioe){
                ioe.printStackTrace();  
        }
        return fos;
    }
    
    public FileOutputStream inventoryOS(String loginUser)
    {   
    	FileOutputStream  fos = null;
        try
        {
            File file = new File(getPath() + "ExportInventory_"+loginUser+".csv");
            if (file.exists()) {
                file.delete();
                file.createNewFile();
            } else {
            	file.createNewFile();
            }
            fos = new FileOutputStream(file); 
            
        } catch (IOException ioe){
                ioe.printStackTrace();  
        }
        return fos;
    }
    
    public void updateChassis()
    {
        try
        {   
        	FileWriter fw=new FileWriter(getPath() + "UpdateChassis.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");    
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
    
    public void updateChassisStatus()
    {
        try
        {   
        	FileWriter fw=new FileWriter(getPath() + "UpdateChassisStatus.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");    
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
    
    public void updateAV()
    {
        try
        {   
        	FileWriter fw=new FileWriter(getPath() + "UpdateAV.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");    
            	//System.out.println("UpdateAVDB Log: " + line);
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
    public void updatePC()
    {
        try
        {   
        	FileWriter fw=new FileWriter(getPath() + "UpdatePC.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");    
            	//System.out.println("UpdateAVDB Log: " + line);
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
    
    public void updateVM()
    {
        try
        {   
        	FileWriter fw=new FileWriter(getPath() + "UpdateVM.log");
            InputStreamReader isr = new InputStreamReader(getIs());
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null) {
            	fw.write(getInfor() + ">" + line + "\n");
            }
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
    public void initRunScriptsLib(String tclLibPath)
    {
        try
        {   
        	File fileDir = new File(getPath() + "mysqltcl-3.03/");
            if (!fileDir.exists()) {
            	fileDir.mkdirs();
            }
            
        	File file = new File(getPath() + "mysqltcl-3.03/pkgIndex.tcl");
            if (file.exists()) {
                file.delete();
                file.createNewFile();
            } else {
            	file.createNewFile();
            }
            
        	FileWriter fw=new FileWriter(file);
            fw.write("proc loadmysqltcl { dir } {" + "\n");
            fw.write("set oldcwd [pwd]" + "\n"); 
            fw.write("cd $dir" + "\n");
            fw.write("load libmysqltcl[info sharedlibextension]" + "\n"); 
            fw.write("cd $oldcwd" + "\n");
            fw.write("}" + "\n");
            fw.write("set dir {" + tclLibPath + "mysqltcl-3.03}" + "\n");
            fw.write("set dirUtils {" + tclLibPath + "}" + "\n");
            fw.write("package ifneeded mysqltcl 3.03 [list loadmysqltcl $dir]" + "\n");
            fw.write("package ifneeded mysqlutils 1.0 [list source [file join $dirUtils mysqlutils.tcl]]" + "\n");
            fw.close();
        } catch (IOException ioe)
              {
                ioe.printStackTrace();  
              }
    }
}



