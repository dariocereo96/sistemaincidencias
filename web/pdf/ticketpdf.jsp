<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="com.itextpdf.text.Phrase"%>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="Models.Ticket"%>
<%@page import="Models.TicketDAO"%>
<%@page import="Configurations.Conexion"%>
<%@page import="com.itextpdf.text.PageSize"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.Element"%>
<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@ page contentType="application/pdf" %>
<%@ page language="java" %>

<%

    TicketDAO ticketDAO = new TicketDAO(Conexion.getConexion());
    Ticket ticket = ticketDAO.obtenerTicketId(Integer.parseInt(request.getParameter("id")));

    // Crear el documento PDF
    Document document = new Document(PageSize.A4);
    PdfWriter.getInstance(document, response.getOutputStream());

    // Abrir el documento
    document.open();

    // Ruta de la imagen
    String imagePath = application.getRealPath("/img/logo.jpeg");

    // Cargar la imagen
    Image logo = Image.getInstance(imagePath);

    // Ajustar tamaño de la imagen (opcional)
    logo.scaleToFit(50, 50); // Cambia las dimensiones según lo necesites

    // Alinear la imagen (opcional)
    logo.setAlignment(Image.ALIGN_LEFT);

    // Agregar cabecera
    PdfPTable tableCabecera = new PdfPTable(2); // 2 columnas
    tableCabecera.setWidthPercentage(100);

    // Agregar celdad imagen
    PdfPCell cellLogo = new PdfPCell(logo);
    cellLogo.setBorder(PdfPCell.NO_BORDER);
    tableCabecera.addCell(cellLogo);

    // Obtener la fecha actual
    java.util.Date date = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    String fechaActual = sdf.format(date);

    // Agregar celdad fecha actual
    PdfPCell cellTexto = new PdfPCell(new Phrase("FECHA DE ELABORACION: "+fechaActual, new Font(Font.FontFamily.HELVETICA, 8    ,Font.BOLD)));
    cellTexto.setBorder(PdfPCell.NO_BORDER);
    cellTexto.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cellTexto.setVerticalAlignment(Element.ALIGN_BOTTOM);
    tableCabecera.addCell(cellTexto);

    // Añadir la tabla cabecera al documento
    document.add(tableCabecera);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el encabezado
    Paragraph encabezado = new Paragraph("REPORTE DE TICKET #" + ticket.getId(), new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
    encabezado.setAlignment(Element.ALIGN_LEFT);
    document.add(encabezado);
    document.add(new Paragraph("\n"));

    // Convertir el color hexadecimal a BaseColor
    BaseColor customColor = new BaseColor(184, 205, 241);

    // Crear una tabla con 4 columnas
    PdfPTable table = new PdfPTable(4); // 2 columnas
    table.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell;

    // Campo "ESTADO"
    cell = new PdfPCell(new Phrase("CREADO", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getFechaCreacion(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Campo "EMPRESA"
    cell = new PdfPCell(new Phrase("EMPRESA", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getRazonSocial(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Campo "PRIORIDAD"
    cell = new PdfPCell(new Phrase("PRIORIDAD", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getPrioridad().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Campo "LUGAR"
    cell = new PdfPCell(new Phrase("DIRECCION", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getDireccionEmpresa().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Campo "TIPO DE INCIDENCIA"
    cell = new PdfPCell(new Phrase("TIPO DE INCIDENCIA", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getTipoTicket().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Campo "PROBLEMA"
    cell = new PdfPCell(new Phrase("PROBLEMA", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    cell.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table.addCell(cell);

    cell = new PdfPCell(new Phrase(ticket.getSubTipoTicket().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell.setBorder(PdfPCell.NO_BORDER);
    cell.setHorizontalAlignment(Element.ALIGN_LEFT); // Alinear a la derecha
    cell.setPadding(10f); // Añadir padding
    table.addCell(cell);

    // Añadir la tabla al documento
    document.add(table);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el detalle
    Paragraph asunto = new Paragraph("ASUNTO", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
    asunto.setAlignment(Element.ALIGN_LEFT);
    document.add(asunto);
    document.add(new Paragraph("\n"));

    // Crear una tabla con 1 columnas
    PdfPTable table2 = new PdfPTable(1); // 2 columnas
    table2.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell2;

    // Campo "ESTADO"
    cell2 = new PdfPCell(new Phrase(ticket.getTitulo().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell2.setPadding(10f); // Añadir padding
    cell2.setBorder(PdfPCell.NO_BORDER);
    cell2.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table2.addCell(cell2);

    document.add(table2);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el detalle
    Paragraph tecnico = new Paragraph("TECNICO ASIGNADO", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
    tecnico.setAlignment(Element.ALIGN_LEFT);
    document.add(tecnico);
    document.add(new Paragraph("\n"));

    // Crear una tabla con 1 columnas
    PdfPTable table3 = new PdfPTable(1); // 2 columnas
    table3.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell3;

    // Campo "ESTADO"
    cell3 = new PdfPCell(new Phrase(ticket.getNombreTecnico().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell3.setPadding(10f); // Añadir padding
    cell3.setBorder(PdfPCell.NO_BORDER);
    cell3.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table3.addCell(cell3);

    document.add(table3);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el detalle
    Paragraph detalle = new Paragraph("DESCRIPCION DE LA INCIDENCIA", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
    detalle.setAlignment(Element.ALIGN_LEFT);
    document.add(detalle);
    document.add(new Paragraph("\n"));

    // Crear una tabla con 1 columnas
    PdfPTable table4 = new PdfPTable(1);
    table4.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell4;

    // Campo "ESTADO"
    cell4 = new PdfPCell(new Phrase(ticket.getDescripcion().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell4.setPadding(10f); // Añadir padding
    cell4.setBorder(PdfPCell.NO_BORDER);
    cell4.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table4.addCell(cell4);

    document.add(table4);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el detalle
    Paragraph fechaCierre = new Paragraph("FECHA DE CIERRE", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
    fechaCierre.setAlignment(Element.ALIGN_LEFT);
    document.add(fechaCierre);
    document.add(new Paragraph("\n"));

    // Crear una tabla con 1 columnas
    PdfPTable table5 = new PdfPTable(1);
    table5.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell5;

    // Campo "ESTADO"
    cell5 = new PdfPCell(new Phrase(ticket.getFechaResolucion(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell5.setPadding(10f); // Añadir padding
    cell5.setBorder(PdfPCell.NO_BORDER);
    cell5.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table5.addCell(cell5);

    document.add(table5);

    // Salto
    document.add(new Paragraph("\n"));

    // Agregar el detalle
    Paragraph comentario = new Paragraph("SOLUCION", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
    fechaCierre.setAlignment(Element.ALIGN_LEFT);
    document.add(comentario);
    document.add(new Paragraph("\n"));

    // Crear una tabla con 1 columnas
    PdfPTable table6 = new PdfPTable(1);
    table6.setWidthPercentage(100);

    // Añadir las celdas con la información del ticket (sin bordes, con padding y color de fondo)
    PdfPCell cell6;

    // Campo "ESTADO"
    cell6 = new PdfPCell(new Phrase(ticket.getComentario().toUpperCase(), new Font(Font.FontFamily.HELVETICA, 10)));
    cell6.setPadding(10f); // Añadir padding
    cell6.setBorder(PdfPCell.NO_BORDER);
    cell6.setBackgroundColor(customColor); // Cambiar color de fondo a gris claro
    table6.addCell(cell6);

    document.add(table6);

    // Salto
    document.add(new Paragraph("\n"));

    //Cerrar el documento
    document.close();
%>