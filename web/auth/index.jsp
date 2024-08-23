<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String mensajeAlerta = (String) session.getAttribute("mensajeAlerta");
    String mensajeError = (String) session.getAttribute("mensajeError");

    if (mensajeAlerta != null) {
        session.removeAttribute("mensajeAlerta");
    }

    if (mensajeError != null) {
        session.removeAttribute("mensajeError");
    }


%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link href="https://fonts.googleapis.com/css?family=Raleway:400,500,600,700" rel="stylesheet">
        <title>Login | Sistema Incidencias</title>
        <style>
            body{
                font-family: 'Raleway',sans-serif
            }
        </style>
    </head>
    <body>
        <main>
            <div class="contenedor__todo">
                <div class="caja__trasera">
                    <div class="caja__trasera-login">
                        <h3>¿YA TIENES CUENTA?</h3>
                        <p>Inicia sesión para entrar en la página</p>
                        <button type="button" id="btn__iniciar-sesion">Iniciar sesión</button>
                    </div>
                    <div class="caja__trasera-register">
                        <h3>¿AÚN NO TIENES CUENTA?</h3>
                        <p>Regístrate para que puedas iniciar sesión</p>
                        <button type="button" id="btn__registrase">Registrarse</button>
                    </div>
                </div>

                <div class="contenedor_-login-register">
                    <form action="${pageContext.request.contextPath}/UsuarioController?action=login" method="POST"  class="formulario__login">
                        <h2>Iniciar sesión</h2>
                        <% if (mensajeError != null) {%>
                        <p style="font-size:12px;color:red;font-weight:bold"><%=mensajeError%></p>
                        <% } %>

                        <% if (mensajeAlerta != null) {%>
                        <p style="font-size:12px;color:#0b2e13;font-weight:bold"><%=mensajeAlerta%></p>
                        <%}%>

                        <input type="text" placeholder="Correo o usuario" name="correoLogin" required=""> 
                        <input type="password" placeholder="Contraseña" name="contrasenaLogin" required="">
                        <button type="submit" name="accion" value="IniciarSesion">Entrar</button>

                    </form>
                    <form action="${pageContext.request.contextPath}/UsuarioController?action=registrar" method="POST"  class="formulario__register">
                        <h2>Registrarse</h2>
                        <input type="text" placeholder="Nombre de usuario" name="nombre" required="">
                        <input type="text" placeholder="Correo Electrónico" name="correo" required="">
                        <input type="password" placeholder="Contraseña" name="contrasena" required="">
                        <input type="submit" name="accion" value="Registrarse">
                    </form>
                </div>
            </div>
        </main>
        <script src="${pageContext.request.contextPath}/js/script.js"></script>
    </body>
</html>