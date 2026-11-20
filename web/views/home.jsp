<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <!-- 1. Hero Banner & Khối chọn nhanh theo điều kiện sống -->
    <div class="row g-3 mb-4">
        <div class="col-lg-8">
            <div class="p-4 p-md-5 rounded-4 text-white h-100 d-flex flex-column justify-content-center"
                 style="background: linear-gradient(135deg, #1B4332 0%, #40916C 100%);">
                <span class="badge bg-warning text-dark align-self-start mb-2 px-3 py-2 rounded-pill">
                    <i class="fa-solid fa-sparkles me-1"></i> Bộ Sưu Tập Xanh 2026
                </span>
                <h1 class="fw-bold mb-3">Mang Thiên Nhiên Chuẩn Sạch Vào Không Gian Sống</h1>
                <p class="opacity-90 mb-4">
                    Chọn cây đúng ánh sáng phòng bạn &mdash; Có sẵn hồ sơ theo dõi nước tưới và cẩm nang phòng bệnh từ nghệ nhân.
                </p>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-warning fw-bold px-4 py-2 rounded-pill">
                        Khám phá vườn cây <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/products?difficulty=Dễ+chăm" class="btn btn-outline-light px-4 py-2 rounded-pill">
                        Cây cho người mới bắt đầu
                    </a>
                </div>
            </div>
        </div>

        <!-- Khối chọn nhanh theo ánh sáng (Đặc trưng riêng của Plants_shop) -->
        <div class="col-lg-4">
            <div class="bg-white p-4 rounded-4 border h-100 d-flex flex-column justify-content-between">
                <div>
                    <h6 class="fw-bold text-success text-uppercase mb-3">
                        <i class="fa-solid fa-sun me-1"></i> Chọn cây theo ánh sáng phòng
                    </h6>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/products?light=Trong+nhà"
                           class="btn btn-light text-start border d-flex justify-content-between align-items-center p-3 rounded-3">
                            <span><i class="fa-solid fa-laptop-house text-success me-2"></i> Phòng kín / Văn phòng</span>
                            <i class="fa-solid fa-chevron-right text-muted small"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?light=Bán+râm"
                           class="btn btn-light text-start border d-flex justify-content-between align-items-center p-3 rounded-3">
                            <span><i class="fa-solid fa-cloud-sun text-warning me-2"></i> Gần cửa sổ / Ban công râm</span>
                            <i class="fa-solid fa-chevron-right text-muted small"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?light=Nắng+gắt"
                           class="btn btn-light text-start border d-flex justify-content-between align-items-center p-3 rounded-3">
                            <span><i class="fa-solid fa-sun text-danger me-2"></i> Sân thượng / Nắng trực tiếp</span>
                            <i class="fa-solid fa-chevron-right text-muted small"></i>
                        </a>
                    </div>
                </div>
                <div class="mt-3 pt-2 border-top small text-muted">
                    <i class="fa-solid fa-circle-info text-success me-1"></i> Chọn đúng ánh sáng giúp cây sống bền gấp 3 lần.
                </div>
            </div>
        </div>
    </div>

    <!-- 2. Danh mục nổi bật -->
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold mb-0"><i class="fa-solid fa-layer-group text-success me-2"></i>Danh Mục Vườn Cây</h4>
        </div>
        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3">
            <c:forEach items="${categories}" var="cat">
                <div class="col">
                    <a href="${pageContext.request.contextPath}/products?cid=${cat.id}" class="cat-card">
                        <div class="cat-icon-circle">
                            <i class="fa-solid ${cat.icon}"></i>
                        </div>
                        <div class="fw-bold mb-1">${cat.name}</div>
                        <div class="small text-muted text-truncate">${cat.description}</div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- 3. Cây Nổi Bật & Dễ Chăm Sóc -->
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold mb-0"><i class="fa-solid fa-fire text-danger me-2"></i>Cây Được Yêu Thích Nhất</h4>
            <a href="${pageContext.request.contextPath}/products" class="text-success fw-semibold text-decoration-none">
                Xem tất cả <i class="fa-solid fa-angle-right"></i>
            </a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-4">
            <c:forEach items="${featuredProducts}" var="p">
                <div class="col">
                    <div class="plant-card">
                        <a href="${pageContext.request.contextPath}/detail?id=${p.id}" class="plant-img-wrap">
                            <img src="${pageContext.request.contextPath}/assets/images/${p.image}"
                                 onerror="this.src='https://placehold.co/400x360/E8F5E9/1B4332?text=${p.name}'"
                                 alt="${p.name}">
                            <span class="badge-difficulty">${p.careDifficulty}</span>
                        </a>
                        <div class="p-3 d-flex flex-column flex-grow-1">
                            <div class="small text-muted mb-1">${p.categoryName}</div>
                            <a href="${pageContext.request.contextPath}/detail?id=${p.id}"
                               class="fw-bold text-dark text-decoration-none mb-2">
                                ${p.name}
                            </a>

                            <!-- 3 thông số sinh trưởng trực quan -->
                            <div class="plant-specs">
                                <span class="spec-pill" title="Nhu cầu ánh sáng">
                                    <i class="fa-solid fa-sun text-warning"></i> ${p.lightLevel}
                                </span>
                                <span class="spec-pill" title="Tần suất tưới">
                                    <i class="fa-solid fa-droplet text-primary"></i> ${p.waterFrequency}
                                </span>
                            </div>

                            <div class="mt-auto pt-2">
                                <div class="mb-2">
                                    <span class="price-current">
                                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                    </span>
                                    <c:if test="${p.oldPrice > p.price}">
                                        <span class="price-old">
                                            <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/>đ
                                        </span>
                                    </c:if>
                                </div>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-buy-plant">
                                        <i class="fa-solid fa-cart-plus me-1"></i> Chọn mua
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- 4. Góc Cẩm Nang Bắt Bệnh Cây Cảnh (Biến tấu từ Góc Sức Khỏe của Long Châu) -->
    <section class="care-guide-banner">
        <div class="row align-items-center g-4">
            <div class="col-lg-7">
                <span class="badge bg-success mb-2">Cẩm Nang Nghệ Nhân Plants_shop</span>
                <h3 class="fw-bold text-dark mb-2">Cây nhà bạn đang bị vàng lá, rệp sáp hay úng rễ?</h3>
                <p class="text-muted mb-3">
                    Mỗi trang chi tiết sản phẩm tại <strong>Plants_shop</strong> đều tích hợp sẵn <em>Phác đồ chăm sóc</em>: 
                    lượng nước chuẩn ml, vị trí đặt hợp phong thủy và loại dinh dưỡng phục hồi tương ứng.
                </p>
                <a href="${pageContext.request.contextPath}/products?cid=5" class="btn btn-success rounded-pill px-4">
                    <i class="fa-solid fa-kit-medical me-1"></i> Xem tủ thuốc & dinh dưỡng cho cây
                </a>
            </div>
            <div class="col-lg-5">
                <div class="bg-white p-3 rounded-4 border">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-warning-subtle text-warning p-3 rounded-3"><i class="fa-solid fa-leaf fa-lg"></i></div>
                        <div>
                            <div class="fw-bold">Vàng lá ngọn & cháy mép</div>
                            <div class="small text-muted">Thường do nắng gắt trực tiếp hoặc thiếu độ ẩm không khí.</div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary-subtle text-primary p-3 rounded-3"><i class="fa-solid fa-droplet-slash fa-lg"></i></div>
                        <div>
                            <div class="fw-bold">Mềm thân, vàng lá gốc</div>
                            <div class="small text-muted">Dấu hiệu thừa nước gây úng rễ, cần ngưng tưới 7-10 ngày.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/inc/_footer.jsp" />