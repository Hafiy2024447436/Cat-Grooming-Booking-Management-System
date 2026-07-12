package catBooking.dao;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.Part;

import catBooking.ConnectionManager;
import catBooking.bean.StaffBean;
import catBooking.util.PasswordUtil;

public class StaffDAO {

    private static final String SELECT_STAFF_LOGIN =
        "SELECT * FROM Staff " +
        "WHERE LOWER(staffUsername) = ? " +
        "AND staffRole != 'Owner' " +
        "AND staffStatus = 'Active'";

    private static final String SELECT_OWNER_LOGIN =
        "SELECT * FROM Staff " +
        "WHERE LOWER(staffUsername) = ? " +
        "AND staffRole = 'Owner' " +
        "AND staffStatus = 'Active'";

    private static final String UPDATE_PASSWORD_ONLY =
        "UPDATE Staff SET staffPassword = ? WHERE staffID = ? AND staffStatus = 'Active'";

    public static StaffBean loginStaff(StaffBean staff) throws SQLException, NoSuchAlgorithmException {
        String inputPassword = staff.getStaffPassword();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_STAFF_LOGIN)) {

            ps.setString(1, staff.getStaffUsername().trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("staffPassword");

                    if (PasswordUtil.checkPassword(inputPassword, storedPassword)) {
                        mapStaff(staff, rs);
                        staff.setLoggedIn(true);

                        // Auto-upgrade old plain password to hashed password after successful login.
                        if (!PasswordUtil.isHashedPassword(storedPassword)) {
                            String upgradedHash = PasswordUtil.hashPassword(inputPassword);
                            updatePasswordOnly(con, staff.getStaffID(), upgradedHash);
                            staff.setStaffPassword(upgradedHash);
                        }
                    } else {
                        staff.setLoggedIn(false);
                    }
                } else {
                    staff.setLoggedIn(false);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            staff.setLoggedIn(false);
        }

        return staff;
    }

    public static StaffBean loginOwner(StaffBean staff) throws SQLException, NoSuchAlgorithmException {
        String inputPassword = staff.getStaffPassword();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_OWNER_LOGIN)) {

            ps.setString(1, staff.getStaffUsername().trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("staffPassword");

                    if (PasswordUtil.checkPassword(inputPassword, storedPassword)) {
                        mapStaff(staff, rs);
                        staff.setLoggedIn(true);

                        // Auto-upgrade old plain password to hashed password after successful login.
                        if (!PasswordUtil.isHashedPassword(storedPassword)) {
                            String upgradedHash = PasswordUtil.hashPassword(inputPassword);
                            updatePasswordOnly(con, staff.getStaffID(), upgradedHash);
                            staff.setStaffPassword(upgradedHash);
                        }
                    } else {
                        staff.setLoggedIn(false);
                    }
                } else {
                    staff.setLoggedIn(false);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            staff.setLoggedIn(false);
        }

        return staff;
    }

    public List<StaffBean> getAllStaff() {
        List<StaffBean> list = new ArrayList<>();

        String sql =
            "SELECT s.staffID, s.staffUsername, s.staffFullName, s.staffEmail, " +
            "s.staffPhoneNumber, s.staffAddress, s.staffRole, s.ownerID, s.staffStatus, " +
            "o.staffFullName AS createdByOwner " +
            "FROM Staff s " +
            "LEFT JOIN Staff o ON s.ownerID = o.staffID " +
            "WHERE s.staffStatus = 'Active' " +
            "ORDER BY s.staffID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffBean s = new StaffBean();

                s.setStaffID(rs.getInt("staffID"));
                s.setStaffUsername(rs.getString("staffUsername"));
                s.setStaffFullName(rs.getString("staffFullName"));
                s.setStaffEmail(rs.getString("staffEmail"));
                s.setStaffPhoneNumber(rs.getString("staffPhoneNumber"));
                s.setStaffAddress(rs.getString("staffAddress"));
                s.setStaffRole(rs.getString("staffRole").toLowerCase());
                s.setOwnerID(rs.getInt("ownerID"));
                s.setStaffStatus(rs.getString("staffStatus"));
                s.setCreatedByOwner(rs.getString("createdByOwner"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public StaffBean getStaffByID(int id) {
        StaffBean staff = null;

        String sql =
            "SELECT staffID, staffUsername, staffFullName, staffEmail, " +
            "staffPhoneNumber, staffAddress, staffRole, staffStatus " +
            "FROM Staff " +
            "WHERE staffID = ? AND staffStatus = 'Active'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff = new StaffBean();

                    staff.setStaffID(rs.getInt("staffID"));
                    staff.setStaffUsername(rs.getString("staffUsername"));
                    staff.setStaffFullName(rs.getString("staffFullName"));
                    staff.setStaffEmail(rs.getString("staffEmail"));
                    staff.setStaffPhoneNumber(rs.getString("staffPhoneNumber"));
                    staff.setStaffAddress(rs.getString("staffAddress"));
                    staff.setStaffRole(rs.getString("staffRole").toLowerCase());
                    staff.setStaffStatus(rs.getString("staffStatus"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staff;
    }

    public int updateStaff(StaffBean staff) {
        return updateStaff(staff, null);
    }

    public int updateStaff(StaffBean staff, Part photoPart) {
        int result = 0;
        boolean updatePassword = staff.getStaffPassword() != null && !staff.getStaffPassword().trim().isEmpty();
        boolean updatePhoto = photoPart != null && photoPart.getSize() > 0;

        StringBuilder sql = new StringBuilder(
            "UPDATE Staff SET staffFullName = ?, staffPhoneNumber = ?, staffEmail = ?, staffAddress = ?"
        );

        if (updatePhoto) {
            sql.append(", staffProfilePhoto = ?");
        }

        if (updatePassword) {
            sql.append(", staffPassword = ?");
        }

        sql.append(" WHERE staffID = ? AND staffStatus = 'Active'");

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setString(index++, staff.getStaffFullName());
            ps.setString(index++, staff.getStaffPhoneNumber());
            ps.setString(index++, staff.getStaffEmail());
            ps.setString(index++, staff.getStaffAddress());

            if (updatePhoto) {
                ps.setBinaryStream(index++, photoPart.getInputStream(), photoPart.getSize());
            }

            if (updatePassword) {
                String passwordToSave = staff.getStaffPassword();

                if (!PasswordUtil.isHashedPassword(passwordToSave)) {
                    passwordToSave = PasswordUtil.hashPassword(passwordToSave);
                }

                ps.setString(index++, passwordToSave);
            }

            ps.setInt(index, staff.getStaffID());

            result = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public boolean hasPendingOrConfirmedAppointments(int staffID) {
        String sql =
            "SELECT 1 FROM Appointment " +
            "WHERE staffID = ? " +
            "AND UPPER(TRIM(appointmentStatus)) IN ('PENDING', 'CONFIRMED') " +
            "AND (recordStatus IS NULL OR UPPER(TRIM(recordStatus)) = 'ACTIVE') " +
            "LIMIT 1";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, staffID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return true;
    }

    public int deleteStaff(int id) {
        int result = 0;

        String sql =
            "UPDATE Staff SET staffStatus = 'Inactive' " +
            "WHERE staffID = ?";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            result = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    private static void updatePasswordOnly(Connection con, int staffID, String hashedPassword) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(UPDATE_PASSWORD_ONLY)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, staffID);
            ps.executeUpdate();
        }
    }

    private static void mapStaff(StaffBean staff, ResultSet rs) throws SQLException {
        staff.setStaffID(rs.getInt("staffID"));
        staff.setOwnerID(rs.getInt("ownerID"));
        staff.setStaffUsername(rs.getString("staffUsername"));
        staff.setStaffPassword(rs.getString("staffPassword"));
        staff.setStaffFullName(rs.getString("staffFullName"));
        staff.setStaffEmail(rs.getString("staffEmail"));
        staff.setStaffPhoneNumber(rs.getString("staffPhoneNumber"));
        staff.setStaffAddress(rs.getString("staffAddress"));
        staff.setStaffRole(rs.getString("staffRole"));
        staff.setStaffStatus(rs.getString("staffStatus"));
    }
}
