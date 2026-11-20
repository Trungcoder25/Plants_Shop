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
@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath() + "</h1>");
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
        CategoryDAO categoryDao = new CategoryImpl();
        ProductDAO productDao = new ProductImpl();

        String keyword = request.getParameter("keyword");
        String cidRaw = request.getParameter("cid");
        String light = request.getParameter("light");
        String difficulty = request.getParameter("difficulty");
        String sort = request.getParameter("sort");

        Integer categoryId = null;
        if (cidRaw != null && !cidRaw.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(cidRaw.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Category> categories = categoryDao.getAll();
        List<Product> products = productDao.FilterProduct(keyword, categoryId, light, difficulty);

        // Sắp xếp theo giá nếu người dùng chọn
        if ("price_asc".equals(sort)) {
            products.sort(Comparator.comparingDouble(Product::getPrice));
        } else if ("price_desc".equals(sort)) {
            products.sort(Comparator.comparingDouble(Product::getPrice).reversed());
        }

        // Lấy tên danh mục đang chọn (nếu có) để hiển thị tiêu đề
        String currentCategoryName = "Tất cả cây cảnh & phụ kiện";
        if (categoryId != null) {
            Category c = categoryDao.getById(categoryId);
            if (c != null) {
                currentCategoryName = c.getName();
            }
        }

        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("currentCategoryName", currentCategoryName);
        request.setAttribute("pageTitle", currentCategoryName + " - Plants_shop");

        request.getRequestDispatcher("/views/products.jsp").forward(request, response);
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
