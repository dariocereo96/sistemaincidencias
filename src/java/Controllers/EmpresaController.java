package Controllers;

import Configurations.Conexion;
import Models.Empresa;
import Models.EmpresaDAO;
import Models.Usuario;
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

@WebServlet(name = "EmpresaController", urlPatterns = {"/EmpresaController"})
public class EmpresaController extends HttpServlet {

    Connection conexion;
    String error = "error.jsp";
    String listarAdmin = "administracion/listatickets.jsp";
    String listarCliente = "usuario/listatickets.jsp";
    String listarEmpresa = "administracion/listaEmpresas.jsp";
    String registrarEmpresa = "administracion/registrarEmpresa.jsp";
    String editarEmpresa = "administracion/editarEmpresa.jsp";
    String editarEmpresaCliente = "usuario/editarPerfil.jsp";
    String cliente = "usuario/";
    Empresa empresa;
    EmpresaDAO empresaDAO;

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

            case "crearEditarEmpresa":
                crearEditarEmpresa(request, response);
                break;

            default:
                request.setAttribute("mensaje", "Accion invalida");
                request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String razonSocial = request.getParameter("razonSocial").trim();
        String direccion = request.getParameter("direccion").trim();
        String telefono = request.getParameter("telefono").trim();
        String correo = request.getParameter("correo").trim();
        String ruc = request.getParameter("ruc").trim();

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            empresa = new Empresa();
            empresaDAO = new EmpresaDAO(conexion);

            // Registramos los datos
            empresa.setCorreo(correo);
            empresa.setDireccion(direccion);
            empresa.setRazonSocial(razonSocial);
            empresa.setRuc(ruc);
            empresa.setTelefono(telefono);

            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (empresaDAO.validarExiste("ruc", empresa.getRuc())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el RUC " + empresa.getRuc() + ".");
                validar = false;
            }

            if (empresaDAO.validarExiste("correo", empresa.getCorreo())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + empresa.getCorreo() + ".");
                validar = false;
            }

            if (empresaDAO.validarExiste("telefono", empresa.getTelefono())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el telefono " + empresa.getTelefono() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("empresa", empresa);
                request.getRequestDispatcher(registrarEmpresa).forward(request, response);
                return;
            }

            empresaDAO.crearEmpresa(empresa);

            session.setAttribute("mensajeAlerta", "Se registro la empresa.");

            response.sendRedirect(listarEmpresa);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int idEmpresa = Integer.parseInt(request.getParameter("idEmpresa"));
        String razonSocial = request.getParameter("razonSocial");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String ruc = request.getParameter("ruc");

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String ruta = editarEmpresa;
        String ruta2 = listarEmpresa;

        if (usuario.getRolId() == 1) {
            ruta = editarEmpresaCliente;
            ruta2 = editarEmpresaCliente + "?id=" + usuario.getId();
        }

        try {
            conexion = Conexion.getConexion();
            empresa = new Empresa();
            empresaDAO = new EmpresaDAO(conexion);

            // Registramos los datos
            empresa.setId(idEmpresa);
            empresa.setCorreo(correo);
            empresa.setDireccion(direccion);
            empresa.setRazonSocial(razonSocial);
            empresa.setRuc(ruc);
            empresa.setTelefono(telefono);

            // Validar los campos que no se repitan en la db
            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (empresaDAO.validarExisteUnico("ruc", empresa.getRuc(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el RUC " + empresa.getRuc() + ".");
                validar = false;
            }

            if (empresaDAO.validarExisteUnico("correo", empresa.getCorreo(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + empresa.getCorreo() + ".");
                validar = false;
            }

            if (empresaDAO.validarExisteUnico("telefono", empresa.getTelefono(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el telefono " + empresa.getTelefono() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("empresa", empresa);
                request.getRequestDispatcher(ruta).forward(request, response);
                return;
            }

            empresaDAO.actualizarEmpresa(empresa);

            session.setAttribute("mensajeAlerta", "Se edito correctamente la empresa.");

            response.sendRedirect(ruta2);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int idEmpresa = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();

        try {
            conexion = Conexion.getConexion();
            empresaDAO = new EmpresaDAO(conexion);
            UsuarioDAO usuarioDAO = new UsuarioDAO(conexion);
            
            empresa = empresaDAO.obtenerEmpresaId(idEmpresa);

            empresaDAO.eliminarEmpresa(idEmpresa);

            usuarioDAO.eliminarUsuario(empresa.getUsuarioId());

            session.setAttribute("mensajeAlerta", "Se elimino correctamente el registro.");

            response.sendRedirect(listarEmpresa);

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }
    }

    private void crearEditarEmpresa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int idEmpresa = Integer.parseInt(request.getParameter("idEmpresa"));
        String razonSocial = request.getParameter("razonSocial");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String ruc = request.getParameter("ruc");

        // Crear sesión y obtener el id del usuario
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        try {
            conexion = Conexion.getConexion();
            empresa = new Empresa();
            empresaDAO = new EmpresaDAO(conexion);

            // Registramos los datos
            empresa.setId(idEmpresa);
            empresa.setCorreo(correo);
            empresa.setDireccion(direccion);
            empresa.setRazonSocial(razonSocial);
            empresa.setRuc(ruc);
            empresa.setTelefono(telefono);

            // Validar los campos que no se repitan en la db
            boolean validar = true;

            // Validar los campos que no se repitan en la db
            if (empresaDAO.validarExisteUnico("ruc", empresa.getRuc(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el RUC " + empresa.getRuc() + ".");
                validar = false;
            }

            if (empresaDAO.validarExisteUnico("correo", empresa.getCorreo(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el correo " + empresa.getCorreo() + ".");
                validar = false;
            }

            if (empresaDAO.validarExisteUnico("telefono", empresa.getTelefono(), empresa.getId())) {
                session.setAttribute("mensajeError", "Ya existe un registro con el telefono " + empresa.getTelefono() + ".");
                validar = false;
            }

            if (!validar) {
                request.setAttribute("empresa", empresa);
                request.getRequestDispatcher(editarEmpresaCliente).forward(request, response);
                return;
            }

            if (empresa.getId() > 0) {
                empresaDAO.actualizarEmpresa(empresa);
            } else {
                empresa.setUsuarioId(usuario.getId());
                empresaDAO.crearEmpresa(empresa);
            }

            session.setAttribute("mensajeAlerta", "Se edito correctamente la empresa.");

            response.sendRedirect(editarEmpresaCliente + "?id=" + usuario.getId());

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("mensaje", "Ocurrio un problema: " + ex.getMessage());
            request.getRequestDispatcher(error).forward(request, response);
        }

    }
}
