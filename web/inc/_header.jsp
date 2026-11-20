<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle != null ? pageTitle : 'Plants_shop - Hệ Thống Cây Cảnh & Chăm Sóc Xanh'}</title>
        <!-- Bootstrap 5 & FontAwesome 6 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>

        <!-- Top Bar -->
        <div class="top-bar">
            <div class="container d-flex justify-content-between align-items-center">
                <div>
                    <i class="fa-solid fa-seedling me-1"></i> Bảo hành cây khỏe 14 ngày &bull; Tư vấn nghệ nhân miễn phí 1-1
                </div>
                <div class="d-none d-md-block">
                    <i class="fa-solid fa-phone-volume me-1"></i> Hotline Tư Vấn Cây: <strong>1800 6868</strong>
                </div>
            </div>
        </div>

        <!-- Main Header -->
        <!-- Main Header -->
        <header class="main-header">
            <div class="container">
                <div class="row align-items-center g-3">
                    <!-- 1. Logo (Tự co giãn vừa đủ nội dung) -->
                    <div class="col-lg-auto col-md-4">
                        <a href="${pageContext.request.contextPath}/home" class="brand-logo text-nowrap">
                            <i class="fa-solid fa-leaf text-warning"></i> Plants_shop
                            <span>Garden</span>
                        </a>
                    </div>

                    <!-- Thanh tìm kiếm trung tâm có Live Search -->
                    <div class="col-lg col-md-8 px-lg-4">
                        <form action="${pageContext.request.contextPath}/products" method="get" class="search-box-wrapper" id="searchForm">
                            <input type="text" name="keyword" id="searchInput" value="${param.keyword}"
                                   class="form-control search-input" autocomplete="off"
                                   placeholder="Tìm tên cây, cây lọc không khí, trị vàng lá, chậu gốm...">
                            <button type="submit" class="search-btn">
                                <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm
                            </button>

                            <!-- Khung hiển thị gợi ý tức thì (Live Search Dropdown) -->
                            <div id="searchDropdown" class="search-dropdown shadow-lg d-none"></div>
                        </form>

                        <div class="quick-keywords d-none d-sm-block text-truncate">
                            <span class="opacity-75 me-1">Gợi ý:</span>
                            <a href="${pageContext.request.contextPath}/products?keyword=Kim+Tiền">Cây Kim Tiền</a>
                            <a href="${pageContext.request.contextPath}/products?light=Trong+nhà">Cây trong nhà</a>
                            <a href="${pageContext.request.contextPath}/products?difficulty=Dễ+chăm">Dễ chăm cho người mới</a>
                            <a href="${pageContext.request.contextPath}/products?keyword=vàng+lá">Trị vàng lá</a>
                        </div>
                    </div>

                    <!-- 3. Tài khoản & Giỏ hàng (Không bao giờ bị ép xuống dòng) -->
                    <div class="col-lg-auto col-12 d-flex justify-content-lg-end justify-content-between align-items-center gap-2">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                <div class="dropdown">
                                    <a class="header-action-btn dropdown-toggle text-nowrap" href="#" role="button" data-bs-toggle="dropdown">
                                        <i class="fa-solid fa-user-check"></i> ${sessionScope.user.fullName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                            <li><a class="dropdown-item fw-bold text-success" href="${pageContext.request.contextPath}/admin/dashboard">
                                                    <i class="fa-solid fa-gauge me-2"></i>Trang Quản Trị</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            </c:if>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="header-action-btn text-nowrap">
                                    <i class="fa-regular fa-user"></i> Đăng nhập
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <a href="${pageContext.request.contextPath}/cart" class="header-action-btn text-nowrap">
                            <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                            <span class="badge rounded-pill bg-warning text-dark">
                                ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Thanh điều hướng danh mục -->
        <nav class="category-nav sticky-top">
            <div class="container">
                <ul class="nav overflow-auto flex-nowrap justify-content-lg-center">
                    <li class="nav-item text-nowrap">
                        <a class="nav-link ${empty param.cid ? 'active' : ''}" href="${pageContext.request.contextPath}/home">
                            <i class="fa-solid fa-house me-1"></i> Trang chủ
                        </a>
                    </li>
                    <c:forEach items="${categories}" var="cat">
                        <li class="nav-item text-nowrap">
                            <a class="nav-link ${param.cid == cat.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/products?cid=${cat.id}">
                                <i class="fa-solid ${cat.icon} me-1 text-success"></i> ${cat.name}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </nav>