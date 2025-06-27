<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Header.jsp" %>
<%@include file="Header.jsp" %>
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
            .mb-3 {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr 1fr;
                column-gap: 5px;
                margin-bottom: 20px;
            }
            .o {
                height: 50px;
                width: 150px;
                color: whitesmoke;
                border-radius: 25px;
                border: none;
                background-color: aquamarine;
                font-weight: bolder;
                font-size: 1.2rem;
            }
            .o:hover{
                cursor: pointer;
            }
            .o:active{
                text-decoration: underline;
                background-color: yellowgreen;
                opacity: 0.90;
                box-shadow: 12px 12px 12px #cccccc;
            }
        </style>
    </head>
    <body>

    <marquee style="background-color: yellow"><h1>Add Books</h1></marquee>
        <%String goal = (String) session.getAttribute("Goal");
            session.removeAttribute("Goal");
            if (goal != null) {
                if ("success".equalsIgnoreCase(goal)) {
        %>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="check-circle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
    </symbol>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#check-circle-fill"/></svg><strong> Book added successfully</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%} else {
    %>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
    </symbol>
    </svg>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">       
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>     <strong>Books could not be added</strong>   
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%}
        }%>
    <form method="post" action="AddBooks" enctype="multipart/form-data">
        <div class="mb-3">
            <div>
                <label class="form-label">Title</label>
                <input type="text" name="title" class="form-control" required>
            </div>
            <div>
                <label class="form-label">Author</label>
                <input type="text" name="author" class="form-control" required>
            </div>
            <div>
                <label class="form-label">PDF</label>
                <input type="file" name="pdf" class="form-control" accept=".pdf"  enctype="multipart/form-data">
            </div>

            <div>
                <label class="form-label">Count</label>
                <input type="number" name="count" class="form-control" min="1" required>
            </div>
        <div class="d-flex justify-content-center gap-3 mt-3">
        <input type="submit" value="Submit" class="o">
        <input type="reset" value="Reset" class="o" style="background-color: graytext">
        <button type="button" class="o"btn btn-primary onclick="window.location.href = 'Admin.jsp'">Back</button>
    </div>

    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>