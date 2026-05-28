package com.service;

import com.beans.UserPojo;
import com.dao.DAOInterface;

public interface LoginValidationInterface {

    public boolean signUp(UserPojo p);
    
    public boolean signIn(String username , String password);
    
    public String forgetPassword(String username  , String question , String answer);
    
    public void updatePassword(String username  , String question , String answer); // Keep this one
    
    // REMOVE this duplicate method - it's causing ambiguity
    //public boolean updatePassword(String username, String newPassword);

    public void setDAO(DAOInterface DAOobj);
    
    public boolean updateUserPassword(String username, String newPassword);
}