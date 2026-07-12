package catBooking.servlet.staff;

import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ViewCustomerController")
public class ViewCustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/StaffController");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        CustomerBean cust = dao.getCustomerByID(Integer.parseInt(idParam));

        request.setAttribute("cust", cust);
        request.getRequestDispatcher("/staff_owner/profile/viewCustomer.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}