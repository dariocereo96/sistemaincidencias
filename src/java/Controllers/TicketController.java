/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Configurations.Conexion;
import Models.Ticket;
import Models.TicketDAO;
import Models.Usuario;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author HP
 */
@WebServlet(name = "TicketController", urlPatterns = {"/TicketController"})
public class TicketController extends HttpServlet {

    Connection conexion;
    Ticket ticket;
    TicketDAO ticketDAO;
    String error = "error.jsp";
    String listarAdmin = "administracion/listatickets.jsp";
    String listarCliente = "usuario/listatickets.jsp";
    String listarClienteCerrados = "usuario/listaticketscerrados.jsp";
    String listarAdminAsignados = "administracion/listaticketAsignados.jsp";
    String listarAdminCerrados = "administracion/listaticketCerrados.jsp";
    String listarTecnicoCerrados = "tecnico/listaticketscerrados.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "eliminar":
                eliminar(request, response);
                break;
            default:
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "registrar":
                registrar(request, response);
                break;

            case "editar":
                editar(request, response);
                break;

            case "asignarTecnico":
                asignarTecnico(request, response);
                break;

            case "cerrarTicket":
                cerrarTicket(request, response);
                break;

            case "valorar":
                valorarAtencion(request, response);
                break;

            default:
                request.setAttribute("mensaje", "Accion invalida");
                request.getRequestDispatcher(error).forward(request, response);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //Obtenemos todos los campos
        String titulo = request.getParameter("titulo").trim();
        String descripcion = request.getParameter("descripcion").trim();
        int tipo_id = Integer.parseInt(request.getParameter("tipo_id"));
        String prioridad = request.getParameter("prioridad");
        int idUsuarioEmpresa = Integer.parseInt(request.getParameter("idUsuarioEmpresa"));
        String lugar = request.getParameter("lugar").trim();
        String encargado = request.getParameter("encargado").trim();

        int subtipo_id;

        switch (tipo_id) {
            case 1:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id1"));
                break;
            case 2:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id2"));
                break;
            case 3:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id3"));
                break;
            case 4:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id4"));
                break;
            default:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id5"));
                break;
        }

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        try {
            conexion = Conexion.getConexion();
            ticket = new Ticket();
            ticket.setTipoId(tipo_id);
            ticket.setTitulo(titulo);
            ticket.setDescripcion(descripcion);
            ticket.setPrioridad(prioridad);
            ticket.setEstado("abierto");
            ticket.setIdUsuario(idUsuarioEmpresa);
            ticket.setEncargado(encargado);
            ticket.setLugar(lugar);
            ticket.setIdSupTipo(subtipo_id);

            ticketDAO = new TicketDAO(conexion);

            ticketDAO.crearTicket(ticket);

            session.setAttribute("mensajeAlerta", "Se registro el ticket.");

            if (usuario.getRolId() == 1) {
                response.sendRedirect(listarCliente);
            }

            if (usuario.getRolId() == 2) {
                //response.sendRedirect(tecnico);
            }

            if (usuario.getRolId() == 3 || usuario.getRolId() == 4 || usuario.getRolId() == 5) {
                response.sendRedirect(listarAdmin);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //Obtenemos todos los campos
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        String titulo = request.getParameter("titulo").trim();
        String descripcion = request.getParameter("descripcion").trim();
        int tipo_id = Integer.parseInt(request.getParameter("tipo_id"));
        String prioridad = request.getParameter("prioridad");
        String lugar = request.getParameter("lugar").trim();
        String encargado = request.getParameter("encargado").trim();

        int subtipo_id;

        switch (tipo_id) {
            case 1:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id1"));
                break;
            case 2:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id2"));
                break;
            case 3:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id3"));
                break;
            case 4:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id4"));
                break;
            default:
                subtipo_id = Integer.parseInt(request.getParameter("subtipo_id5"));
                ;
                break;
        }

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        try {
            conexion = Conexion.getConexion();
            ticket = new Ticket();
            ticket.setId(idTicket);
            ticket.setTipoId(tipo_id);
            ticket.setTitulo(titulo);
            ticket.setDescripcion(descripcion);
            ticket.setPrioridad(prioridad);
            ticket.setEstado("abierto");
            ticket.setEncargado(encargado);
            ticket.setLugar(lugar);
            ticket.setIdSupTipo(subtipo_id);

            ticketDAO = new TicketDAO(conexion);

            ticketDAO.actualizarTicket(ticket);

            session.setAttribute("mensajeAlerta", "Se edito el ticket #"+idTicket);

            switch (usuario.getRolId()) {
                case 1:
                    response.sendRedirect(listarCliente);
                    break;
                case 2:
                    break;
                default:
                    response.sendRedirect(listarAdmin);
                    break;
            }

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }

    private void asignarTecnico(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        //Obtenemos los campos
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        int idTecnico = Integer.parseInt(request.getParameter("idTecnico"));

        try {
            conexion = Conexion.getConexion();
            ticket = new Ticket();
            ticketDAO = new TicketDAO(conexion);

            ticketDAO.asignarTecnicoTicket(idTicket, idTecnico);

            HttpSession session = request.getSession();

            session.setAttribute("mensajeAlerta", "Ticket #" + idTicket + " asignado correctamente.");

            response.sendRedirect(listarAdminAsignados);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        int idTicket = Integer.parseInt(request.getParameter("id"));

        try {
            conexion = Conexion.getConexion();
            ticketDAO = new TicketDAO(conexion);

            ticketDAO.eliminarTicket(idTicket);

            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            session.setAttribute("mensajeAlerta", "Se cancelo el ticket.");

            if (usuario.getRolId() == 1) {
                response.sendRedirect(listarCliente);
            }

            if (usuario.getRolId() == 3 || usuario.getRolId() == 4 || usuario.getRolId() == 5) {
                response.sendRedirect(listarAdmin);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void cerrarTicket(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        String comentario = request.getParameter("comentario");

        try {
            conexion = Conexion.getConexion();
            ticketDAO = new TicketDAO(conexion);

            ticketDAO.cerrarTicket(idTicket, comentario);

            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            session.setAttribute("mensajeAlerta", "Ticket #" + idTicket + " cerrado correctamente.");

            if (usuario.getRolId() == 4 || usuario.getRolId() == 5) {
                response.sendRedirect(listarAdminCerrados);
            } else {
                response.sendRedirect(listarTecnicoCerrados);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }

    private void valorarAtencion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String valoracion = request.getParameter("valoracion");
        String comentarioUsuario = request.getParameter("comentarioUsuario");
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));

        try {
            conexion = Conexion.getConexion();
            ticketDAO = new TicketDAO(conexion);
            HttpSession session = request.getSession();
            
            ticketDAO.valorizarTicket(idTicket, valoracion, comentarioUsuario);
    
            session.setAttribute("mensajeAlerta", "Ticket #" + idTicket + " calificado correctamente.");

            response.sendRedirect(listarClienteCerrados); 
            
        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }
}
