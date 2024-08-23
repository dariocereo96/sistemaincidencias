<%@page import="Models.TecnicoDAO"%>
<%@page import="Models.Tecnico"%>
<%@page import="Models.EmpresaDAO"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.Empresa"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Usuario"%>
<%
    List<Empresa> listaEmpresas = new ArrayList<Empresa>();
    List<Tecnico> listaTecnicos = new ArrayList<Tecnico>();

    Usuario usuarioSession = null;
    Usuario usuario = new Usuario();

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
    } else {
        EmpresaDAO empresaDAO = new EmpresaDAO(Conexion.getConexion());
        listaEmpresas = empresaDAO.obtenerEmpresasNoAsignadas();

        TecnicoDAO tecnicoDAO = new TecnicoDAO(Conexion.getConexion());
        listaTecnicos = tecnicoDAO.obtenerTecnicosSinAsignar();

        usuarioSession = (Usuario) request.getSession().getAttribute("usuario");

        if (request.getAttribute("usuario") != null) {
            usuario = (Usuario) request.getAttribute("usuario");
        }

    }

    String mensajeError = (String) session.getAttribute("mensajeError");
    if (mensajeError
            != null) {
        session.removeAttribute("mensajeError");
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro usuario | Sistema Gestion Incidencias</title>
        <!-- Bootstrap Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" />
        <!-- FontAwesome Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/font-awesome.css" rel="stylesheet" />
        <!-- Morris Chart Styles-->
        <link href="${pageContext.request.contextPath}/assets/js/morris/morris-0.4.3.min.css" rel="stylesheet" />
        <!-- Custom Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/custom-styles.css" rel="stylesheet" />
        <style>

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
                            <li><a href="#"><i class="fa fa-user fa-fw"></i><%= usuarioSession != null ? usuarioSession.perfilRol() : ""%></a></li>
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
                                    int rol2 = usuarioSession != null ? usuarioSession.getRolId() : -1;
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
                                    int rol = usuarioSession != null ? usuarioSession.getRolId() : -1;

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
                <p style="padding: 0px 12px;font-weight: bolder;font-size: 12px"><%= usuarioSession != null ? usuarioSession.getNombre().toUpperCase() + " | " + usuarioSession.getTipoUsuario().toUpperCase() : ""%></p>
                <div id="page-inner">
                    <div class="row">
                        <div class="col-md-12">
                            <h1 class="page-header" style="font-size: 24px;">
                                Registro de usuario
                            </h1>
                            <% if (mensajeError != null) {%>
                            <div class="alert alert-danger">
                                <%= mensajeError%>
                            </div>
                            <% }%>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <form onsubmit="validarFormulario(event)" action="${pageContext.request.contextPath}/UsuarioController?action=registrar" method="POST">

                                        <div class="form-group">
                                            <label for="rol">Rol:</label>
                                            <select id="rol" name="rol" class="form-control" style="margin-bottom: 20px">
                                                <%if (usuarioSession.getRolId() == 5) {%>
                                                <option value="1">Usuario</option>
                                                <%} else { %>
                                                <option value="2">Tecnico</option>
                                                <option value="3">Administrador</option>
                                                <option value="4">Superadministrador</option>
                                                <option value="5">Digitador</option>
                                                <%}%>
                                            </select>
                                        </div>

                                        <div class="form-group" id="div_empresas" style="display: none">
                                            <label for="idEmpresa">Seleccione una empresa:</label>
                                            <select id="idEmpresa" name="idEmpresa" class="form-control" style="margin-bottom: 20px">
                                                <%
                                                    if (listaEmpresas == null || listaEmpresas.isEmpty()) {
                                                %>
                                                <option value="-1">No hay empresas disponibles</option>
                                                <%
                                                } else {
                                                    for (Empresa empresa : listaEmpresas) {
                                                %>
                                                <option value="<%= empresa.getId()%>"><%= empresa.getRazonSocial()%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="form-group" id="div_tecnicos" style="display: none">
                                            <label for="idTecnico">Seleccione un tecnico:</label>
                                            <select id="idTecnico" name="idTecnico" class="form-control" style="margin-bottom: 20px">
                                                <%
                                                    if (listaTecnicos == null || listaTecnicos.isEmpty()) {
                                                %>
                                                <option value="-1">No hay tecnicos disponibles</option>
                                                <%
                                                } else {
                                                    for (Tecnico tecnico : listaTecnicos) {
                                                %>
                                                <option value="<%= tecnico.getId()%>"><%= tecnico.getNombre() + " " + tecnico.getApellido()%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="nombre">Nombre de usuario:</label>
                                            <input value="<%= (usuario.getNombre() != null) ? usuario.getNombre() : ""%>" type="text" class="form-control" style="margin-bottom: 20px" id="nombre" name="nombre" required>
                                        </div>

                                        <div class="form-group">
                                            <label for="correo">Correo Electrónico:</label>
                                            <input type="email" value="<%= (usuario.getCorreoElectronico() != null) ? usuario.getCorreoElectronico() : ""%>" class="form-control mb-2" style="margin-bottom: 20px" id="correo" name="correo" required>
                                        </div>

                                        <div class="form-group">
                                            <label for="contrasena">Contraseña:</label>
                                            <input type="password" class="form-control" style="margin-bottom: 20px" id="contrasena" name="contrasena" required>
                                        </div>

                                        <div style="text-align: right">
                                            <input type="submit" class="btn btn-primary" value="Registrar">
                                            <a href="${pageContext.request.contextPath}/administracion/listausuarios.jsp" class="btn btn-danger">Cancelar</a>
                                        </div

                                    </form>
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

        <script>
                                        document.addEventListener("DOMContentLoaded", function () {
                                            function mostrar() {
                                                let tipo = document.getElementById('rol').value;
                                                let divTecnicos = document.getElementById('div_tecnicos');
                                                let divEmpresas = document.getElementById('div_empresas');

                                                console.log(tipo);

                                                if (tipo === "1") {
                                                    divEmpresas.style.display = "block";
                                                    divTecnicos.style.display = "none";
                                                } else if (tipo === "2") {
                                                    divEmpresas.style.display = "none";
                                                    divTecnicos.style.display = "block";
                                                } else {
                                                    divEmpresas.style.display = "none";
                                                    divTecnicos.style.display = "none";
                                                }
                                            }

                                            // Añadir el evento onchange al select
                                            document.getElementById('rol').addEventListener('change', mostrar);
                                            mostrar();
                                        });

                                        function validarFormulario(event) {
                                            let tipo = document.getElementById('rol').value;
                                            let idEmpresa = document.getElementById('idEmpresa').value;
                                            let idTecnico = document.getElementById('idTecnico').value;

                                            if (tipo === "1") {
                                                if (idEmpresa < 0) {
                                                    event.preventDefault();
                                                    alert('No existe empresa disponible.');
                                                }
                                            }

                                            if (tipo === "2") {
                                                if (idTecnico < 0) {
                                                    event.preventDefault();
                                                    alert('No existe tecnico disponible.');
                                                }
                                            }
                                        }

        </script>

    </body>
</html>
