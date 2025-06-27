<%-- 
    Document   : SendUserMail.jsp
    Created on : 21 Jun, 2025, 10:33:22 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page import="java.sql.*,java.io.*,java.util.*;"%>
<%@page import="javax.servlet.http.*,javax.servlet.*,javax.mail.*,javax.mail.internet.*;"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <%
        final String from = "librarysystemxyz@gmail.com";
        final String pass = "vprtzczxtnuoazdb";
        HttpSession ses=request.getSession(false);
        String to=String.valueOf(ses.getAttribute("email"));
        String name=String.valueOf(ses.getAttribute("USER"));
        String subject = "Book Issue Details";
            String msg = "Dear " + name + ",\n\nYour book has been issued successfully.\nPlease check the attached receipt.\n\nThanks,\nLibrary Team";
            Properties props=new Properties();
            props.put("mail.smtp.auth", "true");                     // Must authenticate
            props.put("mail.smtp.starttls.enable", "true");          // Enable STARTTLS
            props.put("mail.smtp.host", "smtp.gmail.com");           // Gmail SMTP server
            props.put("mail.smtp.port", "587");                      // STARTTLS port
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
              Session sess=Session.getInstance(props,new javax.mail.Authenticator()
            {
               protected PasswordAuthentication getPasswordAuthentication(){
                   return new PasswordAuthentication(from,pass);
               } 
            });
                try {
                MimeMessage message = new MimeMessage(sess);
                message.setFrom(new InternetAddress(from));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject(subject);

                MimeBodyPart textPart = new MimeBodyPart();
                textPart.setText(msg);

                MimeBodyPart attachPart = new MimeBodyPart();
                String pdfPath=String.valueOf(ses.getAttribute("pdfPath"));
                attachPart.attachFile(new File(pdfPath));

                Multipart mp = new MimeMultipart();
                mp.addBodyPart(textPart);
                mp.addBodyPart(attachPart);

                message.setContent(mp);
                Transport.send(message);

                response.sendRedirect("BrowseBooksServlet?status=done");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("BrowseBooksServlet?status=notdone");
            }
    %>
</html>
