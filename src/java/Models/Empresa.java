/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Models;

import com.sun.xml.rpc.processor.modeler.j2ee.xml.string;

/**
 *
 * @author HP
 */
public class Empresa {

    private int id;
    private String razonSocial;
    private String direccion;
    private String telefono;
    private String correo;
    private String ruc;
    private int usuarioId;
    private String username;

    public Empresa() {
    }

    // Constructor
    public Empresa(int id, String razonSocial, String direccion, String telefono, String correo, String ruc, int usuarioId) {
        this.id = id;
        this.razonSocial = razonSocial;
        this.direccion = direccion;
        this.telefono = telefono;
        this.correo = correo;
        this.ruc = ruc;
        this.usuarioId = usuarioId;
    }

    // Constructor
    public Empresa(int id, String razonSocial, String direccion, String telefono, String correo, String ruc, int usuarioId, String username) {
        this.id = id;
        this.razonSocial = razonSocial;
        this.direccion = direccion;
        this.telefono = telefono;
        this.correo = correo;
        this.ruc = ruc;
        this.usuarioId = usuarioId;
        this.username = username;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getRuc() {
        return ruc;
    }

    public void setRuc(String ruc) {
        this.ruc = ruc;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

}
