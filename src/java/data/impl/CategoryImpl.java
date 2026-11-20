/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data.impl;

import java.sql.*;
import data.dao.CategoryDAO;
import data.driver.MySQLDriver;
import java.util.*;
import model.Category;

/**
 *
 * @author Admin
 */
public class CategoryImpl implements CategoryDAO {

    @Override
    public List<Category> getAll() {
        List<Category> lst = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY id ASC";
        try (Connection conn = MySQLDriver.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){
            while (rs.next()) {
                lst.add(new Category(
                    rs.getInt("id"), 
                    rs.getString("NAME"), 
                    rs.getString("slug"), 
                    rs.getString("icon"), 
                    rs.getString("description")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }

    @Override
    public Category getById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = MySQLDriver.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()){
                if (rs.next()) {
                    return new Category(
                        rs.getInt("id"), 
                        rs.getString("name"), 
                        rs.getString("slug"), 
                        rs.getString("icon"), 
                        rs.getString("description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
