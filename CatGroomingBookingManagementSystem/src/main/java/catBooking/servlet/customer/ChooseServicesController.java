package catBooking.servlet.customer;

import catBooking.bean.CatBean;
import catBooking.bean.ServiceBean;
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
import java.util.List;

@WebServlet("/ChooseServicesController")
public class ChooseServicesController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentDateValue = request.getParameter("date");
        String appointmentTime = request.getParameter("time");
        String catIDValue = request.getParameter("catID");

        Date parsedDate = DateUtil.parseDate(appointmentDateValue);

        if (parsedDate == null
                || appointmentTime == null || appointmentTime.trim().isEmpty()
                || catIDValue == null || catIDValue.trim().isEmpty()) {
            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        String appointmentDate = DateUtil.formatDate(parsedDate);

        try {
            int catID = Integer.parseInt(catIDValue);

            CustomerCatDAO catDAO = new CustomerCatDAO();
            CatBean cat = catDAO.getCatByID(catID);

            if (cat == null) {
                response.sendRedirect("SelectCatController?date=" + appointmentDate + "&time=" + appointmentTime);
                return;
            }

            ServiceDAO serviceDAO = new ServiceDAO();
            List<ServiceBean> mainServices = serviceDAO.getMainGroomingPackages();
            List<ServiceBean> addOnServices = serviceDAO.getAddOnServices();

            request.setAttribute("appointmentDate", appointmentDate);
            request.setAttribute("appointmentTime", appointmentTime);
            request.setAttribute("cat", cat);
            request.setAttribute("mainServices", mainServices);
            request.setAttribute("addOnServices", addOnServices);

            request.getRequestDispatcher("/customer/appointment/chooseServices.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("SelectCatController?date=" + appointmentDate + "&time=" + appointmentTime);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load services.");
            request.getRequestDispatcher("/customer/appointment/chooseServices.jsp").forward(request, response);
        }
    }
}
