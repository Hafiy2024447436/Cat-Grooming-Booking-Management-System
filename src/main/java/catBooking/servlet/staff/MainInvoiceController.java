package catBooking.servlet.staff;

import catBooking.dao.StaffInvoiceDAO;
import catBooking.dao.StaffInvoiceDAO.InvoiceRow;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/MainInvoiceController")
public class MainInvoiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StaffInvoiceDAO dao = new StaffInvoiceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        List<InvoiceRow> invoiceList = dao.getAllInvoices();
        request.setAttribute("invoiceList", invoiceList);

        // NEW: "has a receipt already been generated for this appointment"
        // is tracked in the session only — no DB column for it. Populated
        // by GenerateReceiptController the moment a receipt is generated.
        // Read-only here; default to an empty set if nothing's been
        // generated yet this session.
        @SuppressWarnings("unchecked")
        Set<Integer> generatedReceiptIds = (Set<Integer>) session.getAttribute("generatedReceiptIds");
        if (generatedReceiptIds == null) {
            generatedReceiptIds = Collections.unmodifiableSet(new HashSet<>());
        }
        request.setAttribute("generatedReceiptIds", generatedReceiptIds);

        request.getRequestDispatcher("/staff_owner/invoice/mainInvoice.jsp")
               .forward(request, response);
    }

    // The invoice list is now read-only — status changes (Confirmed →
    // Completed) happen from the Appointment Edit screen, not from here.
    // Kept as a passthrough so old bookmarked/cached POSTs still work.
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}