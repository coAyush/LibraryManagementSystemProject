<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page session="true"%>
<%@page import="LibraryManagement.EmailUtil"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send OTP Mail</title>
    </head>
    <body>
        <%
            // Get email and otp from session
            String to = (String) session.getAttribute("email");
            Integer otp = (Integer) session.getAttribute("otp");

            // Check if email and otp are not null
            if (to == null || (otp == null && session.getAttribute("newPass") == null)) {
                out.println("<h3 style='color:red;'>Session expired or invalid. Please try again.</h3>");
                return;
            }

            String subject = "";
            String message = "";
            if (session.getAttribute("otp") != null) {
                subject = "OTP Generated";
                message = "Your OTP is: " + otp;
            } else {
                subject = "Password Updated";
                message = "Your new password is: " + (String) session.getAttribute("newPass");
            }

            boolean sent = EmailUtil.sendEmail(to, subject, message);
            if (!sent) {
                session.setAttribute("mailError", EmailUtil.getLastError());
            } else {
                session.removeAttribute("mailError");
            }

            if (session.getAttribute("otp") != null) {
                response.sendRedirect("forgotPassword.jsp?status=" + (sent ? "otpgenerated" : "sendfailed"));
            } else if (session.getAttribute("newPass") != null) {
                response.sendRedirect("forgotPassword.jsp?status=" + (sent ? "passwordchanged" : "sendfailed"));
            }
        %>
    </body>
</html>
