<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <!-- Thông báo chúc mừng nếu khách vừa đặt hàng thành công -->
    <c:if test="${not empty param.successId}">
        <div class="alert alert-success rounded-4 p-4 border-success shadow-sm mb-4 d-flex align-items-center gap-3">
            <i class="fa-solid fa-circle-check fa-2x text-success"></i>
            <div>
                <h5 class="fw-bold mb-1">Đặt hàng thành công! Mã đơn của bạn là #ORD${param.successId}</h5>
                <p class="mb-0 small">
                    Nghệ nhân tại <strong>Plants_shop</strong> đang kiểm tra độ ẩm đất và đóng gói chống sốc cho chậu cây của bạn.
                </p>
            </div>
        </div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="fa-solid fa-box-open text-success me-2"></i>Lịch Sử Đơn Cây Của Bạn</h4>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-success rounded-pill btn-sm px-3">
            <i class="fa-solid fa-plus me-1"></i> Đặt thêm cây mới
        </a>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="bg-white p-5 rounded-4 border text-center">
                <i class="fa-solid fa-seedling fa-3x text-muted mb-3"></i>
                <h5>Bạn chưa có đơn hàng nào</h5>
                <p class="text-muted small">Hãy chọn một chậu cây xanh mát để bắt đầu hành trình chăm cây nhé!</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-success rounded-pill px-4">Xem danh sách cây</a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="d-flex flex-column gap-4">
                <c:forEach items="${orders}" var="o">
                    <div class="bg-white rounded-4 border shadow-sm overflow-hidden">
                        <!-- Header từng đơn hàng: Mã đơn, Ngày đặt & Nhãn trạng thái -->
                        <div class="p-3 px-4 bg-light border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div>
                                <span class="fw-bold text-dark me-3">Đơn hàng #ORD${o.id}</span>
                                <span class="small text-muted">
                                    <i class="fa-regular fa-clock me-1"></i>
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
                            </div>

                            <!-- Hiển thị huy hiệu trạng thái trực quan -->
                            <div>
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}">
                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">
                                            <i class="fa-solid fa-hourglass-half me-1"></i> Chờ xác nhận
                                        </span>
                                    </c:when>
                                    <c:when test="${o.status == 'CONFIRMED'}">
                                        <span class="badge bg-info text-dark px-3 py-2 rounded-pill">
                                            <i class="fa-solid fa-clipboard-check me-1"></i> Đã xác nhận & Đóng gói
                                        </span>
                                    </c:when>
                                    <c:when test="${o.status == 'SHIPPING'}">
                                        <span class="badge bg-primary px-3 py-2 rounded-pill">
                                            <i class="fa-solid fa-truck-fast me-1"></i> Đang giao cây
                                        </span>
                                    </c:when>
                                    <c:when test="${o.status == 'DELIVERED'}">
                                        <span class="badge bg-success px-3 py-2 rounded-pill">
                                            <i class="fa-solid fa-circle-check me-1"></i> Giao thành công
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger px-3 py-2 rounded-pill">
                                            <i class="fa-solid fa-ban me-1"></i> Đã hủy
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Danh sách các chậu cây trong đơn -->
                        <div class="p-4">
                            <c:forEach items="${o.details}" var="d">
                                <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${pageContext.request.contextPath}/assets/images/${d.productImage}"
                                             onerror="this.src='https://placehold.co/60x60/E8F5E9/1B4332?text=Plant'"
                                             class="rounded-3 border" style="width: 56px; height: 56px; object-fit: cover;">
                                        <div>
                                            <a href="${pageContext.request.contextPath}/detail?id=${d.productId}"
                                               class="fw-bold text-dark text-decoration-none">
                                                ${d.productName}
                                            </a>
                                            <div class="small text-muted">Số lượng: x${d.quantity}</div>
                                        </div>
                                    </div>
                                    <div class="fw-semibold text-dark">
                                        <fmt:formatNumber value="${d.subtotal}" type="number" groupingUsed="true"/>đ
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Chân đơn hàng: Địa chỉ nhận & Tổng tiền -->
                            <div class="row mt-3 pt-2 align-items-center g-2">
                                <div class="col-md-8 small text-muted">
                                    <div><strong>Người nhận:</strong> ${o.customerName} (${o.customerPhone})</div>
                                    <div><strong>Địa chỉ:</strong> ${o.shippingAddress}</div>
                                    <c:if test="${not empty o.note}">
                                        <div><strong>Ghi chú:</strong> ${o.note}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <span class="small text-muted me-2">Tổng thanh toán:</span>
                                    <span class="fs-5 fw-bold text-success">
                                        <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/>đ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/inc/_footer.jsp" />