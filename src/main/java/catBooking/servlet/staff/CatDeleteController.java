package catBooking.servlet.staff;

import catBooking.dao.StaffCatDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/CatDeleteController")
public class CatDeleteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StaffCatDAO catDAO = new StaffCatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/CatListController");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String idParam = request.getParameter("catID");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CatListController?error=missingCatID");
            return;
        }

        try {
            int catID = Integer.parseInt(idParam);

            if (catDAO.hasPendingOrConfirmedAppointments(catID)) {
                response.sendRedirect(request.getContextPath() + "/CatListController?notifType=error&notifMsg=This%20cat%20cannot%20be%20deleted%20because%20there%20are%20pending%20or%20confirmed%20appointments%20using%20this%20cat.");
                return;
            }

            boolean deleted = catDAO.deleteCat(catID);

            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/CatListController?notifType=delete&notifMsg=Cat%20deleted%20successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/CatListController?error=deleteFailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/CatListController?error=invalidCatID");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CatListController?error=databaseError");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CatListController?error=deleteError");
        }
    }
}