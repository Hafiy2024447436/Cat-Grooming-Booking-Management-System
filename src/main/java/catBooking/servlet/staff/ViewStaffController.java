package catBooking.servlet.staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import catBooking.bean.StaffBean;
import catBooking.dao.StaffDAO;

@WebServlet("/ViewStaffController")
public class ViewStaffController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/OwnerController");
            return;
        }
        StaffDAO dao = new StaffDAO();
        StaffBean staff = dao.getStaffByID(Integer.parseInt(idParam));
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/staff_owner/profile/viewStaff.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}