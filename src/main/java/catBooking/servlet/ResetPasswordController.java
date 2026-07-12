package catBooking.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import catBooking.dao.ForgotPasswordDAO;
import catBooking.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResetPasswordController")
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ForgotPasswordDAO forgotPasswordDAO = new ForgotPasswordDAO();

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/resetPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !Boolean.TRUE.equals(session.getAttribute("resetOtpVerified"))) {
            response.sendRedirect(request.getContextPath() + "/ForgotPasswordController");
            return;
        }

        String role = (String) session.getAttribute("resetRole");
        String email = (String) session.getAttribute("resetEmail");

        if (role == null || email == null) {
            clearResetSession(session);
            response.sendRedirect(request.getContextPath() + "/ForgotPasswordController");
            return;
        }

        String newPassword = clean(request.getParameter("newPassword"));
        String confirmPassword = clean(request.getParameter("confirmPassword"));

        if (newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Please fill in all password fields.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Password and confirm password do not match.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            boolean updated = forgotPasswordDAO.updatePassword(role, email, hashedPassword);

            if (updated) {
                clearResetSession(session);

                String msg = URLEncoder.encode("Password reset successfully. Please log in with your new password.", StandardCharsets.UTF_8.name());
                response.sendRedirect(request.getContextPath() + "/loginPage.jsp?notifType=create&notifMsg=" + msg);
            } else {
                request.setAttribute("error", "Password could not be updated. Please request a new OTP.");
                request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
        }
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
