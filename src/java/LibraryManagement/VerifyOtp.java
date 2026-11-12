package LibraryManagement;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "VerifyOtp", urlPatterns = {"/VerifyOtp"})
public class VerifyOtp extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String verifyParam = request.getParameter("verify");
        int enteredOtp = (verifyParam != null && !verifyParam.trim().isEmpty()) ? Integer.parseInt(verifyParam.trim()) : -1;
        HttpSession session = request.getSession(false);

        Integer sessionOtp = (session != null) ? (Integer) session.getAttribute("otp") : null;

        if (sessionOtp != null && sessionOtp == enteredOtp) {
            response.sendRedirect("forgotPassword.jsp?status=verified");
            session.removeAttribute("otp");
        } else {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('Invalid OTP'); location='forgotPassword.jsp';</script>");
        }
    }
}
