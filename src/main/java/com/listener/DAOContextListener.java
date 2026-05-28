package com.listener;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextAttributeEvent;
import jakarta.servlet.ServletContextAttributeListener;
import jakarta.servlet.annotation.WebListener;

//listner for Centralized db connection

@WebListener
public class DAOContextListener implements  ServletContextAttributeListener {

	Connection con;
	ServletContext c;
	
	public void attributeAdded(ServletContextAttributeEvent e)  { 
		
		c = e.getServletContext();
		
		try {
			Class.forName(c.getInitParameter("driver"));
			con = DriverManager.getConnection(c.getInitParameter("url"), c.getInitParameter("username"), c.getInitParameter("password"));
			System.out.println("connection object....."+con);
			
			c.setAttribute("DBCon", con);
			
		
		} catch (ClassNotFoundException e1) {

			e1.printStackTrace();
		} catch (SQLException e1) {
			
			e1.printStackTrace();
		}
	
	}
	

	public void attributeRemoved(ServletContextAttributeEvent e)  { 

		try {
			con = (Connection) c.getAttribute("DBCon");
			con.close();
			
		} catch (SQLException e1) {
			
			e1.printStackTrace();
		}
		
	}
	
	
    public void attributeReplaced(ServletContextAttributeEvent e)  { 

    }

}
