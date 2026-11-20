<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/inc/_admin_sidebar.jsp" />

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <div>
        <h4 class="fw-bold mb-1">Quản Lý & Xử Lý Đơn Hàng</h4>
        <p class="text-muted small mb-0">Xác nhận đơn mới, cập nhật tiến độ đóng gói và giao cây cho khách</p>
    </div>

    <!-- Thanh lọc nhanh theo trạng thái đơn -->
    <div class="btn-group btn-group-sm">
        <a href="${pageContext.request.contextPath}/admin/orders"
           class="btn ${empty param.status ? 'btn-success' : 'btn-outline-secondary'}">Tất cả</a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING"
           class="btn ${param.status == 'PENDING' ? 'btn-warning' : 'btn-outline-secondary'}">Chờ xác nhận</a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=CONFIRMED"
           class="btn ${param.status == 'CONFIRMED' ? 'btn-info' : 'btn-outline-secondary'}">Đã xác nhận</a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=SHIPPING"
           class="btn ${param.status == 'SHIPPING' ? 'btn-primary' : 'btn-outline-secondary'}">Đang giao</a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED"
           class="btn ${param.status == 'DELIVERED' ? 'btn-success' : 'btn-outline-secondary'}">Hoàn thành</a>
    </div>
</div>

<c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show rounded-3 small">
        <i class="fa-solid fa-circle-check me-1"></i> Đã cập nhật trạng thái đơn hàng!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="bg-white p-4 rounded-4 border shadow-sm">
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light small text-uppercase">
                <tr>
                    <th>Mã đơn & Ngày đặt</th>
                    <th>Thông tin người nhận</th>
                    <th>Chi tiết cây đặt mua</th>
                    <th>Tổng tiền</th>
                    <th>Cập nhật trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="o">
                    <tr>
                        <td>
                            <div class="fw-bold text-dark">#ORD${o.id}</div>
                            <div class="small text-muted">
                                <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </td>
                        <td class="small">
                            <div class="fw-bold">${o.customerName} &bull; ${o.customerPhone}</div>
                            <div class="text-muted">${o.shippingAddress}</div>
                            <c:if test="${not empty o.note}">
                                <div class="text-primary fst-italic mt-1">Ghi chú: ${o.note}</div>
                            </c:if>
                        </td>
                        <td class="small">
                            <ul class="list-unstyled mb-0">
                                <c:forEach items="${o.details}" var="d">
                                    <li>&bull; <strong>${d.productName}</strong> (x${d.quantity})</li>
                                </c:forEach>
                            </ul>
                        </td>
                        <td class="fw-bold text-success text-nowrap">
                            <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/>đ
                        </td>
                        <td style="min-width: 220px;">
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex gap-2">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <select name="status" class="form-select form-select-sm">
                                    <option value="PENDING" ${o.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="CONFIRMED" ${o.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="SHIPPING" ${o.status == 'SHIPPING' ? 'selected' : ''}>Đang giao cây</option>
                                    <option value="DELIVERED" ${o.status == 'DELIVERED' ? 'selected' : ''}>Giao thành công</option>
                                    <option value="CANCELLED" ${o.status == 'CANCELLED' ? 'selected' : ''}>Hủy đơn</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-success px-3">Lưu</button>
                            </form>
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