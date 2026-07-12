package catBooking.servlet.staff;

import catBooking.dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/DashboardController")
public class DashboardController extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Only staff/owner should land here — customers have their own home page.
        if (userRole == null || (!userRole.equals("staff") && !userRole.equals("owner"))) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        try {
            DashboardDAO dashboardDAO = new DashboardDAO();
            DashboardDAO.DashboardStats stats = dashboardDAO.getStats();
            List<DashboardDAO.RecentAppointmentRow> recent = dashboardDAO.getRecentAppointments(5);

            request.setAttribute("stats", stats);
            request.setAttribute("recentAppointments", recent);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load dashboard data.");
        }

        request.getRequestDispatcher("/staff_owner/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}