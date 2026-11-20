/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package data.dao;

import java.util.List;
import model.Product;

/**
 *
 * @author Admin
 */
public interface ProductDAO {
    List<Product> getAll();
    List<Product> getFeaturedProducts(int limit);
    // Tìm nhanh tối đa 'limit' sản phẩm phục vụ khung gợi ý Live Search
    List<Product> searchQuick(String keyword, int limit);
    List<Product> FilterProduct(String keyword, Integer categoryId, String lightLevel, String careDifficulty);
    Product getById(int id);
    List<Product> getRelatedProducts(int categoryId, int excludeId, int limit);
    
    //Admin
    boolean Insert(Product p);
    boolean Update(Product p);
    boolean Delete(int id);
    
    
}
