<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*,javax.servlet.http.*,java.util.*,java.sql.*"%>
<%@page import="LibraryManagement.User,LibraryManagement.DBConnection" %>
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
        <title>Manage Users - Admin Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .content-card {
                border: none;
                border-radius: 12px;
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
                        <a href="Admin.jsp" class="btn btn-outline-light btn-sm">Dashboard</a>
                        <a href="AddExisting.jsp" class="btn btn-outline-primary btn-sm">Manage Books</a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4" style="max-width: 850px;">
            <%
                String status = request.getParameter("status");
                if (status != null) {
                    if ("success".equalsIgnoreCase(status)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>✅ User removed successfully.</strong> Student account has been deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("notfound".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <strong>⚠️ User Not Found:</strong> No student record was found with the specified ID.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else if ("admindeletionnotpossible".equalsIgnoreCase(status)) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong>🚫 Action Forbidden:</strong> Administrator accounts cannot be deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      }
                }
            %>

            <!-- Registered Students Table -->
            <div class="card content-card shadow-sm mb-4">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0 fw-bold">👥 Registered Students</h5>
                    <span class="badge bg-primary">Active Directory</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 380px; overflow-y: auto;">
                        <table class="table table-bordered table-hover align-middle mb-0">
                            <thead class="table-light sticky-top">
                                <tr>
                                    <th style="width: 70px;" class="text-center">ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th style="width: 100px;" class="text-center">Role</th>
                                    <th style="width: 90px;" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<User> usersList = (List<User>) getServletContext().getAttribute("USERSlist");
                                    if (usersList == null) {
                                        usersList = new ArrayList<User>();
                                        Connection conn = null;
                                        PreparedStatement ps = null;
                                        ResultSet rs = null;
                                        try {
                                            conn = DBConnection.getConnection();
                                            ps = conn.prepareStatement("SELECT * FROM users WHERE Role!='Admin'");
                                            rs = ps.executeQuery();
                                            while (rs.next()) {
                                                usersList.add(new User(
                                                    rs.getInt("ID"),
                                                    rs.getString("Name"),
                                                    rs.getString("email"),
                                                    rs.getString("password"),
                                                    rs.getString("Role")
                                                ));
                                            }
                                            getServletContext().setAttribute("USERSlist", usersList);
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            DBConnection.closeQuietly(rs, ps, conn);
                                        }
                                    }

                                    if (usersList != null && !usersList.isEmpty()) {
                                        for (User u : usersList) {
                                %>
                                <tr>
                                    <td class="text-center fw-bold">#<%= u.getID() %></td>
                                    <td><%= u.getName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td class="text-center"><span class="badge bg-secondary"><%= u.getRole() %></span></td>
                                    <td class="text-center">
                                        <button class="btn btn-outline-danger btn-sm" onclick="populateId(<%= u.getID() %>)">Select</button>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">No student records found in database.</td>
                                </tr>
                                <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Remove user form -->
            <div class="card content-card shadow-sm">
                <div class="card-header bg-danger text-white py-3">
                    <h5 class="mb-0 fw-bold">🗑️ Remove Student Account</h5>
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-warning py-2 mb-3 small">
                        ⚠️ <strong>Caution:</strong> Deleting a student permanently removes their library account and borrowing history.
                    </div>
                    <form class="row g-3" action="RemoveUser" method="post">
                        <div class="col-12 col-md-6">
                            <label for="inputId" class="form-label fw-bold">Student User ID <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="Id" id="inputId" placeholder="Enter or select student ID" required>
                        </div>
                        <div class="col-12 d-flex flex-wrap gap-2">
                            <button type="submit" class="btn btn-danger px-4">Delete Student</button>
                            <button type="reset" class="btn btn-secondary px-3">Clear</button>
                            <a href="Admin.jsp" class="btn btn-outline-dark px-3">Dashboard</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function populateId(id) {
                document.getElementById('inputId').value = id;
                document.getElementById('inputId').focus();
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
