<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<%
    if (session.getAttribute("USER") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book - Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            margin: 40px auto;
            max-width: 550px;
            background-color: #ffffff;
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
        String status = request.getParameter("return");
        if (status != null) {
            if ("success".equalsIgnoreCase(status)) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ✅ <strong>Book returned successfully!</strong> Thank you for returning on time.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      } else { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ❌ <strong>Could not return book.</strong> Please make sure you have this book issued and the title matches.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%      }
        }
    %>

    <!-- Return Form -->
    <div class="form-container">
        <h3 class="text-center mb-4 fw-bold">Return a Book</h3>
        <form action="Return" method="post" class="needs-validation" novalidate>
            <div class="mb-4">
                <label for="title" class="form-label fw-bold">Book Title</label>
                <input type="text" class="form-control" id="title" name="title" placeholder="Enter the exact book title" required>
                <div class="invalid-feedback">Please enter the book title.</div>
            </div>
            <div class="d-flex justify-content-center gap-3">
                <button type="submit" class="btn btn-success px-4">Return Book</button>
                <button type="reset" class="btn btn-secondary px-4">Reset</button>
                <a href="Home.jsp" class="btn btn-outline-dark px-4">Back</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (() => {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', e => {
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
