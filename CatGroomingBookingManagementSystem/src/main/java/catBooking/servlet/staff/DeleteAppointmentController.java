package catBooking.servlet.staff;

import catBooking.dao.StaffAppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/DeleteAppointmentController")
public class DeleteAppointmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentID;
        try {
            appointmentID = Integer.parseInt(request.getParameter("appointmentID"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController?error=deleteFailed");
            return;
        }

        StaffAppointmentDAO dao = new StaffAppointmentDAO();
        boolean success = dao.deleteAppointment(appointmentID);

        boolean ajax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"));

        if (ajax) {
            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();
            out.write(success ? "success" : "error");
            return;
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController?notifType=delete&notifMsg=Appointment%20deleted%20successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController?error=deleteFailed");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
