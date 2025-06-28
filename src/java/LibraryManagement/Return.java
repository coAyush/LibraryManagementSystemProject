/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet(name = "Return", urlPatterns = {"/Return"})
public class Return extends HttpServlet {

    final String url = "your database connection url";
    final String username = "db username";
    final String password = "database password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AddDB servlet hit! title=" + request.getParameter("title"));

        HttpSession ses = request.getSession(false);
        if (ses == null ||ses.getAttribute("ID") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        int u_id = (Integer) ses.getAttribute("ID");
        int b_id=0;
        
        int count = 0;
        String title = request.getParameter("title");
        String q1 = "SELECT count,book_id FROM Books WHERE title=? ";
        String q2 = "DELETE FROM ISSUE WHERE U_ID=? AND B_ID=?";
        String q3 = "UPDATE Books SET COUNT=? WHERE title=?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try {
                Connection con = DriverManager.getConnection(url, username, password);
                PreparedStatement prep1 = con.prepareStatement(q1);
                PreparedStatement prep2 = con.prepareStatement(q2);
                PreparedStatement prep3 = con.prepareStatement(q3);
                prep1.setString(1,title);
                ResultSet rs=prep1.executeQuery();
                if(rs.next()){
                    count=rs.getInt("count")+1;
                    b_id=rs.getInt("book_id");
                prep3.setInt(1, count);
                prep3.setString(2, title);
                int c1=prep3.executeUpdate();
                if(c1>0){
                    prep2.setInt(1, u_id);
                    prep2.setInt(2, b_id);
                    int c2=prep2.executeUpdate();
                    if(c2>0){
                        response.sendRedirect("Return.jsp?return=success");
                    }
                    else{
                        response.sendRedirect("Return.jsp?return=not");
                    }
                }else{
                     response.sendRedirect("Return.jsp?return=not");
                }
                }else{
                   response.sendRedirect("Return.jsp?return=not");

                }
            } catch (SQLException e) {
                e.printStackTrace();
                 response.sendRedirect("Return.jsp?return=not");
            }
        } catch (ClassNotFoundException | IOException e) {
             response.sendRedirect("Return.jsp?return=not");
        }
    }

}
