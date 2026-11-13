<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*,LibraryManagement.DBConnection"%>
<%@page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("ID");
    if (session.getAttribute("USER") == null || userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    // Fetch user's currently issued books for the dropdown
    List<String> issuedTitles = new ArrayList<String>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT b.title FROM issue i JOIN books b ON i.B_ID = b.book_id WHERE i.U_ID = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        while (rs.next()) {
            issuedTitles.add(rs.getString("title"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.closeQuietly(rs, ps, conn);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book - Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .form-container {
            max-width: 550px;
            margin: 30px auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
        }
    </style>
</head>
<body>

<!-- Responsive Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="Home.jsp">📚 Library Portal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navContent">
            <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                <a href="Home.jsp" class="btn btn-outline-light btn-sm">Home</a>
                <a href="MyAccount.jsp" class="btn btn-outline-info btn-sm">My Account</a>
                <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>

<div class="container my-4">
    <%
        String status = request.getParameter("return");
        String retTitle = request.getParameter("title");
        if (status != null) {
            if ("success".equalsIgnoreCase(status)) {
    %>
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
        ✅ <strong>Book Returned:</strong> "<strong><%= (retTitle != null ? retTitle : "") %></strong>" was returned successfully! Thank you.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      } else if ("not_issued".equalsIgnoreCase(status)) { %>
    <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
        ⚠️ <strong>Not Currently Issued:</strong> You do not currently have "<strong><%= (retTitle != null ? retTitle : "") %></strong>" on loan.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      } else if ("not_found".equalsIgnoreCase(status)) { %>
    <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
        ⚠️ <strong>Book Not Found:</strong> Could not find book "<strong><%= (retTitle != null ? retTitle : "") %></strong>" in catalog.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      } else if ("empty_title".equalsIgnoreCase(status)) { %>
    <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
        ⚠️ <strong>Missing Title:</strong> Please select or type the title of the book to return.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      } else { %>
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
        ❌ <strong>Error:</strong> Could not process book return. Please verify and try again.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      }
        }
    %>

    <!-- Return Form -->
    <div class="form-container">
        <h4 class="text-center mb-3 fw-bold">🔄 Return a Book</h4>
        <p class="text-center text-muted small mb-4">Choose from your currently issued books below or enter the title.</p>
        
        <form action="Return" method="post">
            <div class="mb-3">
                <label for="issuedSelect" class="form-label fw-bold">Your Issued Books</label>
                <select class="form-select" id="issuedSelect" onchange="document.getElementById('titleInput').value = this.value">
                    <option value="">-- Select from your issued books (<%= issuedTitles.size() %> active) --</option>
                    <% for (String t : issuedTitles) { %>
                    <option value="<%= t %>"><%= t %></option>
                    <% } %>
                </select>
            </div>

            <div class="mb-4">
                <label for="titleInput" class="form-label fw-bold">Book Title <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="titleInput" name="title" placeholder="Selected or exact book title" required>
            </div>

            <div class="d-flex flex-wrap justify-content-center gap-2">
                <button type="submit" class="btn btn-success px-4">Confirm Return</button>
                <button type="reset" class="btn btn-secondary px-3" onclick="document.getElementById('issuedSelect').selectedIndex = 0">Reset</button>
                <a href="Home.jsp" class="btn btn-outline-dark px-3">Back to Home</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
