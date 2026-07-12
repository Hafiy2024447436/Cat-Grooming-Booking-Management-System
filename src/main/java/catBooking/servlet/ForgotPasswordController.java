package catBooking.servlet;

import java.io.IOException;
import java.security.SecureRandom;

import catBooking.dao.ForgotPasswordDAO;
import catBooking.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ForgotPasswordController")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final long OTP_VALID_DURATION = 5 * 60 * 1000; // 5 minutes

    private final ForgotPasswordDAO forgotPasswordDAO = new ForgotPasswordDAO();

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String generateOtp() {
        int number = 100000 + RANDOM.nextInt(900000);
        return String.valueOf(number);
    }

    private boolean isValidRole(String role) {
        return "customer".equalsIgnoreCase(role)
                || "staff".equalsIgnoreCase(role)
                || "owner".equalsIgnoreCase(role);
    }

    private boolean isValidEmail(String email) {
        return email != null
                && email.length() <= 70
                && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = clean(request.getParameter("role")).toLowerCase();
        String email = clean(request.getParameter("email")).toLowerCase();

        if (!isValidRole(role)) {
            request.setAttribute("error", "Please select a valid role.");
            request.setAttribute("role", role);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid registered email address.");
            request.setAttribute("role", role);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        try {
            if (!forgotPasswordDAO.emailExists(role, email)) {
                request.setAttribute("error", "No active account found with this role and email address.");
                request.setAttribute("role", role);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }

            String otp = generateOtp();
            long expiryTime = System.currentTimeMillis() + OTP_VALID_DURATION;

            boolean emailSent = EmailUtil.sendOtpEmail(email, otp);

            if (!emailSent) {
                request.setAttribute("error", "OTP could not be sent. Please check the SMTP environment variables.");
                request.setAttribute("role", role);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("resetRole", role);
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetOtp", otp);
            session.setAttribute("resetOtpExpiry", expiryTime);
            session.setAttribute("resetOtpVerified", false);
            session.setAttribute("resetOtpAttempts", 0);

            response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp?sent=success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.setAttribute("role", role);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
        }
    }
}
