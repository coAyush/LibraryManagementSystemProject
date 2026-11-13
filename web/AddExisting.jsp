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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Manage Stock - Existing Books</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .card-strip {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                white-space: nowrap;
                padding: 15px;
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            }
            .card-strip .inventory-card {
                display: inline-block;
                width: 210px;
                margin-right: 15px;
                vertical-align: top;
                white-space: normal;
                cursor: pointer;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .card-strip .inventory-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 6px 14px rgba(0,0,0,0.12);
            }
            .inventory-card img {
                height: 130px;
                object-fit: contain;
                padding: 8px;
            }
            .form-container {
                max-width: 650px;
                margin: 25px auto;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            }
        </style>
    </head>
    <body>
        <!-- Responsive Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">Admin Portal</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navContent">
                    <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                        <a href="Admin.jsp" class="btn btn-outline-light btn-sm">Dashboard</a>
                        <a href="AddBooks.jsp" class="btn btn-outline-success btn-sm">+ Add New Book</a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <!-- Notification Alerts -->
            <%
                String status = request.getParameter("Added");
                String respTitle = request.getParameter("title");
                String newCount = request.getParameter("newCount");

                if (status != null) {
                    if ("success".equalsIgnoreCase(status)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>✅ Stock Updated:</strong> Successfully added copies to <strong><%= (respTitle != null ? respTitle : "the book") %></strong>. Total stock is now <strong><%= (newCount != null ? newCount : "") %></strong>.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("not_found".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <strong>⚠️ Book Not Found:</strong> Could not find "<strong><%= (respTitle != null ? respTitle : "") %></strong>". Please click a book from the list below or select from the dropdown.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("empty_title".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <strong>⚠️ Missing Title:</strong> Please select or enter a book title to update.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong>❌ Error:</strong> Could not update stock. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      }
                }
            %>

            <!-- Existing Books Strip -->
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h5 class="fw-bold mb-0">📚 Current Books in Library (Click to Select):</h5>
                <span class="text-muted small">Scroll horizontally →</span>
            </div>

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
            %>

            <div class="card-strip mb-4">
                <%
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
                <div class="card inventory-card shadow-sm" onclick="selectBook('<%= book.getTitle().replace("'", "\\'") %>')">
                    <img src="<%= imagePath %>" class="card-img-top" alt="<%= book.getTitle() %>">
                    <div class="card-body p-2 text-center">
                        <h6 class="card-title fw-bold text-truncate mb-1" title="<%= book.getTitle() %>"><%= book.getTitle() %></h6>
                        <p class="card-text text-muted small mb-1">By <%= book.getAuthor() %></p>
                        <span class="badge bg-primary px-2 py-1">Stock: <%= book.getCount() %></span>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="alert alert-warning text-center w-100 py-3">No books found in the inventory.</div>
                <%  } %>
            </div>

            <!-- Responsive Add Copies Form -->
            <div class="form-container">
                <h4 class="text-center mb-3 fw-bold">➕ Add Copies to Existing Book</h4>
                <p class="text-center text-muted small mb-4">Select a book from the list or dropdown, enter the quantity, and submit.</p>
                
                <form class="row g-3" action="AddExisting" method="post">
                    <div class="col-12 col-md-8">
                        <label for="bookDropdown" class="form-label fw-bold">Select Book Title</label>
                        <select class="form-select" id="bookDropdown" onchange="syncTitleInput(this.value)">
                            <option value="">-- Choose from existing books --</option>
                            <%
                                if (books != null) {
                                    for (Book b : books) {
                            %>
                            <option value="<%= b.getTitle() %>"><%= b.getTitle() %> (Current: <%= b.getCount() %>)</option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <input type="text" class="form-control mt-2" name="title" id="titleInput" placeholder="Or enter exact book title" required>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="countInput" class="form-label fw-bold">Copies to Add</label>
                        <input type="number" class="form-control" name="count" id="countInput" min="1" value="1" required>
                    </div>

                    <div class="col-12 d-flex flex-wrap justify-content-center gap-2 mt-4">
                        <button type="submit" class="btn btn-primary px-4">Update Stock</button>
                        <button type="reset" class="btn btn-secondary px-3" onclick="resetForm()">Reset</button>
                        <a href="Admin.jsp" class="btn btn-outline-dark px-3">Dashboard</a>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function selectBook(title) {
                document.getElementById('titleInput').value = title;
                const dropdown = document.getElementById('bookDropdown');
                for (let i = 0; i < dropdown.options.length; i++) {
                    if (dropdown.options[i].value.toLowerCase() === title.toLowerCase()) {
                        dropdown.selectedIndex = i;
                        break;
                    }
                }
                document.getElementById('titleInput').scrollIntoView({ behavior: 'smooth' });
            }

            function syncTitleInput(value) {
                if (value) {
                    document.getElementById('titleInput').value = value;
                }
            }

            function resetForm() {
                document.getElementById('bookDropdown').selectedIndex = 0;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
