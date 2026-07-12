package catBooking.servlet.staff;

import catBooking.bean.CatBean;
import catBooking.dao.StaffCatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/CatListController")
public class CatListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StaffCatDAO catDAO = new StaffCatDAO();

    public CatListController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	
        doPost(request, response);
        
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	String searchTerm = request.getParameter("search");
        try {
            List<CatBean> cats;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                cats = catDAO.searchCats(searchTerm.trim());
            } else {
                cats = catDAO.getAllCats();
            }
            request.setAttribute("cats", cats);
            request.setAttribute("breeds", catDAO.getLastBreeds());    
            request.setAttribute("custs", catDAO.getLastCustomers());  
            request.getRequestDispatcher("/staff_owner/cat/mainCat.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/staff_owner/cat/mainCat.jsp").forward(request, response);
        }
    }
}