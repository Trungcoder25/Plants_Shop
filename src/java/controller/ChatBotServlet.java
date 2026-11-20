/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import data.dao.ProductDAO;
import data.impl.ProductImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import model.Product;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ChatBotServlet", urlPatterns = {"/api/chatbot"})
public class ChatBotServlet extends HttpServlet {

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
            out.println("<title>Servlet ChatBotServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatBotServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    // Dán Gemini API Key của bạn vào đây (lấy miễn phí tại aistudio.google.com)
    // Nếu để trống, hệ thống sẽ tự chạy chế độ Trợ lý Nội bộ thông minh dựa trên MySQL
    private static final String GEMINI_API_KEY = "";

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "");
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
        processRequest(request, response);
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
        response.setContentType("application/json; charset=UTF-8");

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            userMessage = "Tư vấn cây cảnh";
        }

        ProductDAO productDao = new ProductImpl();
        List<Product> allProducts = productDao.getAll();

        // 1. Tìm tối đa 2 cây trong kho khớp với từ khóa của khách để đính kèm thẻ mua hàng
        List<Product> matchedProducts = productDao.searchQuick(userMessage, 2);

        // 2. Tạo câu trả lời từ Gemini AI (nếu có API Key) hoặc Trợ lý Nội bộ
        String aiReply;
        if (GEMINI_API_KEY != null && !GEMINI_API_KEY.isBlank()) {
            aiReply = callGeminiAI(userMessage, allProducts);
        } else {
            aiReply = generateSmartLocalReply(userMessage, matchedProducts);
        }

        // 3. Đóng gói JSON trả về gồm: câu trả lời (reply) + danh sách cây gợi ý (products)
        StringBuilder json = new StringBuilder("{");
        json.append("\"reply\":\"").append(escapeJson(aiReply)).append("\",");
        json.append("\"products\":[");
        for (int i = 0; i < matchedProducts.size(); i++) {
            Product p = matchedProducts.get(i);
            json.append("{")
                .append("\"id\":").append(p.getId()).append(",")
                .append("\"name\":\"").append(escapeJson(p.getName())).append("\",")
                .append("\"price\":").append((long) p.getPrice()).append(",")
                .append("\"image\":\"").append(escapeJson(p.getImage())).append("\"")
                .append("}");
            if (i < matchedProducts.size() - 1) json.append(",");
        }
        json.append("]}");

        try (PrintWriter out = response.getWriter()) {
            out.print(json.toString());
        }
    }
    
    // Gọi Gemini 2.5 Flash API bằng HttpClient chuẩn của Java 11+
    private String callGeminiAI(String userMessage, List<Product> catalog) {
        try {
            StringBuilder catalogContext = new StringBuilder("Danh sách cây đang bán tại Plants_shop:\n");
            for (Product p : catalog) {
                catalogContext.append(String.format("- %s (Giá: %,.0fđ, Ánh sáng: %s, Độ khó: %s, Chăm sóc: %s)\n",
                        p.getName(), p.getPrice(), p.getLightLevel(), p.getCareDifficulty(), p.getCareGuide()));
            }

            String systemPrompt = "Bạn là Nghệ nhân tư vấn cây cảnh của hệ thống Plants_shop (phong cách tận tâm như dược sĩ Long Châu). "
                    + "Hãy trả lời ngắn gọn (tối đa 3-4 câu), thân thiện bằng tiếng Việt, dựa trên dữ liệu vườn cây sau:\n"
                    + catalogContext + "\nCâu hỏi khách hàng: " + userMessage;

            String requestBody = "{\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(systemPrompt) + "\"}]}]}";

            HttpClient client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> httpResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            String body = httpResponse.body();

            // Trích xuất nội dung trường "text" từ phản hồi JSON của Gemini
            int textIdx = body.indexOf("\"text\":");
            if (textIdx != -1) {
                int startQuote = body.indexOf("\"", textIdx + 7) + 1;
                int endQuote = startQuote;
                while (endQuote < body.length()) {
                    if (body.charAt(endQuote) == '"' && body.charAt(endQuote - 1) != '\\') break;
                    endQuote++;
                }
                return body.substring(startQuote, endQuote)
                           .replace("\\n", "\n")
                           .replace("\\\"", "\"");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Chào bạn! Vườn cây Plants_shop sẵn sàng hỗ trợ chọn cây theo ánh sáng phòng và hướng dẫn trị vàng lá. Bạn muốn tìm cây cho không gian nào ạ?";
    }
    
    // Chế độ dự phòng thông minh: Phân tích ý định & truy xuất CSDL ngay cả khi chưa nhập API Key
    private String generateSmartLocalReply(String msg, List<Product> matched) {
        String lower = msg.toLowerCase();
        if (lower.contains("vàng lá") || lower.contains("úng") || lower.contains("bệnh")) {
            return "Cây bị vàng lá thường do tưới quá nhiều nước gây úng rễ hoặc thiếu sáng. Bạn nên cắt bỏ lá vàng, ngưng tưới 3-4 ngày cho khô mặt đất và bổ sung dinh dưỡng phục hồi rễ bên dưới nhé!";
        }
        if (lower.contains("bàn") || lower.contains("văn phòng") || lower.contains("trong nhà")) {
            return "Với không gian phòng kín hoặc bàn làm việc ít nắng, bạn nên ưu tiên các dòng chịu bóng tốt và lọc không khí như Kim Tiền, Lưỡi Hổ hoặc Trầu Bà. Dưới đây là gợi ý phù hợp từ vườn:";
        }
        if (lower.contains("phong thủy") || lower.contains("tài lộc")) {
            return "Để thu hút vượng khí và tài lộc, Cây Kim Ngân, Kim Tiền và Phát Tài Núi là lựa chọn hàng đầu vì tán lá xanh mướt quanh năm và rất dễ chăm sóc.";
        }
        if (!matched.isEmpty()) {
            return "Mình đã tìm thấy mẫu cây phù hợp với nhu cầu của bạn trong vườn Plants_shop. Bạn bấm vào thẻ bên dưới để xem chỉ số ánh sáng và cách tưới chi tiết nhé!";
        }
        return "Chào bạn! Mình là Trợ lý Nghệ nhân của Plants_shop. Bạn có thể hỏi mình về: chọn cây để bàn ít nắng, cây phong thủy, hoặc cách xử lý khi cây bị vàng lá nhé!";
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
