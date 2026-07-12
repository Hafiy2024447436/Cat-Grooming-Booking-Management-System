package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.CustomerBean;
import catBooking.util.DateUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class StaffInvoiceDAO {

    public static class InvoiceRow {
        private int appointmentID;
        private String invoiceNo;
        private String appointmentDate;
        private String appointmentTime;
        private String appointmentStatus;
        private String paymentStatus;
        private String catName;
        private String staffFullName;
        private String custFullName;
        private String custEmail;
        private int custID;
        private List<ServiceLine> services = new ArrayList<>();
        private List<ServiceLine> mainServices = new ArrayList<>();
        private List<ServiceLine> addOnServices = new ArrayList<>();
        private double totalAmount;

        public int getAppointmentID() { return appointmentID; }
        public String getInvoiceNo() { return invoiceNo; }
        public String getAppointmentDate() { return appointmentDate; }
        public String getAppointmentTime() { return appointmentTime; }
        public String getAppointmentStatus() { return appointmentStatus; }
        public String getPaymentStatus() { return paymentStatus; }
        public String getCatName() { return catName; }
        public String getStaffFullName() { return staffFullName; }
        public String getCustFullName() { return custFullName; }
        public String getCustEmail() { return custEmail; }
        public int getCustID() { return custID; }
        public List<ServiceLine> getServices() { return services; }
        public List<ServiceLine> getMainServices() { return mainServices; }
        public List<ServiceLine> getAddOnServices() { return addOnServices; }
        public double getTotalAmount() { return totalAmount; }
    }

    public static class ServiceLine {
        private int serviceID;
        private String serviceName;
        private String category;
        private double price;

        public int getServiceID() { return serviceID; }
        public String getServiceName() { return serviceName; }
        public String getCategory() { return category; }
        public double getPrice() { return price; }
    }

    public static class CatOption {
        public int catID;
        public String catName;
    }

    private static final String GROUPED_SELECT =
            "SELECT a.appointmentID, "
          + "'INV-' || TO_CHAR(a.appointmentDate, 'YYMMDD') || '-' || LPAD(CAST(a.appointmentID AS TEXT), 4, '0') AS invoiceNo, "
          + "TO_CHAR(a.appointmentDate, 'DD-MON-YYYY') AS appointmentDate, "
          + "TO_CHAR(a.appointmentTime, 'HH24:MI') AS appointmentTime, "
          + "a.appointmentStatus, "
          + "c.catName, cu.custID, cu.custFullName, cu.custEmail, "
          + "s.serviceID, s.serviceName, s.category, s.price, "
          + "st.staffFullName "
          + "FROM Appointment a "
          + "JOIN Cat c ON a.catID = c.catID "
          + "JOIN Customer cu ON c.custID = cu.custID "
          + "JOIN Service s ON a.serviceID = s.serviceID "
          + "LEFT JOIN Staff st ON a.staffID = st.staffID ";

    private static final String SERVICE_ORDER =
            " ORDER BY a.appointmentDate DESC, a.appointmentID DESC, "
          + "CASE "
          + "WHEN UPPER(TRIM(s.category)) = 'MAIN' THEN 1 "
          + "WHEN UPPER(TRIM(s.category)) = 'ADDON' THEN 2 "
          + "ELSE 3 END, s.serviceName";

    public List<InvoiceRow> getAllInvoices() {
        Map<Integer, InvoiceRow> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' AND UPPER(TRIM(a.appointmentStatus)) IN ('CONFIRMED', 'COMPLETED')"
                + SERVICE_ORDER;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                mapIntoGroup(map, rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    public List<InvoiceRow> getAllPaidReceipts() {
        Map<Integer, InvoiceRow> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' AND UPPER(TRIM(a.appointmentStatus)) = 'COMPLETED'"
                + SERVICE_ORDER;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                mapIntoGroup(map, rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    public InvoiceRow getInvoiceByID(int appointmentID) {
        Map<Integer, InvoiceRow> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
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

    public List<InvoiceRow> getInvoicesByCustomerID(int custID) {
        Map<Integer, InvoiceRow> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE cu.custID = ? "
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    public List<InvoiceRow> getPaidReceiptsByCustomerID(int custID) {
        Map<Integer, InvoiceRow> map = new LinkedHashMap<>();

        String sql = GROUPED_SELECT
                + "WHERE cu.custID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(a.appointmentStatus)) = 'COMPLETED'"
                + SERVICE_ORDER;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    mapIntoGroup(map, rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    private void mapIntoGroup(Map<Integer, InvoiceRow> map, ResultSet rs) throws SQLException {
        int id = rs.getInt("appointmentID");
        InvoiceRow row = map.get(id);

        if (row == null) {
            row = new InvoiceRow();

            row.appointmentID = id;
            row.invoiceNo = rs.getString("invoiceNo");
            row.appointmentDate = rs.getString("appointmentDate");
            row.appointmentTime = rs.getString("appointmentTime");
            row.appointmentStatus = rs.getString("appointmentStatus");
            row.paymentStatus = "Completed".equalsIgnoreCase(row.appointmentStatus)
                    ? "Paid"
                    : "Unpaid";
            row.catName = rs.getString("catName");
            row.custID = rs.getInt("custID");
            row.custFullName = rs.getString("custFullName");
            row.custEmail = rs.getString("custEmail");

            String staff = rs.getString("staffFullName");
            row.staffFullName = staff != null ? staff : "Not assigned";

            map.put(id, row);
        }

        ServiceLine line = new ServiceLine();
        line.serviceID = rs.getInt("serviceID");
        line.serviceName = rs.getString("serviceName");
        line.category = normalizeCategory(rs.getString("category"));
        line.price = rs.getDouble("price");

        row.services.add(line);

        if ("MAIN".equals(line.category)) {
            row.mainServices.add(line);
        } else if ("ADDON".equals(line.category)) {
            row.addOnServices.add(line);
        }

        row.totalAmount += line.price;
    }

    public boolean updatePaymentStatus(int appointmentID, String paymentStatus) {
        String newAppointmentStatus =
                "Paid".equalsIgnoreCase(paymentStatus) ? "Completed" : "Confirmed";

        String sql = "UPDATE Appointment SET appointmentStatus = ? "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newAppointmentStatus);
            ps.setInt(2, appointmentID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<CustomerBean> getAllCustomers() {
        List<CustomerBean> list = new ArrayList<>();

        String sql = "SELECT custID, custFullName, custEmail, custPhoneNumber "
                + "FROM Customer "
                + "ORDER BY custFullName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CustomerBean c = new CustomerBean();
                c.setCustID(rs.getInt("custID"));
                c.setCustFullName(rs.getString("custFullName"));
                c.setCustEmail(rs.getString("custEmail"));
                c.setCustPhoneNumber(rs.getString("custPhoneNumber"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<CatOption> getCatsByCustomer(int custID) {
        List<CatOption> list = new ArrayList<>();

        String sql = "SELECT catID, catName "
                + "FROM Cat "
                + "WHERE custID = ? "
                + "ORDER BY catName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CatOption cat = new CatOption();
                    cat.catID = rs.getInt("catID");
                    cat.catName = rs.getString("catName");
                    list.add(cat);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int createAppointment(int catID, int staffID, String appointmentDate,
                                 String appointmentTime, List<Integer> serviceIDs,
                                 double totalAmount, String status) {

        Date sqlDate = DateUtil.parseDate(appointmentDate);
        appointmentTime = normalizeTimeToHH24MI(appointmentTime);

        if (sqlDate == null
                || appointmentTime == null || appointmentTime.trim().isEmpty()
                || serviceIDs == null || serviceIDs.isEmpty()) {
            return -1;
        }

        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            int appointmentID;

            String idSql = "SELECT nextval('appointmentid_seq') AS nextID";

            try (PreparedStatement ps = con.prepareStatement(idSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    appointmentID = rs.getInt("nextID");
                } else {
                    con.rollback();
                    return -1;
                }
            }

            String insertSql = "INSERT INTO Appointment "
                    + "(appointmentID, catID, serviceID, appointmentDate, appointmentTime, "
                    + "appointmentStatus, weight, totalAmount, staffID) "
                    + "VALUES (?, ?, ?, ?, "
                    + "CAST(? AS TIME), ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                for (int serviceID : serviceIDs) {
                    double servicePrice = getServicePrice(con, serviceID);

                    if (servicePrice < 0) {
                        con.rollback();
                        return -1;
                    }

                    ps.setInt(1, appointmentID);
                    ps.setInt(2, catID);
                    ps.setInt(3, serviceID);
                    ps.setDate(4, sqlDate);
                    ps.setString(5, appointmentTime);
                    ps.setString(6, status);
                    ps.setNull(7, Types.NUMERIC);
                    ps.setDouble(8, servicePrice);
                    ps.setInt(9, staffID);
                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();
            return appointmentID;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return -1;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    private double getServicePrice(Connection con, int serviceID) {
        String sql = "SELECT price FROM Service WHERE serviceID = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("price");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    private String normalizeCategory(String category) {
        if (category == null) {
            return "";
        }

        return category.trim().toUpperCase();
    }

    private String normalizeTimeToHH24MI(String time) {
        if (time == null || time.trim().isEmpty()) {
            return "";
        }

        String value = time.trim().toUpperCase();

        try {
            if (value.matches("\\d{2}:\\d{2}")) {
                return value;
            }

            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("h:mm a");
            DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm");

            return LocalTime.parse(value, inputFormatter).format(outputFormatter);

        } catch (Exception e) {
            e.printStackTrace();
            return value;
        }
    }
}