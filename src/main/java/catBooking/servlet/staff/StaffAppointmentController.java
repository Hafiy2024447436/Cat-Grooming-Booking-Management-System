package catBooking.servlet.staff;

import catBooking.dao.StaffAppointmentDAO;
import catBooking.dao.StaffAppointmentDAO.AppointmentRow;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/StaffAppointmentController")
public class StaffAppointmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("userRole") == null) {
    	    response.sendRedirect("LoginController");
    	    return;
    	}

        StaffAppointmentDAO dao = new StaffAppointmentDAO();
        List<AppointmentRow> appointments = dao.getAllAppointmentsWithCustomer();

        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/staff_owner/appointment/appointmentManagement.jsp").forward(request, response);
    }
}