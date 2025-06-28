package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    final String url = "your database connection url";
    final String username = "db username";
    final String password = "database password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        int id = 0;
        System.out.println("RegisterServlet triggered for: " + name);
        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(3600);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded successfully.");
            try (Connection con = DriverManager.getConnection(url, username, password)) {

                // Check if user already exists by name only (optional)
                String checkQuery = "SELECT * FROM USERS WHERE Name = ? AND email =?";
                PreparedStatement checkStmt = con.prepareStatement(checkQuery);
                checkStmt.setString(1, name);
                checkStmt.setString(2, email);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    System.out.println("User already exists.");
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();
                    session.setAttribute("name", name);
                    session.setAttribute("email", email);

                    out.println("<script type='text/javascript'>");
                    out.println("alert('User already registered. Please login.');");
                    out.println("location='Login.jsp';");
                    out.println("</script>");
                    return;
                }

                PrintWriter out = response.getWriter();
                String insertQuery = "INSERT INTO USERS(Name, password,Role,email) VALUES (?, ?, ?,?)";
                PreparedStatement prep = con.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
                prep.setString(1, name);
                prep.setString(2, pass);
                prep.setString(3, role);
                prep.setString(4, email);
                int res = prep.executeUpdate();

                if (res > 0) {
                    ResultSet keys = prep.getGeneratedKeys();
                    if (keys.next()) {
                        id = keys.getInt(1); // get auto-incremented ID
                    }
                    System.out.println("User registered: " + name + ", Role: " + role);
                    session.setAttribute("name", name);
                    session.setAttribute("pass", pass);
                    session.setAttribute("email", email);
                    session.setAttribute("ID", id);
                    session.setAttribute("role", role);
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Registration successful. Redirecting to login page...');");
                    out.println("window.location.href = 'Login.jsp';");
                    out.println("</script>");

                } else {
                    System.out.println("User registration failed.");
                    response.setContentType("text/html");
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Registration failed.');");
                    out.println("location='Register.html';");
                    out.println("</script>");
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("class not found");
        }
    }
}
