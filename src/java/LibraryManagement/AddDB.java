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
import LibraryManagement.Book;
import java.time.LocalDate;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet(name = "AddDB", urlPatterns = {"/AddDB"})
public class AddDB extends HttpServlet {

    final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String username = "root";
    final String password = "ayush52141";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AddDB servlet hit! title=" + request.getParameter("title"));

        HttpSession ses = request.getSession(false);
        if (ses == null || String.valueOf(ses.getAttribute("ID")) == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        int u_id = (Integer)ses.getAttribute("ID");
        int b_id = 0;
        int count = 0;
        String author="";
        String title = request.getParameter("title");
        LocalDate issue = LocalDate.now();
        LocalDate due = LocalDate.now().plusDays(20);
        String q1 = "SELECT * FROM Books WHERE title=?";
        String q2 = "INSERT INTO Issue(U_ID,B_ID,Issue_Date,Due_Date)VALUES(?,?,?,?)";
        String q3 = "UPDATE Books SET COUNT=? WHERE title=?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try {
                Connection con = DriverManager.getConnection(url, username, password);
                PreparedStatement prep1 = con.prepareStatement(q1);
                PreparedStatement prep2 = con.prepareStatement(q2);
                PreparedStatement prep3 = con.prepareStatement(q3);
                prep1.setString(1, title);
                ResultSet rs = prep1.executeQuery();
                if (rs.next()) {
                    b_id = rs.getInt("book_id");
                    author=rs.getString("author");
                    count = rs.getInt("count");
                } else {
                    response.sendRedirect("BrowseBooks.jsp?status=book_not_found");
                    return;
                }
                if (count > 0) {
                    count -= 1;
                } else {
                    response.sendRedirect("BrowseBooks.jsp?status=notdone");
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
                        response.sendRedirect("BrowseBooks.jsp?status=notdone");
                        return;
                    }
                } else {
                    response.sendRedirect("BrowseBooks.jsp?status=notdone");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            response.getWriter().print("class no found");
        }
    }
}
