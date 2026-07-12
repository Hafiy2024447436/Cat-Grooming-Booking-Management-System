package catBooking.servlet.staff;

import catBooking.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteCustomerController")
public class DeleteCustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String source = request.getParameter("source");

        String redirectBase = "staff".equals(source)
            ? request.getContextPath() + "/StaffController"
            : request.getContextPath() + "/OwnerController";

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(redirectBase);
            return;
        }

        try {
            int custID = Integer.parseInt(idParam);
            CustomerDAO dao = new CustomerDAO();
            int result = dao.deleteCustomer(custID);

            response.sendRedirect(redirectBase + (result > 0 ? "?notifType=delete&notifMsg=Customer%20account%20deleted%20successfully." : "?notifType=error&notifMsg=Unable%20to%20delete%20customer%20account."));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectBase + "?notifType=error&notifMsg=Unable%20to%20delete%20customer%20account.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}