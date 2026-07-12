package catBooking.servlet.staff;

import catBooking.dao.StaffAppointmentDAO;
import catBooking.dao.StaffAppointmentDAO.AppointmentViewRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ViewAppointmentController")
public class ViewAppointmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("appointmentID");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
            return;
        }

        int appointmentID;
        try {
            appointmentID = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
            return;
        }

        StaffAppointmentDAO dao = new StaffAppointmentDAO();
        AppointmentViewRow appt = dao.getAppointmentForView(appointmentID);

        if (appt == null) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
            return;
        }

        request.setAttribute("appt", appt);
        request.getRequestDispatcher("/staff_owner/appointment/viewAppointmentDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}