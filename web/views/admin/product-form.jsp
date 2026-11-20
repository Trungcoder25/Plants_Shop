<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/inc/_admin_sidebar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-1">${product != null ? 'Chỉnh Sửa Thông Tin Cây' : 'Thêm Chậu Cây Mới Vào Vườn'}</h4>
        <p class="text-muted small mb-0">Điền đầy đủ chỉ số sinh trưởng và cẩm nang để khách dễ chọn cây</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary rounded-pill px-4">
        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
    </a>
</div>

<form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data"
      class="bg-white p-4 p-md-5 rounded-4 border shadow-sm">
    <!-- Trường ẩn lưu ID và tên ảnh cũ khi ở chế độ Chỉnh sửa -->
    <input type="hidden" name="id" value="${product != null ? product.id : 0}">
    <input type="hidden" name="existingImage" value="${product != null ? product.image : ''}">

    <div class="row g-4">
        <!-- Cột trái: Thông tin bán hàng -->
        <div class="col-lg-6">
            <h6 class="fw-bold text-success border-bottom pb-2 mb-3">1. Thông Tin Cơ Bản & Giá Bán</h6>

            <div class="mb-3">
                <label class="form-label small fw-semibold">Tên sản phẩm cây cảnh <span class="text-danger">*</span></label>
                <input type="text" name="name" value="${product.name}" class="form-control" required
                       placeholder="Ví dụ: Cây Kim Ngân Thủy Sinh Để Bàn">
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Danh mục<span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select" required>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.id}" ${product != null && product.categoryId == c.id ? 'selected' : ''}>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Số lượng tồn kho <span class="text-danger">*</span></label>
                    <input type="number" name="stock" value="${product != null ? product.stock : 20}" min="0" class="form-control" required>
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Giá bán hiện tại (VNĐ) <span class="text-danger">*</span></label>
                    <input type="number" name="price" value="${product != null ? product.price.intValue() : ''}" min="1000" step="1000" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Giá gốc trước giảm (nếu có)</label>
                    <input type="number" name="oldPrice" value="${product != null && product.oldPrice > 0 ? product.oldPrice.intValue() : ''}" min="0" step="1000" class="form-control">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold">Hình ảnh sản phẩm</label>
                <input type="file" name="imageFile" accept="image/*" class="form-control">
                <c:if test="${not empty product.image}">
                    <div class="mt-2 d-flex align-items-center gap-2 small text-muted">
                        <img src="${pageContext.request.contextPath}/assets/images/${product.image}"
                             onerror="this.src='https://placehold.co/50x50/E8F5E9/1B4332?text=Img'"
                             class="rounded border" style="width: 48px; height: 48px; object-fit: cover;">
                        <span>Ảnh hiện tại: <code>${product.image}</code> (Bỏ trống nếu không muốn đổi ảnh)</span>
                    </div>
                </c:if>
            </div>

            <div class="form-check form-switch mt-3">
                <input class="form-check-input" type="checkbox" name="isFeatured" id="featSwitch" ${product.featured ? 'checked' : ''}>
                <label class="form-check-label fw-semibold small" for="featSwitch">Hiển thị ở mục "Cây Được Yêu Thích Nhất" trên Trang chủ</label>
            </div>
        </div>

        <!-- Cột phải: Thông số sinh trưởng & Cẩm nang kiểu Long Châu -->
        <div class="col-lg-6">
            <h6 class="fw-bold text-success border-bottom pb-2 mb-3">2. Chỉ Số Sinh Trưởng & Cẩm Nang Nghệ Nhân</h6>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Chiều cao cây / Quy cách</label>
                    <input type="text" name="plantHeight" value="${product.plantHeight}" class="form-control" placeholder="Ví dụ: 25 - 35 cm">
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Tần suất tưới nước</label>
                    <input type="text" name="waterFrequency" value="${product.waterFrequency}" class="form-control" placeholder="Ví dụ: 2 lần/tuần">
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Nhu cầu ánh sáng</label>
                    <select name="lightLevel" class="form-select">
                        <option value="Trong nhà" ${product.lightLevel == 'Trong nhà' ? 'selected' : ''}>Trong nhà</option>
                        <option value="Bán râm" ${product.lightLevel == 'Bán râm' ? 'selected' : ''}>Bán râm</option>
                        <option value="Nắng gắt" ${product.lightLevel == 'Nắng gắt' ? 'selected' : ''}>Nắng gắt</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-semibold">Độ khó chăm sóc</label>
                    <select name="careDifficulty" class="form-select">
                        <option value="Dễ chăm" ${product.careDifficulty == 'Dễ chăm' ? 'selected' : ''}>Dễ chăm</option>
                        <option value="Trung bình" ${product.careDifficulty == 'Trung bình' ? 'selected' : ''}>Trung bình</option>
                        <option value="Chuyên sâu" ${product.careDifficulty == 'Chuyên sâu' ? 'selected' : ''}>Chuyên sâu</option>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold">Mô tả đặc điểm & Ý nghĩa phong thủy</label>
                <textarea name="description" rows="3" class="form-control" required>${product.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold">Cẩm nang chăm sóc & Phòng bệnh cây</label>
                <textarea name="careGuide" rows="3" class="form-control"
                          placeholder="Hướng dẫn ánh sáng, lượng nước tưới và cách xử lý khi cây vàng lá...">${product.careGuide}</textarea>
            </div>
        </div>
    </div>

    <div class="mt-4 pt-3 border-top text-end">
        <button type="submit" class="btn btn-success btn-lg rounded-pill px-5 fw-bold">
            <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Thông Tin Cây Cảnh
        </button>
    </div>
</form>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>