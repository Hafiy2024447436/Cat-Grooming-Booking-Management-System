package catBooking.servlet.staff;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import catBooking.ConnectionManager;
import catBooking.util.EmailUtil;
import catBooking.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RegisterStaffController")
public class RegisterStaffController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String PASSWORD_CHARS =
            "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#$";

    private static final SecureRandom RANDOM = new SecureRandom();

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String generateRandomPassword() {
        StringBuilder password = new StringBuilder();

        password.append("ABCDEFGHJKLMNPQRSTUVWXYZ"
                .charAt(RANDOM.nextInt("ABCDEFGHJKLMNPQRSTUVWXYZ".length())));
        password.append("abcdefghijkmnopqrstuvwxyz"
                .charAt(RANDOM.nextInt("abcdefghijkmnopqrstuvwxyz".length())));
        password.append("23456789"
                .charAt(RANDOM.nextInt("23456789".length())));
        password.append("@#$"
                .charAt(RANDOM.nextInt("@#$".length())));

        while (password.length() < 10) {
            password.append(PASSWORD_CHARS.charAt(RANDOM.nextInt(PASSWORD_CHARS.length())));
        }

        for (int i = password.length() - 1; i > 0; i--) {
            int j = RANDOM.nextInt(i + 1);
            char temp = password.charAt(i);
            password.setCharAt(i, password.charAt(j));
            password.setCharAt(j, temp);
        }

        return password.toString();
    }

    private boolean isValidUsername(String username) {
        return username != null
                && username.length() >= 3
                && username.length() <= 20
                && username.matches("^[a-z0-9._-]+$");
    }

    private boolean isValidEmail(String email) {
        return email != null
                && email.length() <= 70
                && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$");
    }

    private boolean staffUsernameExists(Connection con, String username) throws Exception {
        String sql = "SELECT staffID FROM Staff WHERE LOWER(TRIM(staffUsername)) = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean staffEmailExists(Connection con, String email) throws Exception {
        String sql = "SELECT staffID FROM Staff "
                   + "WHERE LOWER(TRIM(staffEmail)) = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private void keepInput(HttpServletRequest request, String username, String email) {
        request.setAttribute("staffUsername", username);
        request.setAttribute("staffEmail", email);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            Object generatedUsername = session.getAttribute("generatedStaffUsername");
            Object generatedEmail = session.getAttribute("generatedStaffEmail");

            if (generatedUsername != null) {
                request.setAttribute("generatedStaffUsername", generatedUsername);
                request.setAttribute("generatedStaffEmail", generatedEmail);

                session.removeAttribute("generatedStaffUsername");
                session.removeAttribute("generatedStaffEmail");
            }
        }

        request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("staffID") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginController");
            return;
        }

        int ownerID = Integer.parseInt(session.getAttribute("staffID").toString());

        // Owner only needs to enter username and email.
        String username = clean(request.getParameter("staffUsername")).toLowerCase();
        String email = clean(request.getParameter("staffEmail")).toLowerCase();

        if (username.isEmpty() || email.isEmpty()) {
            keepInput(request, username, email);
            request.setAttribute("error", "Please enter username and email.");
            request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
            return;
        }

        if (!isValidUsername(username)) {
            keepInput(request, username, email);
            request.setAttribute("error", "Username must be 3-20 characters and can only contain lowercase letters, numbers, underscore (_), dot (.) and hyphen (-). Spaces are not allowed.");
            request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
            return;
        }

        if (!isValidEmail(email)) {
            keepInput(request, username, email);
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
            return;
        }

        String generatedPassword = generateRandomPassword();
        String hashedPassword = PasswordUtil.hashPassword(generatedPassword);

        // Temporary profile details. Staff can update these after first login.
        String defaultFullName = username;
        String defaultPhoneNumber = "0000000000";
        String defaultAddress = "Pending update";

        try (Connection con = ConnectionManager.getConnection()) {
            con.setAutoCommit(false);

            try {
                if (staffUsernameExists(con, username)) {
                    con.rollback();
                    keepInput(request, username, email);
                    request.setAttribute("error", "Username already exists. Please choose another username.");
                    request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
                    return;
                }

                if (staffEmailExists(con, email)) {
                    con.rollback();
                    keepInput(request, username, email);
                    request.setAttribute("error", "Email address is already registered.");
                    request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
                    return;
                }

                String sql = "INSERT INTO Staff "
                           + "(staffID, staffUsername, staffPassword, staffFullName, "
                           + "staffPhoneNumber, staffEmail, staffAddress, staffRole, "
                           + "staffProfilePhoto, ownerID) "
                           + "VALUES (nextval('staffid_seq'), ?, ?, ?, ?, ?, ?, 'Staff', NULL, ?)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, username);
                    ps.setString(2, hashedPassword);
                    ps.setString(3, defaultFullName);
                    ps.setString(4, defaultPhoneNumber);
                    ps.setString(5, email);
                    ps.setString(6, defaultAddress);
                    ps.setInt(7, ownerID);

                    ps.executeUpdate();
                }

                boolean emailSent = EmailUtil.sendStaffAccountEmail(email, username, generatedPassword);

                if (!emailSent) {
                    con.rollback();
                    keepInput(request, username, email);
                    request.setAttribute("error", "Staff account was not created because the temporary password email could not be sent. Please check the SMTP environment variables and try again.");
                    request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
                    return;
                }

                con.commit();

                session.setAttribute("generatedStaffUsername", username);
                session.setAttribute("generatedStaffEmail", email);

                response.sendRedirect(request.getContextPath() + "/RegisterStaffController?notifType=create&notifMsg=Staff%20account%20registered%20successfully.%20Temporary%20password%20has%20been%20sent.");

            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();

            String errorMessage = "Registration failed. Please try again.";

            if (e.getMessage() != null) {
                if (e.getMessage().contains("STAFFPASSWORD_LEN")) {
                    errorMessage = "Generated password failed the password length rule. Please try again.";
                } else if (e.getMessage().contains("STAFFUSERNAME")
                        || e.getMessage().contains("UNIQUE")) {
                    errorMessage = "Username already exists. Please choose another username.";
                } else if (e.getMessage().contains("STAFFEMAIL")
                        || e.getMessage().contains("EMAIL")) {
                    errorMessage = "Email address is already registered.";
                } else if (e.getMessage().contains("FK_STAFF_OWNER")) {
                    errorMessage = "Unable to register staff. Please login again.";
                }
            }

            keepInput(request, username, email);
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/staff_owner/profile/registerStaff.jsp").forward(request, response);
        }
    }
}
