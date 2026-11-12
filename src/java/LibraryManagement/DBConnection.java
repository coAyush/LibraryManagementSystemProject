package LibraryManagement;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        String envUrl = getEnvOrProperty("JDBC_DATABASE_URL");
        if (envUrl == null) {
            envUrl = getEnvOrProperty("DB_URL");
        }

        String host = getEnvOrDefault("DB_HOST", "mydb");
        String port = getEnvOrDefault("DB_PORT", "3306");
        String dbName = getEnvOrDefault("DB_NAME", "library");
        String user = getEnvOrDefault("DB_USER", "root");
        String password = getEnvOrDefault("DB_PASSWORD", "ayush52141");

        String jdbcUrl;
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            jdbcUrl = envUrl.trim();
        } else {
            jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName
                    + "?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        return DriverManager.getConnection(jdbcUrl, user, password);
    }

    public static String getEnvOrProperty(String key) {
        String val = System.getenv(key);
        if (val == null || val.trim().isEmpty()) {
            val = System.getProperty(key);
        }
        return (val != null && !val.trim().isEmpty()) ? val.trim() : null;
    }

    public static String getEnvOrDefault(String key, String defaultValue) {
        String val = getEnvOrProperty(key);
        return (val != null) ? val : defaultValue;
    }

    public static void closeQuietly(AutoCloseable... closeables) {
        if (closeables == null) {
            return;
        }
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}

