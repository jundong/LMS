package com.spirent.javaconnector;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;

import com.spirent.initparameters.InitBaseParameters;

public class DataBaseConnection {
	private static String     
    driver="org.gjt.mm.mysql.Driver",//Driver 
    url = InitBaseParameters.getDbPath(),//URL    
    Name= InitBaseParameters.getUsername(),//DB User Name    
    Password= InitBaseParameters.getPassword();//DB Password
	private static Class driverClass = null;    
    private static ObjectPool connectionPool = null; 
    
    public DataBaseConnection(){           
    } 
    /**    
     * Start DataBase connection pool    
     * @throws Exception    
     */     
    public static void StartPool() {    
      
        initDataSource();     
        if (connectionPool != null) {     
            ShutdownPool();     
        }      
        try {     
        	GenericObjectPool pool = new GenericObjectPool(null);  
        	pool.setMaxActive(20);
            connectionPool = pool;     
            ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(url, Name, Password);     
            PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true);     
            Class.forName("org.apache.commons.dbcp.PoolingDriver");     
            PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");     
            driver.registerPool("dbpool", connectionPool);                  
       
        } catch (Exception e) {     
            e.printStackTrace();    
        }     
    }     
    /**    
     * Initial DataSource    
     */     
    private static synchronized void initDataSource() {             
        if (driverClass == null) {     
            try {     
                driverClass = Class.forName(driver);     
            } catch (ClassNotFoundException e) {     
                e.printStackTrace();    
            }     
        }     
    }
    /**    
     * Release DataBase Pool
     */     
    public static void ShutdownPool() {     
        try {     
            PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");     
            driver.closePool("dbpool");    
        } catch (SQLException e) {     
            e.printStackTrace();    
        }     
    }         
     
    /**    
     * Get connection from DataBase connection pool    
     * @return    
     */     
    public static Connection getConnection() {     
        Connection conn = null;     
        if(connectionPool == null)     
            StartPool();     
        try {     
            conn = DriverManager.getConnection("jdbc:apache:commons:dbcp:dbpool");     
        } catch (SQLException  e) {     
            e.printStackTrace();    
        }     
        return conn;     
    }     
        
    /**   
     * Get connection    
     * getConnection   
     * @param name   
     * @return   
     */   
    public static Connection getConnection(String name){    
        return getConnection();    
    }    
    /**   
     * Release connection   
     * freeConnection   
     * @param conn   
     */   
    public static void freeConnection(Connection conn){    
        if(conn != null){    
            try {    
                conn.close();    
            } catch (SQLException e) {                  
                e.printStackTrace();    
            }    
        }    
    }    
    /**   
     * Release connection   
     * freeConnection   
     * @param name   
     * @param con   
     */   
    public static void freeConnection (String name,Connection con){    
        freeConnection(con);    
    } 
    
    /**   
     * Example   
     * main   
     * @param args   
     */   
/*    public static void main(String[] args) {  
    	 Statement stmt = null;
    	 ResultSet rs = null;
    	 Connection conn = null;
        try {    
            conn = DataBaseConnection.getConnection();    
            if(conn != null){    
            	stmt = conn.createStatement();    
                rs = stmt.executeQuery("select * from users");    
         
                while(rs.next()){                       
                    System.out.println(rs.getString("username"));    
            }    
               
            }
         } catch (Exception e) {              
            e.printStackTrace();    
        }finally {
        	try {
        		if(rs != null){
        			rs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(conn != null){
        			DataBaseConnection.freeConnection(conn); 
        		}
        	} catch (Exception e) {      
    			System.out
				.println("Close DB error occourred in AddDUT.java: "
						+ e.getMessage());
        	}
        } 
   
    } */ 
}
