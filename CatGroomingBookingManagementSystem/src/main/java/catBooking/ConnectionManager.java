package catBooking;

import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * PostgreSQL connection factory.
 *
 * Local defaults:
 *   DB_URL=jdbc:postgresql://localhost:5432/cat_grooming
 *   DB_USER=postgres
 *   DB_PASSWORD=your_postgres_password
 *
 * Heroku is supported through DATABASE_URL. The postgres:// URL is converted
 * automatically to a JDBC URL, so database credentials are never hard-coded.
 */
public final class ConnectionManager {

    private static final String POSTGRES_DRIVER = "org.postgresql.Driver";

    private ConnectionManager() {
        // Utility class
    }

    static {
        try {
            Class.forName(POSTGRES_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "PostgreSQL JDBC driver not found. Update the Maven project so the PostgreSQL dependency is available.");
        }
    }

    public static Connection getConnection() throws SQLException {
        DatabaseConfig config = resolveConfig();
        return DriverManager.getConnection(config.jdbcUrl, config.username, config.password);
    }

    private static DatabaseConfig resolveConfig() {
        String jdbcUrl = firstNonBlank(
                System.getenv("JDBC_DATABASE_URL"),
                System.getenv("DB_URL"));

        String username = firstNonBlank(
                System.getenv("JDBC_DATABASE_USERNAME"),
                System.getenv("DB_USER"));

        String password = firstNonBlank(
                System.getenv("JDBC_DATABASE_PASSWORD"),
                System.getenv("DB_PASSWORD"));

        if (jdbcUrl != null) {
            if (jdbcUrl.startsWith("postgres://") || jdbcUrl.startsWith("postgresql://")) {
                DatabaseConfig parsed = fromHerokuDatabaseUrl(jdbcUrl);
                return new DatabaseConfig(
                        parsed.jdbcUrl,
                        defaultIfBlank(username, parsed.username),
                        defaultIfBlank(password, parsed.password));
            }

            return new DatabaseConfig(
                    normalizeJdbcUrl(jdbcUrl),
                    defaultIfBlank(username, "postgres"),
                    defaultIfBlank(password, ""));
        }

        String databaseUrl = System.getenv("DATABASE_URL");
        if (databaseUrl != null && !databaseUrl.isBlank()) {
            return fromHerokuDatabaseUrl(databaseUrl.trim());
        }

        return new DatabaseConfig(
                "jdbc:postgresql://localhost:5432/cat_grooming",
                defaultIfBlank(username, "postgres"),
                defaultIfBlank(password, ""));
    }

    private static DatabaseConfig fromHerokuDatabaseUrl(String databaseUrl) {
        try {
            URI uri = URI.create(databaseUrl);

            String rawUserInfo = uri.getRawUserInfo();
            String username = "";
            String password = "";

            if (rawUserInfo != null) {
                String[] credentials = rawUserInfo.split(":", 2);
                username = decode(credentials[0]);
                if (credentials.length > 1) {
                    password = decode(credentials[1]);
                }
            }

            int port = uri.getPort() == -1 ? 5432 : uri.getPort();
            String path = uri.getRawPath();
            String query = uri.getRawQuery();

            StringBuilder jdbc = new StringBuilder("jdbc:postgresql://")
                    .append(uri.getHost())
                    .append(':')
                    .append(port)
                    .append(path == null || path.isBlank() ? "/postgres" : path);

            if (query != null && !query.isBlank()) {
                jdbc.append('?').append(query);
            }

            if (!isLocalHost(uri.getHost()) && !containsSslMode(query)) {
                jdbc.append(query == null || query.isBlank() ? '?' : '&')
                    .append("sslmode=require");
            }

            return new DatabaseConfig(jdbc.toString(), username, password);
        } catch (RuntimeException e) {
            throw new IllegalStateException("Invalid DATABASE_URL for PostgreSQL.", e);
        }
    }

    private static String normalizeJdbcUrl(String url) {
        if (url.startsWith("jdbc:postgresql://")) {
            return url;
        }
        throw new IllegalStateException(
                "DB_URL must start with jdbc:postgresql://, postgres://, or postgresql://");
    }

    private static boolean containsSslMode(String query) {
        return query != null && query.toLowerCase().contains("sslmode=");
    }

    private static boolean isLocalHost(String host) {
        return host == null
                || "localhost".equalsIgnoreCase(host)
                || "127.0.0.1".equals(host)
                || "::1".equals(host);
    }

    private static String decode(String value) {
        return URLDecoder.decode(value, StandardCharsets.UTF_8);
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private static String defaultIfBlank(String value, String defaultValue) {
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }

    private static final class DatabaseConfig {
        private final String jdbcUrl;
        private final String username;
        private final String password;

        private DatabaseConfig(String jdbcUrl, String username, String password) {
            this.jdbcUrl = jdbcUrl;
            this.username = username;
            this.password = password;
        }
    }
}
