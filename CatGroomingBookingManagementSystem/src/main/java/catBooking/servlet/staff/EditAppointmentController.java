package catBooking.servlet.staff;

import catBooking.bean.ServiceBean;
import catBooking.dao.ServiceDAO;
import catBooking.dao.StaffAppointmentDAO;
import catBooking.dao.StaffAppointmentDAO.AppointmentEditRow;
import catBooking.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/EditAppointmentController")
public class EditAppointmentController extends HttpServlet {
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

    private String normalizeTimeToHH24MI(String time) {
        if (time == null || time.trim().isEmpty()) {
            return "";
        }

        String value = time.trim().toUpperCase();

        try {
            if (value.matches("\\d{2}:\\d{2}")) {
                return value;
            }

            java.time.format.DateTimeFormatter inputFormatter =
                    java.time.format.DateTimeFormatter.ofPattern("h:mm a");

            java.time.format.DateTimeFormatter outputFormatter =
                    java.time.format.DateTimeFormatter.ofPattern("HH:mm");

            return java.time.LocalTime.parse(value, inputFormatter).format(outputFormatter);

        } catch (Exception e) {
            e.printStackTrace();
            return value;
        }
    }


    private Date parseAppointmentDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }

        String value = dateStr.trim();

        try {
            if (value.matches("\\d{4}-\\d{2}-\\d{2}")) {
                return Date.valueOf(value);
            }
        } catch (Exception ignored) {
            // Fallback to DD-MON-YYYY parser below.
        }

        return DateUtil.parseDate(value);
    }

    private String toDisplayDate(Date date) {
        return DateUtil.formatDate(date);
    }

    private String toIsoDate(Date date) {
        if (date == null) {
            return "";
        }

        return date.toLocalDate().toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginController");
            return;
        }

        String idParam = request.getParameter("appointmentID");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
            return;
        }

        try {
            int appointmentID = Integer.parseInt(idParam.trim());

            StaffAppointmentDAO dao = new StaffAppointmentDAO();
            AppointmentEditRow appt = dao.getAppointmentForEdit(appointmentID);

            if (appt == null) {
                response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
                return;
            }

            String currentStatus = normalizeStatus(appt.appointmentStatus);

            if (!"Pending".equals(currentStatus)) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=editLocked");
                return;
            }

            String selectedDate = appt.appointmentDate;
            String selectedDateISO = appt.appointmentDateISO;
            String requestedDate = request.getParameter("date");

            if (selectedDateISO == null || selectedDateISO.trim().isEmpty()) {
                Date parsedExistingDate = parseAppointmentDate(selectedDate);
                selectedDateISO = toIsoDate(parsedExistingDate);
            }

            if (requestedDate != null && !requestedDate.trim().isEmpty()) {
                Date parsedDate = parseAppointmentDate(requestedDate);

                if (parsedDate != null) {
                    selectedDate = toDisplayDate(parsedDate);
                    selectedDateISO = toIsoDate(parsedDate);
                } else {
                    request.setAttribute("errorMessage", "Invalid date. Please choose a valid appointment date.");
                }
            }

            ServiceDAO serviceDAO = new ServiceDAO();
            List<ServiceBean> mainServices = serviceDAO.getMainGroomingPackages();
            List<ServiceBean> addOnServices = serviceDAO.getAddOnServices();
            List<Integer> currentServiceIDs = dao.getServiceIDsByAppointmentID(appointmentID);
            List<String> bookedTimes = dao.getBookedTimesByDateForEdit(selectedDateISO, appointmentID);

            request.setAttribute("appt", appt);
            request.setAttribute("mainServices", mainServices);
            request.setAttribute("addOnServices", addOnServices);
            request.setAttribute("currentServiceIDs", currentServiceIDs);
            request.setAttribute("selectedDate", selectedDate);
            request.setAttribute("selectedDateISO", selectedDateISO);
            request.setAttribute("bookedTimes", bookedTimes);

            request.getRequestDispatcher("/staff_owner/appointment/editAppointment.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
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
        String dateValue = request.getParameter("appointmentDate");
        String time = normalizeTimeToHH24MI(request.getParameter("appointmentTime"));
        String serviceIDsCsv = request.getParameter("serviceIDs");
        String totalAmountStr = request.getParameter("totalAmount");

        try {
            int appointmentID = Integer.parseInt(idParam.trim());

            StaffAppointmentDAO dao = new StaffAppointmentDAO();
            AppointmentEditRow oldAppt = dao.getAppointmentForEdit(appointmentID);

            if (oldAppt == null) {
                response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
                return;
            }

            String oldStatus = normalizeStatus(oldAppt.appointmentStatus);

            if (!"Pending".equals(oldStatus)) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?error=editLocked");
                return;
            }

            if (serviceIDsCsv == null || serviceIDsCsv.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/EditAppointmentController?appointmentID=" + appointmentID + "&error=noService");
                return;
            }

            if (time == null || time.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/EditAppointmentController?appointmentID=" + appointmentID + "&error=noTime");
                return;
            }

            Date appointmentDate = parseAppointmentDate(dateValue);

            if (appointmentDate == null) {
                response.sendRedirect(request.getContextPath()
                        + "/EditAppointmentController?appointmentID=" + appointmentID + "&error=invalidDate");
                return;
            }

            String appointmentDateDisplay = toDisplayDate(appointmentDate);
            String appointmentDateISO = toIsoDate(appointmentDate);

            if (!dao.isTimeAvailableForEdit(appointmentID, appointmentDateISO, time)) {
                response.sendRedirect(request.getContextPath()
                        + "/EditAppointmentController?appointmentID=" + appointmentID
                        + "&date=" + appointmentDateISO
                        + "&error=timeBooked");
                return;
            }

            double totalAmount = Double.parseDouble(totalAmountStr);

            boolean updated = dao.updateAppointmentFull(
                    appointmentID,
                    appointmentDateDisplay,
                    time,
                    oldStatus,
                    serviceIDsCsv,
                    totalAmount
            );

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/StaffAppointmentController?success=updated");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/EditAppointmentController?appointmentID=" + appointmentID + "&error=updateFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/StaffAppointmentController?error=updateError");
        }
    }
}
