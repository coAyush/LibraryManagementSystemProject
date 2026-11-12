package LibraryManagement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class Refresh implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        List<Book> booklist = new ArrayList<>();
        List<User> users = new ArrayList<>();

        Connection con = null;
        PreparedStatement prep = null;
        PreparedStatement prep2 = null;
        ResultSet rs = null;
        ResultSet rd = null;

        try {
            con = DBConnection.getConnection();

            String query = "SELECT * FROM books";
            prep = con.prepareStatement(query);
            rs = prep.executeQuery();
            while (rs.next()) {
                booklist.add(new Book(
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("pdf"),
                        rs.getInt("count")
                ));
            }
            sce.getServletContext().setAttribute("booklist", booklist);

            String q = "SELECT * FROM users WHERE Role!='Admin'";
            prep2 = con.prepareStatement(q);
            rd = prep2.executeQuery();
            while (rd.next()) {
                users.add(new User(
                        rd.getInt("ID"),
                        rd.getString("Name"),
                        rd.getString("email"),
                        rd.getString("password"),
                        rd.getString("Role")
                ));
            }
            sce.getServletContext().setAttribute("USERSlist", users);

        } catch (Exception e) {
            System.err.println("Database initialization warning in contextInitialized: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(rs, rd, prep, prep2, con);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
