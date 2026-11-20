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
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

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
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    
    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void syncCartMetrics(HttpSession session, Map<Integer, CartItem> cart) {
        int totalCount = 0;
        double totalAmount = 0;
        for (CartItem item : cart.values()) {
            totalCount += item.getQuantity();
            totalAmount += item.getSubtotal();
        }
        session.setAttribute("cartCount", totalCount);
        session.setAttribute("cartTotal", totalAmount);
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
        Map<Integer, CartItem> cart = getCart(session);
        syncCartMetrics(session, cart);

        CategoryDAO categoryDao = new CategoryImpl();
        request.setAttribute("categories", categoryDao.getAll());
        request.setAttribute("pageTitle", "Giỏ hàng của bạn - Plants_shop");
        request.getRequestDispatcher("/views/cart.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);
        String action = request.getParameter("action");
        ProductDAO productDao = new ProductImpl();

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                Product p = productDao.getById(productId);

                if (p != null && p.getStock() > 0 && quantity > 0) {
                    if (cart.containsKey(productId)) {
                        CartItem existing = cart.get(productId);
                        int newQty = Math.min(existing.getQuantity() + quantity, p.getStock());
                        existing.setQuantity(newQty);
                    } else {
                        int validQty = Math.min(quantity, p.getStock());
                        cart.put(productId, new CartItem(p, validQty));
                    }
                }
            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                if (cart.containsKey(productId)) {
                    if (quantity <= 0) {
                        cart.remove(productId);
                    } else {
                        Product p = productDao.getById(productId);
                        int maxStock = (p != null) ? p.getStock() : quantity;
                        cart.get(productId).setQuantity(Math.min(quantity, maxStock));
                    }
                }
            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.remove(productId);
            } else if ("clear".equals(action)) {
                cart.clear();
            }
        } catch (NumberFormatException ignored) {}

        syncCartMetrics(session, cart);
        response.sendRedirect(request.getContextPath() + "/cart");
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
