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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentID = request.getParameter("appointmentID");

        if (appointmentID == null || appointmentID.trim().isEmpty()) {
            response.sendRedirect("CustomerAppointmentController");
            return;
        }

        CustAppointmentDAO appointmentDAO = new CustAppointmentDAO();
        AppointmentBean appointment = appointmentDAO.getAppointmentById(appointmentID);

        if (appointment == null) {
            response.sendRedirect("CustomerAppointmentController?error=AppointmentNotFound");
            return;
        }

        try {
            CustomerCatDAO catDAO = new CustomerCatDAO();
            CatBean cat = catDAO.getCatByID(appointment.getCatID());
            request.setAttribute("cat", cat);
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<ServiceBean> selectedServices = new ArrayList<>();
        List<ServiceBean> mainServices = new ArrayList<>();
        List<ServiceBean> addOnServices = new ArrayList<>();

        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            List<Integer> serviceIDs = appointmentDAO.getServiceIDsByAppointmentID(appointment.getAppointmentID());

            for (int serviceID : serviceIDs) {
                ServiceBean service = serviceDAO.getServiceById(serviceID);
                if (service == null) {
                    continue;
                }

                selectedServices.add(service);

                String category = service.getCategory() == null ? "" : service.getCategory().trim().toUpperCase();
                if ("MAIN".equals(category)) {
                    mainServices.add(service);
                } else if ("ADDON".equals(category)) {
                    addOnServices.add(service);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("appointment", appointment);
        request.setAttribute("selectedServices", selectedServices);
        request.setAttribute("mainServices", mainServices);
        request.setAttribute("addOnServices", addOnServices);
        request.getRequestDispatcher("/customer/appointment/bookingSuccess.jsp").forward(request, response);
    }
}
