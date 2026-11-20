/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import data.dao.*;
import data.impl.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import model.*;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDashboardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDao = new ProductImpl();
        OrderDAO orderDao = new OrderImpl();
        UserDAO userDao = new UserImpl();

        List<Product> allProducts = productDao.getAll();
        List<Order> allOrders = orderDao.getAllOrders();
        List<User> allUsers = userDao.getAll();

        // 1. Tính tổng doanh thu (chỉ cộng các đơn không bị hủy) & đếm đơn chờ xác nhận
        double totalRevenue = 0;
        int pendingOrdersCount = 0;
        for (Order o : allOrders) {
            if (!"CANCELLED".equalsIgnoreCase(o.getStatus())) {
                totalRevenue += o.getTotalAmount();
            }
            if ("PENDING".equalsIgnoreCase(o.getStatus())) {
                pendingOrdersCount++;
            }
        }

        // 2. Lọc ra các chậu cây sắp hết tồn kho (stock <= 15) để cảnh báo nhập vườn
        List<Product> lowStockProducts = new ArrayList<>();
        for (Product p : allProducts) {
            if (p.getStock() <= 15) {
                lowStockProducts.add(p);
            }
        }

        // Lấy 5 đơn hàng mới nhất hiển thị ra bảng theo dõi nhanh
        List<Order> recentOrders = allOrders.size() > 5 ? allOrders.subList(0, 5) : allOrders;

        // Đẩy dữ liệu sang JSP
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", allOrders.size());
        request.setAttribute("pendingOrdersCount", pendingOrdersCount);
        request.setAttribute("totalProducts", allProducts.size());
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("activeMenu", "dashboard");

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
