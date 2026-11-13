<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Login - Library Management</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            body {
                background: linear-gradient(135deg, #eef2f7 0%, #dbe2ef 100%);
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 16px;
            }
            .login-card {
                background: #ffffff;
                border: none;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                width: 100%;
                max-width: 440px;
            }
            .role-btn {
                padding: 10px 14px;
                font-weight: 600;
                border-radius: 10px;
                transition: transform 0.15s ease;
            }
            .role-btn:active {
                transform: scale(0.98);
            }
        </style>
    </head>
    <body>
        <%
            String user = (String) session.getAttribute("name");
            String email = (String) session.getAttribute("email");
        %>
        <div class="login-card p-4 p-sm-5">
            <div class="text-center mb-4">
                <div class="fs-1">📚</div>
                <h3 class="fw-bold mb-1">Library Login</h3>
                <p class="text-muted small">Sign in to your student or administrator account</p>
            </div>

            <form method="post" action="LoginServlet">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Username</label>
                    <input type="text" name="username" class="form-control form-control-lg fs-6" required placeholder="Enter username" 
                           value="<%=(user != null) ? user : ""%>">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Email Address</label>
                    <input type="email" name="email" class="form-control form-control-lg fs-6" required placeholder="Enter registered email" 
                           value="<%=(email != null) ? email : ""%>">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Password</label>
                    <input type="password" name="password" class="form-control form-control-lg fs-6" required placeholder="Enter password">
                </div>

                <!-- Hidden input to capture the role -->
                <input type="hidden" name="role" id="roleInput">

                <!-- Responsive Login buttons -->
                <div class="row g-2 mt-4">
                    <div class="col-6">
                        <button type="submit" onclick="setRole('Student')" class="btn btn-primary w-100 role-btn">Student Login</button>
                    </div>
                    <div class="col-6">
                        <button type="submit" onclick="setRole('Admin')" class="btn btn-success w-100 role-btn">Admin Login</button>
                    </div>
                </div>
            </form>

            <div class="d-flex flex-wrap justify-content-between align-items-center mt-4 pt-2 border-top small">
                <a href="forgotPassword.jsp" class="text-decoration-none text-muted">Forgot password?</a>
                <a href="Register.html" class="text-decoration-none fw-semibold">New Student? Register</a>
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
