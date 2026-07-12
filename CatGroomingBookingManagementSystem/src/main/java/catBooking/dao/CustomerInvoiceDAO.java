package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.InvoiceBean;
import catBooking.bean.InvoiceBean.ServiceLine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class CustomerInvoiceDAO {

    private static final String GROUPED_SELECT =
              "SELECT a.appointmentID, "
            + "'INV-' || TO_CHAR(a.appointmentDate, 'YYMMDD') || '-' || LPAD(CAST(a.appointmentID AS TEXT), 4, '0') AS invoiceNo, "
            + "TO_CHAR(a.appointmentDate, 'DD-MON-YYYY') AS appointmentDate, "
            + "TO_CHAR(a.appointmentTime, 'HH24:MI') AS appointmentTime, "
            + "a.appointmentStatus, "
            + "c.catName, "
            + "s.serviceID, s.serviceName, s.category, s.price, "
            + "st.staffFullName "
            + "FROM Appointment a "
            + "JOIN Cat c ON a.catID = c.catID "
            + "JOIN Service s ON a.serviceID = s.serviceID "
            + "LEFT JOIN Staff st ON a.staffID = st.staffID ";

    private static final String SERVICE_ORDER =
              " ORDER BY a.appointmentDate DESC, a.appointmentID DESC, "
            + "CASE "
            + "WHEN UPPER(TRIM(s.category)) = 'MAIN' THEN 1 "
            + "WHEN UPPER(TRIM(s.category)) = 'ADDON' THEN 2 "
            + "ELSE 3 END, s.serviceName";

    public List<InvoiceBean> getInvoicesByCustomer(int custID) {
        Map<Integer, InvoiceBean> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE c.custID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(a.appointmentStatus)) IN ('CONFIRMED', 'COMPLETED')"
                + SERVICE_ORDER;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    mapIntoGroup(map, rs);
                }
            }

            System.out.println("CustomerInvoiceDAO.getInvoicesByCustomer: custID="
                    + custID + " -> " + map.size() + " invoice(s)");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    public InvoiceBean getInvoiceByAppointmentID(int appointmentID) {
        Map<Integer, InvoiceBean> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(a.appointmentStatus)) IN ('CONFIRMED', 'COMPLETED') "
                + "ORDER BY CASE "
                + "WHEN UPPER(TRIM(s.category)) = 'MAIN' THEN 1 "
                + "WHEN UPPER(TRIM(s.category)) = 'ADDON' THEN 2 "
                + "ELSE 3 END, s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    mapIntoGroup(map, rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (map.isEmpty()) {
            return null;
        }

        return map.values().iterator().next();
    }

    private void mapIntoGroup(Map<Integer, InvoiceBean> map, ResultSet rs) throws SQLException {
        int appointmentID = rs.getInt("appointmentID");
        InvoiceBean inv = map.get(appointmentID);

        if (inv == null) {
            inv = new InvoiceBean();
            inv.setAppointmentID(appointmentID);
            inv.setInvoiceNo(rs.getString("invoiceNo"));
            inv.setAppointmentDate(rs.getString("appointmentDate"));
            inv.setAppointmentTime(rs.getString("appointmentTime"));
            inv.setAppointmentStatus(rs.getString("appointmentStatus"));
            inv.setCatName(rs.getString("catName"));

            String staff = rs.getString("staffFullName");
            inv.setStaffFullName(staff != null ? staff : "Not assigned");

            map.put(appointmentID, inv);
        }

        ServiceLine line = new ServiceLine();
        line.setServiceID(rs.getInt("serviceID"));
        line.setServiceName(rs.getString("serviceName"));
        line.setCategory(normalizeCategory(rs.getString("category")));
        line.setPrice(rs.getDouble("price"));

        inv.getServices().add(line);

        if (inv.getServiceName() == null) {
            inv.setServiceName(line.getServiceName());
            inv.setServicePrice(line.getPrice());
        }

        if ("MAIN".equals(line.getCategory())) {
            inv.getMainServices().add(line);
        } else if ("ADDON".equals(line.getCategory())) {
            inv.getAddOnServices().add(line);
        }

        inv.setTotalAmount(inv.getTotalAmount() + line.getPrice());
    }

    private String normalizeCategory(String category) {
        if (category == null) {
            return "";
        }

        String clean = category.trim().toUpperCase(Locale.ENGLISH);
        if ("ADD-ON".equals(clean) || "ADD_ON".equals(clean) || "ADD ON".equals(clean)) {
            return "ADDON";
        }

        return clean;
    }
}
