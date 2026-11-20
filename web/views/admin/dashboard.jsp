<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_admin_sidebar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-1">Tổng Quan Hoạt Động Vườn Cây</h4>
        <p class="text-muted small mb-0">Theo dõi doanh thu, đơn hàng mới và cảnh báo tồn kho cây cảnh</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/products?action=create" class="btn btn-success rounded-pill px-4 fw-semibold">
        <i class="fa-solid fa-plus me-1"></i> Nhập cây mới
    </a>
</div>

<!-- 4 Thẻ thống kê KPI -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="kpi-card shadow-sm">
            <div class="small text-muted fw-semibold mb-1">DOANH THU DỰ KIẾN</div>
            <div class="fs-4 fw-bold text-success">
                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>đ
            </div>
            <div class="small text-muted mt-1"><i class="fa-solid fa-circle-check text-success me-1"></i>Tính trên đơn hợp lệ</div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="kpi-card shadow-sm">
            <div class="small text-muted fw-semibold mb-1">ĐƠN CHỜ XÁC NHẬN</div>
            <div class="fs-4 fw-bold text-warning">${pendingOrdersCount} <span class="fs-6 fw-normal text-muted">/ ${totalOrders} đơn</span></div>
            <div class="small mt-1"><a href="${pageContext.request.contextPath}/admin/orders?status=PENDING" class="text-decoration-none">Xử lý ngay &rarr;</a></div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="kpi-card shadow-sm">
            <div class="small text-muted fw-semibold mb-1">MẪU CÂY ĐANG BÁN</div>
            <div class="fs-4 fw-bold text-dark">${totalProducts} <span class="fs-6 fw-normal text-muted">sản phẩm</span></div>
            <div class="small text-muted mt-1">Thuộc 5 nhóm danh mục</div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="kpi-card shadow-sm">
            <div class="small text-muted fw-semibold mb-1">THÀNH VIÊN ĐĂNG KÝ</div>
            <div class="fs-4 fw-bold text-primary">${totalUsers} <span class="fs-6 fw-normal text-muted">tài khoản</span></div>
            <div class="small text-muted mt-1">Khách hàng & Quản trị</div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!-- Bảng 5 đơn hàng mới nhất -->
    <div class="col-lg-7">
        <div class="bg-white p-4 rounded-4 border shadow-sm h-100">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h6 class="fw-bold mb-0"><i class="fa-solid fa-clock-rotate-left text-success me-2"></i>Đơn Hàng Mới Nhất</h6>
                <a href="${pageContext.request.contextPath}/admin/orders" class="small text-success text-decoration-none fw-semibold">Xem tất cả</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle small">
                    <thead class="table-light">
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${recentOrders}" var="o">
                            <tr>
                                <td class="fw-bold">#ORD${o.id}</td>
                                <td>
                                    <div class="fw-semibold">${o.customerName}</div>
                                    <div class="text-muted" style="font-size: 0.78rem;">${o.customerPhone}</div>
                                </td>
                                <td class="fw-bold text-success">
                                    <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/>đ
                                </td>
                                <td>
                                    <span class="badge bg-secondary-subtle text-dark">${o.status}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Cảnh báo cây sắp hết tồn kho -->
    <div class="col-lg-5">
        <div class="bg-white p-4 rounded-4 border shadow-sm h-100">
            <h6 class="fw-bold mb-3 text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i>Cảnh Báo Sắp Hết Hàng (&le; 15 chậu)</h6>
            <c:choose>
                <c:when test="${empty lowStockProducts}">
                    <p class="text-muted small">Tất cả các mẫu cây trong vườn đều đang có số lượng ổn định.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${lowStockProducts}" var="lp">
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <div>
                                <div class="fw-semibold small">${lp.name}</div>
                                <div class="text-muted" style="font-size: 0.75rem;">${lp.categoryName}</div>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-danger-subtle text-danger">Còn ${lp.stock}</span>
                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${lp.id}"
                                   class="btn btn-sm btn-outline-success py-0 px-2">Nhập thêm</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

        </div> <!-- Đóng cột phải từ _admin_sidebar.jsp -->
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>