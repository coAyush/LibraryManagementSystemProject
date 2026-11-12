<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*,javax.servlet.http.*,java.util.*,java.sql.*,LibraryManagement.Book,LibraryManagement.DBConnection"%>
<%@page session="true"%>
<%
    String role = (String) session.getAttribute("Role");
    if (session.getAttribute("USER") == null || !"Admin".equalsIgnoreCase(role)) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Existing Books - Admin</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .card-strip {
                overflow-x: auto;
                overflow-y: hidden;
                white-space: nowrap;
                padding: 15px;
                background-color: #ffffff;
                border-radius: 10px;
                margin: 20px auto;
                box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            }
            .card-strip .card {
                display: inline-block;
                width: 220px;
                margin-right: 15px;
                vertical-align: top;
                white-space: normal;
            }
            .card img {
                height: 140px;
                object-fit: contain;
                padding: 10px;
            }
            .form-container {
                max-width: 650px;
                margin: 20px auto;
                padding: 25px;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">Admin Portal</a>
                <div class="ms-auto">
                    <a href="Admin.jsp" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
                    <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String status = request.getParameter("Added");
                if (status != null) {
            %>
            <div class="alert alert-<%= "success".equalsIgnoreCase(status) ? "success" : "danger" %> alert-dismissible fade show" role="alert">
                <strong><%= "success".equalsIgnoreCase(status) ? "✅ Stock added successfully!" : "❌ Could not add stock. Please check title." %></strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%  } %>

            <h5 class="fw-bold mb-2">📚 Current Inventory:</h5>
            <div class="card-strip">
                <%
                    List<Book> books = (List<Book>) request.getAttribute("BOOKS");
                    if (books == null) {
                        books = (List<Book>) getServletContext().getAttribute("booklist");
                    }
                    if (books == null) {
                        books = new ArrayList<Book>();
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = DBConnection.getConnection();
                            ps = conn.prepareStatement("SELECT * FROM books");
                            rs = ps.executeQuery();
                            while (rs.next()) {
                                books.add(new Book(rs.getString("title"), rs.getString("author"), rs.getString("pdf"), rs.getInt("count")));
                            }
                            getServletContext().setAttribute("booklist", books);
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            DBConnection.closeQuietly(rs, ps, conn);
                        }
                    }

                    if (books != null && !books.isEmpty()) {
                        for (Book book : books) {
                            String imagePath = "Images/addbooks.png";
                            if ("JSP_Tutorial".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/JSP_Tutorial.jpg";
                            } else if ("The Complete Reference".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/The Complete Reference.jpeg";
                            } else if ("Spring ".equalsIgnoreCase(book.getTitle()) || "Spring".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/spring.png";
                            } else if ("Sevlets_Tutorial".equalsIgnoreCase(book.getTitle()) || "Servlets_Tutorial".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/Sevlets_Tutorial.jpeg";
                            } else if ("Mathematical Physics".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/Mathematical Physics.jpeg";
                            } else if ("Spring Boot".equalsIgnoreCase(book.getTitle())) {
                                imagePath = "Images/Spring Boot.jpg";
                            }
                %>
                <div class="card shadow-sm">
                    <img src="<%= imagePath %>" class="card-img-top" alt="<%= book.getTitle() %>">
                    <div class="card-body p-2 text-center">
                        <h6 class="card-title fw-bold text-truncate" title="<%= book.getTitle() %>"><%= book.getTitle() %></h6>
                        <p class="card-text text-muted small mb-1">Author: <%= book.getAuthor() %></p>
                        <p class="card-text small mb-2"><span class="badge bg-primary">Stock: <%= book.getCount() %></span></p>
                    </div>
                    <div class="card-footer bg-transparent border-0 p-2 pt-0">
                        <a href="pdf/<%= book.getPdf() %>" target="_blank" class="btn btn-sm btn-outline-secondary w-100">Preview PDF</a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="alert alert-warning text-center w-100">No books found in the inventory.</div>
                <%  } %>
            </div>

            <div class="form-container">
                <h4 class="text-center mb-4 fw-bold">➕ Add Copies to Existing Book</h4>
                <form class="row g-3" action="AddExisting" method="post">
                    <div class="col-md-6">
                        <label for="titleInput" class="form-label fw-bold">Book Title</label>
                        <input type="text" class="form-control" name="title" id="titleInput" placeholder="Exact title of the book" required>
                    </div>
                    <div class="col-md-6">
                        <label for="countInput" class="form-label fw-bold">Quantity to Add</label>
                        <input type="number" class="form-control" name="count" id="countInput" min="1" value="1" required>
                    </div>
                    <div class="col-12 d-flex justify-content-center gap-3 mt-4">
                        <button type="submit" class="btn btn-primary px-4">Add Copies</button>
                        <button type="reset" class="btn btn-secondary px-4">Reset</button>
                        <button type="button" class="btn btn-outline-dark px-4" onclick="window.location.href = 'Admin.jsp'">Back</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
