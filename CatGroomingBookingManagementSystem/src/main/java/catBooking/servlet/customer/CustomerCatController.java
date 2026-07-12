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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/CustomerCatController")
public class CustomerCatController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerCatController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        int custID = (int) session.getAttribute("userID");

        // call DAO methods
        List<CatBean> cats = CustomerCatDAO.getCatsByCustomer(custID);
        List<BreedBean> breeds = CustomerCatDAO.getBreedsByCat(custID);
        List<CustomerBean> custs = CustomerCatDAO.getCustByCat(custID);
        List<BreedBean> allBreeds = CustomerCatDAO.getAllBreeds();

        // set attributes for JSP
        request.setAttribute("cats", cats);
        request.setAttribute("breeds", breeds);
        request.setAttribute("custs", custs);
        request.setAttribute("allBreeds", allBreeds);
        request.getRequestDispatcher("customer/cat/customerCat.jsp").forward(request, response);
    }
}