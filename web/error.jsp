<%-- 
    Document   : error
    Created on : 24/07/2024, 22:15:46
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error | Sistema Incidencias</title>
    </head>
    <body>
        <% if (request.getAttribute("mensaje") != null) {%>
            <p style="font-size:15px;font-weight:bold"><%=request.getAttribute("mensaje")%></p>
        <%}%>
    </body>
</html>
