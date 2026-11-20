<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_admin_sidebar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-1">Quản Lý Danh Mục Cây Cảnh</h4>
        <p class="text-muted small mb-0">Thêm mới, cập nhật thông số sinh trưởng, cẩm nang chăm sóc và tồn kho</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/products?action=create" class="btn btn-success rounded-pill px-4 fw-bold">
        <i class="fa-solid fa-plus me-1"></i> Thêm Cây Mới
    </a>
</div>

<c:if test="${param.msg == 'saved'}">
    <div class="alert alert-success alert-dismissible fade show rounded-3 small">
        <i class="fa-solid fa-circle-check me-1"></i> Đã lưu thông tin sản phẩm cây cảnh thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
    <div class="alert alert-warning alert-dismissible fade show rounded-3 small">
        <i class="fa-solid fa-trash-can me-1"></i> Đã xóa sản phẩm khỏi hệ thống.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="bg-white p-4 rounded-4 border shadow-sm">
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light small text-uppercase">
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tên cây & Danh mục</th>
                    <th>Thông số chăm sóc</th>
                    <th>Giá bán</th>
                    <th>Tồn kho</th>
                    <th class="text-end">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${products}" var="p">
                    <tr>
                        <td class="fw-bold text-muted">#${p.id}</td>
                        <td>
                            <img src="${pageContext.request.contextPath}/assets/images/${p.image}"
                                 onerror="this.src='https://placehold.co/60x60/E8F5E9/1B4332?text=Plant'"
                                 class="rounded-3 border" style="width: 56px; height: 56px; object-fit: cover;">
                        </td>
                        <td>
                            <div class="fw-bold text-dark">${p.name}</div>
                            <span class="badge bg-success-subtle text-success small">${p.categoryName}</span>
                            <c:if test="${p.featured}">
                                <span class="badge bg-warning text-dark small">Nổi bật</span>
                            </c:if>
                        </td>
                        <td class="small">
                            <div><i class="fa-solid fa-sun text-warning me-1"></i> ${p.lightLevel}</div>
                            <div><i class="fa-solid fa-droplet text-primary me-1"></i> ${p.waterFrequency} (${p.careDifficulty})</div>
                        </td>
                        <td>
                            <div class="fw-bold text-success">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                            </div>
                            <c:if test="${p.oldPrice > p.price}">
                                <div class="small text-muted text-decoration-line-through">
                                    <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/>đ
                                </div>
                            </c:if>
                        </td>
                        <td>
                            <span class="badge ${p.stock > 10 ? 'bg-light text-dark border' : 'bg-danger text-white'}">
                                ${p.stock} chậu
                            </span>
                        </td>
                        <td class="text-end text-nowrap">
                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}"
                               class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                <i class="fa-solid fa-pen"></i> Sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa cây [${p.name}] không?');"
                               class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                <i class="fa-solid fa-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>