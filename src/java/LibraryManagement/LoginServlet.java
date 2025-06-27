package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String username = "root";
    final String password = "ayush52141";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String email = request.getParameter("email");

        String query = "SELECT * FROM USERS WHERE Name=? AND email=? AND Role=?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, username, password);
            PreparedStatement st = con.prepareStatement(query);

            st.setString(1, user);
            st.setString(2, email);
            st.setString(3, role);

            ResultSet rs = st.executeQuery();
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("USER", user);
            if (rs.next()) {
                String dbPass = rs.getString("password");
                int id = rs.getInt("ID");
                
                if (dbPass.equals(pass)) {
                   
                    session.setAttribute("Role", role);
                    session.setAttribute("ID", id);
                    session.setAttribute("pass", dbPass);

                    if ("Admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("Admin.jsp");
                    } else if ("Student".equalsIgnoreCase(role)) {
                        response.sendRedirect("Home.jsp");
                    } else {
                        showAlert(response, "Unauthorized role. Redirecting to login.", "Login.jsp");
                    }
                } else {
                    // Password mismatch
                    showAlert(response, "Incorrect password. Try again or reset it.", "Login.jsp");
                }
            } else {
                // No user found
                if ("Admin".equalsIgnoreCase(role)) {
                    showAlert(response, "Admin login failed. Try again.", "Login.jsp");
                } else {
                    showAlert(response, "Student not registered. Please register now.", "Register.html");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert(response, "Server error occurred. Please try again.", "Login.jsp");
        }
    }

    private void showAlert(HttpServletResponse response, String message, String page) throws IOException {
        response.setContentType("text/html");

        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("location='" + page + "';");
        out.println("</script>");
    }
}
