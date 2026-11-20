document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchInput");
    const searchDropdown = document.getElementById("searchDropdown");
    const searchForm = document.getElementById("searchForm");

    if (!searchInput || !searchDropdown) return;

    // Tự động lấy contextPath của ứng dụng (ví dụ: /Plants_Shop)
    const contextPath = searchForm.getAttribute("action").replace("/products", "");
    let debounceTimer = null;

    // Định dạng tiền tệ VNĐ
    const formatVND = (amount) => new Intl.NumberFormat("vi-VN").format(amount) + "đ";

    // Hiển thị gợi ý xu hướng & tra cứu nhanh khi ô tìm kiếm trống
    function showPopularSuggestions() {
        searchDropdown.innerHTML = `
            <div class="p-3">
                <div class="small fw-bold text-success text-uppercase mb-2">
                    <i class="fa-solid fa-fire text-warning me-1"></i> Tra cứu nhanh & Phổ biến
                </div>
                <div>
                    <a href="${contextPath}/products?keyword=Kim+Tiền" class="search-chip">Cây Kim Tiền</a>
                    <a href="${contextPath}/products?keyword=Lưỡi+Hổ" class="search-chip">Cây Lưỡi Hổ</a>
                    <a href="${contextPath}/products?keyword=Sen+Đá" class="search-chip">Sen đá để bàn</a>
                    <a href="${contextPath}/products?keyword=vàng+lá" class="search-chip">
                        <i class="fa-solid fa-stethoscope text-danger me-1"></i>Trị vàng lá / Úng rễ
                    </a>
                    <a href="${contextPath}/products?keyword=Phân+bón" class="search-chip">Phân bón hữu cơ</a>
                </div>
            </div>
        `;
        searchDropdown.classList.remove("d-none");
    }

    // Gọi API /api/search-suggest để lấy kết quả theo từ khóa
    function fetchSuggestions(keyword) {
        fetch(`${contextPath}/api/search-suggest?q=${encodeURIComponent(keyword)}`)
            .then((res) => res.json())
            .then((items) => {
                if (!items || items.length === 0) {
                    searchDropdown.innerHTML = `
                        <div class="p-4 text-center small text-muted">
                            <i class="fa-solid fa-seedling fa-lg mb-2 d-block text-success"></i>
                            Không tìm thấy cây phù hợp với "<strong>${keyword}</strong>".<br>
                            Thử tìm theo triệu chứng (ví dụ: <em>vàng lá</em>) hoặc tên cây khác nhé!
                        </div>
                    `;
                    searchDropdown.classList.remove("d-none");
                    return;
                }

                let html = `<div class="px-3 py-2 bg-light small fw-semibold text-muted border-bottom">
                                Sản phẩm & Giải pháp gợi ý
                            </div>`;

                items.forEach((item) => {
                    const imgUrl = `${contextPath}/assets/images/${item.image}`;
                    const fallbackUrl = `https://placehold.co/60x60/E8F5E9/1B4332?text=Plant`;

                    html += `
                        <a href="${contextPath}/detail?id=${item.id}" class="search-suggest-item">
                            <img src="${imgUrl}" onerror="this.src='${fallbackUrl}'" alt="${item.name}">
                            <div class="flex-grow-1 overflow-hidden">
                                <div class="fw-bold text-truncate small">${item.name}</div>
                                <div class="text-muted" style="font-size: 0.75rem;">
                                    <span class="text-success">${item.categoryName}</span> &bull;
                                    <i class="fa-solid fa-sun text-warning"></i> ${item.lightLevel}
                                </div>
                            </div>
                            <div class="fw-bold text-success small text-nowrap">
                                ${formatVND(item.price)}
                            </div>
                        </a>
                    `;
                });

                // Nút xem toàn bộ kết quả ở đáy khung gợi ý
                html += `
                    <a href="${contextPath}/products?keyword=${encodeURIComponent(keyword)}"
                       class="d-block text-center py-2 bg-light text-success fw-bold small text-decoration-none">
                        Xem tất cả kết quả cho "${keyword}" <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                `;

                searchDropdown.innerHTML = html;
                searchDropdown.classList.remove("d-none");
            })
            .catch((err) => console.error("Lỗi tìm kiếm:", err));
    }

    // Khi bấm chuột vào ô tìm kiếm
    searchInput.addEventListener("focus", function () {
        const val = this.value.trim();
        if (val.length === 0) {
            showPopularSuggestions();
        } else {
            fetchSuggestions(val);
        }
    });

    // Khi gõ phím (trì hoãn 250ms để tránh gửi request liên tục mỗi ký tự)
    searchInput.addEventListener("input", function () {
        clearTimeout(debounceTimer);
        const val = this.value.trim();

        if (val.length === 0) {
            showPopularSuggestions();
            return;
        }

        debounceTimer = setTimeout(() => {
            fetchSuggestions(val);
        }, 250);
    });

    // Đóng khung gợi ý khi bấm chuột ra ngoài khu vực tìm kiếm
    document.addEventListener("click", function (e) {
        if (!searchForm.contains(e.target)) {
            searchDropdown.classList.add("d-none");
        }
    });
});