<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page session="true"%>
<%@page import="LibraryManagement.EmailUtil"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mail</title>
    </head>
    <body>
        <%
            String to = request.getParameter("to");
            String name = request.getParameter("from");
            String subject = request.getParameter("subject");
            String message = request.getParameter("msg");
            String fullMessage = "Message from: " + name + "\n\n" + message;

            boolean sent = EmailUtil.sendEmail(to, subject, fullMessage);
            if (sent) {
                response.sendRedirect("Sending.jsp?status=sent");
            } else {
                response.sendRedirect("Sending.jsp?status=not sent");
            }
        %>
    </body>
</html>
