package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.AppointmentBean;
import catBooking.util.DateUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CustAppointmentDAO {

    public static class AppointmentServiceRow {
        public int serviceID;
        public String serviceName;
        public String category;
        public double price;

        public int getServiceID() {
            return serviceID;
        }

        public String getServiceName() {
            return serviceName;
        }

        public String getCategory() {
            return category;
        }

        public double getPrice() {
            return price;
        }
    }

    public int getNextAppointmentID() {
        String sql = "SELECT nextval('appointmentid_seq') AS nextID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("nextID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<String> getBookedTimesByDate(String appointmentDate) {
        List<String> bookedTimes = new ArrayList<>();
        Date sqlDate = DateUtil.parseDate(appointmentDate);

        if (sqlDate == null) {
            return bookedTimes;
        }

        String sql = "SELECT DISTINCT TO_CHAR(appointmentTime, 'HH24:MI') AS appointmentTime "
                + "FROM Appointment "
                + "WHERE CAST(appointmentDate AS DATE) = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(appointmentStatus)) <> 'CANCELLED'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookedTimes.add(rs.getString("appointmentTime"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookedTimes;
    }

    public boolean addAppointment(AppointmentBean appt) {
        String sql = "INSERT INTO Appointment "
                + "(appointmentID, catID, serviceID, appointmentDate, appointmentTime, "
                + "appointmentStatus, weight, totalAmount, staffID, recordStatus) "
                + "VALUES (?, ?, ?, ?, "
                + "CAST(? AS TIME), ?, ?, ?, ?, 'Active')";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appt.getAppointmentID());
            ps.setInt(2, appt.getCatID());
            ps.setInt(3, appt.getServiceID());
            ps.setDate(4, appt.getAppointmentDate());
            ps.setString(5, appt.getAppointmentTime());
            ps.setString(6, appt.getAppointmentStatus());
            if (appt.getWeight() == null || appt.getWeight() <= 0) {
                ps.setNull(7, Types.NUMERIC);
            } else {
                ps.setDouble(7, appt.getWeight());
            }
            ps.setDouble(8, appt.getTotalAmount());
            ps.setInt(9, appt.getStaffID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public AppointmentBean getAppointmentById(String appointmentID) {
        String sql = "SELECT appointmentID, catID, "
                + "'APT-' || TO_CHAR(MIN(appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(appointmentID AS TEXT)) < 4 THEN LPAD(CAST(appointmentID AS TEXT), 4, '0') ELSE CAST(appointmentID AS TEXT) END AS appointmentNo, "
                + "MIN(appointmentDate) AS appointmentDate, "
                + "TO_CHAR(MIN(appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(appointmentStatus) AS appointmentStatus, "
                + "MAX(NULLIF(weight, 0)) AS weight, "
                + "SUM(totalAmount) AS totalAmount, "
                + "MIN(staffID) AS staffID "
                + "FROM Appointment "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "GROUP BY appointmentID, catID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AppointmentBean appt = new AppointmentBean();
                    appt.setAppointmentID(rs.getInt("appointmentID"));
                    appt.setAppointmentNo(rs.getString("appointmentNo"));
                    appt.setCatID(rs.getInt("catID"));
                    appt.setAppointmentDate(rs.getDate("appointmentDate"));
                    appt.setAppointmentTime(rs.getString("appointmentTime"));
                    appt.setAppointmentStatus(rs.getString("appointmentStatus"));
                    double weightValue = rs.getDouble("weight");
                    appt.setWeight(rs.wasNull() ? null : weightValue);
                    appt.setTotalAmount(rs.getDouble("totalAmount"));
                    appt.setStaffID(rs.getInt("staffID"));
                    return appt;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<AppointmentBean> getAllAppointments() {
        List<AppointmentBean> appointments = new ArrayList<>();

        String sql = "SELECT a.appointmentID, "
                + "'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "MIN(a.catID) AS catID, "
                + "MIN(a.appointmentDate) AS appointmentDate, "
                + "TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(a.appointmentStatus) AS appointmentStatus, "
                + "MAX(NULLIF(a.weight, 0)) AS weight, "
                + "SUM(a.totalAmount) AS totalAmount, "
                + "MIN(a.staffID) AS staffID "
                + "FROM Appointment a "
                + "JOIN Cat c ON a.catID = c.catID "
                + "JOIN Customer cu ON c.custID = cu.custID "
                + "WHERE UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "GROUP BY a.appointmentID "
                + "ORDER BY MIN(a.appointmentDate) DESC, MIN(a.appointmentTime) DESC";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AppointmentBean appt = new AppointmentBean();
                appt.setAppointmentID(rs.getInt("appointmentID"));
                appt.setAppointmentNo(rs.getString("appointmentNo"));
                appt.setCatID(rs.getInt("catID"));
                appt.setAppointmentDate(rs.getDate("appointmentDate"));
                appt.setAppointmentTime(rs.getString("appointmentTime"));
                appt.setAppointmentStatus(rs.getString("appointmentStatus"));
                double weightValue = rs.getDouble("weight");
                appt.setWeight(rs.wasNull() ? null : weightValue);
                appt.setTotalAmount(rs.getDouble("totalAmount"));
                appt.setStaffID(rs.getInt("staffID"));
                appointments.add(appt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }

    public List<AppointmentBean> getAppointmentsByCustomer(int custID) {
        List<AppointmentBean> appointments = new ArrayList<>();

        String sql = "SELECT a.appointmentID, a.catID, "
                + "'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "MIN(a.appointmentDate) AS appointmentDate, "
                + "TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(a.appointmentStatus) AS appointmentStatus, "
                + "MAX(NULLIF(a.weight, 0)) AS weight, "
                + "SUM(a.totalAmount) AS totalAmount, "
                + "MIN(a.staffID) AS staffID "
                + "FROM Appointment a "
                + "JOIN Cat c ON a.catID = c.catID "
                + "WHERE c.custID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "GROUP BY a.appointmentID, a.catID "
                + "ORDER BY MIN(a.appointmentDate) DESC, MIN(a.appointmentTime) DESC";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentBean appt = new AppointmentBean();
                    appt.setAppointmentID(rs.getInt("appointmentID"));
                    appt.setAppointmentNo(rs.getString("appointmentNo"));
                    appt.setCatID(rs.getInt("catID"));
                    appt.setAppointmentDate(rs.getDate("appointmentDate"));
                    appt.setAppointmentTime(rs.getString("appointmentTime"));
                    appt.setAppointmentStatus(rs.getString("appointmentStatus"));
                    double weightValue = rs.getDouble("weight");
                    appt.setWeight(rs.wasNull() ? null : weightValue);
                    appt.setTotalAmount(rs.getDouble("totalAmount"));
                    appt.setStaffID(rs.getInt("staffID"));
                    appointments.add(appt);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }

    public int getAnyStaffID() {
        String sql = "SELECT staffID FROM Staff LIMIT 1";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("staffID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 1;
    }

    public List<Integer> getServiceIDsByAppointmentID(int appointmentID) {
        List<Integer> ids = new ArrayList<>();

        String sql = "SELECT a.serviceID "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY categoryOrder, s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("serviceID"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ids;
    }

    public List<AppointmentServiceRow> getServicesByAppointmentID(int appointmentID) {
        List<AppointmentServiceRow> services = new ArrayList<>();

        String sql = "SELECT DISTINCT s.serviceID, s.serviceName, s.category, s.price, "
                + "CASE WHEN UPPER(TRIM(s.category)) = 'MAIN' THEN 1 "
                + "WHEN UPPER(TRIM(s.category)) = 'ADDON' THEN 2 ELSE 3 END AS categoryOrder "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY categoryOrder, s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentServiceRow row = new AppointmentServiceRow();
                    row.serviceID = rs.getInt("serviceID");
                    row.serviceName = rs.getString("serviceName");
                    row.category = rs.getString("category");
                    row.price = rs.getDouble("price");
                    services.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }

    public boolean isSlotAvailable(String appointmentDate, String appointmentTime) {
        Date sqlDate = DateUtil.parseDate(appointmentDate);

        if (sqlDate == null) {
            return false;
        }

        String sql = "SELECT COUNT(*) AS total FROM Appointment "
                + "WHERE CAST(appointmentDate AS DATE) = ? "
                + "AND TO_CHAR(appointmentTime, 'HH24:MI') = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(appointmentStatus)) <> 'CANCELLED'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlDate);
            ps.setString(2, appointmentTime);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total") == 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<AppointmentBean> getAppointmentsByDateRange(String startDate, String endDate) {
        List<AppointmentBean> appointments = new ArrayList<>();

        Date sqlStartDate = DateUtil.parseDate(startDate);
        Date sqlEndDate = DateUtil.parseDate(endDate);

        if (sqlStartDate == null || sqlEndDate == null) {
            return appointments;
        }

        String sql = "SELECT appointmentID, "
                + "'APT-' || TO_CHAR(appointmentDate, 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(appointmentID AS TEXT)) < 4 THEN LPAD(CAST(appointmentID AS TEXT), 4, '0') ELSE CAST(appointmentID AS TEXT) END AS appointmentNo, "
                + "catID, serviceID, appointmentDate, "
                + "TO_CHAR(appointmentTime, 'HH24:MI') AS appointmentTime, "
                + "appointmentStatus, weight, totalAmount, staffID "
                + "FROM Appointment "
                + "WHERE CAST(appointmentDate AS DATE) BETWEEN ? AND ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY appointmentDate DESC, appointmentTime DESC";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlStartDate);
            ps.setDate(2, sqlEndDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentBean appt = new AppointmentBean();
                    appt.setAppointmentID(rs.getInt("appointmentID"));
                    appt.setAppointmentNo(rs.getString("appointmentNo"));
                    appt.setCatID(rs.getInt("catID"));
                    appt.setServiceID(rs.getInt("serviceID"));
                    appt.setAppointmentDate(rs.getDate("appointmentDate"));
                    appt.setAppointmentTime(rs.getString("appointmentTime"));
                    appt.setAppointmentStatus(rs.getString("appointmentStatus"));
                    double weightValue = rs.getDouble("weight");
                    appt.setWeight(rs.wasNull() ? null : weightValue);
                    appt.setTotalAmount(rs.getDouble("totalAmount"));
                    appt.setStaffID(rs.getInt("staffID"));
                    appointments.add(appt);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }
}