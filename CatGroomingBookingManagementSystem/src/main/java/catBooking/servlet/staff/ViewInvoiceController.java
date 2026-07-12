package catBooking.servlet.staff;

import catBooking.dao.StaffInvoiceDAO;
import catBooking.dao.StaffInvoiceDAO.InvoiceRow;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ViewInvoiceController")
public class ViewInvoiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (userRole == null || (!userRole.equals("staff") && !userRole.equals("owner"))) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        try {
            int appointmentID = Integer.parseInt(request.getParameter("appointmentID"));

            StaffInvoiceDAO dao = new StaffInvoiceDAO();
            InvoiceRow invoice = dao.getInvoiceByID(appointmentID);

            if (invoice == null) {
                response.sendRedirect(request.getContextPath() + "/MainInvoiceController");
                return;
            }

            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/staff_owner/invoice/viewInvoice.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/MainInvoiceController");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}