<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.io.*, java.sql.*, java.time.LocalDateTime, java.util.*"%>
<%@page import="LibraryManagement.DBConnection, LibraryManagement.EmailUtil"%>
<%@page session="true" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issue Book</title>
</head>
<body>
<%
    String title = request.getParameter("title");
    String name = (String) session.getAttribute("USER");
    String mail = "";
    boolean updated = false;

    Connection con = null;
    PreparedStatement prep = null, userStmt = null, updateStmt = null;
    ResultSet rs = null, ru = null;

    if (title != null && name != null) {
        try {
            con = DBConnection.getConnection();

            // Get book details
            prep = con.prepareStatement("SELECT * FROM books WHERE title=?");
            prep.setString(1, title);
            rs = prep.executeQuery();

            int bookId = 0, count = 0;
            if (rs.next()) {
                bookId = rs.getInt("book_id");
                count = rs.getInt("count");
            }

            // Get user email
            userStmt = con.prepareStatement("SELECT email FROM users WHERE Name=?");
            userStmt.setString(1, name);
            ru = userStmt.executeQuery();
            if (ru.next()) {
                mail = ru.getString("email");
            }

            if (count > 0) {
                count--;
                updateStmt = con.prepareStatement("UPDATE books SET count=? WHERE book_id=?");
                updateStmt.setInt(1, count);
                updateStmt.setInt(2, bookId);
                updated = updateStmt.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, ru, prep, userStmt, updateStmt, con);
        }

        if (updated) {
            // Create professional PDF receipt
            String folderPath = application.getRealPath("/Issue");
            if (folderPath == null) {
                folderPath = System.getProperty("java.io.tmpdir") + File.separator + "Issue";
            }
            File folder = new File(folderPath);
            if (!folder.exists()) folder.mkdirs();

            String safeTitle = title.replaceAll("[^a-zA-Z0-9.-]", "_");
            String filePath = folder.getAbsolutePath() + File.separator + safeTitle + "_" + System.currentTimeMillis() + ".pdf";
            String issueDateStr = java.time.LocalDate.now().toString();
            String dueDateStr = java.time.LocalDate.now().plusDays(20).toString();

            try {
                LibraryManagement.CreatePdf.createReceipt(filePath, name, mail, title, issueDateStr, dueDateStr);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Send Email
            String subject = "Book Issued: " + title + " (Receipt Attached)";
            String msg = "Dear " + name + ",\n\nYour book '" + title + "' has been issued successfully.\n"
                    + "Issue Date: " + issueDateStr + "\n"
                    + "Return Due Date: " + dueDateStr + " (20 Days Loan)\n\n"
                    + "Please find your official transaction receipt attached.\n\n"
                    + "Best regards,\nLibrary Management Portal";
            boolean sent = EmailUtil.sendEmailWithAttachment(mail, subject, msg, filePath);

            response.sendRedirect("BrowseBooks.jsp?status=" + (sent ? "done" : "done"));

        } else {
            response.sendRedirect("BrowseBooks.jsp?status=notdone");
        }

    } else {
        response.sendRedirect("BrowseBooks.jsp?status=notdone");
    }
%>
</body>
</html>
