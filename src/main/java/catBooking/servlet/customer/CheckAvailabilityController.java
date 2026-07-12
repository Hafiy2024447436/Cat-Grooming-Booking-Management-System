package catBooking.servlet.customer;

import catBooking.dao.CustAppointmentDAO;
import catBooking.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/CheckAvailabilityController")
public class CheckAvailabilityController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedDateValue = request.getParameter("date");

        if (selectedDateValue != null && !selectedDateValue.trim().isEmpty()) {
            Date selectedDate = DateUtil.parseDate(selectedDateValue);

            if (selectedDate == null) {
                request.setAttribute("errorMessage", "Invalid date format. Please use DD-MON-YYYY.");
            } else {
                String selectedDateDisplay = DateUtil.formatDate(selectedDate);
                CustAppointmentDAO dao = new CustAppointmentDAO();
                List<String> bookedTimes = dao.getBookedTimesByDate(selectedDateDisplay);

                request.setAttribute("selectedDate", selectedDateDisplay);
                request.setAttribute("bookedTimes", bookedTimes);
            }
        }

        request.getRequestDispatcher("/customer/appointment/checkAvailability.jsp").forward(request, response);
    }
}
