package lumin.model;
import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:derby://localhost:1527/LuminDB";
    private static final String USER = "Lumin";
    private static final String PASS = "Lumin123";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
