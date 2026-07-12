package catBooking.servlet.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import catBooking.bean.StaffBean;
import catBooking.dao.StaffDAO;
import catBooking.util.PasswordUtil;

@WebServlet("/EditOwnerController")
@MultipartConfig
public class EditOwnerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String clean(String value) {
        return value == null ? "" : value.trim();
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

    private int getLoggedInStaffID(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffID") == null) {
            return 0;
        }

        try {
            return Integer.parseInt(session.getAttribute("staffID").toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/OwnerController");
            return;
        }

        StaffDAO dao = new StaffDAO();
        StaffBean staff = dao.getStaffByID(Integer.parseInt(idParam));

        int loggedInStaffID = getLoggedInStaffID(request);
        boolean canEditPassword = staff != null && loggedInStaffID == staff.getStaffID();

        request.setAttribute("staff", staff);
        request.setAttribute("canEditPassword", canEditPassword);
        request.getRequestDispatcher("/staff_owner/profile/editOwner.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam  = request.getParameter("ownerId");
        String fullname = clean(request.getParameter("fullname"));
        String phone    = clean(request.getParameter("phone"));
        String email    = clean(request.getParameter("email"));
        String address  = clean(request.getParameter("address"));
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        String editUrl = request.getContextPath() + "/EditOwnerController?id=" + idParam;

        try {
            int targetOwnerID = Integer.parseInt(idParam);
            boolean canEditPassword = getLoggedInStaffID(request) == targetOwnerID;

            if (!isValidFullName(fullname)) {
                response.sendRedirect(editUrl + "&error=fullNameInvalid");
                return;
            }

            if (!isValidPhone(phone)) {
                response.sendRedirect(editUrl + "&error=phoneInvalid");
                return;
            }

            if (!isValidEmail(email)) {
                response.sendRedirect(editUrl + "&error=emailInvalid");
                return;
            }

            String passwordToSave = null;

            if (canEditPassword && newPassword != null && !newPassword.trim().isEmpty()) {
                if (newPassword.length() < 8) {
                    response.sendRedirect(editUrl + "&error=invalidPassword");
                    return;
                }

                if (confirmNewPassword == null || !newPassword.equals(confirmNewPassword)) {
                    response.sendRedirect(editUrl + "&error=passwordMismatch");
                    return;
                }

                passwordToSave = PasswordUtil.hashPassword(newPassword);
            }

            StaffBean staff = new StaffBean();
            staff.setStaffID(targetOwnerID);
            staff.setStaffFullName(fullname);
            staff.setStaffPhoneNumber(phone);
            staff.setStaffEmail(email.trim().toLowerCase());
            staff.setStaffAddress(address);
            staff.setStaffPassword(passwordToSave);

            Part photoPart = request.getPart("staffProfilePhoto");

            StaffDAO dao = new StaffDAO();
            int result = dao.updateStaff(staff, photoPart);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/OwnerController?notifType=update&notifMsg=Owner%20information%20updated%20successfully.");
            } else {
                response.sendRedirect(editUrl + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EditOwnerController?id=" + idParam + "&error=exception");
        }
    }
}
