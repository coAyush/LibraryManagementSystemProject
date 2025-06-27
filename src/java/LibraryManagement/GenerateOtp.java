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
import java.util.*;
import javax.servlet.http.HttpSession;


@WebServlet(name = "GenerateOtp", urlPatterns = {"/GenerateOtp"})
public class GenerateOtp extends HttpServlet {

     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Random rand=new Random();
        int otp=1000+rand.nextInt(9000);
        HttpSession session=request.getSession(false);
        session.setAttribute("otp", otp);
        response.sendRedirect("OtpVerification.jsp");
        
    }

   

}
