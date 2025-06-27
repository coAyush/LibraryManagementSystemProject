<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="javax.mail.*, javax.mail.internet.*"%>
<%@page import="java.io.*, java.sql.*, java.time.LocalDateTime, java.util.*"%>
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

    final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String dbUser = "root";
    final String dbPass = "ayush52141";

    if (title != null && name != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, dbUser, dbPass);

            // Get book details
            prep = con.prepareStatement("SELECT * FROM Books WHERE title=?");
            prep.setString(1, title);
            rs = prep.executeQuery();

            int bookId = 0, count = 0;
            if (rs.next()) {
                bookId = rs.getInt("book_id");
                count = rs.getInt("count");
            }

            // Get user email
            userStmt = con.prepareStatement("SELECT email FROM Users WHERE Name=?");
            userStmt.setString(1, name);
            ru = userStmt.executeQuery();
            if (ru.next()) {
                mail = ru.getString("email");
            }

            if (count > 0) {
                count--;
                updateStmt = con.prepareStatement("UPDATE Books SET count=? WHERE book_id=?");
                updateStmt.setInt(1, count);
                updateStmt.setInt(2, bookId);
                updated = updateStmt.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ru != null) ru.close(); } catch (Exception e) {}
            try { if (prep != null) prep.close(); } catch (Exception e) {}
            try { if (userStmt != null) userStmt.close(); } catch (Exception e) {}
            try { if (updateStmt != null) updateStmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        if (updated) {
            // Create PDF
            String folderPath = application.getRealPath("/") + "Issue/";
            File folder = new File(folderPath);
            if (!folder.exists()) folder.mkdirs();

            String filePath = folderPath + title + ".pdf";
            Document doc = new Document();
            try {
                PdfWriter.getInstance(doc, new FileOutputStream(filePath));
                doc.open();
                doc.add(new Paragraph("Book Issued Successfully\n\n"));
                PdfPTable table = new PdfPTable(4);
                table.addCell("Name");
                table.addCell("Title");
                table.addCell("Issue Date");
                table.addCell("Due Date");

                table.addCell(name);
                table.addCell(title);
                table.addCell(LocalDateTime.now().toLocalDate().toString());
                table.addCell(LocalDateTime.now().plusDays(15).toLocalDate().toString());
                doc.add(table);
                doc.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Send Email
            final String fromUser = "librarysystemxyz@gmail.com";
            final String fromPass = "vprtzczxtnuoazdb"; // Use app password
            String subject = "Book Issue Details";
            String msg = "Dear " + name + ",\n\nYour book has been issued successfully.\nPlease check the attached receipt.\n\nThanks,\nLibrary Team";

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            Session ses = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromUser, fromPass);
                }
            });

            try {
                MimeMessage message = new MimeMessage(ses);
                message.setFrom(new InternetAddress(fromUser));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(mail));
                message.setSubject(subject);

                MimeBodyPart textPart = new MimeBodyPart();
                textPart.setText(msg);

                MimeBodyPart attachPart = new MimeBodyPart();
                attachPart.attachFile(new File(filePath));

                Multipart mp = new MimeMultipart();
                mp.addBodyPart(textPart);
                mp.addBodyPart(attachPart);

                message.setContent(mp);
                Transport.send(message);

                response.sendRedirect("BrowseBooks.jsp?status=done");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("BrowseBooks.jsp?status=not done");
            }

        } else {
            response.sendRedirect("BrowseBooks.jsp?status=not done");
        }

    } else {
        response.sendRedirect("BrowseBooks.jsp?status=not done");
    }
%>
</body>
</html>
