package model;

/**
 * Lớp biểu diễn chi tiết từng sản phẩm nằm trong một đơn hàng (bảng order_details)
 */
public class OrderDetail {
    private int id;
    private int orderId;
    private int productId;
    private int quantity;
    private double price; // Lưu giá tại thời điểm mua (đề phòng sau này shop đổi giá)

    // Hai thuộc tính bổ sung lấy từ bảng products (qua câu lệnh JOIN) để hiển thị ra giao diện
    private String productName;
    private String productImage;

    public OrderDetail() {}

    // Tính thành tiền của từng dòng sản phẩm
    public double getSubtotal() {
        return price * quantity;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
}