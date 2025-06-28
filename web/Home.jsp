<%-- 
    Document   : Home.jsp
    Created on : 12 Jun, 2025, 8:53:52 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page  import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="javax.servlet.ServletContext"%>
<%@page session = "true" %> 
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .card h5 {
            margin-bottom: 0;
        }
        .logout {
            position: absolute;
            top: 20px;
            right: 20px;
            display:inline-block
        }
        .he{
            text-align: center;
            
        }
        .he h1:hover{
            background-color: lightblue;
        }
        .he h1{
            border-radius: 5px;
            font-family: Arial;
            font-weight: bolder;
            color : whitesmoke;
            background-color: graytext;
            display: inline-block;
            padding: 10px 20px;  
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="he">
        <h1>Welcome,<%= session.getAttribute("USER")%></h1>
    </div>
<div class="logout">
    <a href="Logout" class="btn btn-danger">Logout</a>
</div>
    <% String logindone=(String)session.getAttribute("loginDone");
if(logindone!=null && "yes".equalsIgnoreCase(logindone)){%>
 <div class="alert alert-danger alert-dismissible fade show" role="alert">
  <strong>Logged in successfully</strong> 
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>

<%}%>
<%   session.removeAttribute("loginDone");%>;
    <h1 class="mb-4">Welcome to the Library Portal</h1>
    <div class="container">
    <div class="row justify-content-center">
        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h5>Browse Books</h5>
                <p>Search and explore available books in the library.</p>
                <a href="BrowseBooksServlet" class="btn btn-primary">Explore</a>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h5>My Account</h5>
                <p>Check your borrowed books and due dates.</p>
                <a href="MyAccount.jsp" class="btn btn-primary">View</a>
            </div>
        </div>
       <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h5>Return Book</h5><br>
                <p>Return the issued books</p>
                <a href="Return.jsp" class="btn btn-primary">Return</a>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card p-4">
                <h5>Contact Librarian</h5>
                <p>Need help? Contact the library staff.</p>
                <a href="Sending.jsp" class="btn btn-primary">Contact</a>
            </div>
        </div>
    </div>
    </div>
</body>
</html>
