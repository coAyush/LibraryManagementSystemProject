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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Explore Books - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .book-card {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                border: none;
                border-radius: 12px;
                overflow: hidden;
            }
            .book-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }
            .book-img-wrapper {
                height: 190px;
                background-color: #ffffff;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 12px;
            }
            .book-img {
                max-height: 100%;
                max-width: 100%;
                object-fit: contain;
            }
        </style>
    </head>
    <body>
        <!-- Responsive Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Home.jsp">📚 Library Catalog</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navContent">
                    <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                        <span class="text-light small">Welcome, <strong><%= session.getAttribute("USER") %></strong></span>
                        <a class="btn btn-outline-light btn-sm" href="Home.jsp">Home</a>
                        <a class="btn btn-outline-info btn-sm" href="MyAccount.jsp">My Account</a>
                        <a class="btn btn-outline-danger btn-sm" href="Logout">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <!-- Status Alerts -->
            <%
                String status = request.getParameter("status");
                if (status != null) {
                    if ("done".equalsIgnoreCase(status)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>✅ Book issued successfully!</strong> An official receipt has been generated and sent to your email.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("done_no_mail".equalsIgnoreCase(status)) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>✅ Book issued successfully!</strong> Your receipt PDF has been generated. You can view your active loan in <a href="MyAccount.jsp" class="alert-link">My Account</a>.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("already_issued".equalsIgnoreCase(status)) { %>
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <strong>ℹ️ Already Issued:</strong> You currently have an active issue for this book. Visit <a href="MyAccount.jsp" class="alert-link">My Account</a> to review your loans.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("out_of_stock".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <strong>⚠️ Out of Stock:</strong> All copies of this book are currently on loan. Please check back later.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("book_not_found".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <strong>⚠️ Book Not Found:</strong> The requested book title could not be found in the catalog.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">       
                <strong>❌ Unable to issue book.</strong> An unexpected error occurred. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      }
                }
            %>

            <!-- Page Title & Search Bar -->
            <div class="row align-items-center mb-4 g-3">
                <div class="col-12 col-md-6">
                    <h3 class="fw-bold mb-0">Browse Library Collection</h3>
                    <p class="text-muted small mb-0">Explore available books, read previews, or issue a copy.</p>
                </div>
                <div class="col-12 col-md-6">
                    <input type="text" id="bookSearch" class="form-control" placeholder="🔍 Search by title or author..." onkeyup="filterBooks()">
                </div>
            </div>

            <!-- Book Grid -->
            <div class="row g-4" id="bookGrid">
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
                            String t = book.getTitle() != null ? book.getTitle().trim() : "";
                            if ("JSP_Tutorial".equalsIgnoreCase(t)) {
                                imagePath = "Images/JSP_Tutorial.jpg";
                            } else if ("The Complete Reference".equalsIgnoreCase(t)) {
                                imagePath = "Images/The Complete Reference.jpeg";
                            } else if ("Spring ".equalsIgnoreCase(t) || "Spring".equalsIgnoreCase(t)) {
                                imagePath = "Images/spring.png";
                            } else if ("Sevlets_Tutorial".equalsIgnoreCase(t) || "Servlets_Tutorial".equalsIgnoreCase(t)) {
                                imagePath = "Images/Sevlets_Tutorial.jpeg";
                            } else if ("Mathematical Physics".equalsIgnoreCase(t)) {
                                imagePath = "Images/Mathematical Physics.jpeg";
                            } else if ("Spring Boot".equalsIgnoreCase(t)) {
                                imagePath = "Images/Spring Boot.jpg";
                            }
                %>
                <div class="col-12 col-sm-6 col-md-4 col-lg-3 book-item" data-title="<%= (book.getTitle() != null ? book.getTitle().toLowerCase() : "") %>" data-author="<%= (book.getAuthor() != null ? book.getAuthor().toLowerCase() : "") %>">
                    <div class="card h-100 book-card shadow-sm">
                        <div class="book-img-wrapper border-bottom">
                            <img src="<%= imagePath %>" class="book-img" alt="<%= book.getTitle() %>">
                        </div>
                        <div class="card-body d-flex flex-column text-center p-3">
                            <h6 class="card-title fw-bold text-truncate mb-1" title="<%= book.getTitle() %>"><%= book.getTitle() %></h6>
                            <p class="card-text text-muted small mb-2">By <%= book.getAuthor() %></p>
                            <p class="card-text small mb-3">
                                <% if (book.getCount() > 0) { %>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1"><%= book.getCount() %> Available</span>
                                <% } else { %>
                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Out of Stock</span>
                                <% } %>
                            </p>
                            <div class="mt-auto d-grid gap-2">
                                <% if (book.getCount() > 0) { %>
                                <a href="<%= request.getContextPath() %>/AddDB?title=<%= java.net.URLEncoder.encode(book.getTitle(), "UTF-8") %>"
                                   class="btn btn-primary btn-sm fw-semibold">Issue Book</a>
                                <% } else { %>
                                <button class="btn btn-secondary btn-sm" disabled>Unavailable</button>
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
                    <div class="alert alert-warning text-center py-4">No books currently available in the catalog.</div>
                </div>
                <%  } %>
            </div>
        </div>

        <script>
            function filterBooks() {
                const query = document.getElementById('bookSearch').value.toLowerCase().trim();
                const items = document.querySelectorAll('.book-item');
                items.forEach(item => {
                    const title = item.getAttribute('data-title') || '';
                    const author = item.getAttribute('data-author') || '';
                    if (title.includes(query) || author.includes(query)) {
                        item.style.display = '';
                    } else {
                        item.style.display = 'none';
                    }
                });
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
