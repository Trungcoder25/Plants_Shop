/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data.impl;

import java.sql.*;
import data.dao.OrderDAO;
import data.driver.MySQLDriver;
import java.util.*;
import model.CartItem;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Admin
 */
public class OrderImpl implements OrderDAO {

    @Override
    public int createOrder(Order order, Collection<CartItem> items) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        PreparedStatement psStock = null;
        ResultSet rsKeys = null;

        String sqlOrder = "INSERT INTO orders (user_id, customer_name, customer_phone, shipping_address, note, total_amount, status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
        String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        // Điều kiện "AND stock >= ?" đảm bảo không bao giờ trừ tồn kho xuống số âm nếu có 2 người đặt cùng lúc
        String sqlStock = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

        try {
            conn = MySQLDriver.getConnection();
            // BƯỚC 1: Tắt chế độ tự động lưu để bắt đầu một Transaction (Giao dịch nguyên tử)
            conn.setAutoCommit(false);

            // BƯỚC 2: Lưu thông tin chung vào bảng orders và yêu cầu trả về ID vừa tự tăng
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            if (order.getUserId() != null) {
                psOrder.setInt(1, order.getUserId());
            } else {
                psOrder.setNull(1, Types.INTEGER); // Khách đặt hàng không cần đăng nhập
            }
            psOrder.setString(2, order.getCustomerName());
            psOrder.setString(3, order.getCustomerPhone());
            psOrder.setString(4, order.getShippingAddress());
            psOrder.setString(5, order.getNote());
            psOrder.setDouble(6, order.getTotalAmount());
            psOrder.executeUpdate();

            // Lấy mã đơn hàng (order_id) vừa được MySQL tạo ra
            rsKeys = psOrder.getGeneratedKeys();
            int generatedOrderId = -1;
            if (rsKeys.next()) {
                generatedOrderId = rsKeys.getInt(1);
            } else {
                conn.rollback();
                return -1;
            }

            // BƯỚC 3: Lưu từng sản phẩm vào order_details VÀ trừ tồn kho trong bảng products
            psDetail = conn.prepareStatement(sqlDetail);
            psStock = conn.prepareStatement(sqlStock);

            for (CartItem item : items) {
                // 3a. Thêm dòng chi tiết đơn hàng
                psDetail.setInt(1, generatedOrderId);
                psDetail.setInt(2, item.getProduct().getId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getProduct().getPrice());
                psDetail.executeUpdate();

                // 3b. Trừ số lượng tồn kho
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getProduct().getId());
                psStock.setInt(3, item.getQuantity());
                int rowsAffected = psStock.executeUpdate();

                // Nếu rowsAffected == 0 nghĩa là cây này đã hết hàng -> Hủy toàn bộ giao dịch!
                if (rowsAffected == 0) {
                    conn.rollback();
                    return -2; // Mã quy ước báo hết tồn kho
                }
            }

            // BƯỚC 4: Mọi thứ thành công -> Xác nhận lưu vĩnh viễn xuống Database
            conn.commit();
            return generatedOrderId;

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có bất kỳ lỗi SQL nào xảy ra giữa chừng, hoàn tác lại trạng thái ban đầu
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return -1;
        } finally {
            // Đóng toàn bộ tài nguyên kết nối để tránh rò rỉ bộ nhớ
            try { if (rsKeys != null) rsKeys.close(); } catch (Exception ignored) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception ignored) {}
            try { if (psDetail != null) psDetail.close(); } catch (Exception ignored) {}
            try { if (psStock != null) psStock.close(); } catch (Exception ignored) {}
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {}
        }
    }
    
    private List<OrderDetail> getDetailsByOrderId(Connection conn, int orderId) throws SQLException {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.name AS product_name, p.image AS product_image "
                   + "FROM order_details od JOIN products p ON od.product_id = p.id "
                   + "WHERE od.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("id"));
                    d.setOrderId(rs.getInt("order_id"));
                    d.setProductId(rs.getInt("product_id"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setPrice(rs.getDouble("price"));
                    d.setProductName(rs.getString("product_name"));
                    d.setProductImage(rs.getString("product_image"));
                    list.add(d);
                }
            }
        }
        return list;
    }
    
    private Order mapOrderRow(Connection conn, ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        int uid = rs.getInt("user_id");
        o.setUserId(rs.wasNull() ? null : uid);
        o.setCustomerName(rs.getString("customer_name"));
        o.setCustomerPhone(rs.getString("customer_phone"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setNote(rs.getString("note"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        // Nạp kèm danh sách cây đã mua trong đơn
        o.setDetails(getDetailsByOrderId(conn, o.getId()));
        return o;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId){
        List<Order> lst = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = MySQLDriver.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lst.add(mapOrderRow(conn, rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }

    @Override
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = MySQLDriver.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrderRow(conn, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = MySQLDriver.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapOrderRow(conn, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = MySQLDriver.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
}
