package catBooking.servlet.staff;

import catBooking.bean.FurBasedServiceBean;
import catBooking.bean.ServiceBean;
import catBooking.bean.WeightBasedServiceBean;
import catBooking.dao.ServiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ManageServicesController")
public class ManageServicesController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ServiceDAO dao;

    @Override
    public void init() {
        dao = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ServiceBean> serviceList = dao.getAllServicesForManagement();
        request.setAttribute("serviceList", serviceList);

        request.getRequestDispatcher("/staff_owner/service/services.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        boolean success = false;

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int serviceID = Integer.parseInt(request.getParameter("serviceID"));

                if (dao.isServiceUsedInAppointment(serviceID)) {
                    response.getWriter().print("inUse");
                    return;
                }

                success = dao.deleteService(serviceID);
            }

            else if ("addAddon".equalsIgnoreCase(action)) {
                ServiceBean service = new ServiceBean();

                service.setServiceName(request.getParameter("serviceName"));
                service.setDescription(request.getParameter("description"));
                service.setCategory("ADDON");
                service.setPrice(Double.parseDouble(request.getParameter("price")));

                success = dao.addService(service);
            }

            else if ("addMainPlain".equalsIgnoreCase(action)) {
                ServiceBean service = new ServiceBean();

                service.setServiceName(request.getParameter("serviceName"));
                service.setDescription(request.getParameter("description"));
                service.setCategory("MAIN");
                service.setPrice(Double.parseDouble(request.getParameter("price")));

                success = dao.addService(service);
            }

            else if ("addFur".equalsIgnoreCase(action)) {
                String shortServiceName = request.getParameter("shortServiceName");
                String shortDescription = request.getParameter("shortDescription");
                String longServiceName = request.getParameter("longServiceName");
                String longDescription = request.getParameter("longDescription");

                double priceShort = Double.parseDouble(request.getParameter("priceShort"));
                double priceLong = Double.parseDouble(request.getParameter("priceLong"));

                success = dao.addMainFurTypeService(
                        shortServiceName,
                        shortDescription,
                        priceShort,
                        longServiceName,
                        longDescription,
                        priceLong
                );
            }

            else if ("addWeight".equalsIgnoreCase(action)) {
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");

                String[] ranges = request.getParameterValues("weightRange");
                String[] prices = request.getParameterValues("weightPrice");

                if (ranges == null || prices == null || ranges.length == 0 || ranges.length != prices.length) {
                    response.getWriter().print("failed");
                    return;
                }

                List<String> weightRanges = new ArrayList<>();
                List<Double> weightPrices = new ArrayList<>();

                for (int i = 0; i < ranges.length; i++) {
                    String range = ranges[i] == null ? "" : ranges[i].trim();
                    double price = Double.parseDouble(prices[i]);

                    if (range.isEmpty() || price <= 0) {
                        response.getWriter().print("failed");
                        return;
                    }

                    weightRanges.add(range);
                    weightPrices.add(price);
                }

                success = dao.addMainWeightBasedService(
                        serviceName,
                        description,
                        weightRanges,
                        weightPrices
                );
            }

            else if ("edit".equalsIgnoreCase(action)) {
                int serviceID = Integer.parseInt(request.getParameter("serviceID"));

                String furType = request.getParameter("furType");
                String weightRange = request.getParameter("weightRange");

                ServiceBean service;

                if (furType != null && !furType.trim().isEmpty()) {
                    FurBasedServiceBean furService = new FurBasedServiceBean();
                    furService.setFurType(furType.trim());
                    service = furService;

                } else if (weightRange != null && !weightRange.trim().isEmpty()) {
                    WeightBasedServiceBean weightService = new WeightBasedServiceBean();
                    weightService.setWeightRange(weightRange.trim());
                    service = weightService;

                } else {
                    service = new ServiceBean();
                }

                service.setServiceID(serviceID);
                service.setServiceName(request.getParameter("serviceName"));
                service.setDescription(request.getParameter("description"));
                service.setPrice(Double.parseDouble(request.getParameter("price")));

                success = dao.updateService(service);
            }

        } catch (Exception e) {
            e.printStackTrace();
            success = false;
        }

        response.getWriter().print(success ? "success" : "failed");
    }
}