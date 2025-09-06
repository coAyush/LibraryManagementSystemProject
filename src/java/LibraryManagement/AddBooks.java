package LibraryManagement;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;

@WebServlet("/AddBooks")
public class AddBooks extends HttpServlet {

    final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String username = "root";
    final String password = "ayush52141";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = "E:\\Servelet\\Servlet_SSSA\\LibraryManagementSystem\\web\\pdf";
        MultipartRequest m = new MultipartRequest(request, path, 50 * 1024 * 1024, new DefaultFileRenamePolicy()); // gets <input type="file" name="pdf">
        String title = m.getParameter("title");
        String Author = m.getParameter("author");
        String fileName = m.getFilesystemName("pdf");
        int count = Integer.parseInt(m.getParameter("count"));
        try {
            HttpSession session = request.getSession();
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, username, password)) {

                String query = "INSERT INTO books(title, author, pdf, count) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, title);
                ps.setString(2, Author);
                ps.setString(3, fileName); // store relative path
                ps.setInt(4, count);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    session.setAttribute("Goal", "success");
                    response.sendRedirect("AddBooks.jsp");
                } else {
                    session.setAttribute("Goal", "Not success");
                    response.sendRedirect("AddBooks.jsp");
                }
            } catch (SQLException e) {
                e.getMessage();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Couldnot write on db");
        }
    }
}
