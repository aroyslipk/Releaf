<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Groups - ReLeaf</title>
    <link rel="stylesheet" href="/css/modern-admin.css">
    <link rel="stylesheet" href="/css/groups.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        /* Enhanced Button Styles */
        .btn-join {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
            border: none;
            padding: 12px 28px;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(45, 122, 72, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-join:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(45, 122, 72, 0.4);
            background: linear-gradient(135deg, #358856, #3d9960);
        }
        .btn-join:active {
            transform: translateY(0);
        }
        .btn-join i {
            font-size: 0.9rem;
        }

        .btn-send {
            background: linear-gradient(135deg, #2D7A48, #358856);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(45, 122, 72, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-send:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
        }
        .btn-send:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-leave {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-leave:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(220, 53, 69, 0.35);
            background: linear-gradient(135deg, #c82333, #bd2130);
        }

        /* Info Note Box */
        .info-note {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            border-left: 4px solid #2D7A48;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .info-note i {
            color: #2D7A48;
            font-size: 1.25rem;
        }
        .info-note p {
            margin: 0;
            color: #1b5e20;
            font-size: 0.95rem;
            font-weight: 500;
        }

        /* Enhanced Chat Input */
        .chat-input {
            display: flex;
            gap: 12px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        .chat-input input {
            flex-grow: 1;
            padding: 14px 18px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        .chat-input input:focus {
            outline: none;
            border-color: #2D7A48;
            box-shadow: 0 0 0 4px rgba(45, 122, 72, 0.1);
        }

        /* Enhanced Group Card */
        .group-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid #e2e8f0;
        }
        .group-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
            border-color: #2D7A48;
        }
        .group-info {
            padding: 24px;
        }
        .group-info h3 {
            font-size: 1.35rem;
            font-weight: 700;
            color: #2D7A48;
            margin-bottom: 8px;
        }
        .group-info .description {
            color: #64748b;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        .group-actions {
            padding: 20px 24px;
            background: linear-gradient(135deg, #f8fdf9, #f0f9f2);
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: center;
        }

        /* Leave Group Section */
        .leave-group-section {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
        }

        /* Chat Section Enhancement */
        .chat-section {
            margin-top: 24px;
            padding: 20px;
            background: #fafbfc;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        .chat-section h4 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2D7A48;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chat-section h4 i {
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/user-header.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fas fa-users" style="margin-right: 12px;"></i>Groups</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <c:if test="${not empty warning}">
            <div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> ${warning}</div>
        </c:if>

        <!-- Info Note -->
        <c:if test="${currentUser.group == null}">
            <div class="info-note">
                <i class="fas fa-info-circle"></i>
                <p>You can only be a member of one group at a time. Choose wisely and collaborate with your team!</p>
            </div>
        </c:if>

        <!-- Current Group Status -->
        <c:if test="${currentUser.group != null}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title"><i class="fas fa-leaf" style="color: #2D7A48; margin-right: 10px;"></i>Your Current Group</h2>
                </div>
                <div class="current-group">
                    <h3>${currentUser.group.groupName}</h3>
                    <p class="description">${currentUser.group.description != null ? currentUser.group.description : 'No description available'}</p>
                    
                    <!-- Group Chat Section -->
                    <div class="chat-section">
                        <h4><i class="fas fa-comments"></i> Group Chat</h4>
                        <div id="chat-messages" class="chat-messages">
                            <div class="chat-loading"><i class="fas fa-spinner fa-spin"></i> Loading messages...</div>
                        </div>
                        <div class="chat-input">
                            <input type="text" id="message-input" placeholder="Type your message..." maxlength="1000">
                            <button id="send-message" class="btn-send"><i class="fas fa-paper-plane"></i> Send</button>
                        </div>
                    </div>
                    
                    <div class="leave-group-section">
                        <form method="post" action="/user/leave-group">
                            <button type="submit" class="btn-leave"><i class="fas fa-sign-out-alt"></i> Leave Group</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Available Groups -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title"><i class="fas fa-globe" style="color: #2D7A48; margin-right: 10px;"></i>Available Groups</h2>
            </div>
            <div class="groups-grid">
                <c:choose>
                    <c:when test="${empty groups}">
                        <div class="no-groups-message">
                            <i class="fas fa-users-slash" style="font-size: 3rem; color: #cbd5e0; margin-bottom: 16px;"></i>
                            <h3>No groups available yet</h3>
                            <p>There are currently no groups to join. Check back later!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="group" items="${groups}">
                            <c:if test="${currentUser.group == null || currentUser.group.id != group.id}">
                                <div class="group-card">
                                    <div class="group-info">
                                        <h3><i class="fas fa-seedling" style="margin-right: 8px;"></i>${group.groupName}</h3>
                                        <p class="description">${group.description != null ? group.description : 'No description available'}</p>
                                    </div>
                                    <div class="group-actions">
                                        <c:if test="${currentUser.group == null}">
                                            <form method="post" action="/user/join-group/${group.id}">
                                                <button type="submit" class="btn-join"><i class="fas fa-user-plus"></i> Join Group</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${currentUser.group != null}">
                                            <span style="color: #64748b; font-size: 0.9rem;"><i class="fas fa-lock"></i> Leave your current group to join</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const chatMessages = document.getElementById('chat-messages');
        const messageInput = document.getElementById('message-input');
        const sendButton = document.getElementById('send-message');
        
        const hasGroup = ${currentUser.group != null};
        if (!hasGroup) return;
        
        const currentUserId = '${currentUser.id}';
        let lastMessageId = 0;

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function loadMessages() {
            fetch('/user/groups/messages')
                .then(response => response.json())
                .then(messages => {
                    if (!Array.isArray(messages) || messages.length === 0) {
                        chatMessages.innerHTML = '<div class="chat-empty"><i class="fas fa-comment-slash" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>No messages yet. Start the conversation!</div>';
                        return;
                    }
                    
                    chatMessages.innerHTML = '';
                    messages.forEach(msg => {
                        const isOwn = msg.userId == currentUserId;
                        const div = document.createElement('div');
                        div.className = 'message ' + (isOwn ? 'message-own' : 'message-other');
                        
                        const time = msg.createdAt ? new Date(msg.createdAt).toLocaleTimeString('en-US', {
                            hour: '2-digit', minute: '2-digit', hour12: false
                        }) : '';
                        
                        div.innerHTML = '<div class="message-container">' +
                            '<div class="message-content">' +
                                '<div class="message-header">' +
                                    '<span class="message-username">' + escapeHtml(msg.username || 'Unknown') + '</span>' +
                                    '<span class="message-time">' + time + '</span>' +
                                '</div>' +
                                '<div class="message-text">' + escapeHtml(msg.messageText || '') + '</div>' +
                            '</div>' +
                        '</div>';
                        chatMessages.appendChild(div);
                        
                        if (msg.id > lastMessageId) lastMessageId = msg.id;
                    });
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                })
                .catch(err => {
                    console.error('Error loading messages:', err);
                    chatMessages.innerHTML = '<div class="chat-error"><i class="fas fa-exclamation-triangle"></i> Failed to load messages</div>';
                });
        }

        function sendMessage() {
            const message = messageInput.value.trim();
            if (!message) return;

            messageInput.disabled = true;
            sendButton.disabled = true;

            const formData = new FormData();
            formData.append('message', message);

            fetch('/user/groups/send-message', { method: 'POST', body: formData })
                .then(response => response.json())
                .then(() => {
                    messageInput.value = '';
                    loadMessages();
                })
                .catch(err => console.error('Error sending message:', err))
                .finally(() => {
                    messageInput.disabled = false;
                    sendButton.disabled = false;
                    messageInput.focus();
                });
        }

        loadMessages();
        setInterval(loadMessages, 5000);

        if (sendButton) sendButton.addEventListener('click', sendMessage);
        if (messageInput) messageInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    });
    </script>
</body>
</html>
