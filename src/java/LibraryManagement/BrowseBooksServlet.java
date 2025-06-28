/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet(name = "BrowseBooksServlet", urlPatterns = {"/BrowseBooksServlet"})
public class BrowseBooksServlet extends HttpServlet {

    final String url = "your database connection url";
    final String username = "db username";
    final String password = "database password";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try  {
                Connection con = DriverManager.getConnection(url, username, password);
                String query = "SELECT * FROM Books";
                PreparedStatement prep = con.prepareStatement(query);
                ResultSet rs = prep.executeQuery();
                while (rs.next()) {
                    books.add(new Book(rs.getString("title"), rs.getString("author"), rs.getString("pdf"), rs.getInt("count")));
                }
                request.setAttribute("BOOKS", books);
                 ServletContext cont=getServletContext();
                 cont.setAttribute("booklist", books);
                String status = request.getParameter("status");
                if (status != null) {
                    request.setAttribute("status", status);

                }
                HttpSession session = request.getSession(false);
                String role = (String) session.getAttribute("Role");
                RequestDispatcher rd;
                if ("Student".equalsIgnoreCase(role)) {
                    rd = request.getRequestDispatcher("BrowseBooks.jsp");
                } else {
                    rd = request.getRequestDispatcher("AddExisting.jsp");
                }
                rd.forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace(response.getWriter());
            }
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
