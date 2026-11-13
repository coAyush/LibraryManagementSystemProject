<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page import="LibraryManagement.EmailUtil"%>
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
        <title>Contact Librarian - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .contact-container {
                max-width: 600px;
                margin: 30px auto;
                background-color: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.06);
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
                        <a href="Home.jsp" class="btn btn-outline-light btn-sm">Home</a>
                        <a href="BrowseBooksServlet" class="btn btn-outline-primary btn-sm">Browse Books</a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String s = request.getParameter("status");
                if (s != null) {
                    if ("sent".equalsIgnoreCase(s)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong>✅ Message sent successfully!</strong> The library staff will review your inquiry.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">       
                <strong>❌ Message could not be sent.</strong> Please try again later.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      }
                }
            %>

            <div class="contact-container">
                <h4 class="text-center mb-3 fw-bold">✉️ Contact Librarian</h4>
                <p class="text-center text-muted small mb-4">Send an inquiry or request assistance from the library team.</p>
                
                <form action="SendMail.jsp" method="post">  
                    <div class="mb-3">
                        <label class="form-label fw-bold">To (Librarian Email)</label>
                        <input type="text" class="form-control bg-light" value="<%= EmailUtil.getMailUser() %>" name="to" readonly required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">From (Your Email)</label>
                        <input type="text" class="form-control bg-light" value="<%= (String)session.getAttribute("email") %>" name="from" required readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Subject <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" placeholder="Brief subject of your message" name="subject" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Message <span class="text-danger">*</span></label>
                        <textarea class="form-control" rows="4" placeholder="Describe your question, request, or issue..." name="msg" required></textarea>
                    </div>
                    <div class="d-flex flex-wrap justify-content-center gap-2">
                        <button type="submit" class="btn btn-primary px-4">Send Message</button>
                        <button type="reset" class="btn btn-secondary px-3">Clear</button>
                        <a href="Home.jsp" class="btn btn-outline-dark px-3">Back to Home</a>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
