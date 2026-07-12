package catBooking.dao;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.Part;

import catBooking.ConnectionManager;
import catBooking.bean.CustomerBean;
import catBooking.util.PasswordUtil;

public class CustomerDAO {
    private static final String SELECT_CUST_LOGIN =
        "SELECT * FROM Customer WHERE LOWER(custUsername) = ? AND custStatus = 'Active'";

    private static final String UPDATE_PROFILE_NO_PASSWORD =
        "UPDATE Customer SET custFullName = ?, custPhoneNumber = ?, custEmail = ? " +
        "WHERE custID = ? AND custStatus = 'Active'";

    private static final String UPDATE_PROFILE_WITH_PASSWORD =
        "UPDATE Customer SET custFullName = ?, custPhoneNumber = ?, custEmail = ?, custPassword = ? " +
        "WHERE custID = ? AND custStatus = 'Active'";

    private static final String UPDATE_PASSWORD_ONLY =
        "UPDATE Customer SET custPassword = ? WHERE custID = ? AND custStatus = 'Active'";

    public static CustomerBean loginCust(CustomerBean cust) throws SQLException, NoSuchAlgorithmException {
        String inputPassword = cust.getCustPassword();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_CUST_LOGIN)) {

            ps.setString(1, cust.getCustUsername().trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("custPassword");

                    if (PasswordUtil.checkPassword(inputPassword, storedPassword)) {
                        mapCustomer(cust, rs);
                        cust.setLoggedIn(true);

                        // Auto-upgrade old plain password to hashed password after successful login.
                        if (!PasswordUtil.isHashedPassword(storedPassword)) {
                            String upgradedHash = PasswordUtil.hashPassword(inputPassword);
                            updatePasswordOnly(con, cust.getCustID(), upgradedHash);
                            cust.setCustPassword(upgradedHash);
                        }
                    } else {
                        cust.setLoggedIn(false);
                    }
                } else {
                    cust.setLoggedIn(false);
                }
            }
        }

        return cust;
    }

    public static boolean updateProfile(CustomerBean cust, boolean changePassword) throws SQLException {
        return updateProfile(cust, changePassword, null, false);
    }

    public static boolean updateProfile(CustomerBean cust, boolean changePassword, Part photoPart, boolean removePhoto) throws SQLException {
        if (cust == null || cust.getCustID() <= 0) {
            return false;
        }

        boolean hasNewPhoto = photoPart != null && photoPart.getSize() > 0;

        StringBuilder sql = new StringBuilder(
            "UPDATE Customer SET custFullName = ?, custPhoneNumber = ?, custEmail = ?"
        );

        if (changePassword) {
            sql.append(", custPassword = ?");
        }

        if (hasNewPhoto || removePhoto) {
            sql.append(", custProfilePhoto = ?");
        }

        sql.append(" WHERE custID = ? AND custStatus = 'Active'");

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setString(index++, cust.getCustFullName());
            ps.setString(index++, cust.getCustPhoneNumber());
            ps.setString(index++, cust.getCustEmail());

            if (changePassword) {
                String passwordToSave = cust.getCustPassword();

                if (!PasswordUtil.isHashedPassword(passwordToSave)) {
                    passwordToSave = PasswordUtil.hashPassword(passwordToSave);
                }

                ps.setString(index++, passwordToSave);
            }

            if (hasNewPhoto) {
                try {
                    ps.setBinaryStream(index++, photoPart.getInputStream(), photoPart.getSize());
                } catch (IOException e) {
                    throw new SQLException("Unable to read uploaded customer photo.", e);
                }
            } else if (removePhoto) {
                ps.setNull(index++, Types.BINARY);
            }

            ps.setInt(index, cust.getCustID());

            return ps.executeUpdate() > 0;
        }
    }

    // Kept for old code that still calls CustomerDAO.updateProfile(cust).
    public static boolean updateProfile(CustomerBean cust) throws SQLException {
        return updateProfile(cust, true);
    }

    public static CustomerBean getCustomerByID(int id) {
        CustomerBean cust = null;

        String sql =
            "SELECT custID, custUsername, custPassword, custFullName, custEmail, custPhoneNumber, custStatus " +
            "FROM Customer WHERE custID = ? AND custStatus = 'Active'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cust = new CustomerBean();
                    mapCustomer(cust, rs);
                    cust.setLoggedIn(true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cust;
    }

    public int updateCustomer(CustomerBean cust) {
        int result = 0;

        String sql =
            "UPDATE Customer SET custFullName = ?, custPhoneNumber = ?, custEmail = ? " +
            "WHERE custID = ? AND custStatus = 'Active'";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, cust.getCustFullName());
            ps.setString(2, cust.getCustPhoneNumber());
            ps.setString(3, cust.getCustEmail());
            ps.setInt(4, cust.getCustID());

            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public List<CustomerBean> getAllCustomers() {
        List<CustomerBean> list = new ArrayList<>();

        String sql =
            "SELECT custID, custUsername, custFullName, custEmail, custPhoneNumber, custStatus " +
            "FROM Customer WHERE custStatus = 'Active' ORDER BY custID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CustomerBean c = new CustomerBean();
                c.setCustID(rs.getInt("custID"));
                c.setCustUsername(rs.getString("custUsername"));
                c.setCustFullName(rs.getString("custFullName"));
                c.setCustEmail(rs.getString("custEmail"));
                c.setCustPhoneNumber(rs.getString("custPhoneNumber"));
                c.setCustStatus(rs.getString("custStatus"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int deleteCustomer(int id) {
        int result = 0;

        String updateCustomerSql =
            "UPDATE Customer " +
            "SET custStatus = 'Inactive' " +
            "WHERE custID = ? " +
            "AND UPPER(TRIM(COALESCE(custStatus, 'Active'))) = 'ACTIVE'";

        String updateCatsSql =
            "UPDATE Cat " +
            "SET catStatus = 'Inactive' " +
            "WHERE custID = ? " +
            "AND UPPER(TRIM(COALESCE(catStatus, 'Active'))) = 'ACTIVE'";

        try (Connection con = ConnectionManager.getConnection()) {
            boolean originalAutoCommit = con.getAutoCommit();

            try {
                con.setAutoCommit(false);

                try (PreparedStatement psCustomer = con.prepareStatement(updateCustomerSql)) {
                    psCustomer.setInt(1, id);
                    result = psCustomer.executeUpdate();
                }

                if (result > 0) {
                    try (PreparedStatement psCats = con.prepareStatement(updateCatsSql)) {
                        psCats.setInt(1, id);
                        psCats.executeUpdate();
                    }
                }

                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    private static void updatePasswordOnly(Connection con, int custID, String hashedPassword) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(UPDATE_PASSWORD_ONLY)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, custID);
            ps.executeUpdate();
        }
    }

    private static void mapCustomer(CustomerBean cust, ResultSet rs) throws SQLException {
        cust.setCustID(rs.getInt("custID"));
        cust.setCustUsername(rs.getString("custUsername"));
        cust.setCustPassword(rs.getString("custPassword"));
        cust.setCustFullName(rs.getString("custFullName"));
        cust.setCustPhoneNumber(rs.getString("custPhoneNumber"));
        cust.setCustEmail(rs.getString("custEmail"));
        cust.setCustStatus(rs.getString("custStatus"));
    }
}
