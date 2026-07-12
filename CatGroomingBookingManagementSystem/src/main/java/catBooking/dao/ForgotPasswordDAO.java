package catBooking.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import catBooking.ConnectionManager;

public class ForgotPasswordDAO {

    public boolean emailExists(String role, String email) throws SQLException {
        String sql = getEmailCheckSql(role);

        if (sql == null || email == null || email.trim().isEmpty()) {
            return false;
        }

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean updatePassword(String role, String email, String hashedPassword) throws SQLException {
        String sql = getPasswordUpdateSql(role);

        if (sql == null || email == null || email.trim().isEmpty()
                || hashedPassword == null || hashedPassword.trim().isEmpty()) {
            return false;
        }

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setString(2, email.trim().toLowerCase());

            return ps.executeUpdate() > 0;
        }
    }

    private String getEmailCheckSql(String role) {
        if (role == null) {
            return null;
        }

        switch (role.toLowerCase()) {
            case "customer":
                return "SELECT custID FROM Customer "
                     + "WHERE LOWER(custEmail) = ? "
                     + "AND custStatus = 'Active'";

            case "staff":
                return "SELECT staffID FROM Staff "
                     + "WHERE LOWER(staffEmail) = ? "
                     + "AND LOWER(staffRole) <> 'owner' "
                     + "AND staffStatus = 'Active'";

            case "owner":
                return "SELECT staffID FROM Staff "
                     + "WHERE LOWER(staffEmail) = ? "
                     + "AND LOWER(staffRole) = 'owner' "
                     + "AND staffStatus = 'Active'";

            default:
                return null;
        }
    }

    private String getPasswordUpdateSql(String role) {
        if (role == null) {
            return null;
        }

        switch (role.toLowerCase()) {
            case "customer":
                return "UPDATE Customer SET custPassword = ? "
                     + "WHERE LOWER(custEmail) = ? "
                     + "AND custStatus = 'Active'";

            case "staff":
                return "UPDATE Staff SET staffPassword = ? "
                     + "WHERE LOWER(staffEmail) = ? "
                     + "AND LOWER(staffRole) <> 'owner' "
                     + "AND staffStatus = 'Active'";

            case "owner":
                return "UPDATE Staff SET staffPassword = ? "
                     + "WHERE LOWER(staffEmail) = ? "
                     + "AND LOWER(staffRole) = 'owner' "
                     + "AND staffStatus = 'Active'";

            default:
                return null;
        }
    }
}
