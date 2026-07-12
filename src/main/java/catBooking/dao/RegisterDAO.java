package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.CustomerBean;
import catBooking.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisterDAO {

    // 1. CHECK IF USERNAME EXISTS
    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT custUsername "
                   + "FROM Customer "
                   + "WHERE LOWER(custUsername) = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // 2. CHECK IF EMAIL EXISTS
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT custEmail "
                   + "FROM Customer "
                   + "WHERE LOWER(custEmail) = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // 3. REGISTER NEW CUSTOMER
    public boolean registerCustomer(CustomerBean customer) throws SQLException {
        String sql = "INSERT INTO Customer (custId, custUsername, custPassword, " +
                     "custFullName, custPhoneNumber, custEmail, custProfilePhoto) " +
                     "VALUES (nextval('custid_seq'), ?, ?, ?, ?, ?, NULL)";

        String passwordToSave = customer.getCustPassword();

        if (!PasswordUtil.isHashedPassword(passwordToSave)) {
            passwordToSave = PasswordUtil.hashPassword(passwordToSave);
        }

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getCustUsername().trim().toLowerCase());
            ps.setString(2, passwordToSave);
            ps.setString(3, customer.getCustFullName());
            ps.setString(4, customer.getCustPhoneNumber());
            ps.setString(5, customer.getCustEmail().trim().toLowerCase());

            return ps.executeUpdate() > 0;
        }
    }
}
