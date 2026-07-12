package catBooking.servlet.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import catBooking.dao.StaffDAO;

@WebServlet("/DeleteStaffController")
public class DeleteStaffController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String source = request.getParameter("source");

        String redirectBase = "owner".equals(source)
            ? request.getContextPath() + "/OwnerController"
            : request.getContextPath() + "/StaffController";

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(redirectBase);
            return;
        }

        try {
            int staffID = Integer.parseInt(idParam);
            StaffDAO dao = new StaffDAO();

            if (dao.hasPendingOrConfirmedAppointments(staffID)) {
                response.sendRedirect(redirectBase + "?notifType=error&notifMsg=This%20staff%20account%20cannot%20be%20deleted%20because%20there%20are%20pending%20or%20confirmed%20appointments%20assigned%20to%20this%20staff.");
                return;
            }

            int result = dao.deleteStaff(staffID);

            response.sendRedirect(redirectBase + (result > 0 ? "?notifType=delete&notifMsg=Staff%20account%20deleted%20successfully." : "?notifType=error&notifMsg=Unable%20to%20delete%20staff%20account."));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectBase + "?notifType=error&notifMsg=Unable%20to%20delete%20staff%20account.");
        }
    }
}