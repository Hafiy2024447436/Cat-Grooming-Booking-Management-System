package catBooking.servlet.staff;

import catBooking.dao.StaffAppointmentDAO;
import catBooking.dao.StaffAppointmentDAO.AppointmentEditRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/UpdateAppointmentStatusController")
public class UpdateAppointmentStatusController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String normalizeStatus(String status) {
        if (status == null) {
            return "Pending";
        }

        String s = status.trim().toLowerCase();

        switch (s) {
            case "confirmed":
                return "Confirmed";
            case "completed":
                return "Completed";
            case "cancelled":
                return "Cancelled";
            default:
                return "Pending";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginController");
            return;
        }

        String idParam = request.getParameter("appointmentID");
        String statusParam = request.getParameter("appointmentStatus");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/StaffAppointmentController?error=statusUpdateFailed");
            return;
        }

        try {
            int appointmentID = Integer.parseInt(idParam.trim());
            String newStatus = normalizeStatus(statusParam);

            StaffAppointmentDAO dao = new StaffAppointmentDAO();
            AppointmentEditRow appointment = dao.getAppointmentForEdit(appointmentID);

            if (appointment == null) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=statusUpdateFailed");
                return;
            }

            String currentStatus = normalizeStatus(appointment.appointmentStatus);

            if ("Cancelled".equals(currentStatus) || "Completed".equals(currentStatus)) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=statusLocked");
                return;
            }

            if ("Pending".equals(currentStatus)
                    && !("Pending".equals(newStatus) || "Cancelled".equals(newStatus))) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=invalidStatus");
                return;
            }

            if ("Confirmed".equals(currentStatus)
                    && !("Confirmed".equals(newStatus) || "Completed".equals(newStatus))) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=invalidStatus");
                return;
            }

            if ("Confirmed".equals(newStatus) && !"Confirmed".equals(currentStatus)) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=invalidStatus");
                return;
            }

            if (currentStatus.equals(newStatus)) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController");
                return;
            }

            Double currentWeight = null;

            if ("Completed".equals(newStatus)) {
                String weightParam = request.getParameter("weight");

                if (weightParam == null || weightParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/StaffAppointmentController?error=weightRequired");
                    return;
                }

                try {
                    currentWeight = Double.parseDouble(weightParam.trim().replace(",", "."));
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath()
                            + "/StaffAppointmentController?error=invalidWeight");
                    return;
                }

                if (currentWeight <= 0 || currentWeight > 99.99) {
                    response.sendRedirect(request.getContextPath()
                            + "/StaffAppointmentController?error=invalidWeight");
                    return;
                }

                currentWeight = Math.round(currentWeight * 100.0) / 100.0;
            }

            boolean updated = dao.updateAppointmentStatus(appointmentID, newStatus, currentWeight);

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?success=statusUpdated");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=statusUpdateFailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/StaffAppointmentController?error=statusUpdateFailed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
    }
}
