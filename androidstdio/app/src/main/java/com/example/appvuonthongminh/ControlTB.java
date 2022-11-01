package com.example.appvuonthongminh;

public class ControlTB {
    int id;
    String tenTB;
    String trangthai;

    public ControlTB(int id, String tenTB, String trangthai) {
        this.id = id;
        this.tenTB = tenTB;
        this.trangthai = trangthai;
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

    public String getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(String trangthai) {
        this.trangthai = trangthai;
    }
}
