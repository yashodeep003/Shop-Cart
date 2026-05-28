package com.serviceImpl;

import java.sql.Connection;

import com.beans.UserPojo;
import com.dao.DAOInterface;
import com.service.LoginValidationInterface;

public class ServicesImpl implements LoginValidationInterface {	
	
	DAOInterface DAOobj = null;
	Connection con;
	
	
	@Override
	public void setDAO(DAOInterface DAOobj) {
		this.DAOobj = DAOobj;
		
	}
	

	
	@Override
	public boolean signUp(UserPojo p) {		
		
		int value = DAOobj.insertData(p);
		if(value!=0) {
			return true;
		}
		
		return false;
		
	}

	@Override
	public boolean signIn(String username, String password) {

		boolean isValid =DAOobj.retriveData(username, password);
		
		return isValid;
	}

	@Override
	public String forgetPassword(String username, String question, String answer) {

		boolean isValid = DAOobj.verifySecurityQuestion(username, question, answer);
		
		if(isValid) {
			return 	"success";
		}
		else {
			return "Invalid security question or answer";
		}
	}

	@Override
	public void updatePassword(String username, String question, String answer) {

		DAOobj.verifySecurityQuestion(username, question, answer);
		
	}
	
	// Keep this method but don't include it in the interface
	public boolean updateUserPassword(String username, String newPassword) {
		return DAOobj.updatePassword(username, newPassword);
	}
}