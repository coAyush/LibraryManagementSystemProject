package LibraryManagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PasswordReset", urlPatterns = {"/PasswordReset"})
public class PasswordReset extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = "UPDATE users SET password = ? WHERE Name=? AND email=?";
        String newPass = request.getParameter("newPass");
        HttpSession session = request.getSession();

        Connection con = null;
        PreparedStatement st = null;

        try {
            con = DBConnection.getConnection();
            st = con.prepareStatement(query);
            String user = (String) session.getAttribute("USER");
            String email = (String) session.getAttribute("email");

            st.setString(1, newPass);
            st.setString(2, user);
            st.setString(3, email);

            int c = st.executeUpdate();
            if (c > 0) {
                session.setAttribute("newPass", newPass);
                response.sendRedirect("OtpVerification.jsp");
            } else {
                response.sendRedirect("forgotPassword.jsp?status=updatefailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?status=updatefailed");
        } finally {
            DBConnection.closeQuietly(st, con);
        }
    }
}
