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
import model.*;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

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
            out.println("<title>Servlet CheckoutServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckoutServlet at " + request.getContextPath() + "</h1>");
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
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        // Nếu giỏ hàng trống thì không cho vào trang thanh toán mà đẩy về /cart
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        CategoryDAO categoryDao = new CategoryImpl();
        request.setAttribute("categories", categoryDao.getAll());
        request.setAttribute("pageTitle", "Thanh toán đơn cây - Plants_shop");
        request.getRequestDispatcher("/views/checkout.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lấy thông tin người nhận từ form
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        // Ghép phương thức thanh toán vào ghi chú để Admin dễ theo dõi
        String fullNote = "[" + paymentMethod + "] " + (note != null ? note.trim() : "");

        // Tính tổng tiền hàng + phí vận chuyển (Miễn phí cho đơn từ 300.000đ)
        double subTotal = 0;
        for (CartItem item : cart.values()) {
            subTotal += item.getSubtotal();
        }
        double shippingFee = (subTotal >= 300000) ? 0 : 30000;
        double finalTotal = subTotal + shippingFee;

        // Đóng gói đối tượng Order
        Order order = new Order();
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser != null) {
            order.setUserId(loggedUser.getId());
        }
        order.setCustomerName(customerName.trim());
        order.setCustomerPhone(customerPhone.trim());
        order.setShippingAddress(shippingAddress.trim());
        order.setNote(fullNote);
        order.setTotalAmount(finalTotal);

        // Gọi DAO thực thi Transaction lưu đơn & trừ tồn kho
        OrderDAO orderDao = new OrderImpl();
        int resultOrderId = orderDao.createOrder(order, cart.values());

        if (resultOrderId > 0) {
            // Đặt hàng thành công -> Xóa sạch giỏ hàng trong Session
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);
            session.setAttribute("cartTotal", 0.0);

            // Chuyển sang trang theo dõi đơn hàng kèm mã đơn vừa tạo
            response.sendRedirect(request.getContextPath() + "/orders?successId=" + resultOrderId);
        } else {
            // Đặt hàng thất bại (do hết tồn kho hoặc lỗi DB)
            CategoryDAO categoryDao = new CategoryImpl();
            request.setAttribute("categories", categoryDao.getAll());
            String errorMsg = (resultOrderId == -2)
                    ? "Rất tiếc, một số chậu cây trong giỏ vừa hết hàng. Vui lòng kiểm tra lại số lượng!"
                    : "Có lỗi xảy ra khi xử lý đơn hàng. Vui lòng thử lại!";
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/views/checkout.jsp").forward(request, response);
        }
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
