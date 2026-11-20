<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Trị Hệ Thống - Plants_shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #F4F7F5; font-family: 'Segoe UI', Roboto, sans-serif; }
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #1B4332 0%, #122E22 100%);
            color: #fff;
        }
        .admin-sidebar .nav-link {
            color: #D8F3DC;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 6px;
            font-weight: 500;
            transition: 0.2s;
        }
        .admin-sidebar .nav-link:hover,
        .admin-sidebar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.16);
            color: #fff;
            font-weight: 600;
        }
        .kpi-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #E5E7EB;
            padding: 20px;
            height: 100%;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Cột trái: Sidebar điều hướng Quản trị -->
        <aside class="col-lg-2 col-md-3 p-3 admin-sidebar d-flex flex-column">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-white text-decoration-none d-flex align-items-center gap-2 px-2 py-3 mb-3 border-bottom border-success">
                <i class="fa-solid fa-leaf text-warning fs-4"></i>
                <div>
                    <div class="fw-bold fs-5 lh-1">Plants_shop</div>
                    <small class="text-warning" style="font-size: 0.72rem;">ADMIN PANEL</small>
                </div>
            </a>

            <ul class="nav flex-column flex-grow-1">
                <li class="nav-item">
                    <a class="nav-link ${activeMenu == 'dashboard' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie me-2"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeMenu == 'products' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/products">
                        <i class="fa-solid fa-seedling me-2"></i> Quản lý Cây cảnh
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeMenu == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/orders">
                        <i class="fa-solid fa-truck-fast me-2"></i> Quản lý Đơn hàng
                    </a>
                </li>
                <li class="nav-item mt-3 pt-3 border-top border-success">
                    <a class="nav-link text-warning" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-store me-2"></i> Xem trang bán hàng
                    </a>
                </li>
            </ul>

            <div class="pt-3 border-top border-success small">
                <div class="opacity-75 mb-2"><i class="fa-solid fa-user-shield me-1"></i> ${sessionScope.user.fullName}</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light w-100 rounded-pill">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </aside>

        <!-- Cột phải: Nội dung chính từng trang -->
        <div class="col-lg-10 col-md-9 p-4">