package LibraryManagement;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Return", urlPatterns = {"/Return"})
public class Return extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession ses = request.getSession(false);
        if (ses == null || ses.getAttribute("ID") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int u_id = (Integer) ses.getAttribute("ID");
        String rawTitle = request.getParameter("title");
        String title = (rawTitle != null) ? rawTitle.trim() : "";

        if (title.isEmpty()) {
            response.sendRedirect("Return.jsp?return=empty_title");
            return;
        }

        String qFindBook = "SELECT book_id, title, count FROM books WHERE LOWER(TRIM(title)) = LOWER(TRIM(?))";
        String qCheckIssue = "SELECT * FROM issue WHERE U_ID=? AND B_ID=?";
        String qDeleteIssue = "DELETE FROM issue WHERE U_ID=? AND B_ID=? LIMIT 1";
        String qUpdateCount = "UPDATE books SET count=? WHERE book_id=?";

        Connection con = null;
        PreparedStatement psFind = null;
        PreparedStatement psCheck = null;
        PreparedStatement psDelete = null;
        PreparedStatement psUpdate = null;
        ResultSet rsFind = null;
        ResultSet rsCheck = null;

        try {
            con = DBConnection.getConnection();

            // 1. Find book
            psFind = con.prepareStatement(qFindBook);
            psFind.setString(1, title);
            rsFind = psFind.executeQuery();

            if (!rsFind.next()) {
                response.sendRedirect("Return.jsp?return=not_found&title=" + URLEncoder.encode(title, "UTF-8"));
                return;
            }

            int b_id = rsFind.getInt("book_id");
            String canonicalTitle = rsFind.getString("title");
            int count = rsFind.getInt("count");

            // 2. Check if student actually has this book issued
            psCheck = con.prepareStatement(qCheckIssue);
            psCheck.setInt(1, u_id);
            psCheck.setInt(2, b_id);
            rsCheck = psCheck.executeQuery();

            if (!rsCheck.next()) {
                response.sendRedirect("Return.jsp?return=not_issued&title=" + URLEncoder.encode(canonicalTitle, "UTF-8"));
                return;
            }

            // 3. Delete issue record
            psDelete = con.prepareStatement(qDeleteIssue);
            psDelete.setInt(1, u_id);
            psDelete.setInt(2, b_id);
            int deleted = psDelete.executeUpdate();

            if (deleted > 0) {
                // 4. Increment available count
                psUpdate = con.prepareStatement(qUpdateCount);
                psUpdate.setInt(1, count + 1);
                psUpdate.setInt(2, b_id);
                psUpdate.executeUpdate();

                response.sendRedirect("Return.jsp?return=success&title=" + URLEncoder.encode(canonicalTitle, "UTF-8"));
            } else {
                response.sendRedirect("Return.jsp?return=not");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Return.jsp?return=not");
        } finally {
            DBConnection.closeQuietly(rsCheck, rsFind, psDelete, psUpdate, psCheck, psFind, con);
        }
    }
}
