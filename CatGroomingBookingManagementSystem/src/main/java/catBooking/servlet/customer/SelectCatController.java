package catBooking.servlet.customer;

import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.dao.CustomerCatDAO;
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

@WebServlet("/SelectCatController")
public class SelectCatController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentDateValue = request.getParameter("date");
        String appointmentTime = request.getParameter("time");

        Date parsedDate = DateUtil.parseDate(appointmentDateValue);

        if (parsedDate == null || appointmentTime == null || appointmentTime.trim().isEmpty()) {
            response.sendRedirect("CheckAvailabilityController");
            return;
        }

        String appointmentDate = DateUtil.formatDate(parsedDate);
        List<CatBean> cats = null;
        List<BreedBean> breeds = null;

        try {
            HttpSession session = request.getSession(false);
            Integer custID = null;

            if (session != null && session.getAttribute("userID") != null) {
                Object custObj = session.getAttribute("userID");
                if (custObj instanceof Integer) {
                    custID = (Integer) custObj;
                } else {
                    custID = Integer.parseInt(custObj.toString());
                }
            }

            if (custID == null) {
                response.sendRedirect("CheckAvailabilityController");
                return;
            }

            cats = CustomerCatDAO.getCatsByCustomer(custID);
            breeds = CustomerCatDAO.getBreedsByCat(custID);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Something went wrong while loading cats.");
        }

        request.setAttribute("cats", cats);
        request.setAttribute("breeds", breeds);
        request.setAttribute("appointmentDate", appointmentDate);
        request.setAttribute("appointmentTime", appointmentTime);

        request.getRequestDispatcher("/customer/appointment/selectCat.jsp").forward(request, response);
    }
}
