package catBooking.servlet.staff;

import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EditCustomerController")
public class EditCustomerController extends HttpServlet {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String source  = request.getParameter("source"); // "staff" or "owner"

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/StaffController");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        CustomerBean cust = dao.getCustomerByID(Integer.parseInt(idParam));

        request.setAttribute("cust", cust);
        request.setAttribute("source", source);
        request.getRequestDispatcher("/staff_owner/profile/editCustomer.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam  = request.getParameter("custId");
        String source   = request.getParameter("source"); // "staff" or "owner"
        String fullname = clean(request.getParameter("fullname"));
        String phone    = clean(request.getParameter("phone"));
        String email    = clean(request.getParameter("email"));

        String safeSource = source == null ? "staff" : source;
        String redirectTarget = "owner".equals(safeSource)
            ? request.getContextPath() + "/OwnerController"
            : request.getContextPath() + "/StaffController";
        String editUrl = request.getContextPath() + "/EditCustomerController?id=" + idParam + "&source=" + safeSource;

        try {
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

            CustomerBean cust = new CustomerBean();
            cust.setCustID(Integer.parseInt(idParam));
            cust.setCustFullName(fullname);
            cust.setCustPhoneNumber(phone);
            cust.setCustEmail(email.trim().toLowerCase());

            CustomerDAO dao = new CustomerDAO();
            int result = dao.updateCustomer(cust);

            if (result > 0) {
                response.sendRedirect(redirectTarget + "?notifType=update&notifMsg=Customer%20information%20updated%20successfully.");
            } else {
                response.sendRedirect(editUrl + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(editUrl + "&error=exception");
        }
    }
}
