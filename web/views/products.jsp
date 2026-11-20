<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">${currentCategoryName}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Cột trái: Bộ lọc nâng cao theo đặc tính cây -->
        <div class="col-lg-3">
            <form action="${pageContext.request.contextPath}/products" method="get" class="bg-white p-4 rounded-4 border shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h6 class="fw-bold mb-0 text-success"><i class="fa-solid fa-filter me-1"></i> Bộ Lọc Chuyên Sâu</h6>
                    <a href="${pageContext.request.contextPath}/products" class="small text-muted text-decoration-none">Xóa lọc</a>
                </div>

                <!-- Giữ từ khóa nếu đang tìm -->
                <c:if test="${not empty param.keyword}">
                    <input type="hidden" name="keyword" value="${param.keyword}">
                </c:if>

                <!-- 1. Lọc theo Danh mục -->
                <div class="mb-4">
                    <label class="fw-bold small text-uppercase text-muted mb-2 d-block">Danh mục cây</label>
                    <div class="form-check mb-1">
                        <input class="form-check-input" type="radio" name="cid" id="catAll" value="" ${empty param.cid ? 'checked' : ''}>
                        <label class="form-check-label small" for="catAll">Tất cả danh mục</label>
                    </div>
                    <c:forEach items="${categories}" var="c">
                        <div class="form-check mb-1">
                            <input class="form-check-input" type="radio" name="cid" id="cat${c.id}" value="${c.id}" ${param.cid == c.id ? 'checked' : ''}>
                            <label class="form-check-label small" for="cat${c.id}">${c.name}</label>
                        </div>
                    </c:forEach>
                </div>

                <!-- 2. Lọc theo Nhu cầu ánh sáng -->
                <div class="mb-4">
                    <label class="fw-bold small text-uppercase text-muted mb-2 d-block">Vị trí & Ánh sáng</label>
                    <select name="light" class="form-select form-select-sm">
                        <option value="">-- Tất cả mức sáng --</option>
                        <option value="Trong nhà" ${param.light == 'Trong nhà' ? 'selected' : ''}>Trong nhà / Thiếu sáng</option>
                        <option value="Bán râm" ${param.light == 'Bán râm' ? 'selected' : ''}>Bán râm / Gần cửa sổ</option>
                        <option value="Nắng gắt" ${param.light == 'Nắng gắt' ? 'selected' : ''}>Nắng gắt / Ban công</option>
                    </select>
                </div>

                <!-- 3. Lọc theo Độ khó chăm sóc -->
                <div class="mb-4">
                    <label class="fw-bold small text-uppercase text-muted mb-2 d-block">Kinh nghiệm chăm cây</label>
                    <select name="difficulty" class="form-select form-select-sm">
                        <option value="">-- Tất cả mức độ --</option>
                        <option value="Dễ chăm" ${param.difficulty == 'Dễ chăm' ? 'selected' : ''}>Dễ chăm (Cho người mới)</option>
                        <option value="Trung bình" ${param.difficulty == 'Trung bình' ? 'selected' : ''}>Trung bình</option>
                        <option value="Chuyên sâu" ${param.difficulty == 'Chuyên sâu' ? 'selected' : ''}>Chuyên sâu (Nghệ nhân)</option>
                    </select>
                </div>

                <!-- Giữ trạng thái sắp xếp -->
                <input type="hidden" name="sort" value="${param.sort}">

                <button type="submit" class="btn btn-success w-100 rounded-pill fw-semibold">
                    Áp dụng bộ lọc
                </button>
            </form>
        </div>

        <!-- Cột phải: Kết quả & Sắp xếp -->
        <div class="col-lg-9">
            <div class="bg-white p-3 rounded-4 border mb-4 d-flex flex-wrap justify-content-between align-items-center gap-2">
                <div>
                    <h5 class="fw-bold mb-0">${currentCategoryName}</h5>
                    <span class="small text-muted">
                        Tìm thấy <strong>${products.size()}</strong> sản phẩm phù hợp
                        <c:if test="${not empty param.keyword}"> cho từ khóa "<em>${param.keyword}</em>"</c:if>
                    </span>
                </div>

                <!-- Thanh sắp xếp nhanh kiểu Long Châu -->
                <div class="d-flex align-items-center gap-2">
                    <span class="small text-muted d-none sm-inline">Sắp xếp:</span>
                    <div class="btn-group btn-group-sm" role="group">
                        <a href="${pageContext.request.contextPath}/products?cid=${param.cid}&keyword=${param.keyword}&light=${param.light}&difficulty=${param.difficulty}&sort="
                           class="btn ${empty param.sort ? 'btn-success' : 'btn-outline-secondary'}">Mới nhất</a>
                        <a href="${pageContext.request.contextPath}/products?cid=${param.cid}&keyword=${param.keyword}&light=${param.light}&difficulty=${param.difficulty}&sort=price_asc"
                           class="btn ${param.sort == 'price_asc' ? 'btn-success' : 'btn-outline-secondary'}">Giá thấp</a>
                        <a href="${pageContext.request.contextPath}/products?cid=${param.cid}&keyword=${param.keyword}&light=${param.light}&difficulty=${param.difficulty}&sort=price_desc"
                           class="btn ${param.sort == 'price_desc' ? 'btn-success' : 'btn-outline-secondary'}">Giá cao</a>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty products}">
                    <div class="bg-white p-5 rounded-4 border text-center">
                        <i class="fa-solid fa-seedling fa-3x text-muted mb-3"></i>
                        <h5>Không tìm thấy chậu cây nào khớp với bộ lọc</h5>
                        <p class="text-muted small">Bạn thử nới lỏng điều kiện ánh sáng hoặc xóa từ khóa tìm kiếm nhé.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-success rounded-pill px-4">Xem toàn bộ vườn cây</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                        <c:forEach items="${products}" var="p">
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

                                        <div class="plant-specs">
                                            <span class="spec-pill"><i class="fa-solid fa-sun text-warning"></i> ${p.lightLevel}</span>
                                            <span class="spec-pill"><i class="fa-solid fa-droplet text-primary"></i> ${p.waterFrequency}</span>
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
                                                <button type="submit" class="btn-buy-plant" ${p.stock <= 0 ? 'disabled' : ''}>
                                                    <i class="fa-solid fa-cart-plus me-1"></i> ${p.stock > 0 ? 'Chọn mua' : 'Tạm hết cây'}
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/inc/_footer.jsp" />