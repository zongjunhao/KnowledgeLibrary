package com.syzc.common.kit;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Auth extends Authenticator {

	private String usernameString = " ";
	private String passwordString = " ";
	
	public Auth(String usernameString, String passwordString) {
		
		this.usernameString = usernameString;
		this.passwordString = passwordString;
	}
	
	public PasswordAuthentication getPasswordAuthentication() {
		
		return new PasswordAuthentication(usernameString, passwordString);
	}
	

}
