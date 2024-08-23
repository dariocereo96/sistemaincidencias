package Controllers;

import Configurations.Conexion;
import Models.EmpresaDAO;
import Models.Tecnico;
import Models.TecnicoDAO;
import Models.UsuarioDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "TecnicoController", urlPatterns = {"/TecnicoController"})
public class TecnicoController extends HttpServlet {

    Connection conexion;
    String error = "error.jsp";
    String listarAdmin = "administracion/listatickets.jsp";
    String listarCliente = "usuario/listaTecnicos.jsp";
    String listarTecnicos = "administracion/listaTecnicos.jsp";
    String registrarTecnico = "administracion/registrarTecnico.jsp";
    String editarTecnico = "administracion/editarTecnico.jsp";
    Tecnico tecnico;
    TecnicoDAO tecnicoDAO;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
                request.setAttribute("mensaje", "Accion invalida");
                request.getRequestDispatcher(error).forward(request, response);
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

            default:
                request.setAttribute("mensaje", "Accion invalida");
                request.getRequestDispatcher(error).forward(request, response);
        }

    }

    private void registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String cedula = request.getParameter("cedula");
        String direccion = request.getParameter("direccion");

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            tecnico = new Tecnico();
            tecnicoDAO = new TecnicoDAO(conexion);

            tecnico.setApellido(apellido);
            tecnico.setCedula(cedula);
            tecnico.setCorreo(correo);
            tecnico.setDireccion(direccion);
            tecnico.setNombre(nombre);
            tecnico.setApellido(apellido);
            tecnico.setTelefono(telefono);

            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (tecnicoDAO.validarExiste("cedula", tecnico.getCedula())) {
                session.setAttribute("mensajeError", "Ya existe un registro con la cedula " + tecnico.getCedula() + ".");
                validar = false;
            }

            if (tecnicoDAO.validarExiste("correo", tecnico.getCorreo())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + tecnico.getCorreo() + ".");
                validar = false;
            }

            if (tecnicoDAO.validarExiste("telefono", tecnico.getTelefono())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el telefono " + tecnico.getTelefono() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("tecnico", tecnico);
                request.getRequestDispatcher(registrarTecnico).forward(request, response);
                return;
            }

            tecnicoDAO.registarTecnico(tecnico);

            session.setAttribute("mensajeAlerta", "Se registro el tecnico.");

            response.sendRedirect(listarTecnicos);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);

        }

    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int idTecnico = Integer.parseInt(request.getParameter("idTecnico"));
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String cedula = request.getParameter("cedula");
        String direccion = request.getParameter("direccion");

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            tecnico = new Tecnico();
            tecnicoDAO = new TecnicoDAO(conexion);

            tecnico.setId(idTecnico);
            tecnico.setApellido(apellido);
            tecnico.setCedula(cedula);
            tecnico.setCorreo(correo);
            tecnico.setDireccion(direccion);
            tecnico.setNombre(nombre);
            tecnico.setTelefono(telefono);

            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (tecnicoDAO.validarExisteUnico("cedula", tecnico.getCedula(), tecnico.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con la cedula " + tecnico.getCedula() + ".");
                validar = false;
            }

            if (tecnicoDAO.validarExisteUnico("correo", tecnico.getCorreo(), tecnico.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + tecnico.getCorreo() + ".");
                validar = false;
            }

            if (tecnicoDAO.validarExisteUnico("telefono", tecnico.getTelefono(), tecnico.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el telefono " + tecnico.getTelefono() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("tecnico", tecnico);
                request.getRequestDispatcher(editarTecnico).forward(request, response);
                return;
            }

            tecnicoDAO.actualizarTecnico(tecnico);

            session.setAttribute("mensajeAlerta", "Se edito el tecnico.");

            response.sendRedirect(listarTecnicos);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);

        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idTecnico = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            tecnicoDAO = new TecnicoDAO(conexion);
            UsuarioDAO usuarioDAO = new UsuarioDAO(conexion);
            tecnico = tecnicoDAO.obtenerTecnico(idTecnico);

            int totalTickets = tecnicoDAO.contarTicketsTecnico(tecnico.getUsuarioId());

            if (totalTickets > 0) {
                session.setAttribute("mensajeAlerta", "El tecnico tiene ticket asignados, no se puedo eliminar.");
            } else {
                tecnicoDAO.eliminarTecnico(idTecnico);
                usuarioDAO.eliminarUsuario(tecnico.getUsuarioId());

                session.setAttribute("mensajeAlerta", "Se elimino el tecnico.");
            }

            response.sendRedirect(listarTecnicos);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

}
