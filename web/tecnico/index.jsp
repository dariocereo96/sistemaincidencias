<%@page import="Configurations.Conexion"%>
<%@page import="Models.TicketDAO"%>
<%@page import="java.util.List"%>
<%@page import="Models.TicketConteo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Usuario"%>

<%
    Usuario usuario = null;
    List<TicketConteo> ticketsConteo = null;
    int total = 0;
    int totalPendientes = 0;
    int totalAsignados = 0;
    int totalCerrado = 0;

    if (request.getSession().getAttribute("usuario") == null) {
        System.out.println("No hay sesion iniciada");
        response.sendRedirect(request.getContextPath() + "/auth/");
        return;
    } else {
        usuario = (Usuario) request.getSession().getAttribute("usuario");

        ticketsConteo = new TicketDAO(Conexion.getConexion()).contarTicketsTecnico(usuario.getId());

        for (TicketConteo t : ticketsConteo) {
            total += t.getTotal();

            if (t.getEstado().equals("abierto")) {
                totalPendientes = t.getTotal();

            }

            if (t.getEstado().equals("en proceso")) {
                totalAsignados = t.getTotal();
            }

            if (t.getEstado().equals("cerrado")) {
                totalCerrado = t.getTotal();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home | Sistema Gestion Incidencias</title>
        <!-- Bootstrap Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" />
        <!-- FontAwesome Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/font-awesome.css" rel="stylesheet" />
        <!-- Morris Chart Styles-->
        <link href="${pageContext.request.contextPath}/assets/js/morris/morris-0.4.3.min.css" rel="stylesheet" />
        <!-- Custom Styles-->
        <link href="${pageContext.request.contextPath}/assets/css/custom-styles.css" rel="stylesheet" />
        <style>
            a:hover{
                text-decoration: none;
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
                            <a class="active-menu" href="${pageContext.request.contextPath}/tecnico/"><i class="fa fa-dashboard"></i> Dashboard</a>
                        </li>

                        <li>
                            <a href="#"><i class="fa fa-list"></i>Incidencias<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="${pageContext.request.contextPath}/tecnico/listatickets.jsp"><i class="fa fa-ticket"></i>Tickets asignados</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/tecnico/listaticketscerrados.jsp"><i class="fa fa-ticket"></i>Tickets cerrados</a>
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
                                Dashboard | Tecnico
                            </h1>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <div class="row" style="padding: 10px">
                                        <div class="col-md-4">
                                            <div  style="background-color: #e38d13;text-align: center;color: #fff;border-radius: 10px">
                                                <p style="font-size: 12px;font-weight: bold;">TOTAL TICKETS</p>
                                                <i class="fa fa-ticket" style="font-size: 40px"></i>
                                                <p><%=total%></p>
                                            </div>  
                                        </div> 

                                        <div class="col-md-4">
                                            <a href="listatickets.jsp">
                                                <div  style="background-color: #0075b0;text-align: center;color: #fff;border-radius: 10px">
                                                    <p style="font-size: 12px;font-weight: bold;">TICKETS ASIGNADOS</p>
                                                    <i class="fa fa-ticket" style="font-size: 40px"></i>
                                                    <p><%=totalAsignados%></p>
                                                </div>
                                            </a>
                                        </div>

                                        <div class="col-md-4">
                                            <a href="listaticketscerrados.jsp">
                                                <div style="background-color: #3c763d;text-align: center;color: #fff;border-radius: 10px">
                                                    <p style="font-size: 12px;font-weight: bold;">TICKETS CERRADOS</p>
                                                    <i class="fa fa-ticket" style="font-size: 40px"></i>
                                                    <p><%=totalCerrado%> </p>
                                                </div>
                                            </a>
                                        </div>
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