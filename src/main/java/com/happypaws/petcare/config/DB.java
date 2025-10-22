package com.happypaws.petcare.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DB {
    private static final String url = "jdbc:sqlserver://localhost:1433;databaseName=Final_db;integratedSecurity=true;encrypt=false";
    private static final String user = "sas";
    private static final String pass = "123";

    static{
        try{Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");}
        catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() throws Exception{
        return DriverManager.getConnection(url, user, pass);
    }
}



