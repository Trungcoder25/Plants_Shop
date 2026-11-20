package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp biểu diễn Đơn đặt hàng (bảng orders)
 */
public class Order {
    private int id;
    private Integer userId; // Dùng Integer (thay vì int) vì khách vãng lai không đăng nhập sẽ có user_id = null
    private String customerName;
    private String customerPhone;
    private String shippingAddress;
    private String note;
    private double totalAmount;
    private String status; // Các trạng thái: PENDING, CONFIRMED, SHIPPING, DELIVERED, CANCELLED
    private Timestamp createdAt;

    // Danh sách các chậu cây thuộc đơn hàng này
    private List<OrderDetail> details = new ArrayList<>();

    public Order() {}

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public List<OrderDetail> getDetails() { return details; }
    public void setDetails(List<OrderDetail> details) { this.details = details; }
}