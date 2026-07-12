package catBooking.servlet.customer;

import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerDashboardDAO;
import catBooking.dao.CustomerDashboardDAO.CustomerDashboardStats;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/CustomerDashboardController")
public class CustomerDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CustomerDashboardDAO dashboardDAO = new CustomerDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String userRole = String.valueOf(session.getAttribute("userRole"));

        if (!"customer".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/sidebar.jsp");
            return;
        }

        int custID = resolveCustomerID(session);

        if (custID <= 0) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        request.setAttribute("custID", custID);

        try {
            CustomerDashboardStats dashboardStats = dashboardDAO.getDashboardStats(custID);

            request.setAttribute("dashboardStats", dashboardStats);
            request.setAttribute("recentAppointments", dashboardStats.getRecentAppointments());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load dashboard data.");
        }

        request.getRequestDispatcher("/customer/customerDashboard.jsp").forward(request, response);
    }

    private int resolveCustomerID(HttpSession session) {
        Object custObj = session.getAttribute("cust");

        if (custObj instanceof CustomerBean) {
            return ((CustomerBean) custObj).getCustID();
        }

        Object userID = session.getAttribute("userID");

        if (userID == null) {
            return 0;
        }

        try {
            if (userID instanceof Integer) {
                return (Integer) userID;
            }

            return Integer.parseInt(userID.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
