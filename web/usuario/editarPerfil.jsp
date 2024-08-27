<%@page import="Configurations.Conexion"%>
<%@page import="Models.EmpresaDAO"%>
<%@page import="Models.Empresa"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Usuario"%>
<%
    Empresa empresa = new Empresa();
    Usuario usuario = null;

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        EmpresaDAO empresaDAO = new EmpresaDAO(Conexion.getConexion());
        usuario = (Usuario) request.getSession().getAttribute("usuario");

        if (request.getParameter("id") != null) {
            empresa = empresaDAO.obtenerEmpresaIdUsuario(Integer.parseInt(request.getParameter("id")));
        } else {
            empresa = (Empresa) request.getAttribute("empresa");
        }
    }

    String mensajeError = (String) session.getAttribute("mensajeError");

    if (mensajeError != null) {
        session.removeAttribute("mensajeError");
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
        <title>Editar empresa Sistema Gestion Incidencias</title>
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
                    <a style="font-size: 18px;text-decoration: none;color:#fff;margin-top: 6px;margin-left: 44px;display: block" href="${pageContext.request.contextPath}/usuario/">
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
                            <li><a href="${pageContext.request.contextPath}/usuario/editarPerfil.jsp?id=<%= usuario != null ? usuario.getId() : "-1"%>"><i class="fa fa-user fa-fw"></i><%= usuario != null ? usuario.perfilRol() : ""%></a></li>
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
                            <a class="active-menu" href="${pageContext.request.contextPath}/usuario/"><i class="fa fa-dashboard"></i> Dashboard</a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-list"></i>Incidencias<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="${pageContext.request.contextPath}/usuario/crearticket.jsp"><i class="fa fa-plus fa-fw"></i>Nuevo ticket</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/usuario/listatickets.jsp"><i class="fa fa-ticket"></i>Tickets creados</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/usuario/listaticketscerrados.jsp"><i class="fa fa-ticket"></i>Tickets cerrados</a>
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
                                Editar Perfil
                            </h1>
                            <% if (mensajeError != null) {%>
                            <div class="alert alert-danger">
                                <%= mensajeError%>
                            </div>
                            <% }%>
                            <% if (mensajeAlerta != null) {%>
                            <div class="alert alert-success">
                                <%= mensajeAlerta%>
                            </div>
                            <% }%>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <form onsubmit="validarFormulario(event)" action="${pageContext.request.contextPath}/EmpresaController?action=crearEditarEmpresa" method="post">
                                        <input type="hidden" name="idEmpresa" value="<%= (empresa != null) ? empresa.getId() : "-1"%>"/>
                                        <div class="form-group">
                                            <label for="razonSocial">Razón Social:</label>
                                            <input type="text" value="<%=(empresa != null) ? empresa.getRazonSocial() : ""%>" class="form-control" id="razonSocial" name="razonSocial" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="ruc">RUC:</label>
                                            <input  oninput="validarRUC(event)" type="text" value="<%=(empresa != null) ? empresa.getRuc() : ""%>" class="form-control" id="ruc" name="ruc" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="direccion">Dirección:</label>
                                            <input type="text" value="<%=(empresa != null) ? empresa.getDireccion() : ""%>" class="form-control" id="direccion" name="direccion" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="telefono">Teléfono de contacto:</label>
                                            <input type="text" oninput="validarTelefono(event)" value="<%=(empresa != null) ? empresa.getTelefono() : ""%>" class="form-control" id="telefono" name="telefono" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="correo">Correo de contacto:</label>
                                            <input type="email" value="<%=(empresa != null) ? empresa.getCorreo() : ""%>" class="form-control" id="correo" name="correo" required>
                                        </div>
                                        <div style="text-align: right">
                                            <input type="submit" class="btn btn-primary" value="Registrar">
                                            <a href="${pageContext.request.contextPath}/usuario/" class="btn btn-danger">Cancelar</a>
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
                                        function validarRUC(event) {
                                            const input = event.target;
                                            const valor = input.value;

                                            // Remover cualquier carácter que no sea un número
                                            input.value = valor.replace(/\D/g, '');

                                            // Limitar la longitud a 13 caracteres
                                            if (input.value.length > 13) {
                                                input.value = input.value.slice(0, 13);
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

                                        function validarFormulario(event) {
                                            const rucInput = document.getElementById('ruc');
                                            if (rucInput.value.length !== 13) {
                                                event.preventDefault();
                                                rucInput.focus();
                                                alert('El RUC debe tener exactamente 13 números.');
                                            }
                                        }
        </script>

    </body>
</html>
