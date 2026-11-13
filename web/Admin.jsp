<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.*,javax.servlet.*"%>
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Library Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .welcome-banner {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 12px;
                padding: 28px 20px;
                margin-bottom: 30px;
            }
            .admin-card {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                border: none;
                border-radius: 12px;
                overflow: hidden;
            }
            .admin-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.12);
            }
            .card-img-top {
                height: 160px;
                object-fit: contain;
                padding: 16px;
                background-color: #ffffff;
            }
        </style>
    </head>
    <body>
        <!-- Responsive Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">⚙️ Admin Portal</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navContent">
                    <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                        <span class="text-light small">Logged in as: <strong><%= session.getAttribute("USER") %></strong></span>
                        <a href="index.jsp" class="btn btn-outline-light btn-sm">Home</a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String login = (String) session.getAttribute("loginDone");
                if ("yes".equalsIgnoreCase(login)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>Welcome!</strong> Successfully authenticated as Administrator.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%
                    session.removeAttribute("loginDone");
                }
            %>

            <div class="welcome-banner text-center shadow-sm">
                <h2 class="fw-bold mb-2">Welcome, <%= session.getAttribute("USER") %></h2>
                <p class="mb-0 text-white-50">Manage library collection, inventory copies, and registered student accounts.</p>
            </div>

            <div class="row g-4 justify-content-center">
                <div class="col-12 col-md-6 col-lg-5">
                    <div class="card admin-card shadow-sm h-100">
                        <div class="border-bottom">
                            <img src="Images/addbooks.png" class="card-img-top" alt="Manage Books">
                        </div>
                        <div class="card-body text-center d-flex flex-column p-4">
                            <h5 class="card-title fw-bold">Book Inventory</h5>
                            <p class="card-text text-muted small">Upload new book titles with PDFs or increment copies for existing titles.</p>
                            <div class="d-flex flex-wrap justify-content-center gap-2 mt-auto">
                                <a href="AddExisting.jsp" class="btn btn-primary px-3">Add Copies</a>
                                <a href="AddBooks.jsp" class="btn btn-success px-3">+ Add New Book</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-5">
                    <div class="card admin-card shadow-sm h-100">
                        <div class="border-bottom">
                            <img src="Images/user_remove.png" class="card-img-top" alt="Manage Users">
                        </div>
                        <div class="card-body text-center d-flex flex-column p-4">
                            <h5 class="card-title fw-bold">User Management</h5>
                            <p class="card-text text-muted small">View all registered students, verify account roles, and manage users.</p>
                            <div class="d-flex justify-content-center mt-auto">
                                <a href="RemoveUser.jsp" class="btn btn-danger px-4">Manage Students</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
