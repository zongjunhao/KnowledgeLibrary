package com.syzc.common.kit;


import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;

import com.syzc.common.config.Constant;



@SuppressWarnings("serial")
public class SendMail extends HttpServlet {

	private Properties properties; // 系统属性
	private Session mailSession; // 邮件会话对象
	private MimeMessage mimeMessage; // MIME邮件对象
	private String mailFromString = Constant.MAILNAME; 
	private String mailToString;
	private String mailBodyString;
	private String mailCopyToString = null;
	private String mailBCopyToString = null;
	private String mailSubjectString = "系统消息"; // 根据实际情况传入
	
	public SendMail() {
		
		String sMTPHostString = Constant.SMTPHOST;
		String portString = Constant.MAILPORT;
		String mailUsernameString = Constant.MAILNAME;
		String mailPasswordString = Constant.MAILPSW;
		Auth auth = new Auth(mailUsernameString, mailPasswordString);
		
		// 设置系统属性
		properties = java.lang.System.getProperties(); // 获得系统属性对象
		properties.put("mail.smtp.host", sMTPHostString); // 设置SMTP主机
		properties.put("mail.smtp.port", portString); // 设置服务端口号
		properties.put("mail.smtp.auth", "true"); // 同时通过验证
		// 获得邮件会话对象
		mailSession = Session.getInstance(properties, auth);	
	}
	
	public boolean sendingMail(String stuNameString, String stuEmailString, String contentString) { // 设置参数，传入收件人信息
		
		try {
			mailToString = stuEmailString;
			mailBodyString = "<p>尊敬的 " + stuNameString + ",<br/><br/>您在系统中收到如下信息：</p>" + "<p>" + contentString + "</p>";
			// 创建MIME邮件对象
			mimeMessage = new MimeMessage(mailSession);
			// 设置发信人
			mimeMessage.setFrom(new InternetAddress(mailFromString));
			// 设置收信人
			if (mailToString != null) {
				
				mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailToString));
			}
			// 设置抄送人
			if (mailCopyToString != null) {
				
				mimeMessage.setRecipients(javax.mail.Message.RecipientType.BCC, InternetAddress.parse(mailBCopyToString));
			}
			// 设置暗送人
			if (mailBCopyToString != null) {
				mimeMessage.setRecipients(javax.mail.Message.RecipientType.BCC, InternetAddress.parse(mailBCopyToString));
			}
			// 设置邮件主题
			mimeMessage.setSubject(mailSubjectString, "gb2312");
			// 设置邮件内容，将邮件body部分转化为HTML格式
			mimeMessage.setContent(mailBodyString, "text/html;charset=gb2312");
			// 发送邮件
			Transport.send(mimeMessage);
			return true;
		} catch (Exception e) {
			
			e.printStackTrace();
			return false;
		} 
	}
}
