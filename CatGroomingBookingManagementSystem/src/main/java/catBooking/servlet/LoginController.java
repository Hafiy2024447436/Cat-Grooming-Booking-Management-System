package catBooking.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import catBooking.bean.CustomerBean;
import catBooking.bean.StaffBean;
import catBooking.dao.CustomerDAO;
import catBooking.dao.StaffDAO;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String role = request.getParameter("role");

            if (role.equals("customer")) {

                CustomerBean customer = new CustomerBean();
                customer.setCustUsername(request.getParameter("username"));
                customer.setCustPassword(request.getParameter("password"));

                customer = CustomerDAO.loginCust(customer);

                if (customer.isLoggedIn()) {
                    HttpSession session = request.getSession(true);

                    session.setAttribute("userRole", "customer");
                    session.setAttribute("userID", customer.getCustID());
                    session.setAttribute("userName", customer.getCustFullName());
                    session.setAttribute("cust", customer);

                    response.sendRedirect(request.getContextPath() + "/sidebar.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid username or password.");
                    request.getRequestDispatcher("/loginPage.jsp").forward(request, response);
                }

            } else if (role.equals("staff")) {

                StaffBean staff = new StaffBean();
                staff.setStaffUsername(request.getParameter("username"));
                staff.setStaffPassword(request.getParameter("password"));

                staff = StaffDAO.loginStaff(staff);

                if (staff.isLoggedIn()) {
                    HttpSession session = request.getSession(true);

                    session.setAttribute("userRole", "staff");
                    session.setAttribute("userID", staff.getStaffID());
                    session.setAttribute("staffID", staff.getStaffID());
                    session.setAttribute("userName", staff.getStaffFullName());

                    response.sendRedirect(request.getContextPath() + "/sidebar.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid username or password.");
                    request.getRequestDispatcher("/loginPage.jsp").forward(request, response);
                }

            } else if (role.equals("owner")) {

                StaffBean owner = new StaffBean();
                owner.setStaffUsername(request.getParameter("username"));
                owner.setStaffPassword(request.getParameter("password"));

                owner = StaffDAO.loginOwner(owner);

                if (owner.isLoggedIn()) {
                    HttpSession session = request.getSession(true);

                    session.setAttribute("userRole", "owner");

                    // Untuk owner, userID dan staffID mesti guna staffID owner
                    session.setAttribute("userID", owner.getStaffID());
                    session.setAttribute("staffID", owner.getStaffID());

                    session.setAttribute("userName", owner.getStaffFullName());

                    response.sendRedirect(request.getContextPath() + "/sidebar.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid username or password.");
                    request.getRequestDispatcher("/loginPage.jsp").forward(request, response);
                }
            }

        } catch (Throwable ex) {
            ex.printStackTrace();

            try {
                request.setAttribute("errorMessage", "Something went wrong. Please try again.");
                request.getRequestDispatcher("/loginPage.jsp").forward(request, response);
            } catch (Exception inner) {
                inner.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
    }
}