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
import javax.servlet.http.HttpSession;
import java.sql.*;
/**
 *
 * @author User
 */
@WebServlet(name = "PasswordReset", urlPatterns = {"/PasswordReset"})
public class PasswordReset extends HttpServlet {
      final String url = "jdbc:mysql://localhost:3306/Library?autoReconnect=true&useSSL=false";
    final String username = "root";
    final String password = "ayush52141";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String query = "UPDATE  USERS SET password = ? WHERE Name=? AND email=?";
         String newPass=request.getParameter("newPass");
          HttpSession session = request.getSession();
         try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, username, password);
            PreparedStatement st = con.prepareStatement(query);
            String user= (String)session.getAttribute("USER");
            String email= (String)session.getAttribute("email");
            st.setString(1, newPass);
             st.setString(2, user);
            st.setString(3, email);
            int c=st.executeUpdate();
            if(c>0){
               session.setAttribute("newPass", newPass);
               response.sendRedirect("OtpVerification.jsp");
            }

    }catch(Exception e){
        e.printStackTrace();
    }
    }


    

}
