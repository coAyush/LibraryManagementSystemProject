<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*, javax.servlet.http.*"%>
<%@page import="LibraryManagement.Book"%>
<%@page import="java.util.*"%>
<%@page session="true"%>
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Explore Books</title>
        <meta charset="UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">
                <a class="navbar-brand">Welcome <%= session.getAttribute("USER")%></a>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link active" href="Home.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="Logout">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <%String d = request.getParameter("status");
            if (d != null) {
                if ("done".equalsIgnoreCase(d)) {

        %>
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="check-circle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
    </symbol>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#check-circle-fill"/></svg><strong> Book Issued...Check your mail</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%} else {

    %>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
    </symbol>
    </svg>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">       
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>     <strong>Something went wrong book not issued</strong>   
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% }
        }%>

    <div class="container mt-4">
        <div class="row g-4">
            <%
                List<Book> books = (List<Book>) request.getAttribute("BOOKS");
                if (books != null && !books.isEmpty()) {
                    for (Book book : books) {
                        String imagePath = "Images/addbooks.png"; // default fallback

                        if (book.getTitle().equalsIgnoreCase("JSP_Tutorial")) {
                            imagePath = "Images/JSP_Tutorial.jpg";
                        } else if (book.getTitle().equalsIgnoreCase("The Complete Reference")) {
                            imagePath = "Images/The Complete Reference.jpeg";
                        } else if (book.getTitle().equalsIgnoreCase("Spring ")) {
                            imagePath = "Images/spring.png";
                        } else if (book.getTitle().equalsIgnoreCase("Sevlets_Tutorial")) {
                            imagePath = "Images/Sevlets_Tutorial.jpeg";
                        } else if (book.getTitle().equalsIgnoreCase("Mathematical Physics")) {
                            imagePath = "Images/Mathematical Physics.jpeg";
                        }
            %>
            <div class="col-md-3">
                <div class="card h-100 shadow-sm">
                    <img src="<%= imagePath%>" class="card-img-top" style="height: 200px; object-fit: contain;">
                    <div class="card-body">
                        <h5 class="card-title"><%= book.getTitle()%></h5>
                        <p class="card-text">Author: <%= book.getAuthor()%></p>
                        <p class="card-text">Available: <%= book.getCount()%></p>
                        <div class="d-grid gap-2">
                            <a href="<%=request.getContextPath()%>/AddDB?title=<%= java.net.URLEncoder.encode(book.getTitle(), "UTF-8")%>"
                               class="btn btn-primary">Issue</a>
                            <a href="pdf/<%= book.getPdf()%>" target="_blank" class="btn btn-secondary">Preview</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12">
                <div class="alert alert-warning text-center">No books available to display.</div>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
