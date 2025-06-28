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
import LibraryManagement.Refresh;
import LibraryManagement.User;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author User
 */
@WebServlet(name = "RemoveUser", urlPatterns = {"/RemoveUser"})
public class RemoveUser extends HttpServlet {

    final String url = "your database connection url";
    final String username = "db username";
    final String password = "database password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int Id = Integer.parseInt(request.getParameter("Id"));
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, username, password)) {
                String Query = "DELETE FROM USERS WHERE ID=?";
                String Query2 = "SELECT Role FROM USERS WHERE ID=?";
                PreparedStatement prep = con.prepareStatement(Query);
                PreparedStatement prep2 = con.prepareStatement(Query2);
                prep.setInt(1, Id);
                prep2.setInt(1, Id);
                ResultSet rs=prep2.executeQuery();
                if(rs.next()){
                    if("admin".equalsIgnoreCase(rs.getString("Role"))){
                    response.sendRedirect("RemoveUser.jsp?status=admindeletionnotpossible");
                    return;
                    }
                }
                List<User>USERSlist=new ArrayList<>();
                int rowsAffected = prep.executeUpdate();
                if (rowsAffected > 0) {
                    String q4="SELECT * FROM USERS WHERE Role!='Admin'";
                    PreparedStatement p4=con.prepareStatement(q4);
                    ResultSet rg=p4.executeQuery();
                    while(rg.next()){
                        USERSlist.add(new User(rg.getInt("ID"),rg.getString("Name"),rg.getString("email"),rg.getString("password"),rg.getString("Role")));
                    }
                    getServletContext().setAttribute("USERSlist", USERSlist);
                    response.sendRedirect("RemoveUser.jsp?status=success");
                } else {
                    response.sendRedirect("RemoveUser.jsp?status=notfound");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
