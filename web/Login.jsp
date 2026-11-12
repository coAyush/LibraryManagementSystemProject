<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Library Management</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            .role-buttons {
                display: grid;
                grid-template-columns: 1fr 1fr;
                column-gap: 10px;
            } 
            body {
                background-color: #f4f6f9;
            }
        </style>
    </head>
    <body>
        <%
            String user = (String) session.getAttribute("name");
            String email = (String) session.getAttribute("email");
        %>
        <div class="container mt-5" style="max-width: 440px;">
            <div class="card shadow p-4">
                <h2 class="text-center mb-4">Library Login</h2>
                <form method="post" action="LoginServlet">
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" required placeholder="Enter your username" 
                               value="<%=(user != null) ? user : ""%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required placeholder="Enter your email" 
                               value="<%=(email != null) ? email : ""%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="Enter your password">
                    </div>

                    <!-- Hidden input to capture the role -->
                    <input type="hidden" name="role" id="roleInput">

                    <!-- Login buttons for Student and Admin -->
                    <div class="role-buttons mt-4">
                        <button type="submit" onclick="setRole('Student')" class="btn btn-primary w-100" style="border-radius: 8px;">Login as Student</button>
                        <button type="submit" onclick="setRole('Admin')" class="btn btn-success w-100" style="border-radius: 8px;">Login as Admin</button>
                    </div>
                </form>
                <div class="d-flex justify-content-between mt-3">
                    <a href="forgotPassword.jsp" class="text-decoration-none">Forgot Password?</a>
                    <a href="Register.html" class="text-decoration-none">New Student? Register</a>
                </div>
            </div>
        </div>

        <script>
            function setRole(role) {
                document.getElementById('roleInput').value = role;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
