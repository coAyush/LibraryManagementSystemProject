<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Password Reset - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            .reset-card {
                background: #ffffff;
                border: none;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                width: 100%;
                max-width: 480px;
            }
        </style>
    </head>
    <body>
        <div class="reset-card p-4 p-sm-5">
            <div class="text-center mb-4">
                <div class="fs-1">🔑</div>
                <h3 class="fw-bold mb-1">Password Recovery</h3>
                <p class="text-muted small">Verify your registered email address with OTP</p>
            </div>

            <%
                String status = request.getParameter("status");
                if (status != null) {
                    String alertClass = "info";
                    String alertMsg = "Unknown status.";

                    if ("otpgenerated".equals(status)) {
                        alertClass = "primary";
                        alertMsg = "📩 OTP sent to your email. Check inbox or spam.";
                    } else if ("verified".equals(status)) {
                        alertClass = "success";
                        alertMsg = "✅ OTP verified! Enter your new password below.";
                    } else if ("passwordchanged".equals(status)) {
                        alertClass = "success";
                        alertMsg = "✅ Password updated successfully! Please log in.";
                    } else if ("sendfailed".equals(status)) {
                        alertClass = "warning";
                        String err = (String) session.getAttribute("mailError");
                        alertMsg = "⚠️ Could not send email OTP" + (err != null && !err.trim().isEmpty() ? " (" + err + ")" : "") + ". (Note: The generated OTP is also printed in Render Server Logs if testing).";
                    } else if ("updatefailed".equals(status)) {
                        alertClass = "danger";
                        alertMsg = "❌ Failed to update password. Please try again.";
                    }
            %>
            <div class="alert alert-<%= alertClass %> alert-dismissible fade show shadow-sm" role="alert">
                <%= alertMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%  } %>

            <!-- Step 1: Request OTP -->
            <form action="GenerateOtp" method="post" class="mb-3">
                <label class="form-label fw-semibold">Step 1: Registered Email</label>
                <div class="input-group">
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" 
                           value="<%= session.getAttribute("email") != null ? session.getAttribute("email") : "" %>" required>
                    <button type="submit" class="btn btn-primary">Send OTP</button>
                </div>
            </form>

            <!-- Step 2: Verify OTP -->
            <form action="VerifyOtp" method="post" class="mb-4">
                <label class="form-label fw-semibold">Step 2: Enter 4-Digit OTP</label>
                <div class="input-group">
                    <input type="number" name="verify" class="form-control" placeholder="Enter OTP from email" required>
                    <button type="submit" class="btn btn-success">Verify</button>
                </div>
            </form>

            <!-- Step 3: New Password (shown only after verification) -->
            <%
                boolean verified = "verified".equals(status);
                if (verified) {
            %>
            <div class="p-3 bg-light rounded border mb-4">
                <form action="PasswordReset" method="post">
                    <label class="form-label fw-bold text-success">Step 3: Enter New Password</label>
                    <div class="mb-3">
                        <input type="password" name="newPass" class="form-control" placeholder="Enter new password" required>
                    </div>
                    <button type="submit" class="btn btn-warning w-100 fw-bold">Save New Password</button>
                </form>
            </div>
            <%  } %>

            <div class="text-center pt-2 border-top">
                <a href="Login.jsp" class="btn btn-outline-secondary btn-sm px-4">← Back to Login</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
