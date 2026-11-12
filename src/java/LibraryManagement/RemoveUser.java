package LibraryManagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RemoveUser", urlPatterns = {"/RemoveUser"})
public class RemoveUser extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("Id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("RemoveUser.jsp?status=notfound");
            return;
        }

        int id = Integer.parseInt(idStr.trim());
        Connection con = null;
        PreparedStatement prep = null;
        PreparedStatement prep2 = null;
        PreparedStatement p4 = null;
        ResultSet rs = null;
        ResultSet rg = null;

        try {
            con = DBConnection.getConnection();
            String query = "DELETE FROM users WHERE ID=?";
            String query2 = "SELECT Role FROM users WHERE ID=?";

            prep = con.prepareStatement(query);
            prep2 = con.prepareStatement(query2);
            prep.setInt(1, id);
            prep2.setInt(1, id);

            rs = prep2.executeQuery();
            if (rs.next()) {
                if ("admin".equalsIgnoreCase(rs.getString("Role"))) {
                    response.sendRedirect("RemoveUser.jsp?status=admindeletionnotpossible");
                    return;
                }
            }

            int rowsAffected = prep.executeUpdate();
            if (rowsAffected > 0) {
                List<User> usersList = new ArrayList<>();
                String q4 = "SELECT * FROM users WHERE Role!='Admin'";
                p4 = con.prepareStatement(q4);
                rg = p4.executeQuery();
                while (rg.next()) {
                    usersList.add(new User(
                            rg.getInt("ID"),
                            rg.getString("Name"),
                            rg.getString("email"),
                            rg.getString("password"),
                            rg.getString("Role")
                    ));
                }
                getServletContext().setAttribute("USERSlist", usersList);
                response.sendRedirect("RemoveUser.jsp?status=success");
            } else {
                response.sendRedirect("RemoveUser.jsp?status=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("RemoveUser.jsp?status=notfound");
        } finally {
            DBConnection.closeQuietly(rs, rg, prep, prep2, p4, con);
        }
    }
}
