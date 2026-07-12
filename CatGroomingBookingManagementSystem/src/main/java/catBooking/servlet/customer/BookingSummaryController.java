package catBooking.servlet.customer;

import catBooking.bean.AppointmentBean;
import catBooking.bean.CatBean;
import catBooking.bean.ServiceBean;
import catBooking.dao.CustAppointmentDAO;
import catBooking.dao.CustomerCatDAO;
import catBooking.dao.ServiceDAO;
import catBooking.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BookingSummaryController")
public class BookingSummaryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class ServiceItem {
        private String id;
        private String name;
        private String category;
        private double price;

        public ServiceItem(String id, String name, String category, double price) {
            this.id = id;
            this.name = name;
            this.category = category;
            this.price = price;
        }

        public String getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getCategory() {
            return category;
        }

        public double getPrice() {
            return price;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentDateValue = request.getParameter("date");
        String appointmentTime = normalizeTimeToHH24MI(request.getParameter("time"));
        String catIDValue = request.getParameter("catID");
        String serviceID = request.getParameter("serviceID");
        String totalAmountValue = request.getParameter("totalAmount");
        String weightInfo = request.getParameter("weightInfo");

        Date appointmentDate = DateUtil.parseDate(appointmentDateValue);

        if (appointmentDate == null
                || appointmentTime == null || appointmentTime.trim().isEmpty()
                || catIDValue == null || catIDValue.trim().isEmpty()
                || serviceID == null || serviceID.trim().isEmpty()
                || totalAmountValue == null || totalAmountValue.trim().isEmpty()) {

            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        double totalAmount;
        int catID;

        try {
            totalAmount = Double.parseDouble(totalAmountValue);
            catID = Integer.parseInt(catIDValue);
        } catch (NumberFormatException e) {
            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        String appointmentDateDisplay = DateUtil.formatDate(appointmentDate);

        try {
            CustomerCatDAO catDAO = new CustomerCatDAO();
            CatBean cat = catDAO.getCatByID(catID);

            if (cat == null) {
                response.sendRedirect("SelectCatController?date=" + appointmentDateDisplay
                        + "&time=" + appointmentTime);
                return;
            }

            AppointmentBean appointment = new AppointmentBean();
            appointment.setAppointmentDate(appointmentDate);
            appointment.setAppointmentTime(appointmentTime);
            appointment.setCatID(catID);
            appointment.setTotalAmount(totalAmount);
            appointment.setAppointmentStatus("Pending");

            List<ServiceItem> selectedServices = getSelectedServices(serviceID);
            List<ServiceItem> selectedMainServices = filterServicesByCategory(selectedServices, "MAIN");
            List<ServiceItem> selectedAddOnServices = filterServicesByCategory(selectedServices, "ADDON");

            request.setAttribute("appointment", appointment);
            request.setAttribute("cat", cat);
            request.setAttribute("serviceID", serviceID);
            request.setAttribute("selectedServices", selectedServices);
            request.setAttribute("selectedMainServices", selectedMainServices);
            request.setAttribute("selectedAddOnServices", selectedAddOnServices);
            request.setAttribute("weightInfo", weightInfo == null ? "" : weightInfo);

            request.setAttribute("appointmentDate", appointmentDateDisplay);
            request.setAttribute("appointmentTime", appointmentTime);
            request.setAttribute("totalAmount", String.format("%.2f", totalAmount));

            request.getRequestDispatcher("/customer/appointment/bookingSummary.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CheckAvailabilityController");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentDateValue = request.getParameter("appointmentDate");
        String appointmentTime = normalizeTimeToHH24MI(request.getParameter("appointmentTime"));
        String catIDValue = request.getParameter("catID");
        String serviceID = request.getParameter("serviceID");
        String totalAmountValue = request.getParameter("totalAmount");

        Date appointmentDate = DateUtil.parseDate(appointmentDateValue);

        if (appointmentDate == null
                || appointmentTime == null || appointmentTime.trim().isEmpty()
                || catIDValue == null || catIDValue.trim().isEmpty()
                || serviceID == null || serviceID.trim().isEmpty()
                || totalAmountValue == null || totalAmountValue.trim().isEmpty()) {

            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        int catID;
        double totalAmount;

        try {
            catID = Integer.parseInt(catIDValue);
            totalAmount = Double.parseDouble(totalAmountValue);
        } catch (NumberFormatException e) {
            String appointmentDateDisplay = DateUtil.formatDate(appointmentDate);

            response.sendRedirect("BookingSummaryController?date=" + appointmentDateDisplay
                    + "&time=" + appointmentTime
                    + "&catID=" + catIDValue
                    + "&serviceID=" + serviceID
                    + "&totalAmount=0&error=InvalidTotal");
            return;
        }

        String[] serviceIDs = serviceID.split(",");

        if (serviceIDs.length == 0) {
            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        CustAppointmentDAO dao = new CustAppointmentDAO();
        ServiceDAO serviceDAO = new ServiceDAO();

        int appointmentID = dao.getNextAppointmentID();

        if (appointmentID <= 0) {
            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        int staffID = dao.getAnyStaffID();
        boolean success = true;

        for (String rawId : serviceIDs) {
            try {
                int svcID = Integer.parseInt(rawId.trim());

                ServiceBean service = serviceDAO.getServiceById(svcID);

                if (service == null) {
                    success = false;
                    break;
                }

                AppointmentBean appointment = new AppointmentBean();
                appointment.setAppointmentID(appointmentID);
                appointment.setCatID(catID);
                appointment.setServiceID(svcID);
                appointment.setAppointmentDate(appointmentDate);
                appointment.setAppointmentTime(appointmentTime);
                appointment.setAppointmentStatus("Pending");
                appointment.setWeight((Double) null);
                appointment.setTotalAmount(service.getPrice());
                appointment.setStaffID(staffID);

                boolean inserted = dao.addAppointment(appointment);

                if (!inserted) {
                    success = false;
                    break;
                }

            } catch (Exception e) {
                e.printStackTrace();
                success = false;
                break;
            }
        }

        if (success) {
            response.sendRedirect("BookingSuccessController?appointmentID=" + appointmentID);
        } else {
            String appointmentDateDisplay = DateUtil.formatDate(appointmentDate);

            response.sendRedirect("BookingSummaryController?date=" + appointmentDateDisplay
                    + "&time=" + appointmentTime
                    + "&catID=" + catIDValue
                    + "&serviceID=" + serviceID
                    + "&totalAmount=" + totalAmountValue
                    + "&error=InsertFailed");
        }
    }

    private List<ServiceItem> getSelectedServices(String serviceID) {
        List<ServiceItem> selectedServices = new ArrayList<>();

        if (serviceID == null || serviceID.trim().isEmpty()) {
            return selectedServices;
        }

        String[] ids = serviceID.split(",");
        ServiceDAO serviceDAO = new ServiceDAO();

        for (String rawId : ids) {
            String id = rawId.trim();

            try {
                ServiceBean service = serviceDAO.getServiceById(Integer.parseInt(id));

                if (service != null) {
                    String category = service.getCategory() == null
                            ? ""
                            : service.getCategory().trim().toUpperCase();

                    selectedServices.add(new ServiceItem(
                            String.valueOf(service.getServiceID()),
                            service.getServiceName(),
                            category,
                            service.getPrice()
                    ));
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        return selectedServices;
    }

    private List<ServiceItem> filterServicesByCategory(List<ServiceItem> services, String category) {
        List<ServiceItem> filtered = new ArrayList<>();

        if (services == null || category == null) {
            return filtered;
        }

        for (ServiceItem service : services) {
            if (service != null && category.equalsIgnoreCase(service.getCategory())) {
                filtered.add(service);
            }
        }

        return filtered;
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

            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("h:mm a");
            DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm");

            return LocalTime.parse(value, inputFormatter).format(outputFormatter);

        } catch (Exception e) {
            e.printStackTrace();
            return value;
        }
    }
}