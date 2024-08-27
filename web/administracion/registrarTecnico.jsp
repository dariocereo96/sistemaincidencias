<%@page import="Models.Tecnico"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Usuario"%>
<%
    Tecnico tecnico = new Tecnico();
    Usuario usuario = null;

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (request.getAttribute("tecnico") != null) {
            tecnico = (Tecnico) request.getAttribute("tecnico");
        }
    }

    String mensajeError = (String) session.getAttribute("mensajeError");
    if (mensajeError != null) {
        session.removeAttribute("mensajeError");
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro tecnico | Sistema Gestion Incidencias</title>
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
                            <li><a href="#"><i class="fa fa-user fa-fw"></i><%= usuario != null ? usuario.perfilRol() : ""%></a></li>
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
                                    int rol2 = usuario != null ? usuario.getRolId() : -1;
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
                                    int rol = usuario != null ? usuario.getRolId() : -1;
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
                <p style="padding: 0px 12px;font-weight: bolder;font-size: 12px"><%= usuario != null ? usuario.getNombre().toUpperCase() + " | " + usuario.getTipoUsuario().toUpperCase() : ""%></p>
                <div id="page-inner">
                    <div class="row">
                        <div class="col-md-12">
                            <h1 class="page-header" style="font-size: 24px;">
                                Registro de tecnico
                            </h1>
                            <% if (mensajeError != null) {%>
                            <div class="alert alert-danger">
                                <%= mensajeError%>
                            </div>
                            <% }%>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <form onsubmit="validarFormulario(event)" action="${pageContext.request.contextPath}/TecnicoController?action=registrar" method="post">
                                        <div class="form-group">
                                            <label for="nombre">Cedula:</label>
                                            <input oninput="validarCedula(event)" value="<%= (tecnico.getCedula() != null) ? tecnico.getCedula() : ""%>" type="text" class="form-control" id="cedula" name="cedula" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="nombre">Nombre:</label>
                                            <input oninput="validarTexto(event)" type="text" value="<%= (tecnico.getNombre() != null) ? tecnico.getNombre() : ""%>" class="form-control" id="nombre" name="nombre" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="apellido">Apellido:</label>
                                            <input oninput="validarTexto(event)" type="text" value="<%= (tecnico.getApellido() != null) ? tecnico.getApellido() : ""%>" class="form-control" id="apellido" name="apellido" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="correo">Correo:</label>
                                            <input type="email" value="<%= (tecnico.getCorreo() != null) ? tecnico.getCorreo() : ""%>" class="form-control" id="correo" name="correo" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="telefono">Telefono:</label>
                                            <input type="text" value="<%= (tecnico.getTelefono() != null) ? tecnico.getTelefono() : ""%>" oninput="validarTelefono(event)" class="form-control" id="telefono" name="telefono">
                                        </div>
                                        <div class="form-group">
                                            <label for="direccion">Direccion:</label>
                                            <input type="text" value="<%= (tecnico.getDireccion() != null) ? tecnico.getDireccion() : ""%>" class="form-control" id="telefono" name="direccion">
                                        </div>
                                        <div style="text-align: right">
                                            <input type="submit" class="btn btn-primary" value="Registrar">
                                            <a href="${pageContext.request.contextPath}/administracion/listaTecnicos.jsp" class="btn btn-danger">Cancelar</a>
                                        </div
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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
                                        function validarCedula(event) {
                                            const input = event.target;
                                            const valor = input.value;

                                            // Remover cualquier carácter que no sea un número
                                            input.value = valor.replace(/\D/g, '');

                                            // Limitar la longitud a 13 caracteres
                                            if (input.value.length > 10) {
                                                input.value = input.value.slice(0, 10);
                                            }
                                        }

                                        function validarTelefono(event) {
                                            const input = event.target;
                                            const valor = input.value;

                                            // Remover cualquier carácter que no sea un número
                                            input.value = valor.replace(/\D/g, '');

                                            // Limitar la longitud a 13 caracteres
                                            if (input.value.length > 10) {
                                                input.value = input.value.slice(0, 10);
                                            }
                                        }

                                        function validarTexto(event) {
                                            const input = event.target;
                                            const valor = input.value;

                                            const onlyLettersAndSpaces = /^[A-Za-z\s]*$/;

                                            if (!onlyLettersAndSpaces.test(valor)) {
                                                input.value = valor.replace(/[^A-Za-z\s]/g, '');
                                            }
                                        }

                                        function validarFormulario(event) {
                                            const cedulaInput = document.getElementById('cedula');
                                            if (cedulaInput.value.length !== 10) {
                                                event.preventDefault();
                                                cedulaInput.focus();
                                                alert('La cedula debe tener exactamente 10 números.');
                                            }
                                        }
        </script>

    </body>
</html>
