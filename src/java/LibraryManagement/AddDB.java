package LibraryManagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        int b_id = 0;
        int count = 0;
        String author = "";
        String title = request.getParameter("title");
        LocalDate issue = LocalDate.now();
        LocalDate due = LocalDate.now().plusDays(20);

        String q1 = "SELECT * FROM books WHERE title=?";
        String q2 = "INSERT INTO issue(U_ID,B_ID,Issue_Date,Due_Date) VALUES (?,?,?,?)";
        String q3 = "UPDATE books SET count=? WHERE title=?";

        Connection con = null;
        PreparedStatement prep1 = null;
        PreparedStatement prep2 = null;
        PreparedStatement prep3 = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            prep1 = con.prepareStatement(q1);
            prep2 = con.prepareStatement(q2);
            prep3 = con.prepareStatement(q3);

            prep1.setString(1, title);
            rs = prep1.executeQuery();
            if (rs.next()) {
                b_id = rs.getInt("book_id");
                author = rs.getString("author");
                count = rs.getInt("count");
            } else {
                response.sendRedirect("BrowseBooksServlet?status=book_not_found");
                return;
            }

            if (count > 0) {
                count -= 1;
            } else {
                response.sendRedirect("BrowseBooksServlet?status=notdone");
                return;
            }

            prep3.setInt(1, count);
            prep3.setString(2, title);
            int s1 = prep3.executeUpdate();

            if (s1 > 0) {
                prep2.setInt(1, u_id);
                prep2.setInt(2, b_id);
                prep2.setDate(3, java.sql.Date.valueOf(issue));
                prep2.setDate(4, java.sql.Date.valueOf(due));
                int s2 = prep2.executeUpdate();

                if (s2 > 0) {
                    ses.setAttribute("author", author);
                    ses.setAttribute("book_id", b_id);
                    ses.setAttribute("title", title);
                    ses.setAttribute("Issue", issue);
                    ses.setAttribute("Due", due);
                    RequestDispatcher rd = request.getRequestDispatcher("CreatePdf");
                    rd.forward(request, response);
                } else {
                    response.sendRedirect("BrowseBooksServlet?status=notdone");
                }
            } else {
                response.sendRedirect("BrowseBooksServlet?status=notdone");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BrowseBooksServlet?status=notdone");
        } finally {
            DBConnection.closeQuietly(rs, prep1, prep2, prep3, con);
        }
    }
}
