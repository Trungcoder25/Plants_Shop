<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart" class="text-success text-decoration-none">Giỏ hàng</a></li>
            <li class="breadcrumb-item active">Xác nhận đặt cây</li>
        </ol>
    </nav>

    <!-- Hiển thị thông báo lỗi nếu đặt hàng thất bại (ví dụ hết tồn kho) -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-4 mb-4">
            <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="row g-4">
            <!-- CỘT TRÁI: Thông tin giao nhận & Phương thức thanh toán -->
            <div class="col-lg-7">
                <div class="bg-white p-4 rounded-4 border shadow-sm mb-4">
                    <h5 class="fw-bold text-success mb-3">
                        <i class="fa-solid fa-location-dot me-2"></i>Thông Tin Nhận Cây
                    </h5>

                    <!-- Tự động điền sẵn họ tên, SĐT, địa chỉ nếu người dùng đã đăng nhập -->
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Họ và tên người nhận <span class="text-danger">*</span></label>
                            <input type="text" name="customerName" value="${sessionScope.user.fullName}"
                                   class="form-control" placeholder="Nhập họ tên..." required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Số điện thoại liên hệ <span class="text-danger">*</span></label>
                            <input type="text" name="customerPhone" value="${sessionScope.user.phone}"
                                   class="form-control" placeholder="090xxxxxxx" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Địa chỉ giao hàng chi tiết <span class="text-danger">*</span></label>
                            <input type="text" name="shippingAddress" value="${sessionScope.user.address}"
                                   class="form-control" placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Lời nhắn cho nghệ nhân / Giao hàng</label>
                            <textarea name="note" rows="2" class="form-control"
                                      placeholder="Ví dụ: Giao giờ hành chính, viết thiệp chúc mừng khai trương, chọn chậu dáng tròn..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Khối chọn phương thức thanh toán -->
                <div class="bg-white p-4 rounded-4 border shadow-sm">
                    <h5 class="fw-bold text-success mb-3">
                        <i class="fa-solid fa-wallet me-2"></i>Phương Thức Thanh Toán
                    </h5>

                    <div class="form-check p-3 border rounded-3 mb-2">
                        <input class="form-check-input ms-1 me-2" type="radio" name="paymentMethod" id="payCOD" value="COD" checked>
                        <label class="form-check-label fw-semibold" for="payCOD">
                            <i class="fa-solid fa-money-bill-wave text-success me-2"></i>Thanh toán tiền mặt khi nhận cây (COD)
                        </label>
                        <div class="small text-muted ms-4 mt-1">Được kiểm tra tình trạng lá và rễ cây khỏe mạnh trước khi thanh toán.</div>
                    </div>

                    <div class="form-check p-3 border rounded-3">
                        <input class="form-check-input ms-1 me-2" type="radio" name="paymentMethod" id="payBank" value="Chuyển khoản">
                        <label class="form-check-label fw-semibold" for="payBank">
                            <i class="fa-solid fa-qrcode text-primary me-2"></i>Chuyển khoản ngân hàng / Quét mã QR
                        </label>
                        <div class="small text-muted ms-4 mt-1">STK: <strong>1903888999</strong> - Ngân hàng MB Bank - Chủ TK: PLANTS SHOP GARDEN.</div>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Tóm tắt đơn hàng -->
            <div class="col-lg-5">
                <div class="bg-white p-4 rounded-4 border shadow-sm">
                    <h5 class="fw-bold mb-3 pb-2 border-bottom">Chi Tiết Đơn Hàng (${sessionScope.cartCount} sản phẩm)</h5>

                    <!-- Danh sách các chậu cây đang đặt -->
                    <div class="mb-3" style="max-height: 280px; overflow-y: auto;">
                        <c:forEach items="${sessionScope.cart.values()}" var="item">
                            <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                <div class="d-flex align-items-center gap-2">
                                    <img src="${pageContext.request.contextPath}/assets/images/${item.product.image}"
                                         onerror="this.src='https://placehold.co/60x60/E8F5E9/1B4332?text=Plant'"
                                         class="rounded border" style="width: 48px; height: 48px; object-fit: cover;">
                                    <div>
                                        <div class="small fw-bold text-dark">${item.product.name}</div>
                                        <div class="small text-muted">Số lượng: x${item.quantity}</div>
                                    </div>
                                </div>
                                <div class="small fw-bold text-dark">
                                    <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>đ
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Tính toán tiền hàng & phí ship -->
                    <div class="d-flex justify-content-between small mb-2">
                        <span class="text-muted">Tạm tính:</span>
                        <span class="fw-semibold">
                            <fmt:formatNumber value="${sessionScope.cartTotal}" type="number" groupingUsed="true"/>đ
                        </span>
                    </div>

                    <div class="d-flex justify-content-between small mb-3">
                        <span class="text-muted">Phí giao cây chống sốc:</span>
                        <c:choose>
                            <c:when test="${sessionScope.cartTotal >= 300000}">
                                <span class="text-success fw-bold">Miễn phí (Đơn &ge; 300k)</span>
                            </c:when>
                            <c:otherwise>
                                <span>30.000đ</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold">Tổng thanh toán:</span>
                        <c:set var="finalTotal" value="${sessionScope.cartTotal >= 300000 ? sessionScope.cartTotal : sessionScope.cartTotal + 30000}" />
                        <span class="fs-4 fw-bold text-success">
                            <fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true"/>đ
                        </span>
                    </div>

                    <button type="submit" class="btn btn-success btn-lg w-100 rounded-pill fw-bold">
                        <i class="fa-solid fa-check-circle me-1"></i> Hoàn Tất Đặt Cây
                    </button>

                    <div class="small text-muted text-center mt-3">
                        <i class="fa-solid fa-gift text-warning me-1"></i> Tặng kèm thẻ hướng dẫn tưới nước & dinh dưỡng dùng thử
                    </div>
                </div>
            </div>
        </div>
    </form>
</main>

<jsp:include page="/inc/_footer.jsp" />