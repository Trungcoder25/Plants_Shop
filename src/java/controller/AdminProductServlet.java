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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import model.Product;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // Tối đa 10MB/ảnh
    maxRequestSize = 1024 * 1024 * 50    // Tối đa 50MB/request
)
public class AdminProductServlet extends HttpServlet {

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
            out.println("<title>Servlet AdminProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminProductServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        ProductDAO productDao = new ProductImpl();
        CategoryDAO categoryDao = new CategoryImpl();
        request.setAttribute("activeMenu", "products");

        switch (action) {
            case "create":
                // Mở form thêm cây mới
                request.setAttribute("categories", categoryDao.getAll());
                request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
                break;

            case "edit":
                // Mở form chỉnh sửa cây hiện có
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Product existingProduct = productDao.getById(id);
                    if (existingProduct != null) {
                        request.setAttribute("product", existingProduct);
                        request.setAttribute("categories", categoryDao.getAll());
                        request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
                response.sendRedirect(request.getContextPath() + "/admin/products");
                break;

            case "delete":
                // Xóa sản phẩm theo ID
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    productDao.Delete(id);
                } catch (NumberFormatException ignored) {}
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=deleted");
                break;

            default:
                // Hiển thị bảng danh sách toàn bộ sản phẩm
                request.setAttribute("products", productDao.getAll());
                request.getRequestDispatcher("/views/admin/products.jsp").forward(request, response);
                break;
        }
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
        ProductDAO productDao = new ProductImpl();

        // Lấy ID (nếu id > 0 là cập nhật cây cũ, ngược lại là thêm cây mới)
        String idRaw = request.getParameter("id");
        int id = (idRaw != null && !idRaw.isEmpty()) ? Integer.parseInt(idRaw) : 0;

        // Đọc các thông tin cơ bản và thông số sinh trưởng từ Form
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String oldPriceRaw = request.getParameter("oldPrice");
        double oldPrice = (oldPriceRaw != null && !oldPriceRaw.isEmpty()) ? Double.parseDouble(oldPriceRaw) : 0;
        int stock = Integer.parseInt(request.getParameter("stock"));

        String plantHeight = request.getParameter("plantHeight");
        String lightLevel = request.getParameter("lightLevel");
        String waterFrequency = request.getParameter("waterFrequency");
        String careDifficulty = request.getParameter("careDifficulty");
        String description = request.getParameter("description");
        String careGuide = request.getParameter("careGuide");
        boolean isFeatured = request.getParameter("isFeatured") != null;

        // Xử lý file ảnh tải lên (nếu Admin chọn file mới)
        String imageFileName = request.getParameter("existingImage"); // Giữ tên ảnh cũ mặc định
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Thêm timestamp vào trước tên file để tránh trùng tên ảnh
            imageFileName = System.currentTimeMillis() + "_" + submittedFileName;

            // Lưu ảnh vào thư mục assets/images của ứng dụng web đang chạy
            String uploadPath = getServletContext().getRealPath("/assets/images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath + File.separator + imageFileName);
        }

        // Nếu thêm mới mà không tải ảnh -> gán tên mặc định
        if (imageFileName == null || imageFileName.trim().isEmpty()) {
            imageFileName = "default-plant.jpg";
        }

        // Đóng gói vào đối tượng Product
        Product p = new Product();
        p.setId(id);
        p.setCategoryId(categoryId);
        p.setName(name.trim());
        p.setPrice(price);
        p.setOldPrice(oldPrice);
        p.setStock(stock);
        p.setImage(imageFileName);
        p.setPlantHeight(plantHeight);
        p.setLightLevel(lightLevel);
        p.setWaterFrequency(waterFrequency);
        p.setCareDifficulty(careDifficulty);
        p.setDescription(description);
        p.setCareGuide(careGuide);
        p.setFeatured(isFeatured);

        if (id > 0) {
            productDao.Update(p);
        } else {
            productDao.Insert(p);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products?msg=saved");
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
