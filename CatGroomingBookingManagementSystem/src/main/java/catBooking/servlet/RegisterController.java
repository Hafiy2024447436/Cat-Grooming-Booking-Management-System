package catBooking.servlet;

import catBooking.bean.CustomerBean;
import catBooking.dao.RegisterDAO;
import catBooking.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/RegisterController")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RegisterDAO registerDAO = new RegisterDAO();

    public RegisterController() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // RETRIEVE INPUT
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // VALIDATE EMPTY INPUT
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "empty");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        fullName = fullName.trim();
        username = username.trim().toLowerCase();
        phoneNumber = phoneNumber.trim();
        email = email.trim().toLowerCase();

        // VALIDATE FULL NAME
        if (!fullName.matches("^[a-zA-Z\\s\\-'.\u00C0-\u024F]+$")) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "fullNameInvalid");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (fullName.matches(".*\\d.*")) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "fullNameHasNumber");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (fullName.length() < 2 || fullName.length() > 100) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "fullNameLength");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // VALIDATE USERNAME
        // Allowed: lowercase letters, numbers, underscore (_), dot (.) and hyphen (-)
        // Not allowed: uppercase letters, spaces, or other special characters
        if (!username.matches("^[a-z0-9._-]+$")) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "usernameInvalid");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (username.length() < 3 || username.length() > 20) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "usernameLength");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // VALIDATE PASSWORD
        if (!password.equals(confirmPassword)) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "passwordMismatch");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "passwordShort");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // VALIDATE PHONE NUMBER
        if (!phoneNumber.matches("^[0-9]{10,11}$")) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "phoneInvalid");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // VALIDATE EMAIL
        if (!isValidEmail(email)) {
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "emailInvalid");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            if (registerDAO.isUsernameExists(username)) {
                keepInput(request, fullName, username, phoneNumber, email);
                request.setAttribute("error", "usernameExists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if (registerDAO.isEmailExists(email)) {
                keepInput(request, fullName, username, phoneNumber, email);
                request.setAttribute("error", "emailExists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            String hashedPassword = PasswordUtil.hashPassword(password);

            CustomerBean customer = new CustomerBean();
            customer.setCustUsername(username);
            customer.setCustPassword(hashedPassword);
            customer.setCustFullName(fullName);
            customer.setCustPhoneNumber(phoneNumber);
            customer.setCustEmail(email);
            customer.setCustProfilePhoto(null);

            boolean registered = registerDAO.registerCustomer(customer);

            if (registered) {
                response.sendRedirect("loginPage.jsp?notifType=create&notifMsg=Account%20registered%20successfully.%20Please%20log%20in.");
            } else {
                keepInput(request, fullName, username, phoneNumber, email);
                request.setAttribute("error", "registrationFailed");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "databaseError");
            request.getRequestDispatcher("/register.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            keepInput(request, fullName, username, phoneNumber, email);
            request.setAttribute("error", "unknown");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        return email != null
                && email.length() <= 70
                && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$");
    }

    private void keepInput(HttpServletRequest request, String fullName, String username,
                           String phoneNumber, String email) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("username", username);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("email", email);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}
