package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String email = request.getParameter("email");

        String query = "SELECT * FROM users WHERE Name=? AND email=? AND Role=?";

        Connection con = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            st = con.prepareStatement(query);

            st.setString(1, user);
            st.setString(2, email);
            st.setString(3, role);

            rs = st.executeQuery();
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("USER", user);

            if (rs.next()) {
                String dbPass = rs.getString("password");
                int id = rs.getInt("ID");

                if (dbPass != null && dbPass.equals(pass)) {
                    session.setAttribute("Role", role);
                    session.setAttribute("ID", id);
                    session.setAttribute("pass", dbPass);
                    session.setAttribute("loginDone", "yes");

                    if ("Admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("Admin.jsp");
                    } else if ("Student".equalsIgnoreCase(role)) {
                        response.sendRedirect("Home.jsp");
                    } else {
                        showAlert(response, "Unauthorized role. Redirecting to login.", "Login.jsp");
                    }
                } else {
                    showAlert(response, "Incorrect password. Try again or reset it.", "Login.jsp");
                }
            } else {
                if ("Admin".equalsIgnoreCase(role)) {
                    showAlert(response, "Admin login failed. Please verify credentials.", "Login.jsp");
                } else {
                    showAlert(response, "Student not registered. Please register now.", "Register.html");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "Login error: " + (e.getMessage() != null ? e.getMessage() : e.toString());
            showAlert(response, errorMsg, "Login.jsp");
        } finally {
            DBConnection.closeQuietly(rs, st, con);
        }
    }

    private void showAlert(HttpServletResponse response, String message, String page) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String safeMsg = message == null ? "Unknown error occurred." : message
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
        out.println("<script type='text/javascript'>");
        out.println("alert('" + safeMsg + "');");
        out.println("location='" + page + "';");
        out.println("</script>");
    }
}
