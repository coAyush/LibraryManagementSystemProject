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
import javax.servlet.http.HttpSession;
import LibraryManagement.Book;
import java.util.ArrayList;

/**
 *
 * @author User
 */
@WebServlet(name = "AddExisting", urlPatterns = {"/AddExisting"})
public class AddExisting extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AddDB servlet hit! title=" + request.getParameter("title"));
        final String url = "your database connection url";
        final String username = "db username";
        final String password = "database password";
        HttpSession ses = request.getSession(false);
        List<Book> booklist = new ArrayList<>();
        String title = request.getParameter("title");
        int count = Integer.parseInt(request.getParameter("count"));
        int incom = 0;
        String q2 = "SELECT COUNT FROM Books WHERE title=?";
        String q3 = "UPDATE Books SET COUNT=? WHERE title=?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try {
                Connection con = DriverManager.getConnection(url, username, password);
                PreparedStatement prep2 = con.prepareStatement(q2);
                prep2.setString(1, title);
                PreparedStatement prep3 = con.prepareStatement(q3);
                ResultSet rs = prep2.executeQuery();
                if (rs.next()) {
                    incom = rs.getInt("count");
                }
                count += incom;
                prep3.setInt(1, count);
                prep3.setString(2, title);
                int c = prep3.executeUpdate();
                if (c > 0) {
                    String q4 = "SELECT * FROM Books";
                    PreparedStatement fetch = con.prepareStatement(q4);
                    ResultSet allBooks = fetch.executeQuery();
                    while(allBooks.next()){
                        booklist.add(new Book(allBooks.getString("title"),
                            allBooks.getString("author"),
                            allBooks.getString("pdf"),
                            allBooks.getInt("count")));
                    }
                    getServletContext().setAttribute("booklist", booklist);
                    response.sendRedirect("AddExisting.jsp?Added=success");
                } else {

                    response.sendRedirect("AddExisting.jsp?Added=not");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("AddExisting.jsp?Added=not");
            }
        } catch (ClassNotFoundException | IOException e) {
            response.sendRedirect("AddExisting.jsp?Added=not");
        }
    }

}
