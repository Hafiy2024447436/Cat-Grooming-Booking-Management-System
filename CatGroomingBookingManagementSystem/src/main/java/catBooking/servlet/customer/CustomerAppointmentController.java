package catBooking.servlet.customer;

import catBooking.bean.AppointmentBean;
import catBooking.bean.CatBean;
import catBooking.dao.CustAppointmentDAO;
import catBooking.dao.CustomerCatDAO;
import catBooking.dao.CustAppointmentDAO.AppointmentServiceRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CustomerAppointmentController")
public class CustomerAppointmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class AppointmentView {
        private AppointmentBean appointment;
        private String catName;
        private List<String> serviceNames = new ArrayList<>();
        private List<String> mainServiceNames = new ArrayList<>();
        private List<String> addOnServiceNames = new ArrayList<>();

        public AppointmentView(AppointmentBean appointment, String catName,
                               List<String> serviceNames,
                               List<String> mainServiceNames,
                               List<String> addOnServiceNames) {
            this.appointment = appointment;
            this.catName = catName;
            this.serviceNames = serviceNames;
            this.mainServiceNames = mainServiceNames;
            this.addOnServiceNames = addOnServiceNames;
        }

        public AppointmentBean getAppointment() {
            return appointment;
        }

        public String getCatName() {
            return catName;
        }

        public List<String> getServiceNames() {
            return serviceNames;
        }

        public List<String> getMainServiceNames() {
            return mainServiceNames;
        }

        public List<String> getAddOnServiceNames() {
            return addOnServiceNames;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer custID = null;

        if (session != null && session.getAttribute("userID") != null) {
            Object obj = session.getAttribute("userID");
            custID = (obj instanceof Integer) ? (Integer) obj : Integer.parseInt(obj.toString());
        }

        if (custID == null) {
            response.sendRedirect("LoginController");
            return;
        }

        CustAppointmentDAO appointmentDAO = new CustAppointmentDAO();
        CustomerCatDAO catDAO = new CustomerCatDAO();
        List<AppointmentView> appointmentViews = new ArrayList<>();

        try {
            List<AppointmentBean> appointments = appointmentDAO.getAppointmentsByCustomer(custID);

            for (AppointmentBean appt : appointments) {
                String catName = "Cat ID: " + appt.getCatID();

                try {
                    CatBean cat = catDAO.getCatByID(appt.getCatID());
                    if (cat != null && cat.getCatName() != null) {
                        catName = cat.getCatName();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                List<String> serviceNames = new ArrayList<>();
                List<String> mainServiceNames = new ArrayList<>();
                List<String> addOnServiceNames = new ArrayList<>();

                try {
                    List<AppointmentServiceRow> services =
                            appointmentDAO.getServicesByAppointmentID(appt.getAppointmentID());

                    for (AppointmentServiceRow service : services) {
                        if (service == null || service.serviceName == null) {
                            continue;
                        }

                        String serviceName = service.serviceName;
                        String category = service.category == null
                                ? ""
                                : service.category.trim().toUpperCase();

                        serviceNames.add(serviceName);

                        if ("MAIN".equals(category)) {
                            mainServiceNames.add(serviceName);
                        } else if ("ADDON".equals(category)) {
                            addOnServiceNames.add(serviceName);
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }

                appointmentViews.add(new AppointmentView(
                        appt,
                        catName,
                        serviceNames,
                        mainServiceNames,
                        addOnServiceNames
                ));
            }

            request.setAttribute("appointmentViews", appointmentViews);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load appointments.");
        }

        request.getRequestDispatcher("/customer/appointment/customerAppointment.jsp").forward(request, response);
    }
}