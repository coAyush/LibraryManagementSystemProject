package LibraryManagement;

import java.io.IOException;
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
        int b_id = 0;
        int count = 0;
        String title = request.getParameter("title");

        String q1 = "SELECT count, book_id FROM books WHERE title=?";
        String q2 = "DELETE FROM issue WHERE U_ID=? AND B_ID=?";
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
                count = rs.getInt("count") + 1;
                b_id = rs.getInt("book_id");

                prep3.setInt(1, count);
                prep3.setString(2, title);
                int c1 = prep3.executeUpdate();

                if (c1 > 0) {
                    prep2.setInt(1, u_id);
                    prep2.setInt(2, b_id);
                    int c2 = prep2.executeUpdate();

                    if (c2 > 0) {
                        response.sendRedirect("Return.jsp?return=success");
                    } else {
                        response.sendRedirect("Return.jsp?return=not");
                    }
                } else {
                    response.sendRedirect("Return.jsp?return=not");
                }
            } else {
                response.sendRedirect("Return.jsp?return=not");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Return.jsp?return=not");
        } finally {
            DBConnection.closeQuietly(rs, prep1, prep2, prep3, con);
        }
    }
}
