<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page session="true" %> 
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
    <title>Library Portal - Student Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .portal-card {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: none;
            border-radius: 12px;
            transition: transform 0.2s;
        }
        .portal-card:hover {
            transform: translateY(-4px);
        }
        .welcome-hero {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="Home.jsp">Library Portal</a>
            <div class="ms-auto">
                <a href="Logout" class="btn btn-outline-danger">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container my-4">
        <%
            String logindone = (String) session.getAttribute("loginDone");
            if (logindone != null && "yes".equalsIgnoreCase(logindone)) {
        %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>Logged in successfully!</strong> Welcome to the Library Portal.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%
                session.removeAttribute("loginDone");
            }
        %>

        <div class="welcome-hero text-center">
            <h1>Welcome, <%= session.getAttribute("USER") %></h1>
            <p class="mb-0">Access books, manage your loans, and explore learning resources.</p>
        </div>

        <div class="row g-4 justify-content-center">
            <div class="col-md-3">
                <div class="card portal-card p-4 h-100 text-center">
                    <h5 class="fw-bold">Browse Books</h5>
                    <p class="text-muted">Search and explore available books in the library catalog.</p>
                    <div class="mt-auto">
                        <a href="BrowseBooksServlet" class="btn btn-primary w-100">Explore</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card portal-card p-4 h-100 text-center">
                    <h5 class="fw-bold">My Account</h5>
                    <p class="text-muted">Check your borrowed books, due dates, and active loans.</p>
                    <div class="mt-auto">
                        <a href="MyAccount.jsp" class="btn btn-primary w-100">View Profile</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card portal-card p-4 h-100 text-center">
                    <h5 class="fw-bold">Return Book</h5>
                    <p class="text-muted">Return issued books back to the library inventory.</p>
                    <div class="mt-auto">
                        <a href="Return.jsp" class="btn btn-primary w-100">Return Book</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card portal-card p-4 h-100 text-center">
                    <h5 class="fw-bold">Contact Librarian</h5>
                    <p class="text-muted">Need help or have questions? Contact the library staff.</p>
                    <div class="mt-auto">
                        <a href="Sending.jsp" class="btn btn-primary w-100">Contact Staff</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
