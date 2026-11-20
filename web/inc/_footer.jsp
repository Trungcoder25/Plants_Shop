<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer>
    <div class="container py-5">
        <div class="row g-4">
            <div class="col-lg-4">
                <h5 class="text-white fw-bold mb-3">
                    <i class="fa-solid fa-leaf text-warning me-2"></i>Plants_shop Garden
                </h5>
                <p class="small opacity-75">
                    Hệ thống cung cấp cây cảnh nội thất, cây phong thủy và giải pháp chăm sóc cây xanh chuẩn khoa học. 
                    Mỗi chậu cây đều đi kèm hồ sơ sinh trưởng và hướng dẫn chăm sóc trọn đời.
                </p>
            </div>
            <div class="col-lg-4">
                <h6 class="text-white fw-bold mb-3">Góc Chăm Sóc & Hỗ Trợ</h6>
                <ul class="list-unstyled small opacity-75">
                    <li class="mb-2"><i class="fa-solid fa-check me-2 text-warning"></i>Tra cứu nguyên nhân cây vàng lá, úng rễ</li>
                    <li class="mb-2"><i class="fa-solid fa-check me-2 text-warning"></i>Chính sách đổi trả cây trong 14 ngày</li>
                    <li class="mb-2"><i class="fa-solid fa-check me-2 text-warning"></i>Giao cây hỏa tốc 2H nội thành</li>
                </ul>
            </div>
            <div class="col-lg-4">
                <h6 class="text-white fw-bold mb-3">Kết Nối Với Nghệ Nhân</h6>
                <p class="small opacity-75 mb-1"><i class="fa-solid fa-location-dot me-2"></i>15 Lương Văn Can, TP. Huế</p>
                <p class="small opacity-75 mb-1"><i class="fa-solid fa-phone me-2"></i>Tư vấn miễn phí: 1800 6868</p>
                <p class="small opacity-75"><i class="fa-solid fa-envelope me-2"></i>hotro@plantsshop.vn</p>
            </div>
        </div>
        <hr class="border-light opacity-25 my-4">
        <div class="text-center small opacity-75">
            &copy; 2026 Plants_shop. Phát triển theo mô hình Java Web MVC.
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<!-- ================= AI CHATBOT TƯ VẤN CÂY CẢNH ================= -->
<style>
    .chatbot-toggler {
        position: fixed;
        bottom: 24px;
        right: 24px;
        width: 58px;
        height: 58px;
        border-radius: 50%;
        background: linear-gradient(135deg, #1B4332, #2D6A4F);
        color: #fff;
        border: none;
        box-shadow: 0 8px 24px rgba(27, 67, 50, 0.35);
        z-index: 1060;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        cursor: pointer;
        transition: transform 0.2s;
    }
    .chatbot-toggler:hover { transform: scale(1.08); }

    .chatbot-window {
        position: fixed;
        bottom: 94px;
        right: 24px;
        width: 360px;
        max-width: calc(100vw - 32px);
        background: #fff;
        border-radius: 20px;
        border: 1px solid #E5E7EB;
        box-shadow: 0 12px 36px rgba(0, 0, 0, 0.16);
        z-index: 1060;
        overflow: hidden;
        display: none;
        flex-direction: column;
    }
    .chatbot-header {
        background: linear-gradient(135deg, #1B4332, #2D6A4F);
        color: #fff;
        padding: 14px 18px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .chatbot-messages {
        height: 320px;
        overflow-y: auto;
        padding: 14px;
        background-color: #FAF8F5;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .msg-bot, .msg-user {
        padding: 10px 14px;
        border-radius: 16px;
        font-size: 0.86rem;
        line-height: 1.45;
        max-width: 85%;
        white-space: pre-line;
    }
    .msg-bot {
        background: #fff;
        color: #1F2937;
        border: 1px solid #E5E7EB;
        align-self: flex-start;
        border-bottom-left-radius: 4px;
    }
    .msg-user {
        background: #2D6A4F;
        color: #fff;
        align-self: flex-end;
        border-bottom-right-radius: 4px;
    }
    .chat-product-card {
        display: flex;
        align-items: center;
        gap: 10px;
        background: #F2F8F4;
        border: 1px solid #B7E4C7;
        border-radius: 12px;
        padding: 8px;
        margin-top: 8px;
        text-decoration: none;
        color: #1B4332;
    }
    .chat-product-card img {
        width: 44px;
        height: 44px;
        border-radius: 8px;
        object-fit: cover;
    }
</style>

<!-- Nút mở Chatbot -->
<button type="button" class="chatbot-toggler" id="chatbotToggleBtn" title="Tư vấn chọn cây cùng AI">
    <i class="fa-solid fa-robot"></i>
</button>

<!-- Cửa sổ hội thoại AI -->
<div class="chatbot-window" id="chatbotWindow">
    <div class="chatbot-header">
        <div class="d-flex align-items-center gap-2">
            <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center" style="width: 34px; height: 34px;">
                <i class="fa-solid fa-seedling"></i>
            </div>
            <div>
                <div class="fw-bold small lh-1">Trợ Lý Nghệ Nhân AI</div>
                <small class="text-warning" style="font-size: 0.7rem;">&bull; Trực tuyến 24/7</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white btn-sm" id="chatbotCloseBtn"></button>
    </div>

    <div class="chatbot-messages" id="chatbotMessages">
        <div class="msg-bot">
            Xin chào! Mình là <strong>Trợ lý AI của Plants_shop</strong> 🌿.<br>
            Bạn cần tìm cây để bàn ít nắng, cây phong thủy hay tư vấn trị vàng lá ạ?
        </div>
    </div>

    <!-- Gợi ý câu hỏi nhanh -->
    <div class="px-2 py-1 bg-white border-top d-flex gap-1 overflow-auto">
        <button type="button" class="btn btn-sm btn-outline-success rounded-pill py-0 px-2 text-nowrap" style="font-size: 0.72rem;"
                onclick="sendQuickChat('Cây để bàn ít nắng')">Cây để bàn</button>
        <button type="button" class="btn btn-sm btn-outline-success rounded-pill py-0 px-2 text-nowrap" style="font-size: 0.72rem;"
                onclick="sendQuickChat('Cây bị vàng lá phải làm sao?')">Trị vàng lá</button>
        <button type="button" class="btn btn-sm btn-outline-success rounded-pill py-0 px-2 text-nowrap" style="font-size: 0.72rem;"
                onclick="sendQuickChat('Cây phong thủy tài lộc')">Phong thủy</button>
    </div>

    <!-- Ô nhập tin nhắn -->
    <form id="chatbotForm" class="p-2 bg-white border-top d-flex gap-2">
        <input type="text" id="chatbotInput" class="form-control form-control-sm rounded-pill px-3"
               placeholder="Nhập câu hỏi về cây cảnh..." autocomplete="off" required>
        <button type="submit" class="btn btn-success btn-sm rounded-circle px-3">
            <i class="fa-solid fa-paper-plane"></i>
        </button>
    </form>
</div>

<script>
    const chatWin = document.getElementById('chatbotWindow');
    const chatMsgs = document.getElementById('chatbotMessages');
    const chatInput = document.getElementById('chatbotInput');
    const chatCtx = '${pageContext.request.contextPath}';

    document.getElementById('chatbotToggleBtn').onclick = () => {
        chatWin.style.display = (chatWin.style.display === 'flex') ? 'none' : 'flex';
        if (chatWin.style.display === 'flex') chatInput.focus();
    };
    document.getElementById('chatbotCloseBtn').onclick = () => chatWin.style.display = 'none';

    function sendQuickChat(text) {
        chatInput.value = text;
        document.getElementById('chatbotForm').dispatchEvent(new Event('submit'));
    }

    document.getElementById('chatbotForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const text = chatInput.value.trim();
        if (!text) return;

        // 1. Hiện tin nhắn của khách
        chatMsgs.innerHTML += `<div class="msg-user">\${text}</div>`;
        chatInput.value = '';
        chatMsgs.scrollTop = chatMsgs.scrollHeight;

        // 2. Hiện trạng thái AI đang soạn câu trả lời
        const loadingId = 'bot-loading-' + Date.now();
        chatMsgs.innerHTML += `<div class="msg-bot text-muted fst-italic" id="\${loadingId}">Nghệ nhân AI đang tra cứu...</div>`;
        chatMsgs.scrollTop = chatMsgs.scrollHeight;

        // 3. Gửi yêu cầu tới ChatBotServlet
        fetch(chatCtx + '/api/chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: 'message=' + encodeURIComponent(text)
        })
        .then(res => res.json())
        .then(data => {
            document.getElementById(loadingId)?.remove();

            let productCardsHtml = '';
            if (data.products && data.products.length > 0) {
                data.products.forEach(p => {
                    const priceStr = new Intl.NumberFormat('vi-VN').format(p.price) + 'đ';
                    productCardsHtml += `
                        <a href="\${chatCtx}/detail?id=\${p.id}" class="chat-product-card">
                            <img src="\${chatCtx}/assets/images/\${p.image}" onerror="this.src='https://placehold.co/50x50/E8F5E9/1B4332?text=Plant'">
                            <div class="overflow-hidden">
                                <div class="fw-bold text-truncate small">\${p.name}</div>
                                <div class="text-success fw-bold" style="font-size: 0.78rem;">\${priceStr} &rarr;</div>
                            </div>
                        </a>`;
                });
            }

            chatMsgs.innerHTML += `<div class="msg-bot">\${data.reply}\${productCardsHtml}</div>`;
            chatMsgs.scrollTop = chatMsgs.scrollHeight;
        })
        .catch(() => {
            document.getElementById(loadingId)?.remove();
            chatMsgs.innerHTML += `<div class="msg-bot text-danger">Kết nối gián đoạn, bạn thử lại sau giây lát nhé!</div>`;
        });
    });
</script>

</body>
</html>