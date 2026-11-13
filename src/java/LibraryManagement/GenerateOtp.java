package LibraryManagement;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "GenerateOtp", urlPatterns = {"/GenerateOtp"})
public class GenerateOtp extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        if (email != null && !email.trim().isEmpty()) {
            session.setAttribute("email", email.trim());
        }

        Random rand = new Random();
        int otp = 1000 + rand.nextInt(9000);
        session.setAttribute("otp", otp);
        System.out.println("[OTP GENERATED] Email: " + email + " -> OTP: " + otp);
        response.sendRedirect("OtpVerification.jsp");
    }
}
