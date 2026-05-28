package com.aspects;

import com.service.LoginValidationInterface;

public class ObjectProvider {

	
	public static LoginValidationInterface  createObject(String className) {
		
		LoginValidationInterface obj=null;
		
		try {
			
			obj= (LoginValidationInterface) Class.forName(className).newInstance();
			
			
		} catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {

			e.printStackTrace();
		}
		
		return obj;
		
		
	}
	
}
