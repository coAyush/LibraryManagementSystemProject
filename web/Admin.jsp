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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Library Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .welcome-banner {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .admin-card {
                transition: transform 0.2s, box-shadow 0.2s;
                border: none;
                border-radius: 12px;
                overflow: hidden;
            }
            .admin-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            }
            .card-img-top {
                height: 180px;
                object-fit: contain;
                padding: 15px;
                background-color: #ffffff;
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">Library Admin Portal</a>
                <div class="ms-auto">
                    <a href="Logout" class="btn btn-outline-danger">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String login = (String) session.getAttribute("loginDone");
                if ("yes".equalsIgnoreCase(login)) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Welcome!</strong> Successfully logged in as Administrator.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    session.removeAttribute("loginDone");
                }
            %>

            <div class="welcome-banner text-center">
                <h2>Welcome, <%= session.getAttribute("USER") %></h2>
                <p class="mb-0">Manage library books, inventory, and registered users.</p>
            </div>

            <div class="row g-4 justify-content-center">
                <div class="col-md-5">
                    <div class="card admin-card shadow-sm h-100">
                        <img src="Images/addbooks.png" class="card-img-top" alt="Add Books">
                        <div class="card-body text-center">
                            <h5 class="card-title fw-bold">Manage Books</h5>
                            <p class="card-text text-muted">Add new titles or update existing inventory counts.</p>
                            <div class="d-flex justify-content-center gap-2 mt-3">
                                <a href="BrowseBooksServlet" class="btn btn-primary">Add Existing</a>
                                <a href="AddBooks.jsp" class="btn btn-success">Add New Book</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="card admin-card shadow-sm h-100">
                        <img src="Images/user_remove.png" class="card-img-top" alt="Remove User">
                        <div class="card-body text-center">
                            <h5 class="card-title fw-bold">User Management</h5>
                            <p class="card-text text-muted">View registered students and manage library accounts.</p>
                            <div class="d-flex justify-content-center mt-3">
                                <a href="RemoveUser.jsp" class="btn btn-danger">Manage Users</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
