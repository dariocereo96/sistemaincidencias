<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Models.TipoTicketDAO"%>
<%@page import="Models.TipoTicket"%>
<%@page import="java.sql.Array"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.UsuarioDAO"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.Ticket"%>
<%@page import="java.util.List"%>
<%@page import="Models.TicketDAO"%>
<%@page import="Models.Usuario"%>

<%
    Usuario usuario = null;
    List<Ticket> tickets = new ArrayList<Ticket>();
    List<Usuario> usuariosTecnicos = new ArrayList<Usuario>();
    List<TipoTicket> tiposTickets = new ArrayList<TipoTicket>();

    // Crear un formato de fecha
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // Obtener la fecha actual
    String today = sdf.format(new Date());

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        usuario = (Usuario) request.getSession().getAttribute("usuario");
        TicketDAO ticketDAO = new TicketDAO(Conexion.getConexion());
        UsuarioDAO usuarioDAO = new UsuarioDAO(Conexion.getConexion());

        tiposTickets = new TipoTicketDAO(Conexion.getConexion()).obtenerTodosTipoTicket();

        usuariosTecnicos = usuarioDAO.obtenerTodosUsuariosTecnicos();

        if (request.getParameter("idticket") != null) {
            int id = Integer.parseInt(request.getParameter("idticket").toString());
            Ticket ticket = ticketDAO.obtenerTicketId(id);

            if (ticket != null && ticket.getEstado().equalsIgnoreCase("abierto")) {
                tickets.add(ticket);
            }

        } else if (request.getParameter("idtipo") != null) {

            int idTipo = Integer.parseInt(request.getParameter("idtipo").toString());

            tickets = ticketDAO.obtenerTodosTicketsPendientesByTipo(idTipo);

        } else if (request.getParameter("prioridad") != null) {

            String prioridad = request.getParameter("prioridad");

            tickets = ticketDAO.obtenerTodosTicketsPendientesByPrioridad(prioridad);

        } else if (request.getParameter("fechaInicio") != null && request.getParameter("fechaFinal") != null) {
            // Formato de la fecha y hora en el string
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

            // Fechas ingresadas por el usuario (convertidas a LocalDate)
            LocalDate fechaInicio = LocalDate.parse(request.getParameter("fechaInicio"), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            LocalDate fechaFinal = LocalDate.parse(request.getParameter("fechaFinal"), DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            // Obtener la lista de tickets
            List<Ticket> lista = ticketDAO.obtenerTodosTicketsPendientes();

            // Filtrar la lista usando un bucle for
            for (Ticket ticket : lista) {
                // Parsear la cadena de fecha y hora a LocalDateTime usando el formato completo
                LocalDateTime fechaRegistro = LocalDateTime.parse(ticket.getFechaCreacion(), formatter);

                // Extraer la fecha (sin hora) para la comparación
                LocalDate fechaRegistroSoloFecha = fechaRegistro.toLocalDate();

                // Verificar si la fecha del ticket está dentro del rango
                if (!fechaRegistroSoloFecha.isBefore(fechaInicio) && !fechaRegistroSoloFecha.isAfter(fechaFinal)) {
                    tickets.add(ticket);
                }
            }

        } else {
            tickets = ticketDAO.obtenerTodosTicketsPendientes();
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
        <title>Tickets pendientes | Sistema Gestion Incidencias</title>
        <!-- Bootstrap Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" />
        <!-- FontAwesome Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/font-awesome.css" rel="stylesheet" />
        <!-- Morris Chart Styles-->
        <link href="${pageContext.request.contextPath}/assets/js/morris/morris-0.4.3.min.css" rel="stylesheet" />
        <!-- Custom Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/custom-styles.css" rel="stylesheet" />
        <style>
            .prioridad-baja {
                background-color: #d4edda;
                padding: 8px;
                border-radius: 10px;
            }
            .prioridad-media {
                background-color: #fff3cd; 
                padding: 8px;
                border-radius: 10px;
            }
            .prioridad-alta {
                background-color: #f8d7da;
                padding: 8px;
                border-radius: 10px;
            }
            .prioridad-critica {
                background-color: #c12e2a;
                padding: 8px;
                border-radius: 10px;
                color:#fff;
            }

            .btn-custom{
                color:#000;
                text-decoration: none;
                color: #fff;
                border-radius: 5px;
                text-align: center;
                padding: 6px 8px;
                margin-right: 4px;  
            }

            .btn-custom:hover{
                color:#fff;

            }

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
                            <h1 class="page-header" style="font-size: 24px">
                                Tickets Pendientes
                            </h1>
                            <% if (mensajeAlerta != null) {%>
                            <div class="alert alert-success">
                                <%= mensajeAlerta%>
                            </div>
                            <% } %>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <div>
                                        <%
                                            int rol4 = usuario != null ? usuario.getRolId() : -1;
                                            if (rol4 == 5) {
                                        %>
                                        <a href="${pageContext.request.contextPath}/administracion/crearticket.jsp" style="margin-right: 10px" class="btn btn-primary"><i class="fa fa-plus-circle" style="margin-right: 6px"></i>Registrar ticket</a>
                                        <%}%>

                                        <a href="listatickets.jsp" class="btn btn-success"><i class="fa fa-file" style="margin-right: 4px"></i>Listar Todo</a>
                                    </div>

                                    <div style="display: flex;margin: 30px 0px">
                                        <form style="margin-right: 20px">
                                            <div style="display: flex">
                                                <label style="margin-right: 10px;margin-top: 6px">ID</label>
                                                <input oninput="validarNumeros(event)" name="idticket" style="margin-right: 10px;width: 170px" class="form-control" required type="text"/>
                                                <button class="btn btn-warning" style="color: #000;font-weight: bold">Buscar</button>
                                            </div>
                                        </form>

                                        <form style="margin-right: 20px"> 
                                            <div style="display: flex">
                                                <label style="margin-right: 10px;margin-top: 6px">TIPO</label>
                                                <select style="margin-right: 10px;width: 170px" class="form-control" name="idtipo" required>
                                                    <%
                                                        for (TipoTicket tipos : tiposTickets) {
                                                    %>
                                                    <option value="<%= tipos.getId()%>"><%= tipos.getTipo()%></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                                <button class="btn btn-warning" style="color: #000;font-weight: bold">Buscar</button>
                                            </div>
                                        </form>

                                        <form style="margin-right: 60px">
                                            <div style="display: flex">
                                                <label style="margin-right: 10px;margin-top: 6px">PRIORIDAD</label>
                                                <select style="margin-right: 10px;width: 170px" class="form-control" id="prioridad" name="prioridad" required>
                                                    <option value="baja">Baja</option>
                                                    <option value="media">Media</option>
                                                    <option value="alta">Alta</option>
                                                    <option value="critica">Critica</option>
                                                </select>
                                                <button class="btn btn-warning" style="color: #000;font-weight: bold">Buscar</button>
                                            </div>
                                        </form>            
                                    </div>

                                    <div>
                                        <form style="display: flex;margin-bottom: 20px">
                                            <div style="display: flex; margin-right: 10px">
                                                <label style="margin-right: 10px; margin-top: 6px">INICIO</label>
                                                <input type="date" max="<%= today%>" required="" class="form-control" name="fechaInicio" value="<%= today%>"/>
                                            </div>

                                            <div style="display: flex; margin-right: 10px">
                                                <label style="margin-right: 10px; margin-top: 6px">FINAL</label>
                                                <input type="date" max="<%= today%>" required="" class="form-control" name="fechaFinal" value="<%= today%>"/>
                                            </div>

                                            <button class="btn btn-warning" style="color: #000; font-weight: bold">Buscar</button>
                                        </form>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table table-striped table-bordered table-hover" style="margin-top: 10px">
                                            <thead style="font-size: 12px;text-align: center">
                                                <tr style="">
                                                    <th>Codigo</th>
                                                    <th>Fecha</th>
                                                    <th>Empresa</th>
                                                    <th>Asunto</th>
                                                    <th>Tipo</th>
                                                    <th>Prioridad</th>
                                                    <th>Estado</th>
                                                    <th>Acciones</th>   
                                                </tr>
                                            </thead>
                                            <tbody style="font-size: 13px;">
                                                <% if (tickets.isEmpty()) { %>
                                                <tr>
                                                    <td colspan="9" class="text-center">No hay datos disponibles.</td>
                                                </tr>
                                                <% } else { %>
                                                <% for (Ticket ticket : tickets) {
                                                        String prioridadClass = "";
                                                        if ("baja".equals(ticket.getPrioridad())) {
                                                            prioridadClass = "prioridad-baja";
                                                        } else if ("media".equals(ticket.getPrioridad())) {
                                                            prioridadClass = "prioridad-media";
                                                        } else if ("alta".equals(ticket.getPrioridad())) {
                                                            prioridadClass = "prioridad-alta";
                                                        } else if ("critica".equals(ticket.getPrioridad())) {
                                                            prioridadClass = "prioridad-critica";
                                                        }
                                                %>
                                                <tr>
                                                    <td><%= ticket.getId()%></td>
                                                    <td><%= ticket.getFechaCreacion()%></td>
                                                    <td><%= ticket.getRazonSocial()%></td>
                                                    <td><%= ticket.getTitulo()%></td>
                                                    <td><%= ticket.getTipoTicket()%></td>
                                                    <td><span class="<%=prioridadClass%>"><%= ticket.getPrioridad()%></span></td>
                                                    <td><%= ticket.getEstado()%></td>
                                                    <td style="display: flex;border:none">
                                                        <a href='#' class="btn-custom" style="background-color: #0075b0;margin-right: 2px;display: flex;justify-content: " onclick="openModal('<%=ticket.getTitulo()%>', '<%=ticket.getDescripcion()%>', <%=ticket.getId()%>, '<%=ticket.getFechaCreacion()%>', '<%=ticket.getRazonSocial()%>', '<%=ticket.getLugar()%>', '<%=ticket.getEncargado()%>', '<%=ticket.getSubTipoTicket()%>', '<%=ticket.getDireccionEmpresa()%>', '<%=ticket.getTelefonoEmpresa()%> ')"><i class="fa fa-eye" style="margin-top: 2px;margin-right: 2px"></i>Ver</a>
                                                        <%
                                                            int rol3 = usuario != null ? usuario.getRolId() : -1;
                                                            if (rol3 == 5) {
                                                        %>
                                                        <a href="${pageContext.request.contextPath}/administracion/editarticket.jsp?id=<%= ticket.getId()%>" class="btn-custom" style="background-color: #e38d13;margin-right: 2px;display: flex"><i class="fa fa-edit" style="margin-top: 2px;margin-right: 2px"></i>Editar</a>
                                                        <a href='#' class="btn-custom" style="background-color: #398439;margin-right: 2px;display: flex;justify-content: center" onclick="openModal2('<%=ticket.getTitulo()%>', '<%=ticket.getRazonSocial()%>', '<%=ticket.getId()%>', '')"><i class="fa fa-user" style="margin-top: 2px;margin-right: 2px"></i> Asignar</a>
                                                        <a class="btn-custom" style="background-color: #c12e2a;display: flex;justify-content: center" onclick="return confirm('¿Estás seguro de que deseas descartar eL ticket #<%=ticket.getId()%> ?')" href='${pageContext.request.contextPath}/TicketController?action=eliminar&id=<%= ticket.getId()%>'><i class="fa fa-minus-circle" style="margin-top: 2px;margin-right: 2px"></i> Descartar</a>
                                                        <%}%>
                                                    </td>
                                                </tr>
                                                <% } %>
                                                <% }%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>               
                        </div>
                    </div>
                </div>
                <!-- /. PAGE INNER  -->
            </div>
            <!-- /. PAGE WRAPPER  -->
        </div>

        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form>
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 class="modal-title" id="myModalLabel">Detalles del Ticket</h4>
                        </div>
                        <div class="modal-body">
                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-6">
                                    <label>Asunto</label>
                                    <input type="text" id="titulo" class="form-control" readonly="true"/>
                                </div>

                                <div class="col-md-6">
                                    <label>Fecha</label>
                                    <input type="text" id="fecha" class="form-control" readonly="true"/>
                                </div>
                            </div>

                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-6">
                                    <label>Empresa</label>
                                    <input type="text" id="empresa" class="form-control" readonly="true"/>
                                </div>

                                <div class="col-md-6">
                                    <label>Telefono</label>
                                    <input type="text" id="telefono" class="form-control" readonly="true"/>
                                </div>
                            </div>

                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-6">
                                    <label>Dirección</label>
                                    <input type="text" id="direccion" class="form-control" readonly="true"/>
                                </div>
                                <div class="col-md-6">
                                    <label>Lugar de Incidencia</label>
                                    <input type="text" id="lugar" class="form-control" readonly="true"/>
                                </div>
                            </div>

                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-6">
                                    <label>Contacto <span style="font-size: 11px;color: #9d9d9d">(Usuario que genero la incidencia)</span></label>
                                    <input type="text" id="responsable" class="form-control" readonly="true"/>
                                </div>

                                <div class="col-md-6">
                                    <label>Tipo de Incidencia</label>
                                    <input type="text" id="tipoIncidencia" class="form-control" readonly="true"/>
                                </div>
                            </div>

                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-12">
                                    <label>Descripción</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" rows="5" readonly="true"></textarea>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true" style="display: none;">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/TicketController?action=asignarTecnico" method="post" id="formulario">
                        <input type="hidden" name="idTicket" id="idTicket" value="-1">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 class="modal-title" id="myModalLabel2">Asignar Ticket</h4>
                        </div>
                        <div class="modal-body">
                            <label>Asunto</label>
                            <input type="text" id="titulo2" class="form-control" readonly="true"/>

                            <label style="margin-top: 20px">Empresa</label>
                            <input type="text" id="empresa2" class="form-control" readonly="true"/>

                            <label style="margin-top: 20px">Tecnico</label>
                            <select name="idTecnico" class="form-control">
                                <%
                                    for (Usuario tecnico : usuariosTecnicos) {
                                %>
                                <option value="<%= tecnico.getId()%>"><%= tecnico.getNombreCompletoUsuario()%></option>
                                <%
                                    }
                                %>
                            </select>

                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="guardar()" class="btn btn-primary">Asignar</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                        </div>
                    </form>
                </div>
            </div>
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
            function openModal(titulo, descripcion, idTicket, fecha, empresa, lugar, resposable, tipo, direccion, telefono) {

                // Abrir el modal
                $('#titulo').val(titulo);
                $('#fecha').val(fecha);
                $('#empresa').val(empresa);
                $('#lugar').val(lugar);
                $('#responsable').val(resposable);
                $('#tipoIncidencia').val(tipo);
                $('#descripcion').val(descripcion);
                $('#idTicket').val(idTicket);
                $('#direccion').val(direccion);
                $('#telefono').val(telefono);
                $('#myModalLabel').text('Detalles del Ticket #' + idTicket);
                $('#myModal').modal('show');
            }

            function openModal2(titulo, razon, idTicket) {
                $('#idTicket').val(idTicket);
                $('#titulo2').val(titulo);
                $('#empresa2').val(razon);
                $('#myModalLabel2').text('Asignar Ticket #' + idTicket);
                $('#myModal2').modal('show');
            }

            function guardar() {
                document.getElementById('formulario').submit();
            }

            function validarNumeros(event) {
                const input = event.target;
                const value = input.value;

                // Expresión regular para remover cualquier carácter que no sea un número
                input.value = value.replace(/\D/g, '');

                // Opcional: Mostrar mensaje de error si se desea informar al usuario
                const errorMessage = document.getElementById('error-message');
                if (input.value !== value) {
                    errorMessage.textContent = 'El campo solo debe contener números.';
                } else {
                    errorMessage.textContent = '';
                }
            }

        </script>
    </body>
</html>
