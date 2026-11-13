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
        String envUrl = getFirstNonEmptyEnv("JDBC_DATABASE_URL", "DB_URL");

        // 2. Fallback to common cloud database URL formats (Render, Railway, TiDB, Aiven, Heroku)
        String rawDatabaseUrl = getFirstNonEmptyEnv("DATABASE_URL", "MYSQL_URL");
        if (rawDatabaseUrl != null) {
            if (rawDatabaseUrl.startsWith("jdbc:")) {
                envUrl = rawDatabaseUrl;
            }
        }

        String host = getFirstNonEmptyEnv("DB_HOST", "MYSQLHOST");
        if (host == null) host = "mydb";

        String port = getFirstNonEmptyEnv("DB_PORT", "MYSQLPORT");
        if (port == null) port = "3306";

        String dbName = getFirstNonEmptyEnv("DB_NAME", "MYSQLDATABASE");
        if (dbName == null) dbName = "library";

        String user = getFirstNonEmptyEnv("DB_USER", "MYSQLUSER");
        if (user == null) user = "root";

        String password = getFirstNonEmptyEnv("DB_PASSWORD", "MYSQLPASSWORD");
        if (password == null) password = "ayush52141";

        // Parse standard cloud URI (mysql://user:pass@host:port/dbname)
        if (envUrl == null && rawDatabaseUrl != null && rawDatabaseUrl.startsWith("mysql://")) {
            try {
                URI uri = new URI(rawDatabaseUrl);
                if (uri.getHost() != null) host = uri.getHost();
                if (uri.getPort() > 0) port = String.valueOf(uri.getPort());
                if (uri.getPath() != null && uri.getPath().length() > 1) {
                    String cleanPath = uri.getPath().substring(1);
                    if (cleanPath.contains("?")) {
                        cleanPath = cleanPath.substring(0, cleanPath.indexOf("?"));
                    }
                    dbName = cleanPath;
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
            // Enable SSL and trust server cert if connecting to cloud provider (non-local)
            boolean isLocal = "localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host) || "mydb".equalsIgnoreCase(host);
            String sslParam = isLocal ? "useSSL=false" : "useSSL=true&requireSSL=false&trustServerCertificate=true";

            jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName
                    + "?autoReconnect=true&" + sslParam + "&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        try {
            return DriverManager.getConnection(jdbcUrl, user, password);
        } catch (SQLException e) {
            String detailedMsg = "Database connection failed (" + host + ":" + port + "/" + dbName + "): " + e.getMessage();
            if ("mydb".equalsIgnoreCase(host)) {
                detailedMsg += " | Note: Default host 'mydb' only works in local Docker Compose. On Render, set DB_HOST, DB_USER, DB_PASSWORD, DB_NAME (or DATABASE_URL) in Environment settings.";
            }
            System.err.println("DBConnection Error: " + detailedMsg);
            throw new SQLException(detailedMsg, e);
        }
    }

    public static String getFirstNonEmptyEnv(String... keys) {
        if (keys == null) return null;
        for (String key : keys) {
            String val = getEnvOrProperty(key);
            if (val != null && !val.trim().isEmpty()) {
                return val.trim();
            }
        }
        return null;
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
