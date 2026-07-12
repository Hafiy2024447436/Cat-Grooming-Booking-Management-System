package catBooking.dao;

import catBooking.ConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    public static class DashboardStats {
        public int todayAppointments;
        public int pendingBookings;
        public int totalCustomers;
        public int totalStaff;
        public int totalCats;
        public double monthRevenue;
        public List<DayRevenue> last7Days = new ArrayList<>();
    }

    public static class DayRevenue {
        public String label;
        public double amount;

        public DayRevenue(String label, double amount) {
            this.label = label;
            this.amount = amount;
        }
    }

    public static class RecentAppointmentRow {
        public int appointmentID;
        public String appointmentNo;
        public String appointmentDate;
        public String appointmentTime;
        public String appointmentStatus;
        public String custFullName;
        public String catName;
        public double totalAmount;
    }

    public DashboardStats getStats() throws SQLException {
        DashboardStats stats = new DashboardStats();

        try (Connection conn = ConnectionManager.getConnection()) {
            stats.todayAppointments = singleIntQuery(conn,
                    "SELECT COUNT(*) FROM Appointment WHERE CAST(appointmentDate AS DATE) = CURRENT_DATE AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'");

            stats.pendingBookings = singleIntQuery(conn,
                    "SELECT COUNT(*) FROM Appointment WHERE appointmentStatus = 'Pending' AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'");

            stats.totalCustomers = singleIntQuery(conn,
                    "SELECT COUNT(*) FROM Customer WHERE custStatus = 'Active'");

            stats.totalStaff = singleIntQuery(conn,
                    "SELECT COUNT(*) FROM Staff WHERE staffRole != 'Owner' AND staffStatus = 'Active'");

            stats.totalCats = singleIntQuery(conn,
                    "SELECT COUNT(*) FROM Cat WHERE catStatus = 'Active'");

            stats.monthRevenue = singleDoubleQuery(conn,
                    "SELECT COALESCE(SUM(totalAmount),0) FROM Appointment "
                    + "WHERE appointmentStatus = 'Completed' "
                    + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                    + "AND DATE_TRUNC('month', appointmentDate) = DATE_TRUNC('month', CURRENT_DATE)");

            stats.last7Days = getLast7DaysRevenue(conn);
        }

        return stats;
    }

    public List<RecentAppointmentRow> getRecentAppointments(int limit) throws SQLException {
        List<RecentAppointmentRow> list = new ArrayList<>();

        String sql =
            "SELECT a.appointmentID, "
            + "        'APT-' || TO_CHAR(a.appointmentDate, 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
            + "        TO_CHAR(a.appointmentDate, 'DD-MON-YYYY') AS appointmentDate, "
            + "        TO_CHAR(a.appointmentTime, 'HH24:MI') AS appointmentTime, "
            + "        a.appointmentStatus, a.totalAmount, c.catName, cu.custFullName "
            + " FROM Appointment a "
            + " JOIN Cat c ON a.catID = c.catID "
            + " JOIN Customer cu ON c.custID = cu.custID "
            + " WHERE UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
            + " ORDER BY a.appointmentDate DESC, a.appointmentTime DESC"
            + " LIMIT ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecentAppointmentRow row = new RecentAppointmentRow();
                    row.appointmentID = rs.getInt("appointmentID");
                    row.appointmentNo = rs.getString("appointmentNo");
                    row.appointmentDate = rs.getString("appointmentDate");
                    row.appointmentTime = rs.getString("appointmentTime");
                    row.appointmentStatus = rs.getString("appointmentStatus");
                    row.totalAmount = rs.getDouble("totalAmount");
                    row.catName = rs.getString("catName");
                    row.custFullName = rs.getString("custFullName");
                    list.add(row);
                }
            }
        }

        return list;
    }

    private List<DayRevenue> getLast7DaysRevenue(Connection conn) throws SQLException {
        String sql =
            "SELECT CAST(appointmentDate AS DATE) AS d, COALESCE(SUM(totalAmount),0) AS total "
            + "FROM Appointment "
            + "WHERE appointmentStatus = 'Completed' "
            + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
            + "AND appointmentDate >= CURRENT_DATE - 6 "
            + "GROUP BY CAST(appointmentDate AS DATE)";

        Map<String, Double> byDate = new HashMap<>();

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                byDate.put(rs.getDate("d").toString(), rs.getDouble("total"));
            }
        }

        List<DayRevenue> result = new ArrayList<>();
        SimpleDateFormat labelFmt = new SimpleDateFormat("dd MMM");
        SimpleDateFormat keyFmt = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -6);

        for (int i = 0; i < 7; i++) {
            String key = keyFmt.format(cal.getTime());
            double amount = byDate.getOrDefault(key, 0.0);
            result.add(new DayRevenue(labelFmt.format(cal.getTime()), amount));
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }

        return result;
    }

    private int singleIntQuery(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private double singleDoubleQuery(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
}
