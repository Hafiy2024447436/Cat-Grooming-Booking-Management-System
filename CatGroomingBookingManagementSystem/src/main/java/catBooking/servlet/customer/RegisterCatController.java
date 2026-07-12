package catBooking.servlet.customer;

import catBooking.bean.CatBean;
import catBooking.dao.CustomerCatDAO;
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

@WebServlet("/RegisterCatController")
@MultipartConfig
public class RegisterCatController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("customer/cat/registerCat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        int custID;
        try {
            custID = Integer.parseInt(session.getAttribute("userID").toString());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
            return;
        }

        String catName = request.getParameter("catName");
        String dateOfBirthValue = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String conditionNotes = request.getParameter("conditionNotes");
        String breedIDStr = request.getParameter("breedID");

        Date dateOfBirth = DateUtil.parseDate(dateOfBirthValue);

        if (catName == null || catName.trim().isEmpty() || dateOfBirth == null) {
            request.setAttribute("errorMsg", "Cat name and date of birth are required. Use DD-MON-YYYY format.");
            request.getRequestDispatcher("customer/cat/registerCat.jsp").forward(request, response);
            return;
        }

        int breedID;
        try {
            breedID = Integer.parseInt(breedIDStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid breed selected.");
            request.getRequestDispatcher("customer/cat/registerCat.jsp").forward(request, response);
            return;
        }

        Part photoPart = request.getPart("catPhoto");

        CatBean cat = new CatBean();
        cat.setCatName(catName.trim());
        cat.setDateOfBirth(dateOfBirth);
        cat.setGender(gender);
        cat.setConditionNotes(conditionNotes);
        cat.setCustID(custID);
        cat.setBreedID(breedID);

        boolean success = CustomerCatDAO.insertCat(cat, photoPart);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/CustomerCatController?notifType=create&notifMsg=Cat%20registered%20successfully.");
        } else {
            request.setAttribute("errorMsg", "Failed to register cat. Please try again.");
            request.getRequestDispatcher("customer/cat/registerCat.jsp").forward(request, response);
        }
    }
}
