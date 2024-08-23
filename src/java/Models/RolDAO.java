/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class RolDAO {

    private final Connection connection;

    public RolDAO(Connection connection) {
        this.connection = connection;
    }

    // Obtener un rol por ID
    public Rol obtenerRolPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Roles WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Rol(
                        rs.getInt("id"),
                        rs.getString("nombre")
                );
            } else {
                return null;
            }
        }
    }

    // Obtener todos los roles
    public List<Rol> obtenerTodosRoles() throws SQLException {
        List<Rol> roles = new ArrayList<Rol>();
        String sql = "SELECT * FROM Roles";
        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                roles.add(new Rol(
                        rs.getInt("id"),
                        rs.getString("nombre")
                ));
            }
        }
        return roles;
    }
    
    
}
