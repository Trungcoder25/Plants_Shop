<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products?cid=${product.categoryId}" class="text-success text-decoration-none">${product.categoryName}</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <!-- Khối thông tin chính -->
    <div class="bg-white p-4 rounded-4 border shadow-sm mb-4">
        <div class="row g-4">
            <!-- Ảnh sản phẩm -->
            <div class="col-lg-5">
                <div class="rounded-4 overflow-hidden border bg-light position-relative">
                    <img src="${pageContext.request.contextPath}/assets/images/${product.image}"
                         onerror="this.src='https://placehold.co/600x550/E8F5E9/1B4332?text=${product.name}'"
                         class="img-fluid w-100" style="max-height: 440px; object-fit: cover;" alt="${product.name}">
                    <span class="badge bg-success position-absolute top-0 start-0 m-3 px-3 py-2 rounded-pill">
                        <i class="fa-solid fa-shield-heart me-1"></i> Cây khỏe chuẩn vườn
                    </span>
                </div>
            </div>

            <!-- Thông số sinh trưởng & Đặt mua -->
            <div class="col-lg-7">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-success-subtle text-success border border-success-subtle">${product.categoryName}</span>
                    <span class="small text-muted">Mã cây: <strong>#PL${product.id}</strong></span>
                </div>

                <h2 class="fw-bold text-dark mb-3">${product.name}</h2>

                <!-- Giá bán -->
                <div class="p-3 rounded-3 mb-4" style="background-color: #F4F9F6;">
                    <div class="d-flex align-items-baseline gap-3">
                        <span class="fs-2 fw-bold text-success">
                            <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>đ
                        </span>
                        <c:if test="${product.oldPrice > product.price}">
                            <span class="text-muted text-decoration-line-through fs-5">
                                <fmt:formatNumber value="${product.oldPrice}" type="number" groupingUsed="true"/>đ
                            </span>
                            <span class="badge bg-warning text-dark">Giá ưu đãi vườn</span>
                        </c:if>
                    </div>
                    <div class="small text-muted mt-1">
                        Tình trạng: 
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="text-success fw-semibold">Còn ${product.stock} chậu sẵn sàng giao</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-danger fw-semibold">Tạm hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Bảng 4 chỉ số sinh trưởng đặc trưng -->
                <div class="row row-cols-2 row-cols-md-4 g-2 mb-4">
                    <div class="col">
                        <div class="p-2 border rounded-3 text-center bg-light h-100">
                            <i class="fa-solid fa-ruler-vertical text-success mb-1"></i>
                            <div class="small text-muted">Chiều cao</div>
                            <div class="fw-bold small">${product.plantHeight}</div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 border rounded-3 text-center bg-light h-100">
                            <i class="fa-solid fa-sun text-warning mb-1"></i>
                            <div class="small text-muted">Ánh sáng</div>
                            <div class="fw-bold small">${product.lightLevel}</div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 border rounded-3 text-center bg-light h-100">
                            <i class="fa-solid fa-droplet text-primary mb-1"></i>
                            <div class="small text-muted">Tưới nước</div>
                            <div class="fw-bold small">${product.waterFrequency}</div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 border rounded-3 text-center bg-light h-100">
                            <i class="fa-solid fa-hand-holding-heart text-danger mb-1"></i>
                            <div class="small text-muted">Độ khó</div>
                            <div class="fw-bold small">${product.careDifficulty}</div>
                        </div>
                    </div>
                </div>

                <!-- Form chọn số lượng & Thêm giỏ hàng -->
                <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">

                    <div class="d-flex align-items-center gap-3 mb-3">
                        <label class="fw-semibold">Chọn số lượng:</label>
                        <div class="input-group" style="width: 135px;">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
                            <input type="number" id="qtyInput" name="quantity" value="1" min="1" max="${product.stock}" class="form-control text-center fw-bold">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
                        </div>
                    </div>

                    <div class="d-flex gap-2 flex-wrap">
                        <button type="submit" class="btn btn-success btn-lg rounded-pill px-5 fw-bold" ${product.stock <= 0 ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-plus me-2"></i> Thêm vào giỏ hàng
                        </button>
                        <a href="tel:18006868" class="btn btn-outline-success btn-lg rounded-pill px-4">
                            <i class="fa-solid fa-headset me-1"></i> Hỏi nghệ nhân
                        </a>
                    </div>
                </form>

                <!-- Cam kết chuẩn Long Châu phiên bản Vườn Cây -->
                <div class="row g-2 pt-3 border-top small text-muted">
                    <div class="col-md-4"><i class="fa-solid fa-rotate-left text-success me-1"></i> Đổi cây mới trong 14 ngày</div>
                    <div class="col-md-4"><i class="fa-solid fa-truck-fast text-success me-1"></i> Giao hỏa tốc chống sốc</div>
                    <div class="col-md-4"><i class="fa-solid fa-book-medical text-success me-1"></i> Tặng kèm thẻ nhắc tưới</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Khối dưới: Phác đồ chăm sóc & Gợi ý dinh dưỡng mua kèm -->
    <div class="row g-4 mb-5">
        <div class="col-lg-8">
            <div class="bg-white p-4 rounded-4 border shadow-sm h-100">
                <h5 class="fw-bold text-success mb-3"><i class="fa-solid fa-file-lines me-2"></i>Đặc Điểm & Ý Nghĩa Cây Trồng</h5>
                <p class="text-secondary lh-lg">${product.description}</p>

                <hr class="my-4">

                <div class="p-4 rounded-4" style="background-color: #F2F8F4; border-left: 5px solid #2D6A4F;">
                    <h5 class="fw-bold text-dark mb-3">
                        <i class="fa-solid fa-stethoscope text-success me-2"></i>Cẩm Nang Chăm Sóc & Phòng Bệnh Từ Nghệ Nhân
                    </h5>
                    <div class="lh-lg text-dark">
                        ${product.careGuide}
                    </div>
                </div>
            </div>
        </div>

        <!-- Cột phải: Dinh dưỡng & Phụ kiện thường mua kèm -->
        <div class="col-lg-4">
            <div class="bg-white p-4 rounded-4 border shadow-sm">
                <h6 class="fw-bold text-uppercase text-success mb-3">
                    <i class="fa-solid fa-kit-medical me-1"></i> Dinh dưỡng & Chậu khuyên dùng
                </h6>
                <c:forEach items="${careAccessories}" var="acc">
                    <div class="d-flex gap-3 align-items-center pb-3 mb-3 border-bottom">
                        <img src="${pageContext.request.contextPath}/assets/images/${acc.image}"
                             onerror="this.src='https://placehold.co/80x80/E8F5E9/1B4332?text=Care'"
                             class="rounded-3 border" style="width: 64px; height: 64px; object-fit: cover;" alt="${acc.name}">
                        <div class="flex-grow-1">
                            <a href="${pageContext.request.contextPath}/detail?id=${acc.id}" class="fw-semibold text-dark text-decoration-none small d-block">
                                ${acc.name}
                            </a>
                            <div class="text-success fw-bold small">
                                <fmt:formatNumber value="${acc.price}" type="number" groupingUsed="true"/>đ
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${acc.id}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-sm btn-outline-success rounded-pill" title="Thêm vào giỏ">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Cây cùng danh mục -->
    <c:if test="${not empty relatedProducts}">
        <section>
            <h4 class="fw-bold mb-3">Cây Cảnh Cùng Nhóm</h4>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-4">
                <c:forEach items="${relatedProducts}" var="rp">
                    <div class="col">
                        <div class="plant-card">
                            <a href="${pageContext.request.contextPath}/detail?id=${rp.id}" class="plant-img-wrap">
                                <img src="${pageContext.request.contextPath}/assets/images/${rp.image}"
                                     onerror="this.src='https://placehold.co/400x360/E8F5E9/1B4332?text=${rp.name}'"
                                     alt="${rp.name}">
                            </a>
                            <div class="p-3">
                                <a href="${pageContext.request.contextPath}/detail?id=${rp.id}" class="fw-bold text-dark text-decoration-none d-block mb-1">
                                    ${rp.name}
                                </a>
                                <div class="price-current">
                                    <fmt:formatNumber value="${rp.price}" type="number" groupingUsed="true"/>đ
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>

<script>
    function changeQty(delta) {
        const input = document.getElementById('qtyInput');
        const max = parseInt(input.max) || 99;
        let val = parseInt(input.value) || 1;
        val += delta;
        if (val < 1) val = 1;
        if (val > max) val = max;
        input.value = val;
    }
</script>

<jsp:include page="/inc/_footer.jsp" />