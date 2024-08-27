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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class TicketDAO {

    private final Connection connection;

    public TicketDAO(Connection connection) {
        this.connection = connection;
    }

    // Crear un nuevo ticket
    public void crearTicket(Ticket ticket) throws SQLException {
        String sql = "INSERT INTO Tickets (titulo, descripcion, tipo_id, prioridad, estado, usuario_id, lugar, encargado, subtipo_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, ticket.getTitulo());
            preparedStatement.setString(2, ticket.getDescripcion());
            preparedStatement.setInt(3, ticket.getTipoId());
            preparedStatement.setString(4, ticket.getPrioridad());
            preparedStatement.setString(5, ticket.getEstado());
            preparedStatement.setInt(6, ticket.getIdUsuario());
            preparedStatement.setString(7, ticket.getLugar());
            preparedStatement.setString(8, ticket.getEncargado());
            preparedStatement.setInt(9, ticket.getIdSupTipo());
            preparedStatement.executeUpdate();
        }
    }

    // Método para obtener un ticket por ID
    public Ticket obtenerTicketId(int id) throws SQLException {
        Ticket ticket = null;
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "WHERE t.id = ? ";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ticket = new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                );
            }
        }
        return ticket;
    }

    // Método para eliminar un ticket por ID
    public void eliminarTicket(int id) throws SQLException {
        String sql = "DELETE FROM Tickets WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // Método para actualizar un ticket
    public void actualizarTicket(Ticket ticket) throws SQLException {

        String sql = "UPDATE Tickets SET titulo = ?, descripcion = ?, tipo_id = ?, prioridad = ?, lugar = ?, encargado = ?, subtipo_id = ? WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, ticket.getTitulo());
            stmt.setString(2, ticket.getDescripcion());
            stmt.setInt(3, ticket.getTipoId());
            stmt.setString(4, ticket.getPrioridad());
            stmt.setString(5, ticket.getLugar());
            stmt.setString(6, ticket.getEncargado());
            stmt.setInt(7, ticket.getIdSupTipo());
            stmt.setInt(8, ticket.getId());
            stmt.executeUpdate();
        }
    }

    // Método para obtener todos los tickets pendientes
    public List<Ticket> obtenerTodosTicketsPendientes() throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'abierto' "
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets pendientes
    public List<Ticket> obtenerTodosTicketsPendientesByTipo(int tipo) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'abierto' AND t.tipo_id = " + tipo + " "
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets pendientes
    public List<Ticket> obtenerTodosTicketsPendientesByPrioridad(String prioridad) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'abierto' AND t.prioridad = '" + prioridad + "' "
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets asignados
    public List<Ticket> obtenerTodosTicketsAsignados() throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'en proceso' "
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets asignados
    public List<Ticket> obtenerTodosTicketsAsignadosByTipo(int tipo) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'en proceso' AND t.tipo_id= " + tipo + " "
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets asignados
    public List<Ticket> obtenerTodosTicketsAsignadosByPrioridad(String prioridad) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'en proceso' AND t.prioridad = '" + prioridad + "'"
                + "order by fecha_creacion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        "",
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets cerrados
    public List<Ticket> obtenerTodosTicketsCerrados() throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'cerrado' "
                + "order by fecha_resolucion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets cerrados
    public List<Ticket> obtenerTodosTicketsCerradosByTipo(int tipo) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'cerrado' AND t.tipo_id=" + tipo + " "
                + "order by fecha_resolucion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Método para obtener todos los tickets cerrados
    public List<Ticket> obtenerTodosTicketsCerradosByPrioridad(String prioridad) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = 'cerrado' AND t.prioridad='" + prioridad + "' "
                + "order by fecha_resolucion desc";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }

        return tickets;
    }

    // Metodo para asignar los tickets
    public void asignarTecnicoTicket(int idTicket, int idUsuarioTecnico) throws SQLException {
        String sql = "UPDATE Tickets SET asignado_a = ?, estado = 'en proceso' WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idUsuarioTecnico);
            stmt.setInt(2, idTicket);
            stmt.executeUpdate();
        }
    }

    public void cerrarTicket(int idTicket, String comentario) throws SQLException {
        String sql = "UPDATE Tickets SET fecha_resolucion = ?, comentario = ?, estado = 'cerrado' WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            // Establecemos la fecha de resolución actual
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            // Establecemos el comentario pasado como parámetro
            stmt.setString(2, comentario);
            // Establecemos el ID del ticket a cerrar
            stmt.setInt(3, idTicket);

            stmt.executeUpdate();
        }
    }

    // Metodo para obtener los tickets creados por el usuario
    public List<Ticket> obtenerTodosTicketsUsuario(int id) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.usuario_id = ? "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<Ticket> obtenerTodosTicketsUsuarioByEstado(int id, String estado) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.estado = '" + estado + "'  AND t.usuario_id = " + id + " "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<Ticket> obtenerTodosTicketsUsuarioByPrioridad(int id, String prioridad) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.prioridad = '" + prioridad + "'  AND t.usuario_id = " + id + " "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<Ticket> obtenerTodosTicketsAsignadosTecnico(int id) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.asignado_a = ? "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<Ticket> obtenerTodosTicketsAsignadosTecnicoByPrioridad(int id, String prioridad) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.asignado_a = ? AND t.prioridad = ? "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setString(2, prioridad);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<Ticket> obtenerTodosTicketsAsignadosTecnicoByEstado(int id, String estado) throws SQLException {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT "
                + "t.*, "
                + "tp.tipo, "
                + "concat(tec.nombre,' ',tec.apellido) as nombreTecnico, "
                + "emp.razon_social, "
                + "emp.direccion as direccionEmpresa, "
                + "emp.telefono as telefonoEmpresa, "
                + "emp.correo as correoEmpresa, "
                + "st.nombre as subtipo "
                + "FROM Tickets t left join Tipoticket tp on t.tipo_id = tp.id "
                + "left join Subtipoticket st on t.subtipo_id = st.id "
                + "left join Usuarios u on t.asignado_a = u.id "
                + "left join Tecnicos tec on u.id = tec.usuario_id "
                + "left join Empresas emp on t.usuario_id = emp.usuario_id "
                + "where t.asignado_a = ? AND t.estado = ? "
                + "order by fecha_creacion desc";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setString(2, estado);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad"),
                        rs.getString("estado"),
                        rs.getString("fecha_creacion"),
                        rs.getString("fecha_resolucion"),
                        rs.getInt("asignado_a"),
                        rs.getString("tipo"),
                        rs.getString("nombreTecnico"),
                        rs.getInt("usuario_id"),
                        rs.getString("lugar"),
                        rs.getString("encargado"),
                        rs.getInt("subtipo_id"),
                        rs.getString("razon_social"),
                        rs.getString("subtipo"),
                        rs.getString("comentario"),
                        rs.getString("direccionEmpresa"),
                        rs.getString("telefonoEmpresa"),
                        rs.getString("correoEmpresa"),
                        rs.getString("valoracion"),
                        rs.getString("comentario_usuario")
                ));
            }
        }
        return tickets;
    }

    public List<TicketConteo> contarTickets() throws SQLException {
        List<TicketConteo> lista = new ArrayList<>();
        String sql = "SELECT estado, COUNT(*) AS total_tickets FROM tickets GROUP BY estado";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String estado = rs.getString("estado");
                int totalTickets = rs.getInt("total_tickets");
                TicketConteo ticketConteo = new TicketConteo(estado, totalTickets);
                lista.add(ticketConteo);
            }
        }

        return lista;
    }

    public List<TicketConteo> contarTicketsTecnico(int idTecnico) throws SQLException {
        List<TicketConteo> lista = new ArrayList<>();
        String sql = "SELECT estado, COUNT(*) AS total_tickets "
                + "FROM tickets "
                + "where asignado_a =" + idTecnico + " "
                + "GROUP BY estado";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String estado = rs.getString("estado");
                int totalTickets = rs.getInt("total_tickets");
                TicketConteo ticketConteo = new TicketConteo(estado, totalTickets);
                lista.add(ticketConteo);
            }
        }

        return lista;
    }

    public List<TicketConteo> contarTicketsUsuario(int idUsuario) throws SQLException {
        List<TicketConteo> lista = new ArrayList<>();
        String sql = "SELECT estado, COUNT(*) AS total_tickets "
                + "FROM tickets "
                + "where usuario_id =" + idUsuario + " "
                + "GROUP BY estado";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String estado = rs.getString("estado");
                int totalTickets = rs.getInt("total_tickets");
                TicketConteo ticketConteo = new TicketConteo(estado, totalTickets);
                lista.add(ticketConteo);
            }
        }

        return lista;
    }
    
    // Metodo para valorizar el ticket
    public void valorizarTicket(int idTicket, String valoracion, String comentario) throws SQLException {
        
        String sql = "UPDATE Tickets SET valoracion = ?, comentario_usuario = ? WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, valoracion);
            stmt.setString(2, comentario);
            stmt.setInt(3, idTicket);
            stmt.executeUpdate();
        }
    }

}
