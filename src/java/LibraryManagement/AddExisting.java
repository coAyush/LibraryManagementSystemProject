package LibraryManagement;

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

@WebServlet(name = "AddExisting", urlPatterns = {"/AddExisting"})
public class AddExisting extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Book> booklist = new ArrayList<>();
        String title = request.getParameter("title");
        String countStr = request.getParameter("count");
        int count = (countStr != null && !countStr.trim().isEmpty()) ? Integer.parseInt(countStr.trim()) : 0;
        int currentCount = 0;

        String q2 = "SELECT count FROM books WHERE title=?";
        String q3 = "UPDATE books SET count=? WHERE title=?";
        String q4 = "SELECT * FROM books";

        Connection con = null;
        PreparedStatement prep2 = null;
        PreparedStatement prep3 = null;
        PreparedStatement fetch = null;
        ResultSet rs = null;
        ResultSet allBooks = null;

        try {
            con = DBConnection.getConnection();
            prep2 = con.prepareStatement(q2);
            prep2.setString(1, title);
            rs = prep2.executeQuery();
            if (rs.next()) {
                currentCount = rs.getInt("count");
            }

            count += currentCount;
            prep3 = con.prepareStatement(q3);
            prep3.setInt(1, count);
            prep3.setString(2, title);
            int c = prep3.executeUpdate();

            if (c > 0) {
                fetch = con.prepareStatement(q4);
                allBooks = fetch.executeQuery();
                while (allBooks.next()) {
                    booklist.add(new Book(
                            allBooks.getString("title"),
                            allBooks.getString("author"),
                            allBooks.getString("pdf"),
                            allBooks.getInt("count")
                    ));
                }
                getServletContext().setAttribute("booklist", booklist);
                response.sendRedirect("AddExisting.jsp?Added=success");
            } else {
                response.sendRedirect("AddExisting.jsp?Added=not");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddExisting.jsp?Added=not");
        } finally {
            DBConnection.closeQuietly(rs, allBooks, prep2, prep3, fetch, con);
        }
    }
}
