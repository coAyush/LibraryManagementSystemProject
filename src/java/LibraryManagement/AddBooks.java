package LibraryManagement;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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

        String path = getServletContext().getRealPath("/pdf");
        if (path == null) {
            path = System.getProperty("java.io.tmpdir") + File.separator + "pdf";
        }

        File uploadDir = new File(path);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        MultipartRequest m = new MultipartRequest(
                request,
                path,
                50 * 1024 * 1024,
                "UTF-8",
                new DefaultFileRenamePolicy()
        );

        String title = m.getParameter("title");
        String author = m.getParameter("author");
        String fileName = m.getFilesystemName("pdf");
        String countStr = m.getParameter("count");
        int count = (countStr != null && !countStr.trim().isEmpty()) ? Integer.parseInt(countStr.trim()) : 1;

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO books(title, author, pdf, count) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(query);

            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, fileName != null ? fileName : "");
            ps.setInt(4, count);

            int rows = ps.executeUpdate();

            HttpSession session = request.getSession();
            if (rows > 0) {
                session.setAttribute("Goal", "success");
            } else {
                session.setAttribute("Goal", "Not success");
            }
            response.sendRedirect("AddBooks.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("Goal", "Not success");
            response.sendRedirect("AddBooks.jsp");
        } finally {
            DBConnection.closeQuietly(ps, con);
        }
    }
}
