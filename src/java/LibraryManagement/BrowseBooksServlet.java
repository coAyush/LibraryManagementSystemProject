package LibraryManagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BrowseBooksServlet", urlPatterns = {"/BrowseBooksServlet"})
public class BrowseBooksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Book> books = new ArrayList<>();
        Connection con = null;
        PreparedStatement prep = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String query = "SELECT * FROM books";
            prep = con.prepareStatement(query);
            rs = prep.executeQuery();

            while (rs.next()) {
                books.add(new Book(
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("pdf"),
                        rs.getInt("count")
                ));
            }

            request.setAttribute("BOOKS", books);
            ServletContext cont = getServletContext();
            cont.setAttribute("booklist", books);

            String status = request.getParameter("status");
            if (status != null) {
                request.setAttribute("status", status);
            }

            HttpSession session = request.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("Role") : null;

            RequestDispatcher rd;
            if ("Student".equalsIgnoreCase(role)) {
                rd = request.getRequestDispatcher("BrowseBooks.jsp");
            } else {
                rd = request.getRequestDispatcher("AddExisting.jsp");
            }
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Home.jsp");
        } finally {
            DBConnection.closeQuietly(rs, prep, con);
        }
    }
}
