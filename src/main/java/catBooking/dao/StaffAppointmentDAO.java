package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.util.DateUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class StaffAppointmentDAO {

    public static class AppointmentRow {
        public int appointmentID;
        public String appointmentNo;
        public String appointmentDate;
        public String appointmentTime;
        public String customerName;
        public String appointmentStatus;
        public Double weight;
        public double totalAmount;
    }

    public List<AppointmentRow> getAllAppointmentsWithCustomer() {
        List<AppointmentRow> list = new ArrayList<>();

        String sql = "SELECT a.appointmentID, "
                + "'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "TO_CHAR(MIN(a.appointmentDate), 'DD-MON-YYYY') AS appointmentDate, "
                + "TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(cu.custFullName) AS custFullName, "
                + "MIN(a.appointmentStatus) AS appointmentStatus, "
                + "MAX(NULLIF(a.weight, 0)) AS weight, "
                + "SUM(a.totalAmount) AS totalAmount "
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
                AppointmentRow row = new AppointmentRow();
                row.appointmentID = rs.getInt("appointmentID");
                row.appointmentNo = rs.getString("appointmentNo");
                row.appointmentDate = rs.getString("appointmentDate");
                row.appointmentTime = rs.getString("appointmentTime");
                row.customerName = rs.getString("custFullName");
                row.appointmentStatus = rs.getString("appointmentStatus");
                double weightValue = rs.getDouble("weight");
                row.weight = rs.wasNull() ? null : weightValue;
                row.totalAmount = rs.getDouble("totalAmount");
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static class AppointmentEditRow {
        public int appointmentID;
        public String appointmentNo;
        public String customerName;
        public String catName;
        public String conditionNotes;
        public String appointmentDate;
        public String appointmentDateISO;
        public String appointmentTime;
        public String appointmentStatus;
        public List<String> serviceNames = new ArrayList<>();
        public List<String> mainServiceNames = new ArrayList<>();
        public List<String> addOnServiceNames = new ArrayList<>();
        public Double weight;
        public double totalAmount;
    }

    public AppointmentEditRow getAppointmentForEdit(int appointmentID) {
        AppointmentEditRow row = null;

        String sql = "SELECT a.appointmentID, "
                + "'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "TO_CHAR(MIN(a.appointmentDate), 'DD-MON-YYYY') AS appointmentDate, "
                + "TO_CHAR(MIN(a.appointmentDate), 'YYYY-MM-DD') AS appointmentDateISO, "
                + "TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(a.appointmentStatus) AS appointmentStatus, "
                + "MAX(NULLIF(a.weight, 0)) AS weight, "
                + "SUM(a.totalAmount) AS totalAmount, "
                + "MIN(c.catName) AS catName, "
                + "MIN(c.conditionNotes) AS conditionNotes, "
                + "MIN(cu.custFullName) AS custFullName "
                + "FROM Appointment a "
                + "JOIN Cat c ON a.catID = c.catID "
                + "JOIN Customer cu ON c.custID = cu.custID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "GROUP BY a.appointmentID";

        String sqlServices = "SELECT s.serviceName, s.category "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY CASE UPPER(s.category) "
                + "WHEN 'MAIN' THEN 1 "
                + "WHEN 'ADDON' THEN 2 "
                + "ELSE 3 END, s.serviceName";

        try (Connection con = ConnectionManager.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, appointmentID);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        row = new AppointmentEditRow();
                        row.appointmentID = rs.getInt("appointmentID");
                        row.appointmentNo = rs.getString("appointmentNo");
                        row.appointmentDate = rs.getString("appointmentDate");
                        row.appointmentDateISO = rs.getString("appointmentDateISO");
                        row.appointmentTime = rs.getString("appointmentTime");
                        row.appointmentStatus = rs.getString("appointmentStatus");
                        double weightValue = rs.getDouble("weight");
                        row.weight = rs.wasNull() ? null : weightValue;
                        row.totalAmount = rs.getDouble("totalAmount");
                        row.catName = rs.getString("catName");
                        row.conditionNotes = rs.getString("conditionNotes");
                        row.customerName = rs.getString("custFullName");
                    }
                }
            }

            if (row != null) {
                try (PreparedStatement ps2 = con.prepareStatement(sqlServices)) {
                    ps2.setInt(1, appointmentID);

                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            String serviceName = rs2.getString("serviceName");
                            String category = normalizeCategory(rs2.getString("category"));

                            row.serviceNames.add(serviceName);

                            if ("MAIN".equals(category)) {
                                row.mainServiceNames.add(serviceName);
                            } else if ("ADDON".equals(category)) {
                                row.addOnServiceNames.add(serviceName);
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return row;
    }

    public static class ServiceDetail {
        public String serviceName;
        public String category;
        public String description;
        public double price;
    }

    public static class AppointmentViewRow {
        public int appointmentID;
        public String appointmentNo;
        public String custFullName;
        public String custEmail;
        public String custPhoneNumber;
        public String appointmentDate;
        public String appointmentTime;
        public String appointmentStatus;
        public List<String> catNames = new ArrayList<>();
        public List<ServiceDetail> services = new ArrayList<>();
        public List<ServiceDetail> mainServices = new ArrayList<>();
        public List<ServiceDetail> addOnServices = new ArrayList<>();
        public Double weight;
        public double totalAmount;
    }

    public AppointmentViewRow getAppointmentForView(int appointmentID) {
        AppointmentViewRow row = null;

        String sql = "SELECT a.appointmentID, "
                + "'APT-' || TO_CHAR(a.appointmentDate, 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "TO_CHAR(a.appointmentDate, 'DD-MON-YYYY') AS appointmentDate, "
                + "TO_CHAR(a.appointmentTime, 'HH24:MI') AS appointmentTime, "
                + "a.appointmentStatus, "
                + "NULLIF(a.weight, 0) AS weight, "
                + "c.catName, s.serviceName, s.category, s.description, s.price AS svcPrice, "
                + "cu.custFullName, cu.custEmail, cu.custPhoneNumber "
                + "FROM Appointment a "
                + "JOIN Cat c ON a.catID = c.catID "
                + "JOIN Customer cu ON c.custID = cu.custID "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY CASE UPPER(s.category) "
                + "WHEN 'MAIN' THEN 1 "
                + "WHEN 'ADDON' THEN 2 "
                + "ELSE 3 END, s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (row == null) {
                        row = new AppointmentViewRow();
                        row.appointmentID = rs.getInt("appointmentID");
                        row.appointmentNo = rs.getString("appointmentNo");
                        row.appointmentDate = rs.getString("appointmentDate");
                        row.appointmentTime = rs.getString("appointmentTime");
                        row.appointmentStatus = rs.getString("appointmentStatus");
                        double weightValue = rs.getDouble("weight");
                        row.weight = rs.wasNull() ? null : weightValue;
                        row.custFullName = rs.getString("custFullName");
                        row.custEmail = rs.getString("custEmail");
                        row.custPhoneNumber = rs.getString("custPhoneNumber");
                    }

                    String catName = rs.getString("catName");

                    if (catName != null && !row.catNames.contains(catName)) {
                        row.catNames.add(catName);
                    }

                    ServiceDetail svc = new ServiceDetail();
                    svc.serviceName = rs.getString("serviceName");
                    svc.category = normalizeCategory(rs.getString("category"));
                    svc.description = rs.getString("description");
                    svc.price = rs.getDouble("svcPrice");

                    row.services.add(svc);

                    if ("MAIN".equals(svc.category)) {
                        row.mainServices.add(svc);
                    } else if ("ADDON".equals(svc.category)) {
                        row.addOnServices.add(svc);
                    }

                    row.totalAmount += svc.price;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return row;
    }

    public boolean updateAppointment(int appointmentID, String date, String time, String status) {
        Date sqlDate = parseAppointmentDate(date);

        if (sqlDate == null) {
            return false;
        }

        time = normalizeTimeToHH24MI(time);
        status = normalizeStatus(status);

        String sql = "UPDATE Appointment "
                + "SET appointmentDate = ?, "
                + "appointmentTime = CAST(? AS TIME), "
                + "appointmentStatus = ? "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlDate);
            ps.setString(2, time);
            ps.setString(3, status);
            ps.setInt(4, appointmentID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Integer> getServiceIDsByAppointmentID(int appointmentID) {
        List<Integer> ids = new ArrayList<>();

        String sql = "SELECT a.serviceID "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY CASE UPPER(s.category) "
                + "WHEN 'MAIN' THEN 1 "
                + "WHEN 'ADDON' THEN 2 "
                + "ELSE 3 END, s.serviceName";

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

    public List<Integer> getServiceIDsByAppointmentIDAndCategory(int appointmentID, String category) {
        List<Integer> ids = new ArrayList<>();

        String sql = "SELECT a.serviceID "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(s.category) = ? "
                + "ORDER BY s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);
            ps.setString(2, normalizeCategory(category));

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


    public List<String> getBookedTimesByDateForEdit(String appointmentDate, int appointmentID) {
        List<String> bookedTimes = new ArrayList<>();
        Date sqlDate = parseAppointmentDate(appointmentDate);

        if (sqlDate == null) {
            return bookedTimes;
        }

        String sql = "SELECT DISTINCT TO_CHAR(appointmentTime, 'HH24:MI') AS appointmentTime "
                + "FROM Appointment "
                + "WHERE CAST(appointmentDate AS DATE) = ? "
                + "AND appointmentID <> ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(appointmentStatus)) <> 'CANCELLED'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlDate);
            ps.setInt(2, appointmentID);

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

    public boolean isTimeAvailableForEdit(int appointmentID, String appointmentDate, String appointmentTime) {
        Date sqlDate = parseAppointmentDate(appointmentDate);

        if (sqlDate == null || appointmentTime == null || appointmentTime.trim().isEmpty()) {
            return false;
        }

        String normalizedTime = normalizeTimeToHH24MI(appointmentTime);

        String sql = "SELECT COUNT(*) AS totalBooked "
                + "FROM Appointment "
                + "WHERE CAST(appointmentDate AS DATE) = ? "
                + "AND TO_CHAR(appointmentTime, 'HH24:MI') = ? "
                + "AND appointmentID <> ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                + "AND UPPER(TRIM(appointmentStatus)) <> 'CANCELLED'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, sqlDate);
            ps.setString(2, normalizedTime);
            ps.setInt(3, appointmentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalBooked") == 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAppointmentFull(int appointmentID, String date, String time,
                                         String status, String serviceIDsCsv, double totalAmount) {
        Date sqlDate = parseAppointmentDate(date);

        if (sqlDate == null) {
            return false;
        }

        if (serviceIDsCsv == null || serviceIDsCsv.trim().isEmpty()) {
            return false;
        }

        time = normalizeTimeToHH24MI(time);
        status = normalizeStatus(status);

        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            int catID = 0;
            int staffID = 0;

            String getInfoSql = "SELECT catID, staffID "
                    + "FROM Appointment "
                    + "WHERE appointmentID = ? "
                    + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE' "
                    + "LIMIT 1";

            try (PreparedStatement ps = con.prepareStatement(getInfoSql)) {
                ps.setInt(1, appointmentID);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        catID = rs.getInt("catID");
                        staffID = rs.getInt("staffID");
                    }
                }
            }

            if (catID == 0 || staffID == 0) {
                con.rollback();
                return false;
            }

            String deleteSql = "DELETE FROM Appointment WHERE appointmentID = ?";

            try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.setInt(1, appointmentID);
                ps.executeUpdate();
            }

            String insertSql = "INSERT INTO Appointment "
                    + "(appointmentID, catID, serviceID, appointmentDate, appointmentTime, "
                    + "appointmentStatus, weight, totalAmount, staffID, recordStatus) "
                    + "VALUES (?, ?, ?, ?, "
                    + "CAST(? AS TIME), ?, ?, ?, ?, 'Active')";

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                String[] serviceIDs = serviceIDsCsv.split(",");
                int insertedCount = 0;

                for (String rawId : serviceIDs) {
                    if (rawId == null || rawId.trim().isEmpty()) {
                        continue;
                    }

                    int svcID = Integer.parseInt(rawId.trim());
                    double servicePrice = getServicePrice(con, svcID);

                    if (servicePrice < 0) {
                        con.rollback();
                        return false;
                    }

                    ps.setInt(1, appointmentID);
                    ps.setInt(2, catID);
                    ps.setInt(3, svcID);
                    ps.setDate(4, sqlDate);
                    ps.setString(5, time);
                    ps.setString(6, status);
                    ps.setNull(7, Types.NUMERIC);
                    ps.setDouble(8, servicePrice);
                    ps.setInt(9, staffID);

                    ps.addBatch();
                    insertedCount++;
                }

                if (insertedCount == 0) {
                    con.rollback();
                    return false;
                }

                ps.executeBatch();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

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

    public boolean deleteAppointment(int appointmentID) {
        String sql = "UPDATE Appointment SET recordStatus = 'Inactive' "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    public static class StaffOption {
        public int staffID;
        public String staffFullName;
    }

    public List<StaffOption> getAssignableStaffList() {
        List<StaffOption> list = new ArrayList<>();

        String sql = "SELECT staffID, staffFullName "
                + "FROM Staff "
                + "WHERE staffStatus = 'Active' "
                + "AND ownerID IS NOT NULL "
                + "AND COALESCE(UPPER(staffRole), 'STAFF') <> 'OWNER' "
                + "ORDER BY staffFullName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffOption staff = new StaffOption();
                staff.staffID = rs.getInt("staffID");
                staff.staffFullName = rs.getString("staffFullName");
                list.add(staff);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static class ConfirmBookingRow {
        public int appointmentID;
        public String appointmentNo;
        public String appointmentDate;
        public String appointmentTime;
        public String appointmentStatus;
        public String customerName;
        public String customerPhone;
        public String customerEmail;
        public String catName;
        public String breedName;
        public String conditionNotes;
        public List<String> serviceNames = new ArrayList<>();
        public List<String> mainServiceNames = new ArrayList<>();
        public List<String> addOnServiceNames = new ArrayList<>();
        public Double weight;
        public double totalAmount;
    }

    public List<ConfirmBookingRow> getAppointmentsForConfirmation() {
        List<ConfirmBookingRow> list = new ArrayList<>();

        String sql = "SELECT a.appointmentID, "
                + "'APT-' || TO_CHAR(MIN(a.appointmentDate), 'YYMMDD') || '-' || CASE WHEN LENGTH(CAST(a.appointmentID AS TEXT)) < 4 THEN LPAD(CAST(a.appointmentID AS TEXT), 4, '0') ELSE CAST(a.appointmentID AS TEXT) END AS appointmentNo, "
                + "TO_CHAR(MIN(a.appointmentDate), 'DD-MON-YYYY') AS appointmentDate, "
                + "TO_CHAR(MIN(a.appointmentTime), 'HH24:MI') AS appointmentTime, "
                + "MIN(a.appointmentStatus) AS appointmentStatus, "
                + "MIN(cu.custFullName) AS custFullName, "
                + "MIN(cu.custPhoneNumber) AS custPhoneNumber, "
                + "MIN(cu.custEmail) AS custEmail, "
                + "MIN(c.catName) AS catName, "
                + "MIN(b.breedName) AS breedName, "
                + "MIN(c.conditionNotes) AS conditionNotes, "
                + "MAX(NULLIF(a.weight, 0)) AS weight, "
                + "SUM(a.totalAmount) AS totalAmount "
                + "FROM Appointment a "
                + "JOIN Cat c ON a.catID = c.catID "
                + "JOIN Customer cu ON c.custID = cu.custID "
                + "LEFT JOIN Breed b ON c.breedID = b.breedID "
                + "WHERE UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "GROUP BY a.appointmentID "
                + "ORDER BY MIN(a.appointmentDate) DESC, MIN(a.appointmentTime) DESC";

        String serviceSql = "SELECT s.serviceName, s.category "
                + "FROM Appointment a "
                + "JOIN Service s ON a.serviceID = s.serviceID "
                + "WHERE a.appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(a.recordStatus, 'Active'))) = 'ACTIVE' "
                + "ORDER BY CASE UPPER(s.category) "
                + "WHEN 'MAIN' THEN 1 "
                + "WHEN 'ADDON' THEN 2 "
                + "ELSE 3 END, s.serviceName";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ConfirmBookingRow row = new ConfirmBookingRow();

                row.appointmentID = rs.getInt("appointmentID");
                row.appointmentNo = rs.getString("appointmentNo");
                row.appointmentDate = rs.getString("appointmentDate");
                row.appointmentTime = rs.getString("appointmentTime");
                row.appointmentStatus = rs.getString("appointmentStatus");
                row.customerName = rs.getString("custFullName");
                row.customerPhone = rs.getString("custPhoneNumber");
                row.customerEmail = rs.getString("custEmail");
                row.catName = rs.getString("catName");
                row.breedName = rs.getString("breedName");
                row.conditionNotes = rs.getString("conditionNotes");
                double weightValue = rs.getDouble("weight");
                row.weight = rs.wasNull() ? null : weightValue;
                row.totalAmount = rs.getDouble("totalAmount");

                try (PreparedStatement servicePs = con.prepareStatement(serviceSql)) {
                    servicePs.setInt(1, row.appointmentID);

                    try (ResultSet serviceRs = servicePs.executeQuery()) {
                        while (serviceRs.next()) {
                            String serviceName = serviceRs.getString("serviceName");
                            String category = normalizeCategory(serviceRs.getString("category"));

                            row.serviceNames.add(serviceName);

                            if ("MAIN".equals(category)) {
                                row.mainServiceNames.add(serviceName);
                            } else if ("ADDON".equals(category)) {
                                row.addOnServiceNames.add(serviceName);
                            }
                        }
                    }
                }

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean updateAppointmentStatusAndStaff(int appointmentID, String status, int staffID) {
        String sql = "UPDATE Appointment SET appointmentStatus = ?, staffID = ? "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normalizeStatus(status));
            ps.setInt(2, staffID);
            ps.setInt(3, appointmentID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAppointmentStatus(int appointmentID, String status) {
        return updateAppointmentStatus(appointmentID, status, null);
    }

    public boolean updateAppointmentStatus(int appointmentID, String status, Double weight) {
        String normalizedStatus = normalizeStatus(status);

        if ("Completed".equals(normalizedStatus) && (weight == null || weight <= 0)) {
            return false;
        }

        String sql = "UPDATE Appointment SET appointmentStatus = ?, "
                + "weight = CASE WHEN ? = 'Completed' THEN ? ELSE weight END "
                + "WHERE appointmentID = ? "
                + "AND UPPER(TRIM(COALESCE(recordStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normalizedStatus);
            ps.setString(2, normalizedStatus);

            if ("Completed".equals(normalizedStatus)) {
                ps.setDouble(3, weight);
            } else {
                ps.setNull(3, Types.NUMERIC);
            }

            ps.setInt(4, appointmentID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    private Date parseAppointmentDate(String date) {
        if (date == null || date.trim().isEmpty()) {
            return null;
        }

        String value = date.trim();

        try {
            if (value.matches("\\d{4}-\\d{2}-\\d{2}")) {
                return Date.valueOf(value);
            }
        } catch (Exception ignored) {
            // Fallback to DD-MON-YYYY parser below.
        }

        return DateUtil.parseDate(value);
    }

    private String normalizeCategory(String category) {
        if (category == null) {
            return "";
        }

        return category.trim().toUpperCase();
    }

    private String normalizeStatus(String status) {
        if (status == null) {
            return "Pending";
        }

        String s = status.trim().toLowerCase();

        switch (s) {
            case "confirmed":
                return "Confirmed";
            case "completed":
                return "Completed";
            case "cancelled":
                return "Cancelled";
            default:
                return "Pending";
        }
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

            java.time.format.DateTimeFormatter inputFormatter =
                    java.time.format.DateTimeFormatter.ofPattern("h:mm a");

            java.time.format.DateTimeFormatter outputFormatter =
                    java.time.format.DateTimeFormatter.ofPattern("HH:mm");

            return java.time.LocalTime.parse(value, inputFormatter).format(outputFormatter);

        } catch (Exception e) {
            e.printStackTrace();
            return value;
        }
    }
}