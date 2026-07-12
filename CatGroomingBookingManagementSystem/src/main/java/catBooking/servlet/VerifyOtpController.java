package catBooking.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyOtpController")
public class VerifyOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("resetOtp") == null
                || session.getAttribute("resetOtpExpiry") == null) {
            response.sendRedirect(request.getContextPath() + "/ForgotPasswordController?expired=true");
            return;
        }

        String enteredOtp = clean(request.getParameter("otp"));
        String sessionOtp = (String) session.getAttribute("resetOtp");
        long expiryTime = (Long) session.getAttribute("resetOtpExpiry");

        if (System.currentTimeMillis() > expiryTime) {
            clearResetSession(session);
            request.setAttribute("error", "OTP has expired. Please request a new OTP.");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        Integer attempts = (Integer) session.getAttribute("resetOtpAttempts");
        if (attempts == null) {
            attempts = 0;
        }

        if (enteredOtp.isEmpty()) {
            request.setAttribute("error", "Please enter the OTP code.");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        if (!enteredOtp.matches("^[0-9]{6}$")) {
            request.setAttribute("error", "OTP must be 6 digits.");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        if (!enteredOtp.equals(sessionOtp)) {
            attempts++;
            session.setAttribute("resetOtpAttempts", attempts);

            if (attempts >= 5) {
                clearResetSession(session);
                request.setAttribute("error", "Too many wrong OTP attempts. Please request a new OTP.");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }

            request.setAttribute("error", "Invalid OTP code. Please try again.");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        session.setAttribute("resetOtpVerified", true);
        response.sendRedirect(request.getContextPath() + "/resetPassword.jsp?verified=success");
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("resetRole");
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetOtp");
        session.removeAttribute("resetOtpExpiry");
        session.removeAttribute("resetOtpVerified");
        session.removeAttribute("resetOtpAttempts");
    }
}
