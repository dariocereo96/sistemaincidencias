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
public class TecnicoDAO {

    private final Connection connection;

    public TecnicoDAO(Connection connection) {
        this.connection = connection;
    }

    public void registarTecnico(Tecnico tecnico) throws SQLException {
        String query = "INSERT INTO tecnicos (cedula, nombre, apellido, correo, telefono, direccion, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, tecnico.getCedula());
            preparedStatement.setString(2, tecnico.getNombre());
            preparedStatement.setString(3, tecnico.getApellido());
            preparedStatement.setString(4, tecnico.getCorreo());
            preparedStatement.setString(5, tecnico.getTelefono());
            preparedStatement.setString(6, tecnico.getDireccion());
            preparedStatement.setNull(7, java.sql.Types.INTEGER);
            preparedStatement.executeUpdate();
        }
    }

    public void actualizarTecnico(Tecnico tecnico) throws SQLException {
        String query = "UPDATE tecnicos SET cedula = ?, nombre = ?, apellido = ?, correo = ?, direccion = ?, telefono = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, tecnico.getCedula());
            preparedStatement.setString(2, tecnico.getNombre());
            preparedStatement.setString(3, tecnico.getApellido());
            preparedStatement.setString(4, tecnico.getCorreo());
            preparedStatement.setString(5, tecnico.getDireccion());
            preparedStatement.setString(6, tecnico.getTelefono());
            preparedStatement.setInt(7, tecnico.getId());
            preparedStatement.executeUpdate();
        }
    }

    public Tecnico obtenerTecnico(int id) throws SQLException {
        String query = "SELECT * FROM tecnicos WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new Tecnico(
                        resultSet.getInt("id"),
                        resultSet.getString("cedula"),
                        resultSet.getString("nombre"),
                        resultSet.getString("apellido"),
                        resultSet.getString("correo"),
                        resultSet.getString("telefono"),
                        resultSet.getString("direccion"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getInt("estado")
                );
            }
        }
        return null;
    }
    
     public Tecnico obtenerTecnicoIdUsuario(int id) throws SQLException {
        String query = "SELECT * FROM tecnicos WHERE usuario_id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new Tecnico(
                        resultSet.getInt("id"),
                        resultSet.getString("cedula"),
                        resultSet.getString("nombre"),
                        resultSet.getString("apellido"),
                        resultSet.getString("correo"),
                        resultSet.getString("telefono"),
                        resultSet.getString("direccion"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getInt("estado")
                );
            }
        }
        return null;
    }
    
    public List<Tecnico> obtenerTecnicos() throws SQLException {
        List<Tecnico> tecnicos = new ArrayList<>();
        String query = "SELECT t.*,u.nombre as username "
                + "FROM tecnicos t left join usuarios u on t.usuario_id = u.id ";
        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                Tecnico tecnico = new Tecnico(
                        resultSet.getInt("id"),
                        resultSet.getString("cedula"),
                        resultSet.getString("nombre"),
                        resultSet.getString("apellido"),
                        resultSet.getString("correo"),
                        resultSet.getString("telefono"),
                        resultSet.getString("direccion"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getString("username"),
                        resultSet.getInt("estado")
                );
                tecnicos.add(tecnico);
            }
        }
        return tecnicos;
    }

    public List<Tecnico> obtenerTecnicosSinAsignar() throws SQLException {
        List<Tecnico> tecnicos = new ArrayList<>();
        String query = "SELECT * FROM tecnicos where usuario_id is null";
        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                Tecnico tecnico = new Tecnico(
                        resultSet.getInt("id"),
                        resultSet.getString("cedula"),
                        resultSet.getString("nombre"),
                        resultSet.getString("apellido"),
                        resultSet.getString("correo"),
                        resultSet.getString("telefono"),
                        resultSet.getString("direccion"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getInt("estado")
                );
                tecnicos.add(tecnico);
            }
        }
        return tecnicos;
    }

    public void eliminarTecnico(int id) throws SQLException {
        String query = "DELETE FROM tecnicos WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
        }
    }

    public void asignarUsuario(int idUsuario, int idTecnico) throws SQLException {
        String query = "UPDATE tecnicos SET usuario_id = ? where id = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, idUsuario);
            preparedStatement.setInt(2, idTecnico);
            preparedStatement.executeUpdate();
        }

    }

    public int contarTicketsTecnico(int id) throws SQLException {
        String sql = "SELECT COUNT(*) as total from Tickets t where t.asignado_a = ? ";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.execute();

            ResultSet rs = stmt.executeQuery();
            rs.next();

            return rs.getInt("total");
        }
    }

    public boolean validarExiste(String campo, String valor) throws SQLException {
        String query = "SELECT COUNT(*) FROM Tecnicos WHERE " + campo + " = ?";
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
        String query = "SELECT COUNT(*) FROM Tecnicos WHERE " + campo + " = ? AND id != ? ";
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
    
    public void cambiarEstadoTecnico(int idTecnico,int estado) throws SQLException{
        
        String sql = "Update tecnicos set estado = ? where id = ?";
        
        try(PreparedStatement stmt = connection.prepareStatement(sql)){
            stmt.setInt(1, estado);
            stmt.setInt(2, idTecnico);
            stmt.executeUpdate();
        }
    }
}
