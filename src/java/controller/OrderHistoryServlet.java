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
import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import model.*;

/**
 *
 * @author Admin
 */
@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orders"})
public class OrderHistoryServlet extends HttpServlet {

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
            out.println("<title>Servlet OrderHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderHistoryServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        OrderDAO orderDao = new OrderImpl();
        CategoryDAO categoryDao = new CategoryImpl();

        List<Order> orders = new ArrayList<>();

        if (user != null) {
            // Nếu đã đăng nhập: lấy toàn bộ lịch sử đơn hàng của tài khoản này
            orders = orderDao.getOrdersByUserId(user.getId());
        } else if (request.getParameter("successId") != null) {
            // Nếu khách vãng lai vừa đặt xong: hiển thị ngay đơn hàng vừa tạo để họ xem biên nhận
            try {
                int successId = Integer.parseInt(request.getParameter("successId"));
                Order justCreated = orderDao.getOrderById(successId);
                if (justCreated != null) {
                    orders.add(justCreated);
                }
            } catch (NumberFormatException ignored) {}
        } else {
            // Chưa đăng nhập và không có mã đơn mới -> chuyển qua trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("categories", categoryDao.getAll());
        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Đơn hàng của tôi - Plants_shop");
        request.getRequestDispatcher("/views/orders.jsp").forward(request, response);
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
