<%-- 
    Document   : forgotPassword
    Created on : 23 Jun, 2025, 10:19:15 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Password Reset</title>
    </head>
    <body>
       <%
    String status = request.getParameter("status");
    if (status != null) {
        String alertClass = "info";
        String alertMsg = "Unknown status.";

        if ("otpgenerated".equals(status)) {
            alertClass = "primary";
            alertMsg = "OTP has been sent to your email.";
        } else if ("verified".equals(status)) {
            alertClass = "success";
            alertMsg = "OTP verified. Please enter your new password.";
        } else if ("passwordchanged".equals(status)) {
            alertClass = "success";
            alertMsg = "Password updated successfully!";
        } else if ("sendfailed".equals(status)) {
            alertClass = "danger";
            alertMsg = "Failed to send email. Please try again.";
        } else if ("updatefailed".equals(status)) {
            alertClass = "danger";
            alertMsg = "Failed to update password. Please try again.";
        }
%>
<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="info-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8 0a8 8 0 1 0 0 16A8 8 0 0 0 8 0zM8.93 4.58a.905.905 0 1 1-1.81 0 .905.905 0 0 1 1.81 0zM8 6.999a.5.5 0 0 1 .5.5v3a.5.5 0 0 1-1 0v-3a.5.5 0 0 1 .5-.5z"/>
    </symbol>
    <symbol id="check-circle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
    </symbol>
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8 0c-.535 0-1.05.21-1.414.586L.586 6.586a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 8 16a2 2 0 0 0 1.414-.586l6-6a2 2 0 0 0 0-2.828l-6-6A1.99 1.99 0 0 0 8 0zM7 4h2v4H7V4zm0 6h2v2H7v-2z"/>
    </symbol>
</svg>

<div class="container mt-3">
    <div class="alert alert-<%= alertClass %> alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Info:">
            <use xlink:href="#<%= "danger".equals(alertClass) ? "exclamation-triangle-fill" : "check-circle-fill" %>" />
        </svg>
        <strong><%= alertMsg %></strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</div>
<%
    }
%>

        <form action="GenerateOtp" method="post">
            <input type="email" placeholder="enter your mail" value="<%=session.getAttribute("email") != null ? session.getAttribute("email") : "" %>" required>
            <input type="submit" value="generate Otp">
            <input type="reset" value="clear">
        </form>
          <form action="VerifyOtp" method="post">
            <input type="number" placeholder="enter  otp sent" name="verify">
            <input type="submit" value="verify">
            <input type="reset" value="clear">
        </form>
            <%
boolean verified = "verified".equals(status);
%>

<% if (verified) { %>
    <form action="PasswordReset" method="post">
        <input type="text" name="newPass" placeholder="Enter your new password" required>
        <input type="submit" value="Submit">
        <input type="reset" value="Clear">
    </form>
<% } %>
 <button type="button" class="btn btn-warning" onclick="window.location.href = 'Login.jsp'">Back</button>
    </body>
</html>
