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
public class TipoTicketDAO {

    private final Connection connection;

    public TipoTicketDAO(Connection connection) {
        this.connection = connection;
    }

    // Obtener todos los roles
    public List<TipoTicket> obtenerTodosTipoTicket() throws SQLException {
        List<TipoTicket> ticketTipos = new ArrayList<>();
        String sql = "SELECT * FROM tipoticket order by id asc";
        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ticketTipos.add(new TipoTicket(
                        rs.getInt("id"),
                        rs.getString("tipo")
                ));
            }
        }
        return ticketTipos;
    }

}
