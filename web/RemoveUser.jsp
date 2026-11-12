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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Users - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">Admin Portal</a>
                <div class="ms-auto">
                    <a href="Admin.jsp" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
                    <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String status = request.getParameter("status");
                if (status != null) {
                    if ("success".equalsIgnoreCase(status)) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>User removed successfully.</strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      } else if ("notfound".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>User not found.</strong> Please verify user ID.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      } else if ("admindeletionnotpossible".equalsIgnoreCase(status)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Action forbidden!</strong> Administrator accounts cannot be deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      }
                }
            %>

            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Registered Students</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive" style="max-height: 350px; overflow-y: auto;">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-dark sticky-top">
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
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
                                    <td><strong><%= u.getID() %></strong></td>
                                    <td><%= u.getName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="badge bg-secondary"><%= u.getRole() %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" class="text-center text-muted">No student records found.</td>
                                </tr>
                                <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Remove user form -->
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">Remove Student by ID</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning py-2 mb-3">
                        ⚠️ <strong>Caution:</strong> Deleting a student removes their entire record from the system.
                    </div>
                    <form class="row g-3" action="RemoveUser" method="post">
                        <div class="col-md-6">
                            <label for="inputId" class="form-label fw-bold">Student User ID</label>
                            <input type="number" class="form-control" name="Id" id="inputId" placeholder="Enter student ID to delete" required>
                        </div>
                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-danger">Delete User</button>
                            <button type="reset" class="btn btn-secondary">Reset</button>
                            <button type="button" class="btn btn-outline-dark" onclick="window.location.href = 'Admin.jsp'">Back to Dashboard</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
