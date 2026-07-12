package catBooking.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import catBooking.ConnectionManager;
import catBooking.util.PasswordUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Initializes an empty Heroku PostgreSQL database without requiring the local
 * psql command. The bootstrap is non-destructive and only creates missing
 * database objects.
 *
 * Automatic initialization is enabled when DATABASE_URL is present. Override
 * with DB_AUTO_INIT=true or DB_AUTO_INIT=false.
 */
@WebListener
public class DatabaseBootstrapListener implements ServletContextListener {

    private static final String SCHEMA_RESOURCE = "/db/cloud_schema.sql";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        if (!isInitializationEnabled()) {
            System.out.println("Database auto-initialization is disabled.");
            return;
        }

        try (Connection connection = ConnectionManager.getConnection()) {
            connection.setAutoCommit(false);

            try {
                executeSchema(connection);
                bootstrapOwner(connection);
                connection.commit();
                System.out.println("PostgreSQL cloud schema is ready.");
            } catch (Exception e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (Exception e) {
            throw new IllegalStateException("Unable to initialize the PostgreSQL database.", e);
        }
    }

    private void executeSchema(Connection connection) throws IOException, SQLException {
        for (String sql : loadSqlStatements()) {
            try (Statement statement = connection.createStatement()) {
                statement.execute(sql);
            }
        }
    }

    private List<String> loadSqlStatements() throws IOException {
        InputStream input = DatabaseBootstrapListener.class.getResourceAsStream(SCHEMA_RESOURCE);
        if (input == null) {
            throw new IOException("Database schema resource was not found: " + SCHEMA_RESOURCE);
        }

        StringBuilder sql = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(input, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                    continue;
                }
                sql.append(line).append('\n');
            }
        }

        List<String> statements = new ArrayList<>();
        for (String statement : sql.toString().split(";")) {
            String trimmed = statement.trim();
            if (!trimmed.isEmpty()) {
                statements.add(trimmed);
            }
        }
        return statements;
    }

    private void bootstrapOwner(Connection connection) throws SQLException {
        if (ownerExists(connection)) {
            return;
        }

        String username = env("BOOTSTRAP_OWNER_USERNAME");
        String password = env("BOOTSTRAP_OWNER_PASSWORD");
        String fullName = env("BOOTSTRAP_OWNER_NAME");
        String email = env("BOOTSTRAP_OWNER_EMAIL");

        if (isBlank(username) || isBlank(password) || isBlank(fullName) || isBlank(email)) {
            System.out.println(
                    "No owner account exists. Set BOOTSTRAP_OWNER_USERNAME, BOOTSTRAP_OWNER_PASSWORD, "
                    + "BOOTSTRAP_OWNER_NAME, and BOOTSTRAP_OWNER_EMAIL before the first deployment to create one.");
            return;
        }

        String phone = defaultIfBlank(env("BOOTSTRAP_OWNER_PHONE"), "0000000000");
        String address = defaultIfBlank(env("BOOTSTRAP_OWNER_ADDRESS"), "Pending update");
        String passwordHash = PasswordUtil.hashPassword(password);

        String sql = "INSERT INTO staff "
                + "(staffusername, staffpassword, stafffullname, staffphonenumber, staffemail, "
                + "staffaddress, staffrole, staffprofilephoto, ownerid, staffstatus) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'Owner', NULL, NULL, 'Active')";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username.trim().toLowerCase());
            statement.setString(2, passwordHash);
            statement.setString(3, fullName.trim());
            statement.setString(4, phone.trim());
            statement.setString(5, email.trim().toLowerCase());
            statement.setString(6, address.trim());
            statement.executeUpdate();
        }

        System.out.println("Initial owner account created from BOOTSTRAP_OWNER_* environment variables.");
    }

    private boolean ownerExists(Connection connection) throws SQLException {
        String sql = "SELECT 1 FROM staff WHERE LOWER(TRIM(staffrole)) = 'owner' LIMIT 1";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            return resultSet.next();
        }
    }

    private boolean isInitializationEnabled() {
        String configured = env("DB_AUTO_INIT");
        if (!isBlank(configured)) {
            return Boolean.parseBoolean(configured);
        }
        return !isBlank(System.getenv("DATABASE_URL"));
    }

    private String env(String name) {
        return System.getenv(name);
    }

    private String defaultIfBlank(String value, String defaultValue) {
        return isBlank(value) ? defaultValue : value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
