package catBooking.servlet.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;

import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerDAO;
import catBooking.util.PasswordUtil;

@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
@WebServlet("/CustomerProfileController")
public class CustomerProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        CustomerBean cust = (session == null) ? null : (CustomerBean) session.getAttribute("cust");

        if (cust == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        request.setAttribute("cust", cust);
        request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        CustomerBean currentCust = (session == null) ? null : (CustomerBean) session.getAttribute("cust");

        if (currentCust == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String fullname = clean(request.getParameter("fullname"));
        String phone = clean(request.getParameter("phone"));
        String email = clean(request.getParameter("email"));
        String newPassword = clean(request.getParameter("password"));
        String confirmPassword = clean(request.getParameter("confirmPassword"));
        boolean changePassword = newPassword != null && !newPassword.isEmpty();
        boolean removePhoto = "true".equalsIgnoreCase(clean(request.getParameter("removePhoto")));
        Part photoPart = request.getPart("custProfilePhoto");

        if (!isValidFullName(fullname)) {
            request.setAttribute("errorMessage", "Full name can only contain letters, spaces, hyphens, and apostrophes.");
            request.setAttribute("cust", currentCust);
            request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
            return;
        }

        if (!isValidPhone(phone)) {
            request.setAttribute("errorMessage", "Phone number must be 10-11 digits.");
            request.setAttribute("cust", currentCust);
            request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
            return;
        }

        if (!isValidEmail(email)) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            request.setAttribute("cust", currentCust);
            request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
            return;
        }

        if (changePassword && !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.setAttribute("cust", currentCust);
            request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
            return;
        }

        if (changePassword && newPassword.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters.");
            request.setAttribute("cust", currentCust);
            request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
            return;
        }

        CustomerBean updatedCust = new CustomerBean();
        updatedCust.setCustID(currentCust.getCustID());
        updatedCust.setCustUsername(currentCust.getCustUsername());
        updatedCust.setCustStatus(currentCust.getCustStatus());
        updatedCust.setCustProfilePhoto(currentCust.getCustProfilePhoto());
        updatedCust.setLoggedIn(currentCust.isLoggedIn());

        updatedCust.setCustFullName(fullname);
        updatedCust.setCustPhoneNumber(phone);
        updatedCust.setCustEmail(email.trim().toLowerCase());
        if (changePassword) {
            updatedCust.setCustPassword(PasswordUtil.hashPassword(newPassword));
        } else {
            updatedCust.setCustPassword(currentCust.getCustPassword());
        }

        try {
            boolean success = CustomerDAO.updateProfile(updatedCust, changePassword, photoPart, removePhoto);

            if (success) {
                currentCust.setCustFullName(updatedCust.getCustFullName());
                currentCust.setCustPhoneNumber(updatedCust.getCustPhoneNumber());
                currentCust.setCustEmail(updatedCust.getCustEmail());

                if (changePassword) {
                    currentCust.setCustPassword(updatedCust.getCustPassword());
                }

                session.setAttribute("cust", currentCust);
                request.setAttribute("successMessage", "Profile updated successfully.");
                request.setAttribute("cust", currentCust);
            } else {
                request.setAttribute("errorMessage", "Update failed. Customer record was not found or is not Active.");
                request.setAttribute("cust", currentCust);
            }
        } catch (SQLException e) {
            e.printStackTrace();

            if (isPasswordLengthError(e)) {
                request.setAttribute("errorMessage", "Password must be at least 8 characters.");
            } else {
                request.setAttribute("errorMessage", "Unable to update profile. Please check your details and try again.");
            }

            request.setAttribute("cust", currentCust);
        }

        request.getRequestDispatcher("/customer/customerProfile.jsp").forward(request, response);
    }

    private boolean isValidFullName(String fullName) {
        return fullName != null
                && fullName.length() >= 2
                && fullName.length() <= 100
                && fullName.matches("^[A-Za-zÀ-ÖØ-öø-ÿ' .-]{2,100}$")
                && !fullName.matches(".*[0-9].*");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10,11}$");
    }

    private boolean isValidEmail(String email) {
        return email != null
                && email.length() <= 70
                && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$");
    }

    private boolean isPasswordLengthError(SQLException e) {
        String message = e.getMessage();
        return message != null
                && (message.contains("ORA-02290") || message.contains("CUSTPASSWORD_LEN"));
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}
