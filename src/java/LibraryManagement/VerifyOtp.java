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


/**
 *
 * @author User
 */
@WebServlet(name = "VerifyOtp", urlPatterns = {"/VerifyOtp"})
public class VerifyOtp extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int enteredOtp = Integer.parseInt(request.getParameter("verify"));
        HttpSession session = request.getSession(false);

        Integer sessionOtp = (Integer) session.getAttribute("otp");

        if (sessionOtp != null && sessionOtp == enteredOtp) {
            response.sendRedirect("forgotPassword.jsp?status=verified");
            session.removeAttribute("otp");
        } else {
            response.getWriter().println("<script>alert('Invalid OTP'); location='forgotPassword.jsp';</script>");
        }
    }
}
