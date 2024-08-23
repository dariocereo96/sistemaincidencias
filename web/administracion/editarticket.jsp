<%@page import="Models.TipoTicketDAO"%>
<%@page import="Models.SubTipoTicketDAO"%>
<%@page import="Models.SubTipoTicket"%>
<%@page import="Models.TipoTicket"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.TicketDAO"%>
<%@page import="Models.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Usuario"%>
<%
    Usuario usuario = null;
    Ticket ticket = null;
    List<TipoTicket> tiposTickets = new ArrayList<TipoTicket>();
    List<SubTipoTicket> subTiposTicketsHardWare = new ArrayList<SubTipoTicket>();
    List<SubTipoTicket> subTiposTicketsSoftware = new ArrayList<SubTipoTicket>();
    List<SubTipoTicket> subTiposTicketsRed = new ArrayList<SubTipoTicket>();
    List<SubTipoTicket> subTiposTicketsUsuario = new ArrayList<SubTipoTicket>();
    List<SubTipoTicket> subTiposTicketsOtros = new ArrayList<SubTipoTicket>();

    String clase = "mostrar";

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
    } else {
        TicketDAO ticketDAO = new TicketDAO(Conexion.getConexion());
        usuario = (Usuario) request.getSession().getAttribute("usuario");
        ticket = ticketDAO.obtenerTicketId(Integer.parseInt(request.getParameter("id")));
        tiposTickets = new TipoTicketDAO(Conexion.getConexion()).obtenerTodosTipoTicket();
        subTiposTicketsHardWare = new SubTipoTicketDAO(Conexion.getConexion()).obtenerTodosSubTipoTicket(1);
        subTiposTicketsSoftware = new SubTipoTicketDAO(Conexion.getConexion()).obtenerTodosSubTipoTicket(2);
        subTiposTicketsRed = new SubTipoTicketDAO(Conexion.getConexion()).obtenerTodosSubTipoTicket(3);
        subTiposTicketsUsuario = new SubTipoTicketDAO(Conexion.getConexion()).obtenerTodosSubTipoTicket(4);
        subTiposTicketsOtros = new SubTipoTicketDAO(Conexion.getConexion()).obtenerTodosSubTipoTicket(5);
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar ticket | Sistema Gestion Incidencias</title>
        <!-- Bootstrap Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" />
        <!-- FontAwesome Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/font-awesome.css" rel="stylesheet" />
        <!-- Morris Chart Styles-->
        <link href="${pageContext.request.contextPath}/assets/js/morris/morris-0.4.3.min.css" rel="stylesheet" />
        <!-- Custom Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/custom-styles.css" rel="stylesheet" />
        <style>
            .mostrar{
                display: block;
            }

            .ocultar{
                display: none;
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
                <p style="padding: 0px 12px;font-weight: bolder;font-size: 12px"><%=usuario != null ? usuario.getNombre().toUpperCase() + " | " + usuario.getTipoUsuario().toUpperCase() : ""%></p>
                <div id="page-inner">
                    <div class="row">

                        <div class="col-md-12">
                            <h1 class="page-header" style="font-size: 24px">
                                Editar Ticket
                            </h1>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <form action="${pageContext.request.contextPath}/TicketController?action=editar" method="post">
                                        <input type="hidden" name="idTicket" value="<%= ticket != null ? ticket.getId() : "-1"%>">
                                        <div class="form-group">
                                            <label for="titulo">Asunto:</label>
                                            <input value="<%=ticket != null ? ticket.getTitulo() : ""%>" type="text" placeholder="Breve descripcion de la incidencia." class="form-control" id="titulo" name="titulo" required>
                                        </div>  

                                        <div class="form-group">
                                            <label for="lugar">Lugar de la incidencia:</label>
                                            <input value="<%=ticket != null ? ticket.getLugar() : ""%>" type="text" placeholder="Por ejemplo, area de sistemas." class="form-control" id="lugar" name="lugar" required>
                                        </div> 

                                        <div class="form-group">
                                            <label for="encargado">Encargado de la incidencia:</label>
                                            <input value="<%=ticket != null ? ticket.getEncargado() : ""%>" type="text" placeholder="Por ejemplo, usuario o empleado que pueda brindar informacion de la incidencia." class="form-control" id="encargado" name="encargado" required>
                                        </div> 

                                        <div class="form-group">
                                            <label for="tipo_id">Tipo:</label>
                                            <select class="form-control" id="tipo_id" name="tipo_id" required>
                                                <%
                                                    for (TipoTicket tipos : tiposTickets) {
                                                        boolean isSelected = tipos.getId() == ticket.getTipoId();
                                                %>
                                                <option value="<%= tipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= tipos.getTipo()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <%
                                            int tipo = ticket != null ? ticket.getTipoId() : -1;

                                            if (tipo == 1) {
                                                clase = "mostrar";
                                            } else {
                                                clase = "ocultar";
                                            }
                                        %>

                                        <div class="form-group <%=clase%>" id="div_hardware">
                                            <label for="subtipo_id">Incidencia:</label>
                                            <select class="form-control" name="subtipo_id1" required>
                                                <%                                                    for (SubTipoTicket subTipos : subTiposTicketsHardWare) {
                                                        boolean isSelected = subTipos.getId() == ticket.getIdSupTipo();
                                                %>
                                                <option value="<%= subTipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= subTipos.getNombre()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <%
                                            int tipo2 = ticket != null ? ticket.getTipoId() : -1;

                                            if (tipo2 == 2) {
                                                clase = "mostrar";
                                            } else {
                                                clase = "ocultar";
                                            }
                                        %>

                                        <div class="form-group <%=clase%>" id="div_software">
                                            <label for="subtipo_id">Incidencia:</label>
                                            <select class="form-control" name="subtipo_id2" required>
                                                <%
                                                    for (SubTipoTicket subTipos : subTiposTicketsSoftware) {
                                                        boolean isSelected = subTipos.getId() == ticket.getIdSupTipo();
                                                %>
                                                <option value="<%= subTipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= subTipos.getNombre()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <%
                                            int tipo3 = ticket != null ? ticket.getTipoId() : -1;

                                            if (tipo == 3) {
                                                clase = "mostrar";
                                            } else {
                                                clase = "ocultar";
                                            }
                                        %>
                                        <div class="form-group <%=clase%>" id="div_red">
                                            <label for="subtipo_id">Incidencia:</label>
                                            <select class="form-control" name="subtipo_id3" required>
                                                <%
                                                    for (SubTipoTicket subTipos : subTiposTicketsRed) {
                                                        boolean isSelected = subTipos.getId() == ticket.getIdSupTipo();
                                                %>
                                                <option value="<%= subTipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= subTipos.getNombre()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <%
                                            int tipo4 = ticket != null ? ticket.getTipoId() : -1;

                                            if (tipo4 == 4) {
                                                clase = "mostrar";
                                            } else {
                                                clase = "ocultar";
                                            }
                                        %>
                                        <div class="form-group <%=clase%>" id="div_usuario">
                                            <label for="tipo">Incidencia:</label>
                                            <select class="form-control" name="subtipo_id4" required>
                                                <%
                                                    for (SubTipoTicket subTipos : subTiposTicketsUsuario) {
                                                        boolean isSelected = subTipos.getId() == ticket.getIdSupTipo();
                                                %>
                                                <option value="<%= subTipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= subTipos.getNombre()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <%
                                            int tipo5 = ticket != null ? ticket.getTipoId() : -1;

                                            if (tipo5 == 5) {
                                                clase = "mostrar";
                                            } else {
                                                clase = "ocultar";
                                            }
                                        %>
                                        <div class="form-group <%=clase%>" id="div_otro">
                                            <label for="subtipo_id">Incidencia:</label>
                                            <select class="form-control" id="subtipo_id5" name="subtipo_id5" required>
                                                <%
                                                    for (SubTipoTicket subTipos : subTiposTicketsOtros) {
                                                        boolean isSelected = subTipos.getId() == ticket.getIdSupTipo();
                                                %>
                                                <option value="<%= subTipos.getId()%>" <%= isSelected ? "selected" : ""%>>
                                                    <%= subTipos.getNombre()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="prioridad">Prioridad:</label>
                                            <select class="form-control" id="prioridad" name="prioridad" required>
                                                <% if (ticket != null) {%>
                                                <option <%= "baja".equals(ticket.getPrioridad()) ? "selected" : ""%> value="baja">Baja</option>
                                                <option <%= "media".equals(ticket.getPrioridad()) ? "selected" : ""%> value="media">Media</option>
                                                <option <%= "alta".equals(ticket.getPrioridad()) ? "selected" : ""%> value="alta">Alta</option>
                                                <option <%= "critica".equals(ticket.getPrioridad()) ? "selected" : ""%> value="critica">Critica</option>
                                                <%}%>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="descripcion">Detalles de la incidencia:</label>
                                            <textarea class="form-control" id="descripcion" name="descripcion" rows="8" required><%= ticket != null ? ticket.getDescripcion().trim() : ""%></textarea>
                                        </div>    

                                        <div style="text-align: right">
                                            <button type="submit" class="btn btn-primary">Guardar Ticket</button>
                                            <a href="${pageContext.request.contextPath}/administracion/listatickets.jsp" class="btn btn-danger">Cancelar</a>
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
                    let tipo = document.getElementById('tipo_id').value;
                    let divHardware = document.getElementById('div_hardware');
                    let divSoftware = document.getElementById('div_software');
                    let divRed = document.getElementById('div_red');
                    let divUsuario = document.getElementById('div_usuario');
                    let divOtro = document.getElementById('div_otro');

                    console.log(tipo);

                    if (tipo === "1") {
                        divHardware.style.display = "block";
                        divSoftware.style.display = "none";
                        divRed.style.display = "none";
                        divUsuario.style.display = "none";
                        divOtro.style.display = "none";

                    } else if (tipo === "2") {
                        divHardware.style.display = "none";
                        divSoftware.style.display = "block";
                        divRed.style.display = "none";
                        divUsuario.style.display = "none";
                        divOtro.style.display = "none";

                    } else if (tipo === "3") {
                        divHardware.style.display = "none";
                        divSoftware.style.display = "none";
                        divRed.style.display = "block";
                        divUsuario.style.display = "none";
                        divOtro.style.display = "none";

                    } else if (tipo === "4") {
                        divHardware.style.display = "none";
                        divSoftware.style.display = "none";
                        divRed.style.display = "none";
                        divUsuario.style.display = "block";
                        divOtro.style.display = "none";
                    } else {
                        divHardware.style.display = "none";
                        divSoftware.style.display = "none";
                        divRed.style.display = "none";
                        divUsuario.style.display = "none";
                        divOtro.style.display = "block";
                    }
                }

                // Añadir el evento onchange al select
                document.getElementById('tipo_id').addEventListener('change', mostrar);
                mostrar();
            });
        </script>

    </body>
</html>
