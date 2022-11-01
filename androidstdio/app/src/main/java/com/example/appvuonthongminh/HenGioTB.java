package com.example.appvuonthongminh;

public class HenGioTB {
    int id;
    String tenTB;
    String GioOn,PhutOn;
    String GioOff,phutOff;

    public HenGioTB(int id, String tenTB, String gioOn, String phutOn, String gioOff, String phutOff) {
        this.id = id;
        this.tenTB = tenTB;
        GioOn = gioOn;
        PhutOn = phutOn;
        GioOff = gioOff;
        this.phutOff = phutOff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenTB() {
        return tenTB;
    }

    public void setTenTB(String tenTB) {
        this.tenTB = tenTB;
    }

    public String getGioOn() {
        return GioOn;
    }

    public void setGioOn(String gioOn) {
        GioOn = gioOn;
    }

    public String getPhutOn() {
        return PhutOn;
    }

    public void setPhutOn(String phutOn) {
        PhutOn = phutOn;
    }

    public String getGioOff() {
        return GioOff;
    }

    public void setGioOff(String gioOff) {
        GioOff = gioOff;
    }

    public String getPhutOff() {
        return phutOff;
    }

    public void setPhutOff(String phutOff) {
        this.phutOff = phutOff;
    }
}
