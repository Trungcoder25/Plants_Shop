# 🌿 Plants_Shop - Hệ Thống Bán Cây Cảnh & Cẩm Nang Chăm Sóc

Ứng dụng web thương mại điện tử chuyên biệt cho cây cảnh nội thất, cây phong thủy và phụ kiện chăm sóc cây, xây dựng theo mô hình **Java Web MVC**.

## 🚀 Công nghệ sử dụng
- **Backend:** Java 17+, Jakarta Servlet & JSP (Tomcat 10.1), JDBC Transaction
- **Frontend:** HTML5, CSS3, Bootstrap 5, FontAwesome 6, JavaScript (AJAX Live Search)
- **Database:** MySQL 8.0

## ✨ Tính năng nổi bật
- **Tìm kiếm thông minh (Live Search):** Gợi ý sản phẩm tức thì theo tên cây và triệu chứng bệnh cây (vàng lá, úng rễ...).
- **Lọc đa tiêu chí:** Lọc theo danh mục, mức độ ánh sáng và độ khó chăm sóc.
- **Giỏ hàng & Thanh toán an toàn:** Kiểm soát tồn kho bằng JDBC Transaction (`commit`/`rollback`), tự động tính tiến độ miễn phí vận chuyển.
- **Trợ lý AI Chatbot:** Tư vấn chọn cây theo không gian sống và gợi ý sản phẩm trực tiếp từ CSDL.
- **Trang Quản trị (Admin):** Phân quyền bảo mật bằng `AdminFilter`, quản lý sản phẩm (CRUD + Upload ảnh), duyệt đơn hàng và thống kê doanh thu.

## ⚙️ Hướng dẫn cài đặt
1. Import file `plants_shop.sql` vào MySQL.
2. Cấu hình thông tin kết nối Database trong `src/java/data/driver/MySQLDriver.java`.
3. Mở dự án bằng NetBeans, thực hiện **Clean and Build** và chạy trên **Apache Tomcat 10+**.
