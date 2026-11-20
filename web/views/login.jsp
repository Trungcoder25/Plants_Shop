<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="bg-white p-4 p-md-5 rounded-4 border shadow-sm">
                <div class="text-center mb-4">
                    <div class="cat-icon-circle mb-2">
                        <i class="fa-solid fa-seedling"></i>
                    </div>
                    <h4 class="fw-bold text-dark">Chào mừng trở lại Plants_shop</h4>
                    <p class="small text-muted">Đăng nhập để theo dõi đơn cây và lịch sử chăm sóc</p>
                </div>

                <c:if test="${param.registered == '1'}">
                    <div class="alert alert-success small">
                        <i class="fa-solid fa-circle-check me-1"></i> Đăng ký thành công! Vui lòng đăng nhập.
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger small">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> ${error}
                    </div>
                </c:if>

                <!--Thông báo phải đăng nhập-->
                <c:if test="${param.msg == 'login_required'}">
                    <div class="alert alert-warning rounded-3 small py-2 mb-3">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Vui lòng đăng nhập tài khoản để thêm cây vào giỏ hoặc tiến hành đặt hàng!
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email đăng nhập</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-regular fa-envelope text-muted"></i></span>
                            <input type="email" name="email" value="${email}" class="form-control" placeholder="nhapemail@gmail.com" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 rounded-pill py-2 fw-bold mb-3">
                        Đăng Nhập
                    </button>
                </form>

                <div class="text-center small">
                    Chưa có tài khoản thành viên?
                    <a href="${pageContext.request.contextPath}/register" class="text-success fw-bold text-decoration-none">Đăng ký ngay</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/inc/_footer.jsp" />