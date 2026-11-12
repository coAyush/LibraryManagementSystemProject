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
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Library System</a>
            <div class="ms-auto">
                <a href="Home.jsp" class="btn btn-outline-light me-2">Home</a>
                <a href="Logout" class="btn btn-danger">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Profile Section -->
    <div class="container my-5">
        <h2 class="mb-4 text-center">My Profile</h2>
        
        <!-- User Info -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title">User Details</h5>
                <p><strong>User ID:</strong> <%= userId %></p>
                <p><strong>Name:</strong> <%= (username != null ? username : "") %></p>
                <p><strong>Email:</strong> <%= (email != null ? email : "") %></p>
                <p><strong>Role:</strong> <%= (role != null ? role : "") %></p>
            </div>
        </div>

        <!-- Issued Books Table -->
        <div class="card shadow-sm">
            <div class="card-body">
                <h5 class="card-title mb-3">Issued Books</h5>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Days Late</th>
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
                            <td><%= title %></td>
                            <td><%= author %></td>
                            <td><%= issueDate %></td>
                            <td><%= dueDate %></td>
                            <td><%= (daysLate > 0 ? daysLate : 0) %></td>
                            <td><%= fine %></td>
                        </tr>
<%
        }
        if (!hasRecords) {
%>
                        <tr><td colspan="6" class="text-center text-muted">No books currently issued.</td></tr>
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
</body>
</html>
