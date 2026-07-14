package catBooking.servlet.customer;

import catBooking.bean.AppointmentBean;
import catBooking.bean.CatBean;
import catBooking.bean.ServiceBean;
import catBooking.dao.CustAppointmentDAO;
import catBooking.dao.CustomerCatDAO;
import catBooking.dao.ServiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BookingSuccessController")
public class BookingSuccessController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentReference =
                request.getParameter("appointmentID");

        /*
         * Fallback sekiranya controller sebelumnya
         * menghantar appointmentNo, bukan appointmentID.
         */
        if (isBlank(appointmentReference)) {
            appointmentReference =
                    request.getParameter("appointmentNo");
        }

        /*
         * Tiada appointment reference.
         * Kembali ke senarai appointment tanpa error popup.
         */
        if (isBlank(appointmentReference)) {
            redirectToCustomerAppointments(request, response);
            return;
        }

        appointmentReference = appointmentReference.trim();

        CustAppointmentDAO appointmentDAO =
                new CustAppointmentDAO();

        /*
         * Cuba cari menggunakan nilai asal dahulu.
         * Contoh: appointmentID=19
         */
        AppointmentBean appointment =
                findAppointment(
                        appointmentDAO,
                        appointmentReference
                );

        /*
         * Sekiranya nilai yang diterima ialah:
         * APT-260715-0019
         *
         * Ambil bahagian terakhir, iaitu 0019,
         * kemudian cuba cari menggunakan ID 19.
         */
        if (appointment == null) {

            String extractedAppointmentID =
                    extractAppointmentID(
                            appointmentReference
                    );

            if (!isBlank(extractedAppointmentID)
                    && !extractedAppointmentID.equals(
                            appointmentReference)) {

                appointment =
                        findAppointment(
                                appointmentDAO,
                                extractedAppointmentID
                        );
            }
        }

        /*
         * Appointment masih tidak dijumpai.
         * Error ini hanya keluar apabila kedua-dua
         * cara pencarian gagal.
         */
        if (appointment == null) {

            System.err.println(
                    "BookingSuccessController: "
                    + "Appointment not found for reference: "
                    + appointmentReference
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/CustomerAppointmentController"
                    + "?error=AppointmentNotFound"
            );

            return;
        }

        /*
         * Dapatkan maklumat kucing.
         */
        CatBean cat = null;

        try {

            CustomerCatDAO catDAO =
                    new CustomerCatDAO();

            cat = catDAO.getCatByID(
                    appointment.getCatID()
            );

        } catch (Exception e) {

            System.err.println(
                    "Unable to retrieve cat information "
                    + "for appointment ID "
                    + appointment.getAppointmentID()
                    + ": "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        /*
         * Dapatkan semua service untuk appointment.
         */
        List<ServiceBean> selectedServices =
                new ArrayList<>();

        List<ServiceBean> mainServices =
                new ArrayList<>();

        List<ServiceBean> addOnServices =
                new ArrayList<>();

        try {

            ServiceDAO serviceDAO =
                    new ServiceDAO();

            List<Integer> serviceIDs =
                    appointmentDAO
                            .getServiceIDsByAppointmentID(
                                    appointment
                                            .getAppointmentID()
                            );

            if (serviceIDs != null) {

                for (Integer serviceID : serviceIDs) {

                    if (serviceID == null) {
                        continue;
                    }

                    ServiceBean service =
                            serviceDAO.getServiceById(
                                    serviceID
                            );

                    if (service == null) {
                        continue;
                    }

                    selectedServices.add(service);

                    String category =
                            service.getCategory() == null
                                    ? ""
                                    : service
                                            .getCategory()
                                            .trim()
                                            .toUpperCase();

                    if ("MAIN".equals(category)) {

                        mainServices.add(service);

                    } else if ("ADDON".equals(category)) {

                        addOnServices.add(service);
                    }
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Unable to retrieve services "
                    + "for appointment ID "
                    + appointment.getAppointmentID()
                    + ": "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        /*
         * Hantar data ke bookingSuccess.jsp.
         */
        request.setAttribute(
                "appointment",
                appointment
        );

        request.setAttribute(
                "cat",
                cat
        );

        request.setAttribute(
                "selectedServices",
                selectedServices
        );

        request.setAttribute(
                "mainServices",
                mainServices
        );

        request.setAttribute(
                "addOnServices",
                addOnServices
        );

        request.getRequestDispatcher(
                "/customer/appointment/bookingSuccess.jsp"
        ).forward(request, response);
    }

    /**
     * Cari appointment menggunakan DAO.
     */
    private AppointmentBean findAppointment(
            CustAppointmentDAO appointmentDAO,
            String appointmentID) {

        if (appointmentDAO == null
                || isBlank(appointmentID)) {

            return null;
        }

        try {

            return appointmentDAO.getAppointmentById(
                    appointmentID.trim()
            );

        } catch (Exception e) {

            System.err.println(
                    "Unable to find appointment using ID "
                    + appointmentID
                    + ": "
                    + e.getMessage()
            );

            return null;
        }
    }

    /**
     * Menukar appointment number seperti:
     *
     * APT-260715-0019
     *
     * kepada:
     *
     * 19
     */
    private String extractAppointmentID(
            String appointmentReference) {

        if (isBlank(appointmentReference)) {
            return null;
        }

        String value =
                appointmentReference.trim();

        /*
         * Kalau sudah nombor sahaja,
         * pulangkan nilai asal.
         */
        if (value.matches("\\d+")) {
            return removeLeadingZeros(value);
        }

        int lastDashIndex =
                value.lastIndexOf('-');

        if (lastDashIndex < 0
                || lastDashIndex >= value.length() - 1) {

            return null;
        }

        String lastPart =
                value.substring(
                        lastDashIndex + 1
                ).trim();

        if (!lastPart.matches("\\d+")) {
            return null;
        }

        return removeLeadingZeros(lastPart);
    }

    /**
     * Tukar 0019 kepada 19.
     */
    private String removeLeadingZeros(
            String numericValue) {

        if (isBlank(numericValue)) {
            return null;
        }

        try {

            return String.valueOf(
                    Long.parseLong(
                            numericValue.trim()
                    )
            );

        } catch (NumberFormatException e) {

            return numericValue.trim();
        }
    }

    /**
     * Redirect ke customer appointment page
     * tanpa menghantar popup error.
     */
    private void redirectToCustomerAppointments(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/CustomerAppointmentController"
        );
    }

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}