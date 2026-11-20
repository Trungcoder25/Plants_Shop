/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package data.dao;

import java.util.*;
import model.*;

/**
 *
 * @author Admin
 */
public interface OrderDAO {
    // Tạo đơn hàng mới kèm chi tiết và trừ tồn kho bằng Transaction. Trả về ID đơn hàng (hoặc -1 nếu lỗi)
    int createOrder(Order order, Collection<CartItem> items);

    // Lấy danh sách đơn hàng của một khách hàng cụ thể
    List<Order> getOrdersByUserId(int userId);

    // Lấy chi tiết 1 đơn hàng theo mã đơn
    Order getOrderById(int orderId);

    // Hai hàm dưới dùng sẵn cho Trang Quản Trị (Ngày 6)
    List<Order> getAllOrders();
    boolean updateStatus(int orderId, String status);
}
