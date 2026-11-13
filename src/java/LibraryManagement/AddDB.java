package LibraryManagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddDB", urlPatterns = {"/AddDB"})
public class AddDB extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            response.sendRedirect("BrowseBooksServlet?status=book_not_found");
            return;
        }

        int b_id = 0;
        int count = 0;
        String author = "";
        String canonicalTitle = title;
        LocalDate issue = LocalDate.now();
        LocalDate due = LocalDate.now().plusDays(20);

        String qFind = "SELECT * FROM books WHERE LOWER(TRIM(title)) = LOWER(TRIM(?))";
        String qCheckExisting = "SELECT * FROM issue WHERE U_ID=? AND B_ID=?";
        String qInsertIssue = "INSERT INTO issue(U_ID, B_ID, Issue_Date, Due_Date) VALUES (?, ?, ?, ?)";
        String qUpdateCount = "UPDATE books SET count=? WHERE book_id=?";

        Connection con = null;
        PreparedStatement psFind = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rsFind = null;
        ResultSet rsCheck = null;

        try {
            con = DBConnection.getConnection();

            // 1. Find the book
            psFind = con.prepareStatement(qFind);
            psFind.setString(1, title);
            rsFind = psFind.executeQuery();

            if (rsFind.next()) {
                b_id = rsFind.getInt("book_id");
                canonicalTitle = rsFind.getString("title");
                author = rsFind.getString("author");
                count = rsFind.getInt("count");
            } else {
                response.sendRedirect("BrowseBooksServlet?status=book_not_found");
                return;
            }

            // 2. Check if student already has this book issued
            psCheck = con.prepareStatement(qCheckExisting);
            psCheck.setInt(1, u_id);
            psCheck.setInt(2, b_id);
            rsCheck = psCheck.executeQuery();
            if (rsCheck.next()) {
                response.sendRedirect("BrowseBooksServlet?status=already_issued");
                return;
            }

            // 3. Check stock
            if (count <= 0) {
                response.sendRedirect("BrowseBooksServlet?status=out_of_stock");
                return;
            }

            // 4. Decrement count
            count -= 1;
            psUpdate = con.prepareStatement(qUpdateCount);
            psUpdate.setInt(1, count);
            psUpdate.setInt(2, b_id);
            int updated = psUpdate.executeUpdate();

            // 5. Insert issue record
            if (updated > 0) {
                psInsert = con.prepareStatement(qInsertIssue);
                psInsert.setInt(1, u_id);
                psInsert.setInt(2, b_id);
                psInsert.setDate(3, java.sql.Date.valueOf(issue));
                psInsert.setDate(4, java.sql.Date.valueOf(due));
                int inserted = psInsert.executeUpdate();

                if (inserted > 0) {
                    ses.setAttribute("author", author);
                    ses.setAttribute("book_id", b_id);
                    ses.setAttribute("title", canonicalTitle);
                    ses.setAttribute("Issue", issue);
                    ses.setAttribute("Due", due);
                    RequestDispatcher rd = request.getRequestDispatcher("CreatePdf");
                    rd.forward(request, response);
                    return;
                }
            }

            response.sendRedirect("BrowseBooksServlet?status=notdone");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BrowseBooksServlet?status=notdone");
        } finally {
            DBConnection.closeQuietly(rsCheck, rsFind, psInsert, psUpdate, psCheck, psFind, con);
        }
    }
}
