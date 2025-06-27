<%-- 
    Document   : Admin.jsp
    Created on : 17 Jun, 2025, 3:57:27 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page session="true"%>
<%@page import="javax.servlet.ServletContext"%>
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <style>
            .ho{
                font-weight: 600;
                color: #2c3e50; 
                font-family: 'Segoe UI', 'Poppins', 'Roboto', sans-serif;
                background: linear-gradient(90deg, #e0c3fc, #8ec5fc);
                padding: 12px 24px;
                font-size: 28px;
                display: inline-block;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
                animation: slideLeft 1s linear infinite; /* Faster */
                padding-left: 0;
               
                text-align: center;
            }
            .logout{
                position: absolute;
                margin-top: 25px;
                top: 20px;
                right: 20px;
                display:block
            }
        </style>                    
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    </head>
    <body>
        <%ServletContext cont = request.getServletContext();
            if (getServletContext().getAttribute("LoginDoneAdmin") == null || !getServletContext().getAttribute("LoginDoneAdmin").toString().equalsIgnoreCase("dontDisplay")) {%>

        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Logged in successfully</strong> 
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%}%>
        <%  cont.setAttribute("LoginDoneAdmin", "dontDisplay");%>
        <div>
            <marquee scrollamount="18" behavior="scroll" direction="left" style="text-align:center; width: 100%; ">  <P class="ho" style="font-family : Arial Black">Welcome <%=session.getAttribute("USER")%></P></marquee>
        </div>
        <div class="logout">
            <a href="Logout" class="btn btn-danger">Logout</a>
        </div>
        <div class="card" style="width: 18rem; display: inline-block">
            <img src="Images/addbooks.png" class="card-img-top" alt="...">
            <div class="card-body">
                <h5 class="card-title">Add Books</h5>
                <a href="BrowseBooksServlet" class="btn btn-primary">Add Existing</a>
                <a href="AddBooks.jsp" class="btn btn-primary"style="margin-left:10px">Add New</a>
            </div>
        </div>
        <div class="card" style="width: 18rem; display: inline-block">
            <img src="Images/user_remove.png" class="card-img-top" alt="...">
            <div class="card-body">
                <h5 class="card-title">Remove User</h5>
                <a href="RemoveUser.jsp" class="btn btn-primary">Delete</a>
            </div>
        </div>
    </body>
</html>
