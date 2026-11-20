/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data.impl;

import data.dao.ProductDAO;
import data.driver.MySQLDriver;
import java.util.*;
import java.sql.*;
import model.Product;

/**
 *
 * @author Admin
 */
public class ProductImpl implements ProductDAO {

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setOldPrice(rs.getDouble("old_price"));
        p.setStock(rs.getInt("stock"));
        p.setImage(rs.getString("image"));
        p.setPlantHeight(rs.getString("plant_height"));
        p.setLightLevel(rs.getString("light_level"));
        p.setWaterFrequency(rs.getString("water_frequency"));
        p.setCareDifficulty(rs.getString("care_difficulty"));
        p.setDescription(rs.getString("description"));
        p.setCareGuide(rs.getString("care_guide"));
        p.setFeatured(rs.getBoolean("is_featured"));
        return p;
    }

    @Override
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id ORDER BY p.id DESC";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> lst = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id "
                + "WHERE p.is_featured = TRUE ORDER BY p.id DESC LIMIT ?";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lst.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }

    @Override
    public List<Product> FilterProduct(String keyword, Integer categoryId, String lightLevel, String careDifficulty) {
        List<Product> lst = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm mở rộng: khớp tên cây, mô tả, cẩm nang trị bệnh hoặc tên danh mục
            sql.append("AND (p.name LIKE ? OR p.description LIKE ? OR p.care_guide LIKE ? OR c.name LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }
        if (lightLevel != null && !lightLevel.trim().isEmpty()) {
            sql.append("AND p.light_level = ? ");
            params.add(lightLevel.trim());
        }
        if (careDifficulty != null && !careDifficulty.trim().isEmpty()) {
            sql.append("AND p.care_difficulty = ? ");
            params.add(careDifficulty.trim());
        }
        sql.append("ORDER BY p.id DESC");

        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lst.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }

    @Override
    public Product getById(int id) {
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id WHERE p.id = ?";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Product> getRelatedProducts(int categoryId, int excludeId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id "
                + "WHERE p.category_id = ? AND p.id != ? ORDER BY RAND() LIMIT ?";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean Insert(Product p) {
        String sql = "INSERT INTO products (category_id, name, price, old_price, stock, image, "
                + "plant_height, light_level, water_frequency, care_difficulty, description, care_guide, is_featured) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getOldPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getImage());
            ps.setString(7, p.getPlantHeight());
            ps.setString(8, p.getLightLevel());
            ps.setString(9, p.getWaterFrequency());
            ps.setString(10, p.getCareDifficulty());
            ps.setString(11, p.getDescription());
            ps.setString(12, p.getCareGuide());
            ps.setBoolean(13, p.isFeatured());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean Update(Product p) {
        String sql = "UPDATE products SET category_id=?, name=?, price=?, old_price=?, stock=?, image=?, "
                + "plant_height=?, light_level=?, water_frequency=?, care_difficulty=?, description=?, care_guide=?, is_featured=? "
                + "WHERE id=?";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getOldPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getImage());
            ps.setString(7, p.getPlantHeight());
            ps.setString(8, p.getLightLevel());
            ps.setString(9, p.getWaterFrequency());
            ps.setString(10, p.getCareDifficulty());
            ps.setString(11, p.getDescription());
            ps.setString(12, p.getCareGuide());
            ps.setBoolean(13, p.isFeatured());
            ps.setInt(14, p.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean Delete(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Product> searchQuick(String keyword, int limit) {
        List<Product> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return list;
        }

        // Ưu tiên xếp các sản phẩm có tên khớp từ khóa lên đầu (ORDER BY CASE...)
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.id "
                + "WHERE p.name LIKE ? OR p.care_guide LIKE ? OR c.name LIKE ? "
                + "ORDER BY CASE WHEN p.name LIKE ? THEN 1 ELSE 2 END, p.id DESC LIMIT ?";

        try (Connection conn = MySQLDriver.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            ps.setInt(5, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
