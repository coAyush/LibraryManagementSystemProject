<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Password Reset</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5" style="max-width: 500px;">
            <div class="card shadow p-4">
                <h3 class="text-center mb-4">Password Reset</h3>

                <%
                    String status = request.getParameter("status");
                    if (status != null) {
                        String alertClass = "info";
                        String alertMsg = "Unknown status.";

                        if ("otpgenerated".equals(status)) {
                            alertClass = "primary";
                            alertMsg = "OTP has been sent to your email.";
                        } else if ("verified".equals(status)) {
                            alertClass = "success";
                            alertMsg = "OTP verified! Please enter your new password below.";
                        } else if ("passwordchanged".equals(status)) {
                            alertClass = "success";
                            alertMsg = "Password updated successfully!";
                        } else if ("sendfailed".equals(status)) {
                            alertClass = "danger";
                            alertMsg = "Failed to send email. Please verify email and try again.";
                        } else if ("updatefailed".equals(status)) {
                            alertClass = "danger";
                            alertMsg = "Failed to update password. Please try again.";
                        }
                %>
                <div class="alert alert-<%= alertClass %> alert-dismissible fade show" role="alert">
                    <%= alertMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%  } %>

                <!-- Step 1: Request OTP -->
                <form action="GenerateOtp" method="post" class="mb-4">
                    <label class="form-label fw-bold">Step 1: Enter Your Email</label>
                    <div class="input-group">
                        <input type="email" name="email" class="form-control" placeholder="Enter your registered email" 
                               value="<%=session.getAttribute("email") != null ? session.getAttribute("email") : "" %>" required>
                        <button type="submit" class="btn btn-primary">Send OTP</button>
                    </div>
                </form>

                <!-- Step 2: Verify OTP -->
                <form action="VerifyOtp" method="post" class="mb-4">
                    <label class="form-label fw-bold">Step 2: Enter OTP</label>
                    <div class="input-group">
                        <input type="number" name="verify" class="form-control" placeholder="Enter 4-digit OTP" required>
                        <button type="submit" class="btn btn-success">Verify</button>
                    </div>
                </form>

                <!-- Step 3: New Password (shown only after verification) -->
                <%
                    boolean verified = "verified".equals(status);
                    if (verified) {
                %>
                <form action="PasswordReset" method="post" class="mb-3">
                    <label class="form-label fw-bold text-success">Step 3: Set New Password</label>
                    <div class="mb-3">
                        <input type="password" name="newPass" class="form-control" placeholder="Enter your new password" required>
                    </div>
                    <button type="submit" class="btn btn-warning w-100 fw-bold">Update Password</button>
                </form>
                <%  } %>

                <div class="text-center mt-3">
                    <a href="Login.jsp" class="btn btn-outline-secondary btn-sm">Back to Login</a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
