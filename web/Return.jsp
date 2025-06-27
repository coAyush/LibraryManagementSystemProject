<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Return Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            margin: 40px auto;
            max-width: 600px;
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }
        .carousel-caption h5 {
            font-weight: bold;
        }
    </style>
</head>
<body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>

<%
    String status = request.getParameter("return");
    if (status != null) {
        if ("success".equalsIgnoreCase(status)) {
%>
<div class="alert alert-success alert-dismissible fade show m-3" role="alert">
    ✅ <strong>Book returned successfully!</strong>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<%
        } else {
%>
<div class="alert alert-danger alert-dismissible fade show m-3" role="alert">
    ❌ <strong>Could not return the book. Try again.</strong>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<%
        }
    }
%>

<!-- Carousel for Notices -->
<div id="noticeCarousel" class="carousel slide container mt-4" data-bs-ride="carousel" data-bs-interval="5000">
    <div class="carousel-inner bg-light p-3 rounded">
        <div class="carousel-item active text-center">
            <h5 class="text-primary">📚 Return books on time!</h5>
        </div>
        <div class="carousel-item text-center">
            <h5 class="text-danger">⏳ Late fine: ₹10 per day</h5>
        </div>
        <div class="carousel-item text-center">
            <h5 class="text-info">👤 Check profile for issued books</h5>
        </div>
    </div>
</div>

<!-- Return Form -->
<div class="form-container">
    <h2 class="text-center mb-4">Return a Book</h2>
    <form action="Return" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
            <label for="title" class="form-label">Book Title</label>
            <input type="text" class="form-control" id="title" name="title" placeholder="Enter the book title" required>
            <div class="invalid-feedback">Please enter the book title.</div>
        </div>
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-success">Return Book</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
            <a href="Home.jsp" class="btn btn-danger">Back</a>
        </div>
    </form>
</div>

<script>
    // Bootstrap validation
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
