<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/inc/_header.jsp" />

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="bg-white p-4 p-md-5 rounded-4 border shadow-sm">
                <div class="text-center mb-4">
                    <h4 class="fw-bold text-dark">Tạo Tài Khoản Thành Viên Xanh</h4>
                    <p class="small text-muted">Nhận ưu đãi dinh dưỡng cây và bảo hành cây khỏe 14 ngày</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger small">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" value="${param.fullName}" class="form-control" placeholder="Nguyễn Văn A" required>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" value="${param.email}" class="form-control" placeholder="email@gmail.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" name="phone" value="${param.phone}" class="form-control" placeholder="0901234567" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Địa chỉ nhận cây mặc định</label>
                        <input type="text" name="address" value="${param.address}" class="form-control" placeholder="Số nhà, tên đường, phường/xã...">
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="password" class="form-control" minlength="6" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Nhập lại mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="confirmPassword" class="form-control" minlength="6" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 rounded-pill py-2 fw-bold mb-3">
                        Hoàn Tất Đăng Ký
                    </button>
                </form>

                <div class="text-center small">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/login" class="text-success fw-bold text-decoration-none">Đăng nhập tại đây</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/inc/_footer.jsp" />