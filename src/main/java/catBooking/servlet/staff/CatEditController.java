package catBooking.servlet.staff;

import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.bean.CustomerBean;
import catBooking.dao.StaffCatDAO;
import catBooking.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/CatEditController")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class CatEditController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final StaffCatDAO catDAO = new StaffCatDAO();

    public CatEditController() {
        super();
    }

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
            int catID = Integer.parseInt(idParam.trim());
            CatBean cat = catDAO.getCatById(catID);
            List<BreedBean> breeds = catDAO.getAllBreeds();
            CustomerBean cust = null;

            if (catDAO.getLastCustomers() != null && !catDAO.getLastCustomers().isEmpty()) {
                cust = catDAO.getLastCustomers().get(0);
            }

            if (cat != null) {
                request.setAttribute("cat", cat);
                request.setAttribute("breeds", breeds);
                request.setAttribute("cust", cust);
                request.getRequestDispatcher("/staff_owner/cat/editCat.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Cat not found.");
                request.getRequestDispatcher("/staff_owner/cat/error.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/CatListController");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/staff_owner/cat/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading cat: " + e.getMessage());
            request.getRequestDispatcher("/staff_owner/cat/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIDStr = request.getParameter("catID");
        String catName = request.getParameter("catName");
        String dateOfBirthValue = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String conditionNotes = request.getParameter("conditionNotes");
        String breedIDStr = request.getParameter("breedID");

        Date dateOfBirth = DateUtil.parseDate(dateOfBirthValue);

        if (catIDStr == null || catIDStr.trim().isEmpty()
                || catName == null || catName.trim().isEmpty()
                || dateOfBirth == null
                || gender == null || gender.trim().isEmpty()
                || breedIDStr == null || breedIDStr.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all required fields. Date must use DD-MON-YYYY.");
            doGet(request, response);
            return;
        }

        try {
            int catID = Integer.parseInt(catIDStr.trim());
            int breedID = Integer.parseInt(breedIDStr.trim());

            Part filePart = request.getPart("catPhoto");

            CatBean cat = new CatBean();
            cat.setCatID(catID);
            cat.setCatName(catName.trim());
            cat.setDateOfBirth(dateOfBirth);
            cat.setGender(gender.trim());
            cat.setConditionNotes(conditionNotes);
            cat.setBreedID(breedID);

            boolean updated = catDAO.updateCat(cat, filePart);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/CatListController?notifType=update&notifMsg=Cat%20information%20updated%20successfully.");
            } else {
                request.setAttribute("error", "Failed to update cat.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input.");
            doGet(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating cat: " + e.getMessage());
            doGet(request, response);
        }
    }
}
