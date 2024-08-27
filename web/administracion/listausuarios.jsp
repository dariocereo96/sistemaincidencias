<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.UsuarioDAO"%>
<%@page import="Models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Usuario> listaUsuarios = new ArrayList<Usuario>();
    Usuario usuarios = null;

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        UsuarioDAO usuarioDAO = new UsuarioDAO(Conexion.getConexion());
        usuarios = (Usuario) request.getSession().getAttribute("usuario");
        
        List<Usuario> lista = usuarioDAO.obtenerTodosUsuarios();
        
        if (request.getParameter("inactivo") != null) {
            for(Usuario user : lista){
                if(user.getEstado()==0){
                    listaUsuarios.add(user);
                }
            }
        } else {
             for(Usuario user : lista){
                if(user.getEstado()==1){
                     listaUsuarios.add(user);
                }
            }
        }
    }

    String mensajeAlerta = (String) session.getAttribute("mensajeAlerta");

    if (mensajeAlerta != null) {
        session.removeAttribute("mensajeAlerta");
    }

%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuarios | Sistema Gestion Incidencias</title>
        <!-- Bootstrap Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" />
        <!-- FontAwesome Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/font-awesome.css" rel="stylesheet" />
        <!-- Morris Chart Styles-->
        <link href="${pageContext.request.contextPath}/assets/js/morris/morris-0.4.3.min.css" rel="stylesheet" />
        <!-- Custom Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/custom-styles.css" rel="stylesheet" />
        <style>
            .btn-custom{
                color:#000;
                text-decoration: none;
                padding: 8px 10px;
                color: #fff;
                display: block;
                border-radius: 5px;
            }

            .btn-custom:hover{
                color:#fff;
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <nav class="navbar navbar-default top-navbar" role="navigation" style="background-color: #004DA4">
                <div class="navbar-header">
                    <a style="font-size: 18px;text-decoration: none;color:#fff;margin-top: 6px;margin-left: 44px;display: block" href="${pageContext.request.contextPath}/administracion/">
                        <image class="" src="${pageContext.request.contextPath}/img/logo.jpeg" alt="logo" style="width: 44px" />
                        SOFT CORP
                    </a>
                </div>

                <ul class="nav navbar-top-links navbar-right" style="padding-right: 40px">
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false">
                            <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">
                            <li><a href="#"><i class="fa fa-user fa-fw"></i><%= usuarios != null ? usuarios.perfilRol() : ""%></a></li>
                            <li><a href="#"><i class="fa fa-gear fa-fw"></i> CONFIGURACION</a>
                            </li>
                            <li class="divider"></li>
                            <li><a href="${pageContext.request.contextPath}/UsuarioController?action=logout"><i class="fa fa-sign-out fa-fw"></i> CERRAR SESION</a>
                            </li>
                        </ul>
                        <!-- /.dropdown-user -->
                    </li>
                    <!-- /.dropdown -->
                </ul>
            </nav>
            <!--/. NAV TOP  -->
            <nav class="navbar-default navbar-side" role="navigation" style="background-color: #004DA4;height: 100%">
                <div class="sidebar-collapse">
                    <ul class="nav" id="main-menu">

                        <li>
                            <a class="active-menu" href="${pageContext.request.contextPath}/administracion/"><i class="fa fa-dashboard"></i>Dashboard</a>
                        </li>

                        <li>
                            <a href="#"><i class="fa fa-users"></i>Clientes<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listaEmpresas.jsp"><i class="fa fa-briefcase"></i>Empresas</a>
                                </li>
                            </ul>
                        </li>

                        <li>
                            <a href="#"><i class="fa fa-users"></i>Tecnicos<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <%
                                    int rol2 = usuarios != null ? usuarios.getRolId() : -1;
                                    if (rol2 == 3 || rol2 == 4) {
                                %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/registrarTecnico.jsp"><i class="fa fa-plus fa-fw"></i>Registrar tecnico</a>
                                </li>
                                <%}%>

                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listaTecnicos.jsp"><i class="fa fa-file"></i>Listado de tecnicos</a>
                                </li>
                            </ul>
                        </li>

                        <li>
                            <a href="#"><i class="fa fa-user fa-fw"></i>Usuarios<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">

                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/registrarusuario.jsp"><i class="fa fa-plus fa-fw"></i>Registrar usuario</a>
                                </li>

                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listausuarios.jsp"><i class="fa fa-file"></i>Listado de usuarios</a>
                                </li>
                            </ul>
                        </li>

                        <li>
                            <a href="#"><i class="fa fa-list"></i>Incidencias<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <%
                                    int rol = usuarios != null ? usuarios.getRolId() : -1;

                                    if (rol == 5) {
                                %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/crearticket.jsp"><i class="fa fa-plus fa-fw"></i>Registrar ticket</a>
                                </li>
                                <%}%>
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listatickets.jsp"><i class="fa fa-ticket"></i>Tickets pendientes</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listaticketAsignados.jsp"><i class="fa fa-ticket"></i>Tickets asignados</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/administracion/listaticketCerrados.jsp"><i class="fa fa-ticket"></i>Tickets cerrados</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
            <!-- /. NAV SIDE  -->

            <div id="page-wrapper">
                <p style="padding: 0px 12px;font-weight: bolder;font-size: 12px"><%=usuarios.getNombre().toUpperCase() + " | " + usuarios.getTipoUsuario().toUpperCase()%></p>
                <div id="page-inner">
                    <div class="row">

                        <div class="col-md-12">
                            <h1 class="page-header" style="font-size: 24px">
                                Lista usuarios
                            </h1>
                            <% if (mensajeAlerta != null) {%>
                            <div class="alert alert-success">
                                <%= mensajeAlerta%>
                            </div>
                            <% } %>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <a href="${pageContext.request.contextPath}/administracion/registrarusuario.jsp" class="btn btn-primary" style="margin-right: 20px"><i class="fa fa-plus-circle" style="margin-right: 6px"></i>Registrar usuario</a>
                                    <a href="${pageContext.request.contextPath}/administracion/listausuarios.jsp" class="btn btn-success"><i class="fa fa-file" style="margin-right: 6px"></i>Usuarios Activos</a>
                                    <a href="${pageContext.request.contextPath}/administracion/listausuarios.jsp?inactivo=0" class="btn btn-danger"><i class="fa fa-file" style="margin-right: 6px"></i>Usuarios Inactivos</a>
                                    <table class="table table-striped table-bordered table-hover" style="margin-top: 10px">
                                        <thead style="font-size: 12px;text-align: center">
                                            <tr>
                                                <th>ID</th>
                                                <th>Usuario</th>
                                                <th>Correo Electrónico</th>
                                                <th>Rol</th>
                                                <th>Asignado a</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody style="font-size: 13px;">
                                            <%
                                                int idRol = usuarios.getRolId(); // ID de tu usuario logueado
                                                if (!listaUsuarios.isEmpty()) {
                                                    for (Usuario usuario : listaUsuarios) {
                                                        if (idRol == 5) {
                                                            // Mostrar solo usuarios con RolId igual a 1
                                                            if (usuario.getRolId() == 1) {
                                            %>
                                            <tr>
                                                <td><%= usuario.getId()%></td>
                                                <td><%= usuario.getNombre()%></td>
                                                <td><%= usuario.getCorreoElectronico()%></td>
                                                <td><%= usuario.getTipoUsuario()%></td>
                                                <td><%= usuario.getNombreEmpresa()%></td>
                                                <td><%= (usuario.getEstado() == 1) ? "Activo" : "Inactivo"%></td>
                                                <td style="display: flex">
                                                    <a class="btn-custom" style="background-color: #0075b0; margin-right: 2px; display: flex; justify-content: center" href="${pageContext.request.contextPath}/administracion/editarusuario.jsp?id=<%= usuario.getId()%>">
                                                        <i class="fa fa-edit" style="margin-top: 2px; margin-right: 2px"></i>Editar
                                                    </a>
                                                    <%if (usuario.getEstado() == 1) {%>
                                                    <!-- Si el usuario está activo, solo mostrar el botón para desactivar -->
                                                    <a class="btn-custom" style="background-color: #F0433D; display: flex; justify-content: center;width: 100%" 
                                                       href="${pageContext.request.contextPath}/UsuarioController?action=cambiarEstado&id=<%= usuario.getId()%>&valor=0">
                                                        <i class="fa fa-minus-circle" style="margin-top: 2px; margin-right: 2px"></i> Desactivar
                                                    </a>
                                                    <%} else {%>
                                                    <!-- Si el usuario está inactivo, solo mostrar el botón para activar -->
                                                    <a class="btn-custom" style="background-color: #398439; display: flex; justify-content: center;width: 100%" 
                                                       href="${pageContext.request.contextPath}/UsuarioController?action=cambiarEstado&id=<%= usuario.getId()%>&valor=1">
                                                        <i class="fa fa-check-circle" style="margin-top: 2px; margin-right: 2px"></i> Activar
                                                    </a>
                                                    <% } %>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            } else {
                                                // Mostrar todos los usuarios sin importar el RolId
                                            %>
                                            <tr>
                                                <td><%= usuario.getId()%></td>
                                                <td><%= usuario.getNombre()%></td>
                                                <td><%= usuario.getCorreoElectronico()%></td>
                                                <td><%= usuario.getTipoUsuario()%></td>

                                                <%if (usuario.getRolId() == 1) {%>
                                                <td><%= usuario.getNombreEmpresa()%></td>
                                                <%} else if (usuario.getRolId() == 2) {%>
                                                <td><%= usuario.getNombreCompletoUsuario()%></td>
                                                <%} else {%>
                                                <td style="text-align: center">-</td>
                                                <%}%>

                                                <td><%= (usuario.getEstado() == 1) ? "Activo" : "Inactivo"%></td>

                                                <td style="display: flex">
                                                    <a class="btn-custom" style="background-color: #0075b0; margin-right: 2px; display: flex; justify-content: center" href="${pageContext.request.contextPath}/administracion/editarusuario.jsp?id=<%= usuario.getId()%>">
                                                        <i class="fa fa-edit" style="margin-top: 2px; margin-right: 2px"></i>Editar
                                                    </a>

                                                    <%if (usuario.getEstado() == 1) {%>
                                                    <!-- Si el usuario está activo, solo mostrar el botón para desactivar -->
                                                    <a class="btn-custom" style="background-color: #F0433D; display: flex; justify-content: center;width: 100%" 
                                                       href="${pageContext.request.contextPath}/UsuarioController?action=cambiarEstado&id=<%= usuario.getId()%>&valor=0">
                                                        <i class="fa fa-minus-circle" style="margin-top: 2px; margin-right: 2px"></i> Desactivar
                                                    </a>
                                                    <%} else {%>
                                                    <!-- Si el usuario está inactivo, solo mostrar el botón para activar -->
                                                    <a class="btn-custom" style="background-color: #398439; display: flex; justify-content: center;width: 100%" 
                                                       href="${pageContext.request.contextPath}/UsuarioController?action=cambiarEstado&id=<%= usuario.getId()%>&valor=1">
                                                        <i class="fa fa-check-circle" style="margin-top: 2px; margin-right: 2px"></i> Activar
                                                    </a>
                                                    <% } %>

                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                            } else {
                                            %>
                                            <tr>
                                                <td colspan="6">No hay usuarios disponibles</td>
                                            </tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /. PAGE INNER  -->
            </div>
            <!-- /. PAGE WRAPPER  -->
        </div>
        <!-- /. WRAPPER  -->
        <!-- JS Scripts-->
        <!-- jQuery Js -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery-1.10.2.js"></script>
        <!-- Bootstrap Js -->
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <!-- Metis Menu Js -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.metisMenu.js"></script>
        <!-- Morris Chart Js -->
        <script src="${pageContext.request.contextPath}/assets/js/morris/raphael-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/morris/morris.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/easypiechart.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/easypiechart-data.js"></script>
        <!-- Custom Js -->
        <script src="${pageContext.request.contextPath}/assets/js/custom-scripts.js"></script>

    </body>
</html>