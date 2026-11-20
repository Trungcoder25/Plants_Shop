<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không tìm thấy trang - Plants_shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100" style="background-color: #FAF8F5;">

    <div class="text-center p-5 bg-white rounded-4 border shadow-sm" style="max-width: 520px;">
        <!-- Biểu tượng cây xanh -->
        <div class="mx-auto mb-3 d-flex align-items-center justify-content-center rounded-circle"
             style="width: 80px; height: 80px; background-color: #D8F3DC; color: #1B4332;">
            <i class="fa-solid fa-seedling fa-2x"></i>
        </div>

        <!-- Phân biệt mã lỗi 404 (sai URL) và 500 (lỗi xử lý hệ thống) -->
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode == 404}">
                <h1 class="display-5 fw-bold text-success">404</h1>
                <h5 class="fw-bold text-dark mb-2">Chậu cây bạn tìm không có ở góc vườn này!</h5>
                <p class="text-muted small mb-4">
                    Đường dẫn có thể đã bị thay đổi hoặc trang không tồn tại. Hãy quay lại khu vườn chính để tiếp tục khám phá nhé.
                </p>
            </c:when>
            <c:otherwise>
                <h1 class="display-5 fw-bold text-warning">Ối!</h1>
                <h5 class="fw-bold text-dark mb-2">Hệ thống đang chăm sóc lại dữ liệu</h5>
                <p class="text-muted small mb-4">
                    Đã xảy ra sự cố tạm thời trong quá trình xử lý yêu cầu. Vui lòng thử lại hoặc quay về trang chủ.
                </p>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/home" class="btn btn-success rounded-pill px-4 py-2 fw-bold">
            <i class="fa-solid fa-house me-2"></i> Về Trang Chủ Plants_shop
        </a>
    </div>

</body>
</html>