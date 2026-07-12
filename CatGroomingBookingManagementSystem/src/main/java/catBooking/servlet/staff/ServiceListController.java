package catBooking.servlet.staff;

import catBooking.bean.ServiceBean;
import catBooking.dao.ServiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/ServiceListController")
public class ServiceListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String role = String.valueOf(session.getAttribute("userRole"));

        if (!"customer".equalsIgnoreCase(role)
                && !"staff".equalsIgnoreCase(role)
                && !"owner".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        List<ServiceBean> serviceList = serviceDAO.getAllServicesForManagement();
        request.setAttribute("serviceList", serviceList);

        request.getRequestDispatcher("/staff_owner/service/viewServices.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
