package Models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class EmpresaDAO {

    private final Connection connection;

    public EmpresaDAO(Connection connection) {
        this.connection = connection;
    }

    public void crearEmpresa(Empresa empresa) throws SQLException {
        String query = "INSERT INTO empresas (razon_social, direccion, telefono, correo, ruc, usuario_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, empresa.getRazonSocial());
            preparedStatement.setString(2, empresa.getDireccion());
            preparedStatement.setString(3, empresa.getTelefono());
            preparedStatement.setString(4, empresa.getCorreo());
            preparedStatement.setString(5, empresa.getRuc());

            if (empresa.getUsuarioId() > 0) {
                preparedStatement.setInt(6, empresa.getUsuarioId());
            } else {
                preparedStatement.setNull(6, java.sql.Types.INTEGER);
            }

            preparedStatement.executeUpdate();
        }
    }

    public Empresa obtenerEmpresaId(int id) throws SQLException {
        String query = "SELECT emp.*,u.nombre as username "
                + "FROM empresas emp left join usuarios u on emp.usuario_id = u.id "
                + "WHERE emp.id = ? ";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new Empresa(
                        resultSet.getInt("id"),
                        resultSet.getString("razon_social"),
                        resultSet.getString("direccion"),
                        resultSet.getString("telefono"),
                        resultSet.getString("correo"),
                        resultSet.getString("ruc"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getString("username")
                );
            }
        }
        return null;
    }

    public Empresa obtenerEmpresaIdUsuario(int id) throws SQLException {
        String query = "SELECT emp.*,u.nombre as username "
                + "FROM empresas emp left join usuarios u on emp.usuario_id = u.id "
                + "WHERE emp.usuario_id = ? ";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new Empresa(
                        resultSet.getInt("id"),
                        resultSet.getString("razon_social"),
                        resultSet.getString("direccion"),
                        resultSet.getString("telefono"),
                        resultSet.getString("correo"),
                        resultSet.getString("ruc"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getString("username")
                );
            }
        }
        return null;
    }

    public List<Empresa> obtenerEmpresas() throws SQLException {
        List<Empresa> empresas = new ArrayList<>();
        String query = "SELECT emp.*,u.nombre as username "
                + "FROM empresas emp left join usuarios u on emp.usuario_id = u.id ";

        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                Empresa empresa = new Empresa(
                        resultSet.getInt("id"),
                        resultSet.getString("razon_social"),
                        resultSet.getString("direccion"),
                        resultSet.getString("telefono"),
                        resultSet.getString("correo"),
                        resultSet.getString("ruc"),
                        resultSet.getInt("usuario_id"),
                        resultSet.getString("username")
                );
                empresas.add(empresa);
            }
        }
        return empresas;
    }

    public List<Empresa> obtenerEmpresasNoAsignadas() throws SQLException {
        List<Empresa> empresas = new ArrayList<>();
        String query = "SELECT * FROM empresas where usuario_id is null";
        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                Empresa empresa = new Empresa(
                        resultSet.getInt("id"),
                        resultSet.getString("razon_social"),
                        resultSet.getString("direccion"),
                        resultSet.getString("telefono"),
                        resultSet.getString("correo"),
                        resultSet.getString("ruc"),
                        resultSet.getInt("usuario_id")
                );
                empresas.add(empresa);
            }
        }
        return empresas;
    }

    public List<Empresa> obtenerEmpresasAsignadas() throws SQLException {
        List<Empresa> empresas = new ArrayList<>();
        String query = "SELECT * FROM empresas where usuario_id is not null";
        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                Empresa empresa = new Empresa(
                        resultSet.getInt("id"),
                        resultSet.getString("razon_social"),
                        resultSet.getString("direccion"),
                        resultSet.getString("telefono"),
                        resultSet.getString("correo"),
                        resultSet.getString("ruc"),
                        resultSet.getInt("usuario_id")
                );
                empresas.add(empresa);
            }
        }
        return empresas;
    }

    public void actualizarEmpresa(Empresa empresa) throws SQLException {
        String query = "UPDATE empresas SET razon_social = ?, direccion = ?, telefono = ?, correo = ?, ruc = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, empresa.getRazonSocial());
            preparedStatement.setString(2, empresa.getDireccion());
            preparedStatement.setString(3, empresa.getTelefono());
            preparedStatement.setString(4, empresa.getCorreo());
            preparedStatement.setString(5, empresa.getRuc());
            preparedStatement.setInt(6, empresa.getId());
            preparedStatement.executeUpdate();
        }
    }

    public void asignarUsuario(int idUsuario, int idEmpresa) throws SQLException {
        String query = "UPDATE empresas SET usuario_id = ? where id = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, idUsuario);
            preparedStatement.setInt(2, idEmpresa);
            preparedStatement.executeUpdate();
        }

    }

    public void eliminarEmpresa(int id) throws SQLException {
        String query = "DELETE FROM empresas WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
        }
    }

    public boolean validarExiste(String campo, String valor) throws SQLException {
        String query = "SELECT COUNT(*) FROM Empresas WHERE " + campo + " = ?";
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

    public boolean validarExisteUnico(String campo, String valor, int idEmpresa) throws SQLException {
        String query = "SELECT COUNT(*) FROM Empresas WHERE " + campo + " = ? AND id != ? ";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, valor);
            preparedStatement.setInt(2, idEmpresa);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}
