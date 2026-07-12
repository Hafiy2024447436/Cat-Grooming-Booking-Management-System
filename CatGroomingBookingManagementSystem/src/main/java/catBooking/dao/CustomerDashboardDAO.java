package catBooking.dao;

import catBooking.ConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class CustomerDashboardDAO {

    public static class CustomerDashboardStats {
        private int totalCats;
        private int upcomingCount;
        private int invoiceCount;
        private List<RecentAppointment> recentAppointments = new ArrayList<>();

        public int getTotalCats() {
            return totalCats;
        }

        public void setTotalCats(int totalCats) {
            this.totalCats = totalCats;
        }

        public int getUpcomingCount() {
            return upcomingCount;
        }

        public void setUpcomingCount(int upcomingCount) {
            this.upcomingCount = upcomingCount;
        }

        public int getInvoiceCount() {
            return invoiceCount;
        }

        public void setInvoiceCount(int invoiceCount) {
            this.invoiceCount = invoiceCount;
        }

        public List<RecentAppointment> getRecentAppointments() {
            return recentAppointments;
        }

        public void setRecentAppointments(List<RecentAppointment> recentAppointments) {
            this.recentAppointments = recentAppointments;
        }
    }

    public static class RecentAppointment {
        private int appointmentID;
        private String appointmentNo;
        private String catName;
        private String appointmentDate;
        private String appointmentTime;
        private String status;
        private String statusClass;
        private double totalAmount;

        public int getAppointmentID() {
            return appointmentID;
        }

        public void setAppointmentID(int appointmentID) {
            this.appointmentID = appointmentID;
        }

        public String getAppointmentNo() {
            return appointmentNo;
        }

        public void setAppointmentNo(String appointmentNo) {
            this.appointmentNo = appointmentNo;
        }

        public String getCatName() {
            return catName;
        }

        public void setCatName(String catName) {
            this.catName = catName;
        }

        public String getAppointmentDate() {
            return appointmentDate;
        }

        public void setAppointmentDate(String appointmentDate) {
            this.appointmentDate = appointmentDate;
        }

        public String getAppointmentTime() {
            return appointmentTime;
        }

        public void setAppointmentTime(String appointmentTime) {
            this.appointmentTime = appointmentTime;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = toTitleCase(status);
            this.statusClass = toStatusClass(status);
        }

        public String getStatusClass() {
            return statusClass;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(double totalAmount) {
            this.totalAmount = totalAmount;
        }
    }

    public CustomerDashboardStats getDashboardStats(int custID) {
        CustomerDashboardStats stats = new CustomerDashboardStats();

        stats.setTotalCats(getTotalCats(custID));
        stats.setUpcomingCount(getUpcomingAppointments(custID));
        stats.setInvoiceCount(getInvoiceCount(custID));
        stats.setRecentAppointments(getRecentAppointments(custID, 5));

        return stats;
    }

    public int getTotalCats(int custID) {
        String sql =
                "SELECT COUNT(*) AS totalCats " +
                "FROM Cat " +
                "WHERE custID = ? " +
                "AND COALESCE(catStatus, 'Active') = 'Active'";

        return getSingleCount(sql, custID);
    }

    public int getUpcomingAppointments(int custID) {
        String sql =
                "SELECT COUNT(DISTINCT a.appointmentID) AS totalUpcoming " +
                "FROM Appointment a " +
                "JOIN Cat c ON a.catID = c.catID " +
                "WHERE c.custID = ? " +
                "AND CAST(a.appointmentDate AS DATE) >= CURRENT_DATE " +
                "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' " +
                "AND UPPER(TRIM(a.appointmentStatus)) IN ('PENDING', 'CONFIRMED')";

        return getSingleCount(sql, custID);
    }

    public int getInvoiceCount(int custID) {
        String sql =
                "SELECT COUNT(DISTINCT a.appointmentID) AS totalInvoices " +
                "FROM Appointment a " +
                "JOIN Cat c ON a.catID = c.catID " +
                "WHERE c.custID = ? " +
                "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' " +
                "AND UPPER(TRIM(a.appointmentStatus)) IN ('CONFIRMED', 'COMPLETED')";

        return getSingleCount(sql, custID);
    }

    public List<RecentAppointment> getRecentAppointments(int custID, int limit) {
        List<RecentAppointment> list = new ArrayList<>();

        String sql =
                "SELECT a.appointmentID, " +
                "         'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, " +
                "         MIN(c.catName) AS catName, " +
                "         TO_CHAR(MIN(a.appointmentDate), 'DD-MON-YYYY') AS appointmentDate, " +
                "         TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, " +
                "         MIN(a.appointmentStatus) AS appointmentStatus, " +
                "         SUM(a.totalAmount) AS totalAmount, " +
                "         MIN(a.appointmentDate) AS sortDate, " +
                "         MIN(a.appointmentTime) AS sortTime " +
                "  FROM Appointment a " +
                "  JOIN Cat c ON a.catID = c.catID " +
                "  WHERE c.custID = ? " +
                "  AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' " +
                "  GROUP BY a.appointmentID " +
                "  ORDER BY sortDate DESC, sortTime DESC " +
                "LIMIT ?";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecentAppointment row = new RecentAppointment();

                    row.setAppointmentID(rs.getInt("appointmentID"));
                    row.setAppointmentNo(rs.getString("appointmentNo"));
                    row.setCatName(rs.getString("catName"));
                    row.setAppointmentDate(rs.getString("appointmentDate"));
                    row.setAppointmentTime(rs.getString("appointmentTime"));
                    row.setStatus(rs.getString("appointmentStatus"));
                    row.setTotalAmount(rs.getDouble("totalAmount"));

                    list.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private int getSingleCount(String sql, int custID) {
        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    private static String toTitleCase(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "Unknown";
        }

        String clean = value.trim().toLowerCase(Locale.ENGLISH);
        return clean.substring(0, 1).toUpperCase(Locale.ENGLISH) + clean.substring(1);
    }

    private static String toStatusClass(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "unknown";
        }

        String clean = value.trim().toLowerCase(Locale.ENGLISH);
        clean = clean.replaceAll("[^a-z0-9]+", "-");
        clean = clean.replaceAll("^-|-$", "");

        return clean.isEmpty() ? "unknown" : clean;
    }
}
