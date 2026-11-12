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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contact Librarian - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .contact-container {
                max-width: 600px;
                margin: 40px auto;
                background-color: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Home.jsp">Library Portal</a>
                <div class="ms-auto">
                    <a href="Home.jsp" class="btn btn-outline-light btn-sm me-2">Home</a>
                    <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container my-4">
            <%
                String s = request.getParameter("status");
                if (s != null) {
                    if ("sent".equalsIgnoreCase(s)) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>✅ Message sent successfully!</strong> The library staff will review your message.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">       
                <strong>❌ Message could not be sent.</strong> Please try again later.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%      }
                }
            %>

            <div class="contact-container">
                <h3 class="text-center mb-4 fw-bold">Contact Librarian</h3>
                <form action="SendMail.jsp" method="post">  
                    <div class="mb-3">
                        <label class="form-label fw-bold">To</label>
                        <input type="text" class="form-control" value="<%= EmailUtil.getMailUser() %>" name="to" readonly required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">From</label>
                        <input type="text" class="form-control" value="<%=(String)session.getAttribute("email")%>" name="from" required readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Subject</label>
                        <input type="text" class="form-control" placeholder="Enter inquiry subject" name="subject" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Message</label>
                        <textarea class="form-control" rows="4" placeholder="Type your message here..." name="msg" required></textarea>
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <button type="submit" class="btn btn-primary px-4">Send Message</button>
                        <button type="reset" class="btn btn-secondary px-4">Clear</button>
                        <button type="button" class="btn btn-outline-dark px-4" onclick="window.location.href = 'Home.jsp'">Back</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
