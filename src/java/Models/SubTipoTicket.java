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
public class SubTipoTicket {
    private int id;
    private String nombre;
    private int tipo_id;
    private String priordad;

    public SubTipoTicket() {
    }

    public SubTipoTicket(int id, String nombre, int tipo_id, String priordad) {
        this.id = id;
        this.nombre = nombre;
        this.tipo_id = tipo_id;
        this.priordad = priordad;
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

    public int getTipo_id() {
        return tipo_id;
    }

    public void setTipo_id(int tipo_id) {
        this.tipo_id = tipo_id;
    }

    public String getPriordad() {
        return priordad;
    }

    public void setPriordad(String priordad) {
        this.priordad = priordad;
    }
    
    
}
