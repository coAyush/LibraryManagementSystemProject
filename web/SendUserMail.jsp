<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>
<%@page import="LibraryManagement.EmailUtil"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Issue Receipt Mail</title>
    </head>
    <%
        HttpSession ses = request.getSession(false);
        if (ses != null) {
            String to = String.valueOf(ses.getAttribute("email"));
            String name = String.valueOf(ses.getAttribute("USER"));
            String subject = "Book Issue Details";
            String msg = "Dear " + name + ",\n\nYour book has been issued successfully.\nPlease check the attached receipt.\n\nThanks,\nLibrary Team";
            String pdfPath = String.valueOf(ses.getAttribute("pdfPath"));

            boolean sent = EmailUtil.sendEmailWithAttachment(to, subject, msg, pdfPath);
            if (sent) {
                response.sendRedirect("BrowseBooksServlet?status=done");
            } else {
                response.sendRedirect("BrowseBooksServlet?status=notdone");
            }
        } else {
            response.sendRedirect("Login.jsp");
        }
    %>
</html>
