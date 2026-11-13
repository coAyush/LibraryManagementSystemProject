<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Add New Book - Admin Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }
            .form-card {
                border: none;
                border-radius: 12px;
            }
        </style>
    </head>
    <body>
        <!-- Responsive Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="Admin.jsp">Admin Portal</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navContent">
                    <div class="navbar-nav ms-auto align-items-lg-center gap-2">
                        <a href="Admin.jsp" class="btn btn-outline-light btn-sm">Dashboard</a>
                        <a href="BrowseBooksServlet" class="btn btn-outline-primary btn-sm">Manage Stock</a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container my-4" style="max-width: 750px;">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h3 class="fw-bold mb-0">Add New Book</h3>
                <a href="Admin.jsp" class="btn btn-outline-secondary btn-sm">← Back to Dashboard</a>
            </div>

            <!-- Notification Alerts -->
            <%
                String goal = (String) session.getAttribute("Goal");
                String goalMsg = (String) session.getAttribute("GoalMsg");
                session.removeAttribute("Goal");
                session.removeAttribute("GoalMsg");

                if (goal != null) {
                    if ("success".equalsIgnoreCase(goal)) {
            %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <strong><%= (goalMsg != null ? goalMsg : "✅ Book added successfully!") %></strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      } else { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">       
                <strong>❌ <%= (goalMsg != null ? goalMsg : "Book could not be added. Please verify inputs.") %></strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <%      }
                }
            %>

            <!-- Responsive Add Book Form -->
            <div class="card form-card shadow-sm p-4">
                <form method="post" action="AddBooks" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label fw-bold">Book Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" required placeholder="e.g. Clean Code">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label fw-bold">Author <span class="text-danger">*</span></label>
                            <input type="text" name="author" class="form-control" required placeholder="e.g. Robert C. Martin">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label fw-bold">PDF Document (.pdf)</label>
                            <input type="file" name="pdf" class="form-control" accept=".pdf" required>
                            <div class="form-text">Upload eBook or digital reference file.</div>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label fw-bold">Initial Quantity <span class="text-danger">*</span></label>
                            <input type="number" name="count" class="form-control" min="1" value="1" required>
                            <div class="form-text">Number of copies to add to stock.</div>
                        </div>
                    </div>

                    <div class="d-flex flex-wrap gap-2 justify-content-end mt-4">
                        <button type="reset" class="btn btn-secondary px-4">Reset</button>
                        <button type="submit" class="btn btn-success px-4">Save Book</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
