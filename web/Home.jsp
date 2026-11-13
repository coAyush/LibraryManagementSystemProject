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
    <title>Student Portal - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .portal-card {
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            border: none;
            border-radius: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .portal-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .welcome-hero {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border-radius: 12px;
            padding: 28px 20px;
            margin-bottom: 30px;
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
                    <span class="text-light small">Welcome, <strong><%= session.getAttribute("USER") %></strong></span>
                    <a href="index.jsp" class="btn btn-outline-light btn-sm">Home</a>
                    <a href="MyAccount.jsp" class="btn btn-outline-info btn-sm">My Account</a>
                    <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container my-4">
        <%
            String logindone = (String) session.getAttribute("loginDone");
            if (logindone != null && "yes".equalsIgnoreCase(logindone)) {
        %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <strong>Logged in successfully!</strong> Welcome back to the Library Portal.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <%
                session.removeAttribute("loginDone");
            }
        %>

        <div class="welcome-hero text-center shadow-sm">
            <h2 class="fw-bold mb-2">Welcome, <%= session.getAttribute("USER") %></h2>
            <p class="mb-0 text-white-50">Browse the online library, manage your active book loans, and contact the librarian.</p>
        </div>

        <div class="row g-4 justify-content-center">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card portal-card p-4 h-100 text-center d-flex flex-column">
                    <div class="fs-1 mb-2">📖</div>
                    <h5 class="fw-bold">Browse Books</h5>
                    <p class="text-muted small">Search and explore available books in the library catalog.</p>
                    <div class="mt-auto">
                        <a href="BrowseBooksServlet" class="btn btn-primary w-100">Explore Catalog</a>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card portal-card p-4 h-100 text-center d-flex flex-column">
                    <div class="fs-1 mb-2">👤</div>
                    <h5 class="fw-bold">My Account</h5>
                    <p class="text-muted small">Check your borrowed books, due dates, and fine calculations.</p>
                    <div class="mt-auto">
                        <a href="MyAccount.jsp" class="btn btn-info text-white w-100">View Profile</a>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card portal-card p-4 h-100 text-center d-flex flex-column">
                    <div class="fs-1 mb-2">🔄</div>
                    <h5 class="fw-bold">Return Book</h5>
                    <p class="text-muted small">Return issued books back to the library collection.</p>
                    <div class="mt-auto">
                        <a href="Return.jsp" class="btn btn-success w-100">Return Book</a>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card portal-card p-4 h-100 text-center d-flex flex-column">
                    <div class="fs-1 mb-2">✉️</div>
                    <h5 class="fw-bold">Contact Librarian</h5>
                    <p class="text-muted small">Need assistance or have queries? Send a message to staff.</p>
                    <div class="mt-auto">
                        <a href="Sending.jsp" class="btn btn-secondary w-100">Contact Staff</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
