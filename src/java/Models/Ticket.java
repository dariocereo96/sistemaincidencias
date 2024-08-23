/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Models;

/**
 *
 * @author HP
 */
public class Ticket {

    private int id;
    private String titulo;
    private String descripcion;
    private int tipoId;
    private String prioridad;
    private String estado;
    private String fechaCreacion;
    private String fechaResolucion;
    private int asignadoA;
    private String tipoTicket;
    private String nombreTecnico;
    private int idUsuario;
    private String lugar;
    private String encargado;
    private int idSupTipo;
    private String razonSocial;
    private String subTipoTicket;
    private String comentario;
    private String direccionEmpresa;
    private String telefonoEmpresa;
    private String emailEmpresa;

    public Ticket() {

    }

    public Ticket(int id,
            String titulo,
            String descripcion,
            int tipoId,
            String prioridad,
            String estado,
            String fechaCreacion,
            String fechaResolucion,
            int asignadoA,
            String tipoTicket,
            String nombreTecnico,
            int idUsuario,
            String lugar,
            String encargado,
            int idSupTipo,
            String razonSocial,
            String subtipoTicket,
            String comentario,
            String direccionEmpresa,
            String telefonoEmpresa,
            String emailEmpresa
    ) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.tipoId = tipoId;
        this.prioridad = prioridad;
        this.estado = estado;
        this.fechaCreacion = fechaCreacion;
        this.fechaResolucion = fechaResolucion;
        this.asignadoA = asignadoA;
        this.tipoTicket = tipoTicket;
        this.nombreTecnico = nombreTecnico;
        this.idUsuario = idUsuario;
        this.lugar = lugar;
        this.encargado = encargado;
        this.idSupTipo = idSupTipo;
        this.razonSocial = razonSocial;
        this.subTipoTicket = subtipoTicket;
        this.comentario = comentario;
        this.direccionEmpresa = direccionEmpresa;
        this.telefonoEmpresa = telefonoEmpresa;
        this.emailEmpresa = emailEmpresa;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getTipoId() {
        return tipoId;
    }

    public void setTipoId(int tipoId) {
        this.tipoId = tipoId;
    }

    public String getPrioridad() {
        return prioridad;
    }

    public void setPrioridad(String prioridad) {
        this.prioridad = prioridad;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getFechaResolucion() {
        return fechaResolucion;
    }

    public void setFechaResolucion(String fechaResolucion) {
        this.fechaResolucion = fechaResolucion;
    }

    public String getTipoTicket() {
        return tipoTicket;
    }

    public void setTipoTicket(String tipoTicket) {
        this.tipoTicket = tipoTicket;
    }

    public int getAsignadoA() {
        return asignadoA;
    }

    public void setAsignadoA(int asignadoA) {
        this.asignadoA = asignadoA;
    }

    public String getNombreTecnico() {
        return nombreTecnico;
    }

    public void setNombreTecnico(String nombreTecnico) {
        this.nombreTecnico = nombreTecnico;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getLugar() {
        return lugar;
    }

    public void setLugar(String lugar) {
        this.lugar = lugar;
    }

    public String getEncargado() {
        return encargado;
    }

    public void setEncargado(String encargado) {
        this.encargado = encargado;
    }

    public int getIdSupTipo() {
        return idSupTipo;
    }

    public void setIdSupTipo(int idSupTipo) {
        this.idSupTipo = idSupTipo;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public String getSubTipoTicket() {
        return subTipoTicket;
    }

    public void setSubTipoTicket(String subTipoTicket) {
        this.subTipoTicket = subTipoTicket;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getDireccionEmpresa() {
        return direccionEmpresa;
    }

    public void setDireccionEmpresa(String direccionEmpresa) {
        this.direccionEmpresa = direccionEmpresa;
    }

    public String getTelefonoEmpresa() {
        return telefonoEmpresa;
    }

    public void setTelefonoEmpresa(String telefonoEmpresa) {
        this.telefonoEmpresa = telefonoEmpresa;
    }

    public String getEmailEmpresa() {
        return emailEmpresa;
    }

    public void setEmailEmpresa(String emailEmpresa) {
        this.emailEmpresa = emailEmpresa;
    }

}
