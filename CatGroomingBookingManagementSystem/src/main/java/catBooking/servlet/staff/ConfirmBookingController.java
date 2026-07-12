package catBooking.servlet.staff;

import catBooking.dao.StaffAppointmentDAO;
import catBooking.dao.StaffAppointmentDAO.ConfirmBookingRow;
import catBooking.dao.StaffAppointmentDAO.StaffOption;
import catBooking.notification.BookingConfirmationEmailPayload;
import catBooking.notification.NotificationClient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/ConfirmBookingController")
public class ConfirmBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final StaffAppointmentDAO appointmentDAO = new StaffAppointmentDAO();
    private final NotificationClient notificationClient = new NotificationClient();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("LoginController");
            return;
        }

        List<ConfirmBookingRow> appointments = appointmentDAO.getAppointmentsForConfirmation();
        List<StaffOption> staffOptions = appointmentDAO.getAssignableStaffList();

        int pendingCount = 0;
        int confirmedCount = 0;

        for (ConfirmBookingRow appointment : appointments) {
            String status = appointment.appointmentStatus == null
                    ? ""
                    : appointment.appointmentStatus.trim().toLowerCase();

            if ("pending".equals(status)) {
                pendingCount++;
            } else if ("confirmed".equals(status)) {
                confirmedCount++;
            }
        }

        request.setAttribute("appointments", appointments);
        request.setAttribute("staffOptions", staffOptions);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("confirmedCount", confirmedCount);
        request.setAttribute("message", request.getParameter("message"));
        request.setAttribute("error", request.getParameter("error"));

        request.getRequestDispatcher("/staff_owner/appointment/confirmBooking.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentIDValue = request.getParameter("appointmentID");
        String action = request.getParameter("action");

        if (appointmentIDValue == null || appointmentIDValue.trim().isEmpty()
                || action == null || action.trim().isEmpty()) {
            response.sendRedirect("ConfirmBookingController?error=Missing booking action.");
            return;
        }

        try {
            int appointmentID = Integer.parseInt(appointmentIDValue);
            String newStatus;

            if ("confirm".equalsIgnoreCase(action)) {
                newStatus = "Confirmed";
            } else if ("reject".equalsIgnoreCase(action)) {
                newStatus = "Cancelled";
            } else {
                response.sendRedirect("ConfirmBookingController?error=Invalid booking action.");
                return;
            }

            boolean updated;

            if ("confirm".equalsIgnoreCase(action)) {
                String staffIDValue = request.getParameter("staffID");

                if (staffIDValue == null || staffIDValue.trim().isEmpty()) {
                    response.sendRedirect(
                        "ConfirmBookingController?error=Please select a staff member before confirming the booking."
                    );
                    return;
                }

                int staffID = Integer.parseInt(staffIDValue);
                updated = appointmentDAO.updateAppointmentStatusAndStaff(appointmentID, newStatus, staffID);
            } else {
                updated = appointmentDAO.updateAppointmentStatus(appointmentID, newStatus);
            }

            if (updated) {
                if ("confirm".equalsIgnoreCase(action)) {
                    sendConfirmationEmail(appointmentID);

                    response.sendRedirect(
                        "ConfirmBookingController?notifType=confirm&notifMsg=Booking%20confirmed%20successfully."
                    );
                } else {
                    response.sendRedirect(
                        "ConfirmBookingController?notifType=reject&notifMsg=Booking%20rejected%20successfully."
                    );
                }
            } else {
                response.sendRedirect("ConfirmBookingController?error=Unable to update booking.");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("ConfirmBookingController?error=Invalid booking data.");
        }
    }

    private void sendConfirmationEmail(int appointmentID) {
        try {
            for (ConfirmBookingRow row : appointmentDAO.getAppointmentsForConfirmation()) {
                if (row.appointmentID == appointmentID) {
                    BookingConfirmationEmailPayload payload = new BookingConfirmationEmailPayload();

                    payload.setAppointmentNo(row.appointmentNo);
                    payload.setCustomerName(row.customerName);
                    payload.setCustomerEmail(row.customerEmail);
                    payload.setCatName(row.catName);
                    payload.setAppointmentDate(row.appointmentDate);
                    payload.setAppointmentTime(row.appointmentTime);
                    payload.setServices(row.serviceNames);
                    payload.setTotalAmount(BigDecimal.valueOf(row.totalAmount));

                    notificationClient.sendBookingConfirmedEmail(payload);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}