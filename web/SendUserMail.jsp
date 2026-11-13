<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@page import="LibraryManagement.EmailUtil"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processing Issue Receipt</title>
    </head>
    <body>
    <%
        HttpSession ses = request.getSession(false);
        if (ses != null) {
            String to = String.valueOf(ses.getAttribute("email"));
            String name = String.valueOf(ses.getAttribute("USER"));
            String subject = "Book Issue Receipt - Library";
            String msg = "Dear " + name + ",\n\nYour book has been issued successfully.\nPlease find your official issue receipt attached.\n\nThank you,\nLibrary Management Team";
            String pdfPath = String.valueOf(ses.getAttribute("pdfPath"));

            boolean sent = false;
            try {
                sent = EmailUtil.sendEmailWithAttachment(to, subject, msg, pdfPath);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // The book was already issued in database and PDF generated.
            // Redirect to BrowseBooksServlet with proper success status.
            if (sent) {
                response.sendRedirect("BrowseBooksServlet?status=done");
            } else {
                response.sendRedirect("BrowseBooksServlet?status=done_no_mail");
            }
        } else {
            response.sendRedirect("Login.jsp");
        }
    %>
    </body>
</html>
