package LibraryManagement;

import java.io.IOException;
import java.net.URLEncoder;
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

        String rawTitle = request.getParameter("title");
        String title = (rawTitle != null) ? rawTitle.trim() : "";
        String countStr = request.getParameter("count");
        int countToAdd = 1;

        try {
            if (countStr != null && !countStr.trim().isEmpty()) {
                countToAdd = Integer.parseInt(countStr.trim());
            }
        } catch (NumberFormatException ignored) {
            countToAdd = 1;
        }

        if (title.isEmpty()) {
            response.sendRedirect("AddExisting.jsp?Added=empty_title");
            return;
        }

        String qFind = "SELECT book_id, title, count FROM books WHERE LOWER(TRIM(title)) = LOWER(TRIM(?))";
        String qUpdate = "UPDATE books SET count=? WHERE book_id=?";
        String qFetchAll = "SELECT * FROM books";

        Connection con = null;
        PreparedStatement psFind = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psFetchAll = null;
        ResultSet rsFind = null;
        ResultSet rsAll = null;

        try {
            con = DBConnection.getConnection();
            psFind = con.prepareStatement(qFind);
            psFind.setString(1, title);
            rsFind = psFind.executeQuery();

            if (rsFind.next()) {
                int bookId = rsFind.getInt("book_id");
                String canonicalTitle = rsFind.getString("title");
                int currentCount = rsFind.getInt("count");
                int newTotal = currentCount + countToAdd;

                psUpdate = con.prepareStatement(qUpdate);
                psUpdate.setInt(1, newTotal);
                psUpdate.setInt(2, bookId);
                int updated = psUpdate.executeUpdate();

                if (updated > 0) {
                    // Refresh ServletContext booklist
                    List<Book> booklist = new ArrayList<>();
                    psFetchAll = con.prepareStatement(qFetchAll);
                    rsAll = psFetchAll.executeQuery();
                    while (rsAll.next()) {
                        booklist.add(new Book(
                                rsAll.getString("title"),
                                rsAll.getString("author"),
                                rsAll.getString("pdf"),
                                rsAll.getInt("count")
                        ));
                    }
                    getServletContext().setAttribute("booklist", booklist);

                    response.sendRedirect("AddExisting.jsp?Added=success&title="
                            + URLEncoder.encode(canonicalTitle, "UTF-8")
                            + "&newCount=" + newTotal);
                    return;
                }
            } else {
                response.sendRedirect("AddExisting.jsp?Added=not_found&title="
                        + URLEncoder.encode(title, "UTF-8"));
                return;
            }

            response.sendRedirect("AddExisting.jsp?Added=not");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddExisting.jsp?Added=error");
        } finally {
            DBConnection.closeQuietly(rsAll, rsFind, psFetchAll, psUpdate, psFind, con);
        }
    }
}
