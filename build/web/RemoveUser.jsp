<%-- 
    Document   : RemoveUser
    Created on : 17 Jun, 2025, 6:39:09 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*,javax.servlet.http.*,java.util.*"%>
<%@page session="true"%>
<%@include file="Header.jsp" %>
<%@include file="Footer.jsp" %>
<%@page import="LibraryManagement.User,LibraryManagement.Refresh" %>
<!DOCTYPE html>
<html>
    <head>
        <style>
            .o{
                display: block;
                background-color: #f0f0f0;
                font-family:Comic Sans MS;
                height: 50px;
                font-weight: bolder;
                color: magenta;
                text-align: center;
                line-height: 50px;
            }
            .o:hover{
                opacity: 0.25;
                background-color: aquamarine;
            }
            .i{
                display: flex;
                column-gap: 5px;
                margin-left: 2px;
            }
        </style>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Remove User</title>
    </head>
    <body>
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
    </symbol>
    </svg>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <P class="o"> Welcome  <%=session.getAttribute("USER")%></p>  
        <% String status = request.getParameter("status");
            if (status != null) {
                if ("success".equalsIgnoreCase(status)) {

        %>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="check-circle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
    </symbol>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#check-circle-fill"/></svg><strong> Deletion successful</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%} else if (("notfound").equalsIgnoreCase(status)) {
    %>
    <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="info-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
    </symbol>
    </svg>
    <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Info:"><use xlink:href="#info-fill"/></svg> <strong> Not Found</strong>
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
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>     <strong>Admin deletion not possible</strong>   
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% }
        }%>
    <div class="alert alert-warning d-flex align-items-center" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Warning:"><use xlink:href="#exclamation-triangle-fill"/></svg>
        <div>
            Warning!! Deleting the record will delete the entire user's data....Be Careful!!
        </div>
    </div>
       
   <!-- Before </body>, replace your current table+form block with this -->

<div class="container mt-4">
    <h3 class="mb-3">Users List</h3>
    
    <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
        <table class="table table-bordered table-hover">
            <thead class="table-dark sticky-top">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<User> Userslist = (List<User>) getServletContext().getAttribute("USERSlist");
                    if (Userslist != null) {
                        for (User u : Userslist) {
                %>
                    <tr>
                        <td><%= u.getID() %></td>
                        <td><%= u.getName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getRole() %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <hr class="my-4">

    <h4>Remove User by ID</h4>
    <form class="row g-3" action="RemoveUser" method="post">
        <div class="col-md-6">
            <label for="inputId" class="form-label">ID</label>
            <input type="number" class="form-control" name="Id" id="inputId" required>
        </div>

        <div class="i mt-2">
            <div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </div>
            <div>
                <button type="reset" class="btn btn-secondary ms-2">Reset</button>
            </div>
            <div>
                <button type="button" class="btn btn-danger ms-2" onclick="window.location.href = 'Admin.jsp'">Back</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>
