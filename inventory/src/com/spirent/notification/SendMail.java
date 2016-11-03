package com.spirent.notification;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;
import java.util.Properties;
import java.util.Vector;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.AuthenticationFailedException;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SendMail {

	private String mailTo = null;
	private String mailFrom = null;
	private String smtpHost = null;
	private boolean debug = false;
	@SuppressWarnings("unused")
	private String messageBasePath = null;
	private String subject = null;
	private String msgContent = null;
	private Vector<?> attachedFileList = null;
	@SuppressWarnings("unused")
	private String mailAccount = null;
	@SuppressWarnings("unused")
	private String mailPass = null;
	private String messageContentMimeType = "text/html; charset=gb2312";
	private String mailbccTo = null;
	private String mailccTo = null;
	private String MAIL_USER = null;
	private String MAIL_PASSWORD = null;
	
	public SendMail() {
		super();
//		smtpHost = GetConfig.getInfor(GetConfig.Config.SMTP_Server);
//		MAIL_USER = GetConfig.getInfor(GetConfig.Config.Mail_Sender);

//		MAIL_PASSWORD = GetConfig.getInfor(GetConfig.Config.Mail_Sender_Password);

//		mailFrom = "TestManager";

	}

	private void fillMail(Session session, MimeMessage msg) throws IOException,
			MessagingException {

		String fileName = null;
		Multipart mPart = new MimeMultipart();
		if (mailFrom != null) {
			msg.setFrom(new InternetAddress(mailFrom));
		} else {
			 System.out.println("no send mail address");
			return;
		}

		if (mailTo != null) {
			InternetAddress[] address = InternetAddress.parse(mailTo);
			msg.setRecipients(Message.RecipientType.TO, address);
		} else {
            System.out.println("no receive address");
			return;
		}

		if (mailccTo != null) {
			InternetAddress[] ccaddress = InternetAddress.parse(mailccTo);
			msg.setRecipients(Message.RecipientType.CC, ccaddress);
		}

		if (mailbccTo != null) {
			InternetAddress[] bccaddress = InternetAddress.parse(mailbccTo);
			msg.setRecipients(Message.RecipientType.BCC, bccaddress);
		}

		msg.setSubject(subject);
		InternetAddress[] replyAddress = { new InternetAddress(mailFrom) };
		msg.setReplyTo(replyAddress);

		// create and fill the first message part
		MimeBodyPart mBodyContent = new MimeBodyPart();
		if (msgContent != null)
			mBodyContent.setContent(msgContent, messageContentMimeType);
		else
			mBodyContent.setContent("", messageContentMimeType);

	   mPart.addBodyPart(mBodyContent);

		// attach the file to the message
		if (attachedFileList != null) {
			for (Enumeration<?> fileList = attachedFileList.elements(); 
			fileList.hasMoreElements();) {

				fileName = (String) fileList.nextElement();
				MimeBodyPart mBodyPart = new MimeBodyPart();

				// attach the file to the message
				FileDataSource fds = new FileDataSource(fileName);
				mBodyPart.setDataHandler(new DataHandler(fds));
				fileName = fileName.split(File.separator)[fileName
						.split(File.separator).length - 1];
				mBodyPart.setFileName(fileName);
				mPart.addBodyPart(mBodyPart);
			}
		}
		msg.setContent(mPart);
		msg.setSentDate(new Date());
	}

	public void init(){
	}

	@SuppressWarnings("static-access")
	public int sendMail() throws IOException, MessagingException {

		Properties props = System.getProperties();
		props.put("mail.smtp.host", smtpHost);
		if(MAIL_USER != null){
			props.put("mail.smtp.auth", "true");
		} else {
		   props.put("mail.smtp.auth", "false");
		}
		Session session = null;
		if(MAIL_USER != null){
			 session = Session.getDefaultInstance(props, new Authenticator(){ 
			      protected PasswordAuthentication getPasswordAuthentication() { 
			          return new PasswordAuthentication(MAIL_USER, MAIL_PASSWORD); 
			      }}); 
		} else {
		   session = Session.getDefaultInstance(props, null);
		}
		session.setDebug(this.debug);
		MimeMessage msg = new MimeMessage(session);
		Transport trans = null;

		try {
			fillMail(session, msg);
			if (mailTo == null) {
				return 1;
			}
			// send the message
			trans = session.getTransport("smtp");

			try {
				trans.connect(smtpHost, MAIL_USER, MAIL_PASSWORD);
			} catch (AuthenticationFailedException e) {
                System.out.println("Username, password or smtp server is not correct: " + e.getMessage());
				return 3;
			} catch (MessagingException e) {
				System.out.println("Message format is not correct: " + e.getMessage());
				return 3;
			}
			trans.send(msg);
			trans.close();
		} catch (MessagingException mex) {
			System.out.println("Message format is not correct: " + mex.getMessage());
			return 3;
		} finally {
			try {
				if (trans != null && trans.isConnected())
					trans.close();
			} catch (Exception e) {
				System.out.println("Cloes connection failed: " + e.getMessage());
			}
		}
    	return 0;
	}

	@SuppressWarnings("unchecked")
	public void setAttachedFileList(java.util.Vector filelist)
	{
		attachedFileList = filelist;
	}

	public void setDebug(boolean debugFlag)
	{
		debug = debugFlag;
	}

	public void setMailAccount(String strAccount) {
		mailAccount = strAccount;
	}

	public void setMailbccTo(String bccto) {
		mailbccTo = bccto;
	}

	public void setMailccTo(String ccto) {
		mailccTo = ccto;
	}

	public void setMailFrom(String from)
	{
		mailFrom = from;
	}

	public void setMailPass(String strMailPass) {

		mailPass = strMailPass;
	}

	public void setMailTo(String to)

	{
		mailTo = to;
	}

	public void setMessageBasePath(String basePath)

	{
		messageBasePath = basePath;
	}

	public void setMessageContentMimeType(String mimeType)

	{
		messageContentMimeType = mimeType;
	}

	public void setMsgContent(String content)

	{
		msgContent = content;
	}

	public void setSMTPHost(String host)

	{
		smtpHost = host;
	}

	public void setSubject(String sub)

	{
		subject = sub;
	}
	
	public void sendMail(SendMail sm, String msg, String smtpHost, String mailTo, String mailFrom, String subject)

	{
		try {
			sm.setSMTPHost(smtpHost);
			sm.setMailTo(mailTo);
			sm.setMailFrom(mailFrom);
			sm.setMsgContent(msg);
			sm.setSubject(subject);
			sm.sendMail();
		} catch (Exception e) {
			System.out.println("Error occurred in SendMail->sendMail: " + e.getMessage());
		}
	}
	
/*	public static void main(String[] argv) throws Exception

	{
		String msg = "Dear Xu, Jundong, you have just been done a reservation on LMS. Details follow:<p> <b>Reservation Organizer: </b>jxu<br><b> Reservation Description: </b>For sending mail testing.<br><b> Reservation Resources: </b>10.47.98.10//1/1,10.47.98.10//1/2<br><b> Reservation Start Date: </b>Thu Mar 4 00:00:00 UTC 0800 2010<br><b> Reservation End Date: </b>Thu Mar 4 12:00:00 UTC 0800 2010</p>";
		SendMail sm = new SendMail();
		String smtpHost = "smtp.spirentcom.com";
		String mailTo = "judo520@gmail.com";
		String mailFrom = "lms@spirentcom.com";
		sm.setMsgContent(msg);
		String subject = "LMS auto notification";
		sm.sendMail(sm, msg, smtpHost, mailTo, mailFrom, subject);
	}*/

}
