<%-- 
    Document   : Sending.jsp
    Created on : 20 Jun, 2025, 11:25:35 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp"%>
<%@page session="true"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            .i{
                margin-top: 5px;
                display: flex;
                column-gap: 2px;
            }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send Mail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    </head>
    <body>
        <% String s = request.getParameter("status");
            if (s != null) {
                if ("sent".equalsIgnoreCase(s)) {
        %>
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="check-circle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
    </symbol>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#check-circle-fill"/></svg><strong> Mail sent successful</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%} else {%>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
    </symbol>
    </svg>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">       
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>     <strong>Not sent</strong>   
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%}
        }%>
    <form action="SendMail.jsp" method="post">  
        <div class="container">
            <div class="input-group mb-3">
                <span class="input-group-text" id="basic-addon1">To</span>
                <input type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1" value="ayushchowdhury719@gmail.com" name="to" readonly required>
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text" id="basic-addon1">From</span>
                <input type="text" class="form-control" placeholder="Enter your mail address" aria-label="Username" aria-describedby="basic-addon1" value="<%=(String)session.getAttribute("email")%>" name="from" required readonly>
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text" id="basic-addon1">Subject</span>
                <input type="text" class="form-control" placeholder="Subject" aria-label="Recipient's username" aria-describedby="basic-addon2"  name="subject" required>

            </div>
            <div class="input-group">
                <span class="input-group-text">Message</span>
                <textarea class="form-control" aria-label="With textarea" name="msg" required></textarea>
            </div>
            <div class="i">
                <button type="submit" class="btn btn-primary" >Submit</button>
                <button type="reset" class="btn btn-secondary" >Clear</button>
                <button type="button" class="btn btn-warning" onclick="window.location.href = 'Home.jsp'">Back</button>
            </div>
        </div>

    </body>
</html>
