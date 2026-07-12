package catBooking.servlet.staff;

import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.bean.CustomerBean;
import catBooking.dao.StaffCatDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/CatViewController")
public class CatViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StaffCatDAO catDAO = new StaffCatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CatListController");
            return;
        }

        try {
            int catID = Integer.parseInt(idParam);

            CatBean cat = catDAO.getCatById(catID);

            if (cat == null) {
                request.setAttribute("error", "Cat not found.");
                request.getRequestDispatcher("/staff_owner/cat/viewCat.jsp").forward(request, response);
                return;
            }

            BreedBean breed = catDAO.getBreedById(cat.getBreedID());
            CustomerBean cust = catDAO.getCustomerById(cat.getCustID());

            request.setAttribute("cat", cat);
            request.setAttribute("breed", breed);
            request.setAttribute("cust", cust);

            request.getRequestDispatcher("/staff_owner/cat/viewCat.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/CatListController");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/staff_owner/cat/viewCat.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading cat: " + e.getMessage());
            request.getRequestDispatcher("/staff_owner/cat/viewCat.jsp").forward(request, response);
        }
    }
}