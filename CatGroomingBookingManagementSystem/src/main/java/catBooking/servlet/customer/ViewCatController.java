package catBooking.servlet.customer;

import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.bean.CustomerBean;
import catBooking.dao.CustomerCatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ViewCatController")
public class ViewCatController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIDStr = request.getParameter("catID");

        if (catIDStr == null || catIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CustomerCatController");
            return;
        }

        int catID = Integer.parseInt(catIDStr);

        //retrieve data from sql through CustomerCatDAO.java
        CatBean cat = CustomerCatDAO.getCatByID(catID);
        BreedBean breed = CustomerCatDAO.getBreedByID(cat.getBreedID());
        CustomerBean cust = CustomerCatDAO.getCustByID(cat.getCustID());

        request.setAttribute("cat", cat);
        request.setAttribute("breed", breed);
        request.setAttribute("cust", cust);

        request.getRequestDispatcher("customer/cat/viewCat.jsp").forward(request, response);
    }
}