/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Models;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class SubTipoTicketDAO {

    private final Connection connection;

    public SubTipoTicketDAO(Connection connection) {
        this.connection = connection;
    }

    // Obtener todos los roles
    public List<SubTipoTicket> obtenerTodosSubTipoTicket(int tipo) throws SQLException {
        List<SubTipoTicket> ticketSubTipos = new ArrayList<>();
        String sql = "SELECT * "
                + "FROM subtipoticket "
                + "where tipo_id = "+tipo
                + " order by id asc";
        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ticketSubTipos.add(new SubTipoTicket(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getInt("tipo_id"),
                        rs.getString("prioridad")
                ));
            }
        }
        return ticketSubTipos;
    }

}
