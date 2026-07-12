package catBooking.servlet.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import catBooking.bean.CustomerBean;
import catBooking.bean.StaffBean;
import catBooking.dao.CustomerDAO;
import catBooking.dao.StaffDAO;

@WebServlet("/OwnerController")
public class OwnerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	StaffDAO staffDAO = new StaffDAO();
    	CustomerDAO customerDAO = new CustomerDAO();

    	List<StaffBean> staffList = staffDAO.getAllStaff();
    	List<CustomerBean> customerList = customerDAO.getAllCustomers();

    	request.setAttribute("staffList", staffList);
    	request.setAttribute("customerList", customerList);
    	request.getRequestDispatcher("/staff_owner/profile/ownerManagement.jsp")
    	       .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}