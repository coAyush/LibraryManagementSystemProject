<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*,javax.servlet.http.*,java.util.*,LibraryManagement.Book"%>
<%@page session="true"%>
<%@include file="Header.jsp"%>
<%@include file="Footer.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Add Existing Books</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            body {
                background-color: #f8f9fa;
            }

            .card-strip {
                overflow-x: auto;
                overflow-y: hidden;
                white-space: nowrap;
                padding: 10px;
                background-color: #ffffff;
                border-radius: 10px;
                margin: 20px auto;
                box-shadow: 0 0 10px rgba(0,0,0,0.05);
                max-width: 95%;
            }


            .card-strip .card {
                display: inline-block;
                width: 220px;
                margin-right: 10px;
                vertical-align: top;
            }

            .card img {
                height: 120px;
                object-fit: contain;
            }

            .form-container {
                max-width: 700px;
                margin: auto;
                margin-top: 20px;
                padding: 25px;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            .scroll-label {
                font-weight: bold;
                margin-left: 30px;
                margin-bottom: -10px;
            }
        </style>
    </head>
    <body>

        <%
            String status = request.getParameter("Added");
            if (status != null) {
        %>
        <div class="container mt-3">
            <% if ("success".equalsIgnoreCase(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Added successfully</strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } else { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Could not add</strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
        </div>
        <% } %>

        <h5 class="scroll-label">📚 Existing Books (scroll if needed):</h5>
        <div class="card-strip">
            <%
                List<Book> books = (List<Book>) request.getAttribute("BOOKS");
                if (books != null && !books.isEmpty()) {
                    for (Book book : books) {
                        String imagePath = "Images/addbooks.png";

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
            <div class="card shadow-sm d-inline-block align-top" style="width: 220px; margin-right: 10px;">
                <img src="<%= imagePath%>" class="card-img-top" style="height: 120px; object-fit: contain;">
                <div class="card-body p-2">
                    <h6 class="card-title mb-1 text-center"><%= book.getTitle()%></h6>
                    <p class="card-text mb-1" style="font-size: 0.85rem;">Author: <%= book.getAuthor()%></p>
                    <p class="card-text mb-2" style="font-size: 0.85rem;">Available: <%= book.getCount()%></p>
                </div>
                <div class="card-footer bg-transparent border-0 p-2 pt-0">
                    <a href="pdf/<%= book.getPdf()%>" target="_blank" class="btn btn-sm btn-outline-primary w-100">Preview</a>
                </div>
            </div>

            <%  }
            } else { %>
            <div class="alert alert-warning text-center w-100">No books available to display.</div>
            <% }%>
        </div>

        <div class="form-container">
            <h4 class="text-center mb-4">➕ Add Copies to Existing Book</h4>
            <form class="row g-3" action="AddExisting" method="post">
                <div class="col-md-6">
                    <label for="titleInput" class="form-label">Title</label>
                    <input type="text" class="form-control" name="title" id="titleInput" required>
                </div>
                <div class="col-md-6">
                    <label for="countInput" class="form-label">Count</label>
                    <input type="number" class="form-control" name="count" id="countInput" required>
                </div>
                <div class="col-12 d-flex justify-content-center gap-3">
                    <button type="submit" class="btn btn-primary">Submit</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                    <button type="button" class="btn btn-danger" onclick="window.location.href = 'Admin.jsp'">Back</button>
                </div>
            </form>
        </div>

    </body>
</html>
