-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 20, 2026 lúc 04:24 AM
-- Phiên bản máy phục vụ: 10.4.27-MariaDB
-- Phiên bản PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `plants_shop`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `icon` varchar(50) DEFAULT 'fa-leaf',
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `NAME`, `slug`, `icon`, `description`) VALUES
(1, 'Cây Để Bàn', 'cay-de-ban', 'fa-seedling', 'Cây nhỏ gọn đặt bàn làm việc, giảm căng thẳng mắt'),
(2, 'Cây Lọc Không Khí', 'cay-loc-khong-khi', 'fa-wind', 'Hấp thụ bụi mịn và khí độc trong phòng kín'),
(3, 'Sen Đá & Xương Rồng', 'sen-da-xuong-rong', 'fa-sun', 'Sức sống bền bỉ, ít tốn công tưới nước'),
(4, 'Cây Phong Thủy', 'cay-phong-thuy', 'fa-spa', 'Mang lại tài lộc, vượng khí cho gia chủ'),
(5, 'Chậu & Dinh Dưỡng', 'chau-va-dinh-duong', 'fa-prescription-bottle', 'Chậu gốm, đất trộn và thuốc trị bệnh cho cây');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `shipping_address` text NOT NULL,
  `note` text DEFAULT NULL,
  `total_amount` decimal(12,0) NOT NULL,
  `STATUS` enum('PENDING','CONFIRMED','SHIPPING','DELIVERED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `customer_name`, `customer_phone`, `shipping_address`, `note`, `total_amount`, `STATUS`, `created_at`) VALUES
(1, NULL, 'Nguyễn Đức Trung', '0977975852', '15 Lương Văn Can', '[COD] ', '150000', 'SHIPPING', '2026-11-17 17:00:51'),
(2, 2, 'Nguyễn Minh Anh', '0987654321', '45 Lê Lợi, TP. Huế', '[COD] ', '150000', 'CONFIRMED', '2026-11-17 17:02:42'),
(3, NULL, 'Nguyễn Đức Trung', '0977975852', '15 Lương Văn Can', '[COD] ', '290000', 'CANCELLED', '2026-11-17 17:03:40');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(12,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_details`
--

INSERT INTO `order_details` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 4, 1, '120000'),
(2, 2, 4, 1, '120000'),
(3, 3, 3, 1, '260000');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `old_price` decimal(12,0) DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 10,
  `image` varchar(255) NOT NULL,
  `plant_height` varchar(50) DEFAULT NULL COMMENT 'Ví dụ: 25 - 35 cm',
  `light_level` enum('Nắng gắt','Bán râm','Trong nhà') DEFAULT 'Trong nhà',
  `water_frequency` varchar(50) DEFAULT NULL COMMENT 'Ví dụ: 2 lần/tuần',
  `care_difficulty` enum('Dễ chăm','Trung bình','Chuyên sâu') DEFAULT 'Dễ chăm',
  `description` text DEFAULT NULL,
  `care_guide` text DEFAULT NULL COMMENT 'Cẩm nang chăm sóc & phòng bệnh kiểu Long Châu',
  `is_featured` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `category_id`, `NAME`, `price`, `old_price`, `stock`, `image`, `plant_height`, `light_level`, `water_frequency`, `care_difficulty`, `description`, `care_guide`, `is_featured`, `created_at`) VALUES
(1, 1, 'Cây Kim Tiền Mini Chậu Gốm Trắng', '185000', '220000', 25, 'kim-tien.jpg', '25 - 30 cm', 'Trong nhà', '1 lần/tuần', 'Dễ chăm', 'Cây Kim Tiền tượng trưng cho sự thịnh vượng, lá xanh bóng dày dặn rất hợp đặt bàn làm việc hoặc quầy thu ngân.', '<b>Ánh sáng:</b> Đặt nơi có ánh sáng đèn huỳnh quang hoặc gần cửa sổ.<br><b>Tưới nước:</b> Chỉ tưới 100ml nước khi mặt đất khô hoàn toàn.<br><b>Dấu hiệu bệnh:</b> Vàng lá gốc thường do úng nước, cần ngưng tưới 10 ngày.', 1, '2026-11-16 03:39:22'),
(2, 2, 'Cây Lưỡi Hổ Thái Vằn Vàng', '150000', '180000', 40, 'luoi-ho.jpg', '30 - 40 cm', 'Trong nhà', '1 lần/10 ngày', 'Dễ chăm', 'Nhà máy lọc không khí ban đêm, hấp thụ formaldehyde và benzen hiệu quả cho phòng ngủ.', '<b>Ánh sáng:</b> Chịu bóng bán phần cực tốt.<br><b>Tưới nước:</b> Tránh tưới trực tiếp vào nõn lá gây thối nhũn.<br><b>Dinh dưỡng:</b> Bón phân tan chậm 2 tháng/lần.', 1, '2026-11-16 03:39:22'),
(3, 2, 'Cây Trầu Bà Đế Vương Xanh', '260000', '310000', 14, 'trau-ba-de-vuong.jpg', '35 - 45 cm', 'Bán râm', '2 lần/tuần', 'Dễ chăm', 'Tán lá rộng sang trọng, thể hiện uy quyền và giúp điều hòa độ ẩm không khí trong văn phòng máy lạnh.', '<b>Ánh sáng:</b> Ưa sáng gián tiếp, tránh nắng trưa làm cháy mép lá.<br><b>Chăm sóc:</b> Lau bụi trên mặt lá bằng khăn ẩm mỗi tuần để cây quang hợp tốt.', 1, '2026-11-16 03:39:22'),
(4, 3, 'Combo 3 Chậu Sen Đá Đế Vương & Nâu', '120000', '150000', 48, 'sen-da-combo.jpg', '10 - 15 cm', 'Nắng gắt', '1 lần/tuần', 'Trung bình', 'Bộ 3 sen đá lên màu chuẩn đẹp kèm chậu đất nung thoát nước tốt.', '<b>Ánh sáng:</b> Cần nắng nhẹ buổi sáng từ 3-4 tiếng/ngày để giữ form và màu sắc.<br><b>Phòng bệnh:</b> Kiểm tra rệp sáp dưới kẽ lá định kỳ.', 1, '2026-11-16 03:39:22'),
(5, 4, 'Cây Bàng Singapore Cỡ Trung', '450000', '520000', 12, 'bang-singapore.jpg', '70 - 90 cm', 'Bán râm', '2 lần/tuần', 'Trung bình', 'Dáng cây thẳng đứng, tán lá lớn hiện đại phù hợp trang trí phòng khách, studio hoặc quán cà phê.', '<b>Ánh sáng:</b> Đặt cạnh ban công hoặc cửa kính lớn.<br><b>Lưu ý:</b> Xoay chậu mỗi tuần để tán cây phát triển đều hai bên.', 0, '2026-11-16 03:39:22'),
(6, 5, 'Phân Bón Nhả Chậm & Kích Rễ Hữu Cơ (Hũ 200g)', '65000', '80000', 100, 'phan-bon-huu-co.jpg', 'Hũ 200g', 'Trong nhà', 'Bón 1 tháng/lần', 'Dễ chăm', 'Giải pháp dinh dưỡng an toàn không mùi cho cây trồng trong nhà, phục hồi cây vàng lá suy yếu.', '<b>Liều dùng:</b> Rải 1 thìa cà phê quanh gốc cây đường kính chậu 15cm, tưới nước nhẹ sau khi bón.', 0, '2026-11-16 03:39:22'),
(7, 3, 'Cây Áo Giấy', '230000', '350000', 20, '1794982434036_2aOboQuZiCiratoaWlUChlp2DgtxCNqTGfFWF7jM.jpg', '25 cm', 'Bán râm', '1 lần / tuần', 'Trung bình', 'Ádasdasdasdwdsqd', '', 0, '2026-11-18 06:13:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` enum('CUSTOMER','ADMIN') DEFAULT 'CUSTOMER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `PASSWORD`, `phone`, `address`, `role`, `created_at`) VALUES
(1, 'Admin Plants', 'admin@plantsshop.vn', '123456', '0977975852', '15 Lương Văn Can, TP. Huế', 'ADMIN', '2026-11-16 03:39:22'),
(2, 'Nguyễn Minh Anh', 'khachhang@gmail.com', '123456', '0987654321', '45 Lê Lợi, TP. Huế', 'CUSTOMER', '2026-11-16 03:39:22');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
