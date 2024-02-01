package com.myproject.repo;

import com.myproject.model.Stock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class StockRepo {

    private JdbcTemplate template;

    public JdbcTemplate getTemplate() {
        return template;
    }

    @Autowired
    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public Stock save(Stock stock) {
        String checkIfExistsSql = "SELECT COUNT(*) FROM stock WHERE stokKodu = ?";
        int count = template.queryForObject(checkIfExistsSql, Integer.class, stock.getStokKodu());

        if (count > 0) {
            throw new RuntimeException("stokKodu " + stock.getStokKodu() + " zaten mevcut.");
        }
        String sql = "INSERT INTO stock (stokKodu, stokAdi, stokTipi, birimi, barkodu, kdvTipi, aciklama, olusturmaZamani) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        int rows = template.update(sql, stock.getStokKodu(), stock.getStokAdi(), stock.getStokTipi(),
                stock.getBirimi(), stock.getBarkodu(), stock.getKdvTipi(), stock.getAciklama());

        if (rows > 0) {
            System.out.println(rows + " rows affected");
            return stock;
        } else {
            throw new RuntimeException("Failed to insert Stock into the database");
        }
    }


    public List<Stock> findAll(String stokKodu, String stokAdi, Integer stokTipi, Double kdvTipi, String barkodu) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM stock WHERE 1=1");

        List<Object> params = new ArrayList<>();

        if (stokKodu != null) {
            sqlBuilder.append(" AND stokKodu = ?");
            params.add(stokKodu);
        }

        if (stokAdi != null) {
            sqlBuilder.append(" AND stokAdi = ?");
            params.add(stokAdi);
        }

        if (stokTipi != null) {
            sqlBuilder.append(" AND stokTipi = ?");
            params.add(stokTipi);
        }

        if (kdvTipi != null) {
            sqlBuilder.append(" AND kdvTipi = ?");
            params.add(kdvTipi);
        }

        if (barkodu != null) {
            sqlBuilder.append(" AND barkodu = ?");
            params.add(barkodu);
        }

        RowMapper<Stock> mapper = (rs, rowNum) -> new Stock(
                rs.getInt("id"),
                rs.getString("stokKodu"),
                rs.getString("stokAdi"),
                rs.getInt("stokTipi"),
                rs.getString("birimi"),
                rs.getString("barkodu"),
                rs.getDouble("kdvTipi"),
                rs.getString("aciklama"),
                rs.getTimestamp("olusturmaZamani").toLocalDateTime()
        );

        return template.query(sqlBuilder.toString(), params.toArray(), mapper);
    }

    public void deleteById(Long stockId) {
        String sql = "DELETE FROM stock WHERE id = ?";
        int rows = template.update(sql, stockId);
        System.out.println(rows + " row(s) affected");
    }

    public Stock getStockById(Long stockId) {
        String sql = "SELECT * FROM stock WHERE id = ?";
        RowMapper<Stock> mapper = (rs, rowNum) ->
                new Stock(rs.getInt("id"), rs.getString("stokKodu"), rs.getString("stokAdi"),
                        rs.getInt("stokTipi"), rs.getString("birimi"), rs.getString("barkodu"),
                        rs.getDouble("kdvTipi"), rs.getString("aciklama"),
                        rs.getTimestamp("olusturmaZamani").toLocalDateTime());

        try {
            return template.queryForObject(sql, new Object[]{stockId}, mapper);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
}