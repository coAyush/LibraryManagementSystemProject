<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="LibraryManagement.DBConnection"%>
<%@page session="true" %>

<%
    Integer userId = (Integer) session.getAttribute("ID");
    String username = (String) session.getAttribute("USER");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("Role");

    if (userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .profile-card {
            border: none;
            border-radius: 12px;
        }
    </style>
</head>
<body>

    <!-- Responsive Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="Home.jsp">📚 Library System</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navContent">
                <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                    <a href="Home.jsp" class="btn btn-outline-light btn-sm">Home</a>
                    <a href="BrowseBooksServlet" class="btn btn-outline-primary btn-sm">Browse Books</a>
                    <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Profile Section -->
    <div class="container my-4" style="max-width: 900px;">
        <h3 class="mb-4 fw-bold">Student Profile & Loans</h3>
        
        <!-- User Info Card -->
        <div class="card profile-card shadow-sm mb-4">
            <div class="card-body p-4">
                <h5 class="card-title fw-bold border-bottom pb-2 mb-3">User Details</h5>
                <div class="row g-3">
                    <div class="col-6 col-md-3">
                        <span class="text-muted small d-block">User ID</span>
                        <span class="fw-bold">#<%= userId %></span>
                    </div>
                    <div class="col-6 col-md-3">
                        <span class="text-muted small d-block">Full Name</span>
                        <span class="fw-bold"><%= (username != null ? username : "-") %></span>
                    </div>
                    <div class="col-12 col-md-4">
                        <span class="text-muted small d-block">Email Address</span>
                        <span class="fw-bold"><%= (email != null ? email : "-") %></span>
                    </div>
                    <div class="col-6 col-md-2">
                        <span class="text-muted small d-block">Role</span>
                        <span class="badge bg-primary"><%= (role != null ? role : "Student") %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Issued Books Table -->
        <div class="card profile-card shadow-sm">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title fw-bold mb-0">Currently Issued Books</h5>
                    <a href="Return.jsp" class="btn btn-outline-success btn-sm">Return a Book</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Book Title</th>
                                <th>Author</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Overdue</th>
                                <th>Fine (₹)</th>
                            </tr>
                        </thead>
                        <tbody>
<%
    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement psBook = null;
    ResultSet rs = null;
    ResultSet rsBook = null;

    try {
        con = DBConnection.getConnection();

        ps = con.prepareStatement("SELECT * FROM issue WHERE U_ID=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        psBook = con.prepareStatement("SELECT title, author FROM books WHERE book_id=?");

        boolean hasRecords = false;
        while (rs.next()) {
            hasRecords = true;
            int bookId = rs.getInt("B_ID");
            java.sql.Date issueSqlDate = rs.getDate("Issue_Date");
            java.sql.Date dueSqlDate = rs.getDate("Due_Date");
            String issueDate = (issueSqlDate != null) ? issueSqlDate.toString() : "-";
            String dueDate = (dueSqlDate != null) ? dueSqlDate.toString() : "-";
            
            long daysLate = 0;
            if (dueSqlDate != null) {
                LocalDate due = dueSqlDate.toLocalDate();
                LocalDate today = LocalDate.now();
                daysLate = ChronoUnit.DAYS.between(due, today);
            }
            long fine = daysLate > 0 ? daysLate * 10 : 0;

            // Get Book details
            psBook.setInt(1, bookId);
            rsBook = psBook.executeQuery();
            String title = "", author = "";
            if (rsBook.next()) {
                title = rsBook.getString("title");
                author = rsBook.getString("author");
            }
            rsBook.close();
%>
                            <tr>
                                <td class="fw-semibold"><%= title %></td>
                                <td class="text-muted"><%= author %></td>
                                <td><%= issueDate %></td>
                                <td><%= dueDate %></td>
                                <td>
                                    <% if (daysLate > 0) { %>
                                        <span class="badge bg-danger"><%= daysLate %> days late</span>
                                    <% } else { %>
                                        <span class="badge bg-success">On time</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (fine > 0) { %>
                                        <span class="text-danger fw-bold">₹<%= fine %></span>
                                    <% } else { %>
                                        <span class="text-muted">₹0</span>
                                    <% } %>
                                </td>
                            </tr>
<%
        }
        if (!hasRecords) {
%>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">You have no books currently issued. <a href="BrowseBooksServlet">Browse books to issue</a>.</td>
                            </tr>
<%
        }
    } catch (Exception e) {
%>
                            <tr><td colspan="6" class="text-danger">Error retrieving books: <%= e.getMessage() %></td></tr>
<%
    } finally {
        DBConnection.closeQuietly(rs, rsBook, ps, psBook, con);
    }
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
