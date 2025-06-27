/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;

import java.util.List;
import LibraryManagement.Book;
import LibraryManagement.User;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 *
 * @author User
 */
@WebListener
public class Refresh implements ServletContextListener {

    final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String username = "root";
    final String password = "ayush52141";

    public void contextInitialized(ServletContextEvent sce) {
        List<Book> booklist = new ArrayList<>();
        List<User> Users = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try {
                Connection con = DriverManager.getConnection(url, username, password);
                String query = "SELECT * FROM Books";
                PreparedStatement prep = con.prepareStatement(query);
                ResultSet rs = prep.executeQuery();
                while (rs.next()) {
                    booklist.add(new Book(rs.getString("title"), rs.getString("author"), rs.getString("pdf"), rs.getInt("count")));
                }

                sce.getServletContext().setAttribute("booklist", booklist);
                String q = "SELECT * FROM USERS WHERE Role!='Admin'";
                PreparedStatement prep2 = con.prepareStatement(q);
                ResultSet rd = prep2.executeQuery();
                while (rd.next()) {
                    Users.add(new User(rd.getInt("ID"), rd.getString("Name"), rd.getString("email"), rd.getString("password"), rd.getString("Role")));
                }
                sce.getServletContext().setAttribute("USERSlist", Users);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
