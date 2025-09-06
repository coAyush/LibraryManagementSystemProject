<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page session="true"%>
<%@page import="java.util.*,javax.mail.*,javax.mail.internet.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send OTP Mail</title>
    </head>
    <body>
        <%
            final String user = "librarysystemxyz@gmail.com";
            final String pass = "vprtzczxtnuoazdb";

            // Get email and otp from session
            String to = (String) session.getAttribute("email");
            Integer otp = (Integer) session.getAttribute("otp");

            // Check if email and otp are not null
            if (to == null || (otp == null && session.getAttribute("newPass")==null)) {
                out.println("<h3 style='color:red;'>Session expired or invalid. Please try again.</h3>");
                return;
            }
            String subject="",message="";
            if(session.getAttribute("otp")!=null){
                subject="otp generated";
                message="your otp is "+String.valueOf(otp);
            }
            else{
                subject="Password Updated";
                message="your new password is "+(String)session.getAttribute("newPass");
            }
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            // Mail Session
            Session ses = Session.getInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, pass);
                }
            });

            try {
                MimeMessage mess = new MimeMessage(ses);
                mess.setFrom(new InternetAddress(user));
                mess.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                mess.setSubject(subject);
                mess.setText(message);
                Transport.send(mess);

                // OTP sent successfully
                if(session.getAttribute("otp")!=null){
                response.sendRedirect("forgotPassword.jsp?status=otpgenerated");
                }
                else if(session.getAttribute("newPass")!=null){
                response.sendRedirect("forgotPassword.jsp?status=passwordchanged");
                }
            } catch (MessagingException e) {
                e.printStackTrace();
                response.sendRedirect("forgotPassword.jsp?status=sendfailed");
            }
        %>
    </body>
</html>
