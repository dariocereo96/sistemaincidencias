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
public class UsuarioDAO {

    private final Connection connection;

    public UsuarioDAO(Connection connection) {
        this.connection = connection;
    }

    // Crear un nuevo usuario
    public int crearUsuario(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO Usuarios (nombre, correo_electronico, contrasena, rol_id, salt) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getCorreoElectronico());
            stmt.setString(3, usuario.getContrasena()); // Encriptada antes de llamar a este método
            stmt.setInt(4, usuario.getRolId());
            stmt.setString(5, usuario.getSalt());
            stmt.executeUpdate();

            ResultSet generatedKeys = stmt.getGeneratedKeys();

            if (generatedKeys.next()) {
                return (int) generatedKeys.getLong(1);
            }

            return -1;

        }
    }

    // Obtener un usuario por ID
    public Usuario obtenerUsuarioPorId(int id) throws SQLException {
        String sql = "SELECT u.*,r.nombre as nombre_rol "
                + "FROM Usuarios u join Roles r on u.rol_id = r.id "
                + "WHERE u.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("correo_electronico"),
                        rs.getString("contrasena"),
                        rs.getInt("rol_id"),
                        rs.getString("nombre_rol"),
                        "",
                        rs.getString("salt"),
                        Integer.parseInt(rs.getString("estado"))
                );
            } else {
                return null;
            }
        }
    }

    // Obtener un usuario por correo electrónico
    public Usuario obtenerUsuarioPorCorreoOrUsername(String correo) throws SQLException {
        String sql = "SELECT u.*, "
                + "r.nombre as nombre_rol "
                + "FROM Usuarios u join Roles r on u.rol_id = r.id "
                + "WHERE u.correo_electronico = ? OR u.nombre = ? ";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, correo);
            stmt.setString(2, correo);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("correo_electronico"),
                        rs.getString("contrasena"),
                        rs.getInt("rol_id"),
                        rs.getString("nombre_rol"),
                        "",
                        rs.getString("salt"),
                        Integer.parseInt(rs.getString("estado"))
                );
            } else {
                return null;
            }
        }
    }

    // Actualizar un usuario
    public void actualizarUsuario(Usuario usuario) throws SQLException {

        if (!usuario.getContrasena().isEmpty()) {
            String sql = "UPDATE Usuarios SET nombre = ?, correo_electronico = ?, contrasena = ?, rol_id = ?, salt = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, usuario.getNombre());
                stmt.setString(2, usuario.getCorreoElectronico());
                stmt.setString(3, usuario.getContrasena());
                stmt.setInt(4, usuario.getRolId());
                stmt.setString(5, usuario.getSalt());
                stmt.setInt(6, usuario.getId());
                stmt.executeUpdate();
            }
        } else {
            String sql = "UPDATE Usuarios SET nombre = ?, correo_electronico = ?, rol_id = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, usuario.getNombre());
                stmt.setString(2, usuario.getCorreoElectronico());
                stmt.setInt(3, usuario.getRolId());
                stmt.setInt(4, usuario.getId());
                stmt.executeUpdate();
            }
        }

    }

    // Eliminar un usuario
    public void eliminarUsuario(int id) throws SQLException {
        String sql = "DELETE FROM Usuarios WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // Obtener todos los usuarios
    public List<Usuario> obtenerTodosUsuarios() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.*, "
                + "r.nombre as nombre_rol, "
                + "emp.razon_social, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico "
                + "FROM Usuarios u left join Roles r on u.rol_id = r.id "
                + "left join Empresas emp on u.id = emp.usuario_id "
                + "left join Tecnicos tec on u.id = tec.usuario_id";
        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                usuarios.add(new Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("correo_electronico"),
                        rs.getString("contrasena"),
                        rs.getInt("rol_id"),
                        rs.getString("nombre_rol"),
                        rs.getString("nombreTecnico"),
                        rs.getString("salt"),
                        rs.getString("razon_social"),
                        Integer.parseInt(rs.getString("estado"))
                ));
            }
        }
        return usuarios;
    }

    // Obtener todos los usuarios
    public List<Usuario> obtenerTodosUsuariosTecnicos() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT "
                + "u.*, "
                + "r.nombre as nombre_rol, "
                + "concat(t.nombre,' ',t.apellido) as nombreTecnico "
                + "FROM Usuarios u join Roles r on u.rol_id = r.id "
                + "join Tecnicos t on u.id = t.usuario_id "
                + "where r.nombre = 'tecnico'";
        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                usuarios.add(new Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("correo_electronico"),
                        rs.getString("contrasena"),
                        rs.getInt("rol_id"),
                        rs.getString("nombre_rol"),
                        rs.getString("nombreTecnico"),
                        "",
                        Integer.parseInt(rs.getString("estado"))
                ));
            }
        }
        return usuarios;
    }

    public int contarTickets(int id) throws SQLException {
        String sql = "SELECT COUNT(*) as total from Tickets t where t.usuario_id = ? OR t.asignado_a = ? ";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, id);
            stmt.execute();

            ResultSet rs = stmt.executeQuery();
            rs.next();

            return rs.getInt("total");
        }
    }

    public boolean validarExiste(String campo, String valor) throws SQLException {
        String query = "SELECT COUNT(*) FROM Usuarios WHERE " + campo + " = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, valor);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean validarExisteUnico(String campo, String valor, int idTecnico) throws SQLException {
        String query = "SELECT COUNT(*) FROM Usuarios WHERE " + campo + " = ? AND id != ? ";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, valor);
            preparedStatement.setInt(2, idTecnico);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean validarExisteEmpresa(int id) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Empresas WHERE usuario_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("total");
                    return count > 0;
                }
            }
        }
        return false;
    }
    
    public void cambiarEstadoUsuario(int idUsuario,int estado) throws SQLException{
        
        String sql = "Update usuarios set estado = ? where id = ?";
        
        try(PreparedStatement stmt = connection.prepareStatement(sql)){
            stmt.setInt(1, estado);
            stmt.setInt(2, idUsuario);
            stmt.executeUpdate();
        }
    }
}
