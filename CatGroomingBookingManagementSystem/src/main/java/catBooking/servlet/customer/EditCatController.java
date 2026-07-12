package catBooking.servlet.customer;

import catBooking.bean.CatBean;
import catBooking.bean.BreedBean;
import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerCatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;

@WebServlet("/EditCatController")
@MultipartConfig
public class EditCatController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: load cat data and show the edit form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIDStr = request.getParameter("catID");

        if (catIDStr == null || catIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/CustomerCatController?notifType=error&notifMsg=Invalid%20cat%20record.");
            return;
        }

        try {
            int catID = Integer.parseInt(catIDStr);

            CatBean cat = CustomerCatDAO.getCatByID(catID);

            if (cat == null) {
                response.sendRedirect(request.getContextPath()
                        + "/CustomerCatController?notifType=error&notifMsg=Cat%20record%20not%20found.");
                return;
            }

            BreedBean breed = CustomerCatDAO.getBreedByID(cat.getBreedID());
            CustomerBean cust = CustomerCatDAO.getCustByID(cat.getCustID());

            request.setAttribute("cat", cat);
            request.setAttribute("breed", breed);
            request.setAttribute("cust", cust);

            request.getRequestDispatcher("customer/cat/editCat.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/CustomerCatController?notifType=error&notifMsg=Invalid%20cat%20record.");
        }
    }

    // POST: save changes to database
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIDStr = request.getParameter("catID");
        String catName = request.getParameter("catName");
        String conditionNotes = request.getParameter("conditionNotes");

        if (catIDStr == null || catIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/CustomerCatController?notifType=error&notifMsg=Invalid%20cat%20record.");
            return;
        }

        try {
            int catID = Integer.parseInt(catIDStr);

            // Get current cat to keep existing photo if no new one uploaded
            CatBean cat = CustomerCatDAO.getCatByID(catID);

            if (cat == null) {
                response.sendRedirect(request.getContextPath()
                        + "/CustomerCatController?notifType=error&notifMsg=Cat%20record%20not%20found.");
                return;
            }

            Part photoPart = request.getPart("catPhoto");

            cat.setCatName(catName == null ? "" : catName.trim());
            cat.setConditionNotes(conditionNotes);

            boolean success = false;

            try {
                success = CustomerCatDAO.updateProfile(cat, photoPart);
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/CustomerCatController?notifType=update&notifMsg=Cat%20information%20updated%20successfully.");
            } else {
                request.setAttribute("errorMsg", "Failed to update. Please try again.");
                request.setAttribute("cat", cat);
                request.setAttribute("breed", CustomerCatDAO.getBreedByID(cat.getBreedID()));
                request.setAttribute("cust", CustomerCatDAO.getCustByID(cat.getCustID()));
                request.getRequestDispatcher("customer/cat/editCat.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/CustomerCatController?notifType=error&notifMsg=Invalid%20cat%20record.");
        }
    }
}
