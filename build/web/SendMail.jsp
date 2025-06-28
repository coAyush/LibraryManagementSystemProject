<%-- 
    Document   : SendMail.jsp
    Created on : 20 Jun, 2025, 11:53:43 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page session="true"%>
<%@page import="java.sql.*,java.io.*,java.util.*;"%>
<%@page import="javax.servlet.http.*,javax.servlet.*,javax.mail.*,javax.mail.internet.*;"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mail</title>
    </head>
    <body>
        <% final String user = "management mail";
            final String pass = "your 16  characters app password";
            String to = request.getParameter("to");
            String name = request.getParameter("from");
            String subject = request.getParameter("subject");
            String message = request.getParameter("msg");
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");                     // Must authenticate
            props.put("mail.smtp.starttls.enable", "true");          // Enable STARTTLS
            props.put("mail.smtp.host", "smtp.gmail.com");           // Gmail SMTP server
            props.put("mail.smtp.port", "587");                      // STARTTLS port
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            Session ses=Session.getInstance(props,new javax.mail.Authenticator()
            {
               protected PasswordAuthentication getPasswordAuthentication(){
                   return new PasswordAuthentication(user,pass);
               } 
            });
            try{
            MimeMessage mess=new MimeMessage(ses);   
            mess.setFrom(new InternetAddress(user));
            mess.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            mess.setSubject(subject);
            String fullMessage = "Message from: " + name + "\n\n" + message;
            mess.setText(fullMessage);
            Transport.send(mess);
            response.sendRedirect("Sending.jsp?status=sent");
            }catch(MessagingException e){
                e.printStackTrace();
                response.sendRedirect("Sending.jsp?status=not sent");

            }
        %>
    </body>
</html>
