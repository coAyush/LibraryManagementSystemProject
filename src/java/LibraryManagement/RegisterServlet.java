package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        int id = 0;

        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(3600);

        Connection con = null;
        PreparedStatement checkStmt = null;
        PreparedStatement prep = null;
        ResultSet rs = null;
        ResultSet keys = null;

        try {
            con = DBConnection.getConnection();

            String checkQuery = "SELECT * FROM users WHERE Name = ? AND email = ?";
            checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, name);
            checkStmt.setString(2, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();
                session.setAttribute("name", name);
                session.setAttribute("email", email);

                out.println("<script type='text/javascript'>");
                out.println("alert('User already registered. Please login.');");
                out.println("location='Login.jsp';");
                out.println("</script>");
                return;
            }

            String insertQuery = "INSERT INTO users(Name, password, Role, email) VALUES (?, ?, ?, ?)";
            prep = con.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
            prep.setString(1, name);
            prep.setString(2, pass);
            prep.setString(3, role);
            prep.setString(4, email);
            int res = prep.executeUpdate();

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            if (res > 0) {
                keys = prep.getGeneratedKeys();
                if (keys.next()) {
                    id = keys.getInt(1);
                }
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
                out.println("<script type='text/javascript'>");
                out.println("alert('Registration failed.');");
                out.println("location='Register.html';");
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('Registration error: " + e.getMessage().replace("'", "\\'") + "');");
            out.println("location='Register.html';");
            out.println("</script>");
        } finally {
            DBConnection.closeQuietly(rs, keys, checkStmt, prep, con);
        }
    }
}
