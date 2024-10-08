<%@page import="Models.EmpresaDAO"%>
<%@page import="Models.Empresa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.UsuarioDAO"%>
<%@page import="Models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Empresa> listaEmpresas = new ArrayList<Empresa>();
    Usuario usuario = null;

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        EmpresaDAO empresaDAO = new EmpresaDAO(Conexion.getConexion());
        
        usuario = (Usuario) request.getSession().getAttribute("usuario");
        
        List<Empresa> lista = empresaDAO.obtenerEmpresas();
         
        if (request.getParameter("inactivo") != null) {
            for(Empresa empresa: lista ){
                if(empresa.getEstado()==0){
                     listaEmpresas.add(empresa);
                }
            }
            
        }else{
            for(Empresa empresa: lista ){
                
                if(empresa.getEstado()==1){
                     listaEmpresas.add(empresa);
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
        <title>Empresas | Sistema Gestion Incidencias</title>
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
                                    int rol3 = usuario != null ? usuario.getRolId() : -1;
                                    if (rol3 == 5) {
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
                            <h1 class="page-header" style="font-size: 24px">
                                Lista empresas
                            </h1>
                            <% if (mensajeAlerta != null) {%>
                            <div class="alert alert-success">
                                <%= mensajeAlerta%>
                            </div>
                            <% } %>

                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <%
                                        int rol4 = usuario != null ? usuario.getRolId() : -1;
                                        if (rol4 == 5) {
                                    %>
                                    <a href="${pageContext.request.contextPath}/administracion/registrarEmpresa.jsp" class="btn btn-primary" style="margin-right: 20px"><i class="fa fa-plus-circle" style="margin-right: 6px"></i>Registrar empresa</a>
                                    <%}%>
                                    
                                    <a href="${pageContext.request.contextPath}/administracion/listaEmpresas.jsp" class="btn btn-success"><i class="fa fa-file" style="margin-right: 6px"></i>Empresas Activas</a>
                                    <a href="${pageContext.request.contextPath}/administracion/listaEmpresas.jsp?inactivo=0" class="btn btn-danger"><i class="fa fa-file" style="margin-right: 6px"></i>Empresas Inactivas</a>
                                    
                                    <table class="table table-striped table-bordered table-hover" style="margin-top: 10px">
                                        <thead style="font-size: 12px;text-align: center">
                                            <tr>
                                                <th>RUC</th>
                                                <th>Razón Social</th>
                                                <th>Dirección</th>
                                                <th>Telefono</th>
                                                <th>Correo</th>
                                                <th>Usuario</th>
                                                <th>Estado</th>
                                                    <%
                                                        int rol5 = usuario != null ? usuario.getRolId() : -1;
                                                        if (rol5 == 5) {
                                                    %>
                                                <th>Acciones</th>
                                                    <%}%>
                                            </tr>
                                        </thead>
                                        <tbody style="font-size: 13px;">
                                            <% if (!listaEmpresas.isEmpty()) {
                                                    for (Empresa empresa : listaEmpresas) {%>
                                            <tr>
                                                <td><%= empresa.getRuc()%></td>
                                                <td><%= empresa.getRazonSocial()%></td>
                                                <td><%= empresa.getDireccion()%></td>
                                                <td><%= empresa.getTelefono()%></td>
                                                <td><%= empresa.getCorreo()%></td>
                                                <td><%= (empresa.getUsername() != null) ? empresa.getUsername() : "No asignado"%></td>
                                                <td><%= (empresa.getEstado() == 1) ? "Activo" : "Inactivo"%></td>
                                                <%
                                                    int rol6 = usuario != null ? usuario.getRolId() : -1;
                                                    if (rol6 == 5) {
                                                %>
                                                <td style="display: flex;">
                                                    <a class="btn-custom" style="background-color: #0088cc;display: flex;margin-right: 2px;justify-content: center" href="${pageContext.request.contextPath}/administracion/editarEmpresa.jsp?id=<%= empresa.getId()%>"><i class="fa fa-edit" style="margin-top: 2px;margin-right: 2px"></i>Editar</a>
                                                    <%if (empresa.getEstado() == 1) {%>
                                                    <a class="btn-custom" style="background-color: #F0433D;display: flex;justify-content: center;width: 100%" href="${pageContext.request.contextPath}/EmpresaController?action=cambiarEstado&id=<%= empresa.getId()%>&valor=0"><i class="fa fa-minus-circle" style="margin-top: 2px;margin-right: 2px"></i>Desactivar</a>
                                                    <%} else {%>
                                                    <a class="btn-custom" style="background-color: #398439;display: flex;justify-content: center;width: 100%" href="${pageContext.request.contextPath}/EmpresaController?action=cambiarEstado&id=<%= empresa.getId()%>&valor=1"><i class="fa fa-minus-circle" style="margin-top: 2px;margin-right: 2px"></i>Activar</a>
                                                    <% } %>
                                                </td>
                                                <%}%>
                                            </tr>
                                            <% }
                                            } else { %>
                                            <tr>
                                                <td colspan="7">No hay usuarios disponibles</td>
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