<%@page import="Models.TipoTicketDAO"%>
<%@page import="Models.TipoTicket"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Models.UsuarioDAO"%>
<%@page import="Configurations.Conexion"%>
<%@page import="Models.Ticket"%>
<%@page import="java.util.List"%>
<%@page import="Models.TicketDAO"%>
<%@page import="Models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Ticket> tickets = new ArrayList<Ticket>();
    List<Usuario> usuariosTecnicos = new ArrayList<Usuario>();
    Usuario usuario = null;
    List<TipoTicket> tiposTickets = new ArrayList<TipoTicket>();

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
    } else {
        TicketDAO ticketDAO = new TicketDAO(Conexion.getConexion());
        UsuarioDAO usuarioDAO = new UsuarioDAO(Conexion.getConexion());
        usuario = (Usuario) request.getSession().getAttribute("usuario");

        if (usuarioDAO.validarExisteEmpresa(usuario.getId())) {

            tiposTickets = new TipoTicketDAO(Conexion.getConexion()).obtenerTodosTipoTicket();

            if (request.getParameter("idticket") != null) {
                int id = Integer.parseInt(request.getParameter("idticket").toString());
                Ticket ticket = ticketDAO.obtenerTicketId(id);

                if (ticket != null && ticket.getIdUsuario() == usuario.getId()) {
                    tickets.add(ticket);
                }

            } else if (request.getParameter("estado") != null) {
                String estado = request.getParameter("estado");
                tickets = ticketDAO.obtenerTodosTicketsUsuarioByEstado(usuario.getId(), estado);

            } else if (request.getParameter("prioridad") != null) {
                String prioridad = request.getParameter("prioridad");
                tickets = ticketDAO.obtenerTodosTicketsUsuarioByPrioridad(usuario.getId(), prioridad);

            } else {
                tickets = ticketDAO.obtenerTodosTicketsUsuario(usuario.getId());
            }

        } else {
            session.setAttribute("mensajeError", "Complete la informacion de su perfil.");
            response.sendRedirect("editarPerfil.jsp");
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
        <title>Tickets creados | Sistema Gestion Incidencias</title>
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
            }
            .btn-custom:hover{
                color:#fff;

            }
            .btn-custom{
                color:#000;
                text-decoration: none;
                color: #fff;
                border-radius: 5px;
                text-align: center;
                padding: 6px 8px;
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
                                    <a href="${pageContext.request.contextPath}/usuario/listatickets.jsp"><i class="fa fa-ticket"></i>Mis tickets creados</a>
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
                                Tickets creados
                            </h1>
                            <% if (mensajeAlerta != null) {%>
                            <div class="alert alert-success">
                                <%= mensajeAlerta%>
                            </div>
                            <% } %>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <a href="${pageContext.request.contextPath}/usuario/crearticket.jsp" class="btn btn-primary"><i class="fa fa-plus-circle" style="margin-right: 6px"></i>Registrar ticket</a>
                                    <a href="listatickets.jsp" class="btn btn-success" style="margin-left: 10px"><i class="fa fa-file" style="margin-right: 4px"></i>Listar Todo</a>
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

                                        <form>
                                            <div style="display: flex">
                                                <label style="margin-right: 10px;margin-top: 6px">ESTADO</label>
                                                <select style="margin-right: 10px;width: 170px" class="form-control" id="prioridad" name="estado" required>
                                                    <option value="abierto">ABIERTO</option>
                                                    <option value="en proceso">EN PROCESO</option>
                                                    <option value="cerrado">CERRADO</option>
                                                </select>
                                                <button class="btn btn-warning" style="color: #000;font-weight: bold">Buscar</button>
                                            </div>
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
                                                    <th>Prioridad</th>
                                                    <th>Estado</th>
                                                    <th>Fecha cierre</th>
                                                    <th>Tecnico asignado</th>
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
                                                    <td><%=ticket.getRazonSocial()%></td>
                                                    <td><%= ticket.getTitulo()%></td>
                                                    <td><span class="<%=prioridadClass%>"><%= ticket.getPrioridad()%></span></td>
                                                    <td><%= ticket.getEstado()%></td>
                                                    <td><%=ticket.getFechaResolucion() != null ? ticket.getFechaResolucion() : "-"%></td>
                                                    <td><%= (ticket.getAsignadoA() > 0) ? ticket.getNombreTecnico() : "SIN ASIGNAR"%></td>
                                                    <td>
                                                        <div style="display: flex">
                                                            <a href='#' class="btn-custom" style="background-color: #398439;margin-right: 2px;display: flex;justify-content: center" onclick="openModal('<%=ticket.getTitulo()%>', '<%=ticket.getDescripcion()%>', <%=ticket.getId()%>, '<%=ticket.getFechaCreacion()%>', '<%=ticket.getRazonSocial()%>', '<%=ticket.getLugar()%>', '<%=ticket.getEncargado()%>', '<%=ticket.getSubTipoTicket()%>', '<%=ticket.getDireccionEmpresa()%>', '<%=ticket.getTelefonoEmpresa()%> ', '<%=ticket.getComentario() != null ? ticket.getComentario() : ""%>')"><i class="fa fa-eye" style="margin-top: 2px;margin-right: 2px"></i>Ver</a>

                                                            <% if (!ticket.getEstado().equals("cerrado")) {%>
                                                            <a class="btn-custom" style="background-color: #0075b0;margin-right: 2px;display: flex;justify-content: center" href="${pageContext.request.contextPath}/usuario/editarticket.jsp?id=<%= ticket.getId()%>"><i class="fa fa-edit" style="margin-top: 2px;margin-right: 2px"></i>Editar</a>
                                                            <a class="btn-custom" style="background-color: #c12e2a;display: flex;justify-content:center" onclick="return confirm('¿Estás seguro de que deseas descartar eL ticket #<%=ticket.getId()%> ?')" href='${pageContext.request.contextPath}/TicketController?action=eliminar&id=<%= ticket.getId()%>'><i class="fa fa-minus-circle" style="margin-top: 2px;margin-right: 2px"></i>Descartar</a>
                                                            <%} else {%>
                                                            <button class="btn-custom" style="background-color: #CFCECE;margin-right: 2px;border: none;display: flex;justify-content: center"><i class="fa fa-edit" style="margin-top: 2px;margin-right: 2px"></i>Editar</button>
                                                            <button class="btn-custom" style="background-color: #CFCECE;margin-right: 2px;border: none;display: flex;justify-content: center"><i class="fa fa-minus-circle" style="margin-top: 2px;margin-right: 2px"></i>Descartar</button>
                                                            <%}%>
                                                        </div>
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

                            <div class="row" style="margin-bottom: 15px">
                                <div class="col-md-12">
                                    <label>Comentario del Tecnico</label>
                                    <textarea class="form-control" id="comentario" name="comentario" rows="5" readonly="true"></textarea>
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
                                                                function openModal(titulo, descripcion, idTicket, fecha, empresa, lugar, resposable, tipo, direccion, telefono, comentario) {
                                                                    // Abrir el modal
                                                                    $('#titulo').val(titulo);
                                                                    $('#fecha').val(fecha);
                                                                    $('#empresa').val(empresa);
                                                                    $('#lugar').val(lugar);
                                                                    $('#responsable').val(resposable);
                                                                    $('#tipoIncidencia').val(tipo);
                                                                    $('#descripcion').val(descripcion);
                                                                    $('#direccion').val(direccion);
                                                                    $('#telefono').val(telefono);
                                                                    $('#comentario').val(comentario);
                                                                    $('#idTicket').val(idTicket);
                                                                    $('#myModalLabel').text('Detalles del Ticket #' + idTicket);
                                                                    $('#myModal').modal('show');
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
