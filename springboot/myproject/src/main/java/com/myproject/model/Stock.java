package com.myproject.model;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
@Scope("prototype")
public class Stock {
    private int id;
    private String stokKodu;
    private String stokAdi;
    private int stokTipi;
    private String birimi;
    private String barkodu;
    private double kdvTipi;
    private String aciklama;
    private LocalDateTime olusturmaZamani;
    // Constructors, getters, and setters

    public Stock() {
    }

    public Stock(int id, String stokKodu, String stokAdi, int stokTipi, String birimi,
                 String barkodu, double kdvTipi, String aciklama, LocalDateTime olusturmaZamani) {
        this.id = id;
        this.stokKodu = stokKodu;
        this.stokAdi = stokAdi;
        this.stokTipi = stokTipi;
        this.birimi = birimi;
        this.barkodu = barkodu;
        this.kdvTipi = kdvTipi;
        this.aciklama = aciklama;
        this.olusturmaZamani = olusturmaZamani;
    }

    // Getters and setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStokKodu() {
        return stokKodu;
    }

    public void setStokKodu(String stokKodu) {
        this.stokKodu = stokKodu;
    }

    public String getStokAdi() {
        return stokAdi;
    }

    public void setStokAdi(String stokAdi) {
        this.stokAdi = stokAdi;
    }

    public int getStokTipi() {
        return stokTipi;
    }

    public void setStokTipi(int stokTipi) {
        this.stokTipi = stokTipi;
    }

    public String getBirimi() {
        return birimi;
    }

    public void setBirimi(String birimi) {
        this.birimi = birimi;
    }

    public String getBarkodu() {
        return barkodu;
    }

    public void setBarkodu(String barkodu) {
        this.barkodu = barkodu;
    }

    public double getKdvTipi() {
        return kdvTipi;
    }

    public void setKdvTipi(double kdvTipi) {
        this.kdvTipi = kdvTipi;
    }

    public String getAciklama() {
        return aciklama;
    }

    public void setAciklama(String aciklama) {
        this.aciklama = aciklama;
    }

    public LocalDateTime getOlusturmaZamani() {
        return olusturmaZamani;
    }

    public void setOlusturmaZamani(LocalDateTime olusturmaZamani) {
        this.olusturmaZamani = olusturmaZamani;
    }

    // toString method for easy debugging and logging
    @Override
    public String toString() {
        return "Stock{" +
                "id=" + id +
                ", stokKodu='" + stokKodu + '\'' +
                ", stokAdi='" + stokAdi + '\'' +
                ", stokTipi=" + stokTipi +
                ", birimi='" + birimi + '\'' +
                ", barkodu='" + barkodu + '\'' +
                ", kdvTipi=" + kdvTipi +
                ", aciklama='" + aciklama + '\'' +
                ", olusturmaZamani=" + olusturmaZamani +
                '}';
    }
}
