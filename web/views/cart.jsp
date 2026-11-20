<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Trang chủ</a></li>
            <li class="breadcrumb-item active">Giỏ hàng của bạn</li>
        </ol>
    </nav>

    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="bg-white p-5 rounded-4 border text-center my-4">
                <i class="fa-solid fa-cart-arrow-down fa-3x text-muted mb-3"></i>
                <h5 class="fw-bold">Giỏ hàng của bạn đang trống</h5>
                <p class="text-muted small">Hãy chọn thêm vài chậu cây xanh mát cho bàn làm việc hoặc góc phòng nhé!</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-success rounded-pill px-4 mt-2">
                    Khám phá vườn cây ngay
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4">
                <!-- Danh sách sản phẩm trong giỏ -->
                <div class="col-lg-8">
                    <!-- Thanh tiến độ miễn phí giao hàng kiểu Long Châu -->
                    <div class="bg-white p-3 rounded-4 border mb-3">
                        <c:choose>
                            <c:when test="${sessionScope.cartTotal >= 300000}">
                                <div class="text-success small fw-semibold mb-2">
                                    <i class="fa-solid fa-truck-fast me-1"></i> Chúc mừng! Đơn hàng của bạn được <strong>MIỄN PHÍ GIAO CÂY HỎA TỐC</strong>.
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar bg-success" style="width: 100%"></div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:set var="remain" value="${300000 - sessionScope.cartTotal}" />
                                <c:set var="percent" value="${(sessionScope.cartTotal / 300000) * 100}" />
                                <div class="small text-dark mb-2">
                                    <i class="fa-solid fa-truck text-warning me-1"></i> Mua thêm
                                    <strong class="text-success"><fmt:formatNumber value="${remain}" type="number" groupingUsed="true"/>đ</strong>
                                    để được miễn phí giao hàng chống sốc!
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar bg-warning" style="width: ${percent}%"></div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="bg-white p-4 rounded-4 border shadow-sm">
                        <div class="d-flex justify-content-between align-items-center pb-3 mb-3 border-bottom">
                            <h5 class="fw-bold mb-0">Giỏ hàng (${sessionScope.cartCount} sản phẩm)</h5>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                    <i class="fa-regular fa-trash-can me-1"></i> Xóa tất cả
                                </button>
                            </form>
                        </div>

                        <c:forEach items="${sessionScope.cart.values()}" var="item">
                            <div class="row align-items-center py-3 border-bottom g-3">
                                <div class="col-3 col-sm-2">
                                    <img src="${pageContext.request.contextPath}/assets/images/${item.product.image}"
                                         onerror="this.src='https://placehold.co/120x120/E8F5E9/1B4332?text=Plant'"
                                         class="img-fluid rounded-3 border" alt="${item.product.name}">
                                </div>

                                <div class="col-9 col-sm-4">
                                    <a href="${pageContext.request.contextPath}/detail?id=${item.product.id}"
                                       class="fw-bold text-dark text-decoration-none d-block mb-1">
                                        ${item.product.name}
                                    </a>
                                    <div class="small text-muted">
                                        <i class="fa-solid fa-sun text-warning"></i> ${item.product.lightLevel} &bull;
                                        <i class="fa-solid fa-droplet text-primary"></i> ${item.product.waterFrequency}
                                    </div>
                                    <div class="text-success fw-semibold small mt-1">
                                        <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/>đ / chậu
                                    </div>
                                </div>

                                <!-- Bộ điều chỉnh số lượng -->
                                <div class="col-6 col-sm-3">
                                    <div class="d-flex align-items-center gap-1">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary px-2">-</button>
                                        </form>

                                        <span class="px-3 py-1 border rounded bg-light fw-bold small">${item.quantity}</span>

                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary px-2"
                                                    ${item.quantity >= item.product.stock ? 'disabled' : ''}>+</button>
                                        </form>
                                    </div>
                                </div>

                                <!-- Thành tiền & Xóa -->
                                <div class="col-6 col-sm-3 text-end">
                                    <div class="fw-bold text-dark mb-1">
                                        <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>đ
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="${item.product.id}">
                                        <button type="submit" class="btn btn-link text-danger p-0 small text-decoration-none">
                                            Xóa
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>

                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/products" class="text-success fw-semibold text-decoration-none small">
                                <i class="fa-solid fa-arrow-left me-1"></i> Tiếp tục chọn thêm cây cảnh
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Khối Tóm tắt thanh toán -->
                <div class="col-lg-4">
                    <div class="bg-white p-4 rounded-4 border shadow-sm">
                        <h5 class="fw-bold mb-3 pb-2 border-bottom">Tóm Tắt Đơn Cây</h5>

                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Tạm tính (${sessionScope.cartCount} sản phẩm):</span>
                            <span class="fw-semibold">
                                <fmt:formatNumber value="${sessionScope.cartTotal}" type="number" groupingUsed="true"/>đ
                            </span>
                        </div>

                        <div class="d-flex justify-content-between mb-3 small">
                            <span class="text-muted">Phí vận chuyển dự kiến:</span>
                            <c:choose>
                                <c:when test="${sessionScope.cartTotal >= 300000}">
                                    <span class="text-success fw-bold">Miễn phí</span>
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

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success w-100 rounded-pill py-2 fw-bold mb-2">
                            Tiến Hành Đặt Hàng <i class="fa-solid fa-arrow-right ms-1"></i>
                        </a>

                        <div class="small text-muted text-center mt-2">
                            <i class="fa-solid fa-shield-halved text-success me-1"></i> Kèm thẻ hướng dẫn chăm sóc & bảo hành 14 ngày
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/inc/_footer.jsp" />