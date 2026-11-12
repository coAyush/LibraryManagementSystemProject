<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*, javax.servlet.http.*, java.util.*, java.sql.*"%>
<%@page import="LibraryManagement.Book, LibraryManagement.DBConnection"%>
<%@page session="true"%>
<%
    if (session.getAttribute("USER") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Explore Books - Library</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .book-card {
                transition: transform 0.2s, box-shadow 0.2s;
                border: none;
                border-radius: 12px;
            }
            .book-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            }
            .book-img {
                height: 180px;
                object-fit: contain;
                padding: 15px;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Home.jsp">Library Catalog</a>
                <div class="ms-auto d-flex align-items-center">
                    <span class="text-light me-3">Welcome, <%= session.getAttribute("USER") %></span>
                    <a class="btn btn-outline-light btn-sm me-2" href="Home.jsp">Home</a>
                    <a class="btn btn-outline-danger btn-sm" href="Logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String status = request.getParameter("status");
                if (status != null) {
                    if ("done".equalsIgnoreCase(status)) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>✅ Book issued successfully!</strong> A receipt has been generated and sent to your email.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      } else if ("book_not_found".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Book not found in library.</strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">       
                <strong>❌ Unable to issue book.</strong> It may be out of stock or an error occurred.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      }
                }
            %>

            <div class="row g-4 mt-2">
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
                <div class="col-md-3">
                    <div class="card h-100 book-card shadow-sm">
                        <img src="<%= imagePath %>" class="card-img-top book-img" alt="<%= book.getTitle() %>">
                        <div class="card-body d-flex flex-column text-center">
                            <h5 class="card-title fw-bold text-truncate" title="<%= book.getTitle() %>"><%= book.getTitle() %></h5>
                            <p class="card-text text-muted small mb-1">Author: <%= book.getAuthor() %></p>
                            <p class="card-text small mb-3">
                                Available: 
                                <% if (book.getCount() > 0) { %>
                                    <span class="badge bg-success"><%= book.getCount() %> in stock</span>
                                <% } else { %>
                                    <span class="badge bg-danger">Out of Stock</span>
                                <% } %>
                            </p>
                            <div class="mt-auto d-grid gap-2">
                                <% if (book.getCount() > 0) { %>
                                <a href="<%= request.getContextPath() %>/AddDB?title=<%= java.net.URLEncoder.encode(book.getTitle(), "UTF-8") %>"
                                   class="btn btn-primary">Issue Book</a>
                                <% } else { %>
                                <button class="btn btn-secondary" disabled>Unavailable</button>
                                <% } %>
                                <a href="pdf/<%= book.getPdf() %>" target="_blank" class="btn btn-outline-secondary btn-sm">Preview PDF</a>
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
                <%  } %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
