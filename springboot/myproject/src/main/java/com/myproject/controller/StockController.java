package com.myproject.controller;
import com.myproject.model.Stock;
import com.myproject.repo.StockRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/stocks")
public class StockController {

    private final StockRepo stockRepo;

    @Autowired
    public StockController(StockRepo stockRepo) {
        this.stockRepo = stockRepo;
    }

    @PostMapping
    public ResponseEntity<String> addStock(@RequestBody Stock stock) {
        try {
            stockRepo.save(stock);
            return ResponseEntity.ok("Stok başarıyla eklendi");
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    @GetMapping
    public List<Stock> getAllStocks(
            @RequestParam(required = false) String stokKodu,
            @RequestParam(required = false) String stokAdi,
            @RequestParam(required = false) Integer stokTipi,
            @RequestParam(required = false) Double kdvTipi,
            @RequestParam(required = false) String barkodu) {
        return stockRepo.findAll(stokKodu, stokAdi, stokTipi, kdvTipi, barkodu);
    }

    @GetMapping("/{id}")
    public Stock getStockById(@PathVariable Long id) {
        return stockRepo.getStockById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteStockById(@PathVariable Long id) {
        stockRepo.deleteById(id);
    }
}