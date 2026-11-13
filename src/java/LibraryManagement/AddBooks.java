package LibraryManagement;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/AddBooks")
public class AddBooks extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String path = getServletContext().getRealPath("/pdf");
        if (path == null) {
            path = System.getProperty("java.io.tmpdir") + File.separator + "pdf";
        }

        File uploadDir = new File(path);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        MultipartRequest m = null;
        try {
            m = new MultipartRequest(
                    request,
                    path,
                    50 * 1024 * 1024,
                    "UTF-8",
                    new DefaultFileRenamePolicy()
            );
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("Goal", "error");
            session.setAttribute("GoalMsg", "File upload failed: " + e.getMessage());
            response.sendRedirect("AddBooks.jsp");
            return;
        }

        String rawTitle = m.getParameter("title");
        String rawAuthor = m.getParameter("author");
        String title = (rawTitle != null) ? rawTitle.trim() : "";
        String author = (rawAuthor != null) ? rawAuthor.trim() : "";
        String fileName = m.getFilesystemName("pdf");
        String countStr = m.getParameter("count");
        int count = 1;

        if (title.isEmpty() || author.isEmpty()) {
            session.setAttribute("Goal", "error");
            session.setAttribute("GoalMsg", "Title and Author are required fields.");
            response.sendRedirect("AddBooks.jsp");
            return;
        }

        try {
            if (countStr != null && !countStr.trim().isEmpty()) {
                count = Integer.parseInt(countStr.trim());
            }
        } catch (NumberFormatException ignored) {
            count = 1;
        }

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement psRefresh = null;
        ResultSet rsRefresh = null;

        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO books(title, author, pdf, count) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(query);

            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, fileName != null ? fileName : "");
            ps.setInt(4, count);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // Immediately refresh ServletContext booklist
                List<Book> booklist = new ArrayList<>();
                psRefresh = con.prepareStatement("SELECT * FROM books");
                rsRefresh = psRefresh.executeQuery();
                while (rsRefresh.next()) {
                    booklist.add(new Book(
                            rsRefresh.getString("title"),
                            rsRefresh.getString("author"),
                            rsRefresh.getString("pdf"),
                            rsRefresh.getInt("count")
                    ));
                }
                getServletContext().setAttribute("booklist", booklist);

                session.setAttribute("Goal", "success");
                session.setAttribute("GoalMsg", "Book '" + title + "' added successfully with " + count + " copies!");
            } else {
                session.setAttribute("Goal", "error");
                session.setAttribute("GoalMsg", "Database insert returned 0 rows affected.");
            }
            response.sendRedirect("AddBooks.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("Goal", "error");
            session.setAttribute("GoalMsg", "Database error: " + e.getMessage());
            response.sendRedirect("AddBooks.jsp");
        } finally {
            DBConnection.closeQuietly(rsRefresh, psRefresh, ps, con);
        }
    }
}
