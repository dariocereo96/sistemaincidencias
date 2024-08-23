package Configurations;

import java.sql.*;
import java.sql.DriverManager;

/**
 *
 * @author lenovo
 */
public class Conexion {

    private static final String usuario = "root";
    private static final String password = "";
    private static final String db = "incidenciaDB";

    public static Connection getConexion() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, usuario, password);
    }
}
