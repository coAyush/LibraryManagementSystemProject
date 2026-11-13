package LibraryManagement;

import java.net.URI;
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
        // 1. Direct JDBC URL override
        String envUrl = getEnvOrProperty("JDBC_DATABASE_URL");
        if (envUrl == null) {
            envUrl = getEnvOrProperty("DB_URL");
        }

        String host = getEnvOrDefault("DB_HOST", "mydb");
        String port = getEnvOrDefault("DB_PORT", "3306");
        String dbName = getEnvOrDefault("DB_NAME", "library");
        String user = getEnvOrDefault("DB_USER", "root");
        String password = getEnvOrDefault("DB_PASSWORD", "ayush52141");

        // 2. Parse standard cloud DATABASE_URL (e.g. Render / Railway format: mysql://user:pass@host:port/dbname)
        String rawDatabaseUrl = getEnvOrProperty("DATABASE_URL");
        if (rawDatabaseUrl != null && rawDatabaseUrl.startsWith("mysql://")) {
            try {
                URI uri = new URI(rawDatabaseUrl);
                if (uri.getHost() != null) host = uri.getHost();
                if (uri.getPort() > 0) port = String.valueOf(uri.getPort());
                if (uri.getPath() != null && uri.getPath().length() > 1) {
                    dbName = uri.getPath().substring(1);
                }
                String userInfo = uri.getUserInfo();
                if (userInfo != null && userInfo.contains(":")) {
                    String[] parts = userInfo.split(":", 2);
                    user = parts[0];
                    password = parts[1];
                }
            } catch (Exception e) {
                System.err.println("Notice: Could not parse DATABASE_URL URI: " + e.getMessage());
            }
        }

        String jdbcUrl;
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            jdbcUrl = envUrl.trim();
            if (!jdbcUrl.startsWith("jdbc:")) {
                jdbcUrl = "jdbc:" + jdbcUrl;
            }
        } else {
            // Enable SSL if connecting to cloud provider (non-local)
            boolean isLocal = "localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host) || "mydb".equalsIgnoreCase(host);
            String sslParam = isLocal ? "useSSL=false" : "useSSL=true&requireSSL=false";

            jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName
                    + "?autoReconnect=true&" + sslParam + "&allowPublicKeyRetrieval=true&serverTimezone=UTC";
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
