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
public class Usuario {

    private int id;
    private String nombre;
    private String correoElectronico;
    private String contrasena;
    private int rolId;
    private String tipoUsuario;
    private String nombreCompletoUsuario;
    private String salt;
    private String nombreEmpresa;
    private int estado;

    public Usuario() {

    }

    public Usuario(int id,
            String nombre,
            String correoElectronico,
            String contrasena,
            int rolId,
            String tipoUsuario,
            String nombreCompletoUsuario,
            String salt,
            int estado) {

        this.id = id;
        this.nombre = nombre;
        this.correoElectronico = correoElectronico;
        this.contrasena = contrasena;
        this.rolId = rolId;
        this.tipoUsuario = tipoUsuario;
        this.nombreCompletoUsuario = nombreCompletoUsuario;
        this.salt = salt;
        this.estado = estado;
    }

    public Usuario(int id,
            String nombre,
            String correoElectronico,
            String contrasena,
            int rolId,
            String tipoUsuario,
            String nombreCompletoUsuario,
            String salt,
            String nombreEmpresa,
            int estado) {
        this.id = id;
        this.nombre = nombre;
        this.correoElectronico = correoElectronico;
        this.contrasena = contrasena;
        this.rolId = rolId;
        this.tipoUsuario = tipoUsuario;
        this.nombreCompletoUsuario = nombreCompletoUsuario;
        this.salt = salt;
        this.nombreEmpresa = nombreEmpresa;
        this.estado = estado;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreoElectronico() {
        return correoElectronico;
    }

    public void setCorreoElectronico(String correoElectronico) {
        this.correoElectronico = correoElectronico;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public int getRolId() {
        return rolId;
    }

    public void setRolId(int rolId) {
        this.rolId = rolId;
    }

    public String getTipoUsuario() {
        return tipoUsuario;
    }

    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public String perfilRol() {
        return (this.nombre + " | " + this.tipoUsuario).toUpperCase();
    }

    public String getNombreCompletoUsuario() {
        return nombreCompletoUsuario;
    }

    public void setNombreCompletoUsuario(String nombreCompletoUsuario) {
        this.nombreCompletoUsuario = nombreCompletoUsuario;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public String getNombreEmpresa() {
        return nombreEmpresa;
    }

    public void setNombreEmpresa(String nombreEmpresa) {
        this.nombreEmpresa = nombreEmpresa;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    
}
