<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Books</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            h1 {
                font-weight: bolder;
                color: rgba(0, 231, 58, 0.904);
                font-family: Arial, Helvetica, sans-serif;
                display: block;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr 1fr;
                column-gap: 15px;
                margin-bottom: 20px;
            }
            .o {
                height: 45px;
                min-width: 130px;
                color: whitesmoke;
                border-radius: 25px;
                border: none;
                background-color: #20c997;
                font-weight: bold;
                font-size: 1.1rem;
            }
            .o:hover{
                cursor: pointer;
                opacity: 0.9;
            }
        </style>
    </head>
    <body class="container py-4">

        <div class="text-center p-3 mb-4 bg-light rounded shadow-sm">
            <h1 class="m-0 text-success">Add New Book</h1>
        </div>

        <%
            String goal = (String) session.getAttribute("Goal");
            session.removeAttribute("Goal");
            if (goal != null) {
                if ("success".equalsIgnoreCase(goal)) {
        %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>✅ Book added successfully!</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%      } else { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">       
            <strong>❌ Book could not be added. Please verify inputs.</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%      }
            }
        %>

        <form method="post" action="AddBooks" enctype="multipart/form-data" class="card shadow p-4">
            <div class="form-grid">
                <div>
                    <label class="form-label font-weight-bold">Title</label>
                    <input type="text" name="title" class="form-control" required placeholder="Enter book title">
                </div>
                <div>
                    <label class="form-label font-weight-bold">Author</label>
                    <input type="text" name="author" class="form-control" required placeholder="Enter author name">
                </div>
                <div>
                    <label class="form-label font-weight-bold">PDF File</label>
                    <input type="file" name="pdf" class="form-control" accept=".pdf" required>
                </div>
                <div>
                    <label class="form-label font-weight-bold">Quantity</label>
                    <input type="number" name="count" class="form-control" min="1" value="1" required>
                </div>
            </div>

            <div class="d-flex justify-content-center gap-3 mt-3">
                <input type="submit" value="Submit" class="btn btn-success px-4">
                <input type="reset" value="Reset" class="btn btn-secondary px-4">
                <button type="button" class="btn btn-outline-primary px-4" onclick="window.location.href = 'Admin.jsp'">Back to Dashboard</button>
            </div>
        </form>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
