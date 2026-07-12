package catBooking.servlet.customer;

import catBooking.bean.CustomerBean;
import catBooking.bean.InvoiceBean;
import catBooking.dao.CustomerInvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CustomerInvoiceController")
public class CustomerInvoiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        CustomerBean cust = (CustomerBean) session.getAttribute("cust"); 

        if (cust == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        CustomerInvoiceDAO dao = new CustomerInvoiceDAO();
        List<InvoiceBean> invoiceList = dao.getInvoicesByCustomer(cust.getCustID());

        request.setAttribute("invoiceList", invoiceList);
        request.setAttribute("cust", cust);
        request.getRequestDispatcher("/customer/customerInvoice.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}