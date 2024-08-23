/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Configurations.Conexion;
import Models.EmpresaDAO;
import Models.PasswordUtils;
import Models.TecnicoDAO;
import Models.Usuario;
import Models.UsuarioDAO;
import java.io.IOException;
import java.security.spec.InvalidKeySpecException;
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
@WebServlet(name = "UsuarioController", urlPatterns = {"/UsuarioController"})
public class UsuarioController extends HttpServlet {

    Connection conexion;
    Usuario usuario;
    UsuarioDAO usuarioDAO;
    EmpresaDAO empresaDAO;
    TecnicoDAO tecnicoDAO;
    String error = "error.jsp";
    String auth = "auth/";
    String admin = "administracion/";
    String cliente = "usuario/";
    String tecnico = "tecnico/";
    String listaUsuario = "administracion/listausuarios.jsp";
    String registrarUsuario = "administracion/registrarusuario.jsp";
    String editarUsuario = "administracion/editarusuario.jsp";

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
            case "logout":
                logout(request, response);
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

            case "login":
                login(request, response);
                break;

            default:
                request.setAttribute("mensaje", "Accion invalida");
                request.getRequestDispatcher(error).forward(request, response);
        }
    }

    public void registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //Obtenemos los campos del formulario
        String nombre = request.getParameter("nombre").trim();
        String correo = request.getParameter("correo").trim();
        String contrasena = request.getParameter("contrasena").trim();
        int rolId = 1;
        String ruta = auth;
        String ruta2 = auth;
        int idEmpresa = -1;
        int idTecnico = -1;

        if (request.getParameter("rol") != null && (request.getParameter("idEmpresa") != null || request.getParameter("idTecnico") != null)) {
            rolId = Integer.parseInt(request.getParameter("rol"));
            ruta = listaUsuario;
            ruta2 = registrarUsuario;

            if (rolId == 1) {
                idEmpresa = Integer.parseInt(request.getParameter("idEmpresa"));
            }

            if (rolId == 2) {
                idTecnico = Integer.parseInt(request.getParameter("idTecnico"));
            }
        }

        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();

            usuario = new Usuario();
            usuario.setNombre(nombre);
            usuario.setCorreoElectronico(correo);
            usuario.setRolId(rolId);
            usuarioDAO = new UsuarioDAO(conexion);

            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (usuarioDAO.validarExiste("nombre", usuario.getNombre())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el nombre de usuario " + usuario.getNombre() + ".");
                validar = false;
            }

            if (usuarioDAO.validarExiste("correo_electronico", usuario.getCorreoElectronico())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + usuario.getCorreoElectronico() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher(ruta2).forward(request, response);
                return;
            }

            // Encriptacion
            String salt = PasswordUtils.generarSalt();
            String contrasenaCifrada = PasswordUtils.encriptarPassword(contrasena, salt);

            usuario.setContrasena(contrasenaCifrada);
            usuario.setSalt(salt);

            int idUsuario = usuarioDAO.crearUsuario(usuario);

            empresaDAO = new EmpresaDAO(conexion);
            tecnicoDAO = new TecnicoDAO(conexion);

            if (idEmpresa > 0) {
                empresaDAO.asignarUsuario(idUsuario, idEmpresa);
            }

            if (idTecnico > 0) {
                tecnicoDAO.asignarUsuario(idUsuario, idTecnico);
            }

            session.setAttribute("mensajeAlerta", "Usuario registrado correctamente.");

            response.sendRedirect(ruta);

        } catch (ClassNotFoundException | SQLException | InvalidKeySpecException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    public void editar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //Obtenemos los campos del formulario
        String nombre = request.getParameter("nombre").trim();
        String correo = request.getParameter("correo").trim();
        String contrasena = request.getParameter("contrasena").trim();
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        int rolId = Integer.parseInt(request.getParameter("rol"));

        HttpSession session = request.getSession();
        usuario = (Usuario) session.getAttribute("usuario");

        try {
            conexion = Conexion.getConexion();

            usuario = new Usuario();
            usuario.setId(idUsuario);
            usuario.setNombre(nombre);
            usuario.setContrasena(contrasena);
            usuario.setCorreoElectronico(correo);
            usuario.setRolId(rolId);
            usuarioDAO = new UsuarioDAO(conexion);

            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (usuarioDAO.validarExisteUnico("nombre", usuario.getNombre(), usuario.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el nombre de usuario " + usuario.getNombre() + ".");
                validar = false;
            }

            if (usuarioDAO.validarExisteUnico("correo_electronico", usuario.getCorreoElectronico(), usuario.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + usuario.getCorreoElectronico() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher(editarUsuario).forward(request, response);
                return;
            }

            if (!contrasena.isEmpty()) {
                // Encriptacion
                String salt = PasswordUtils.generarSalt();
                String contrasenaCifrada = PasswordUtils.encriptarPassword(contrasena, salt);
        
                usuario.setContrasena(contrasenaCifrada);
                usuario.setSalt(salt);
            }

            usuarioDAO.actualizarUsuario(usuario);

            session.setAttribute("mensajeAlerta", "Usuario editado correctamente.");

            response.sendRedirect(listaUsuario);

        } catch (ClassNotFoundException | SQLException | InvalidKeySpecException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }

    public void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //Obtenemos los datos del formulario
        String correo = request.getParameter("correoLogin");
        String contrasena = request.getParameter("contrasenaLogin");

        try {

            conexion = Conexion.getConexion();

            usuarioDAO = new UsuarioDAO(conexion);

            usuario = usuarioDAO.obtenerUsuarioPorCorreoOrUsername(correo);

            // Crear sesión y almacenar el usuario
            HttpSession session = request.getSession();

            if (usuario != null && PasswordUtils.validarPassword(contrasena, usuario.getSalt(), usuario.getContrasena())) {

                session.setAttribute("usuario", usuario);

                switch (usuario.getRolId()) {
                    case 1:
                        response.sendRedirect(cliente);
                        break;
                    case 2:
                        response.sendRedirect(tecnico);
                        break;
                    default:
                        response.sendRedirect(admin);
                        break;
                }

            } else {
                session.setAttribute("mensajeError", "Correo electrónico o contraseña incorrectos.");
                response.sendRedirect(auth);
            }

        } catch (ClassNotFoundException | SQLException | InvalidKeySpecException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(auth);
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int idUsuario = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            usuarioDAO = new UsuarioDAO(conexion);

            int totalTickets = usuarioDAO.contarTickets(idUsuario);

            if (totalTickets > 0) {
                session.setAttribute("mensajeAlerta", "El usuario tiene ticket creados o asignados, no se pudo eliminar.");
            } else {
                usuarioDAO.eliminarUsuario(idUsuario);
                session.setAttribute("mensajeAlerta", "Se elimino el usuario.");
            }

            response.sendRedirect(listaUsuario);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }

}
