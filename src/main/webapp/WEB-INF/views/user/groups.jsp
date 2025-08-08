<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Groups - ReLeaf</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/profile.css">
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>ReLeaf</h1>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/user/dashboard">Dashboard</a></li>
                    <li><a href="/user/tasks">Tasks</a></li>
                    <li><a href="/user/achievements">Achievements</a></li>
                    <li><a href="/user/notices">Notices</a></li>
                    <li><a href="/user/groups" class="active">Groups</a></li>
                    <li><a href="/user/messages">Messages</a></li>
                    <li><a href="/user/profile">Profile</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, ${sessionScope.userName}</span>
                <span class="xp-badge">${user.xpPoints} XP</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <h1 class="page-title">Groups</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty warning}">
            <div class="alert alert-warning">
                ${warning}
            </div>
        </c:if>

        <!-- Current Group Status -->
        <c:if test="${currentUser.group != null and currentUser.group.groupName != null}">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Your Current Group</h2>
                </div>
                <div class="current-group">
                    <h3>${currentUser.group.groupName}</h3>
                    <p class="description">${currentUser.group.description != null ? currentUser.group.description : 'No description available'}</p>
                    <div class="members-section">
                        <h4>Members (${currentUser.group.members != null ? currentUser.group.members.size() : 0})</h4>
                        <table class="members-table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>XP Points</th>
                                    <th>Completed Tasks</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="member" items="${currentUser.group.members}">
                                    <c:if test="${member != null and member.name != null}">
                                        <tr class="${member.id == currentUser.id ? 'current-user' : ''}">
                                            <td>
                                                ${member.name}
                                                <c:if test="${member.id == currentUser.id}">
                                                    <span class="badge">You</span>
                                                </c:if>
                                            </td>
                                            <td class="xp-cell">${member.xpPoints != null ? member.xpPoints : 0} XP</td>
                                            <td>${member.completedTasks != null ? member.completedTasks.size() : 0}</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Group Chat Section -->
                    <div class="chat-section">
                        <h4>Group Chat</h4>
                        <div id="chat-messages" class="chat-messages">
                            <!-- Messages will be loaded dynamically -->
                        </div>
                        <div class="chat-input">
                            <input type="text" id="message-input" placeholder="Type your message..." maxlength="1000">
                            <button id="send-message" class="btn btn-primary">Send</button>
                        </div>
                    </div>
                    
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            const chatMessages = document.getElementById('chat-messages');
                            const messageInput = document.getElementById('message-input');
                            const sendButton = document.getElementById('send-message');

                            // Show loading state
                            chatMessages.innerHTML = '<div class="chat-loading">Loading messages...</div>';

                            function loadMessages() {
                                if (!chatMessages) {
                                    console.error('Chat messages container not found');
                                    return;
                                }

                                fetch('/user/groups/messages?groupId=${currentUser.group.id}')  // Add groupId parameter
                                    .then(response => {
                                        if (!response.ok) throw new Error('Network response was not ok');
                                        return response.json();
                                    })
                                    .then(messages => {
                                        if (!messages || !Array.isArray(messages)) {
                                            throw new Error('Invalid message format received');
                                        }
                                        
                                        // Process messages
                                        displayMessages(messages);
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        showErrorMessage('Unable to load messages. Please refresh the page.');
                                    });
                            }

                            function displayMessages(messages) {
                                if (!messages.length) {
                                    chatMessages.innerHTML = '<div class="chat-empty">No messages yet. Start the conversation!</div>';
                                    return;
                                }

                                // Clear only if this is the first load
                                if (!lastMessageId) {
                                    chatMessages.innerHTML = '';
                                }

                                messages.forEach(message => {
                                    if (message && message.id > (lastMessageId || 0)) {
                                        appendMessage(message);
                                        lastMessageId = message.id;
                                    }
                                });

                                scrollToBottom();
                            }

                            function showErrorMessage(message) {
                                const errorDiv = document.createElement('div');
                                errorDiv.className = 'chat-error';
                                errorDiv.textContent = message;
                                chatMessages.appendChild(errorDiv);
                            }

                            function scrollToBottom() {
                                chatMessages.scrollTop = chatMessages.scrollHeight;
                            }

                            // Load initial messages
                            loadMessages();

                            // Setup periodic refresh
                            setInterval(loadMessages, 5000);

                            // Send message function
                            function sendMessage() {
                                const message = messageInput.value.trim();
                                if (!message) return;

                                // Disable input while sending
                                messageInput.disabled = true;
                                sendButton.disabled = true;

                                const formData = new FormData();
                                formData.append('message', message);
                                formData.append('groupId', '${currentUser.group.id}');  // Add groupId

                                fetch('/user/groups/send-message', {
                                    method: 'POST',
                                    body: formData
                                })
                                .then(response => {
                                    if (!response.ok) throw new Error('Failed to send message');
                                    return response.json();
                                })
                                .then(() => {
                                    messageInput.value = '';
                                    loadMessages();
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    showErrorMessage('Failed to send message. Please try again.');
                                })
                                .finally(() => {
                                    messageInput.disabled = false;
                                    sendButton.disabled = false;
                                    messageInput.focus();
                                });
                            }

                            // Event listeners
                            sendButton.addEventListener('click', sendMessage);
                            messageInput.addEventListener('keypress', function(e) {
                                if (e.key === 'Enter' && !e.shiftKey) {
                                    e.preventDefault();
                                    sendMessage();
                                }
                            });
                        });
                    </script>

                    <style>
                        .chat-loading, .chat-empty, .chat-error {
                            padding: 1rem;
                            text-align: center;
                            color: var(--gray);
                        }

                        .chat-error {
                            color: #d32f2f;
                            background: #ffebee;
                            border-radius: 4px;
                        }

                        .chat-empty {
                            font-style: italic;
                        }

                        /* Chat section styles */
                        .chat-section {
                            margin: 2rem 0;
                            padding: 1.5rem;
                            background: var(--light-green);
                            border-radius: 8px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        }

                        .chat-messages {
                            height: 400px;
                            overflow-y: auto;
                            padding: 1.5rem;
                            background: white;
                            border-radius: 8px;
                            margin: 1rem 0;
                            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
                        }

                        .chat-input {
                            display: flex;
                            gap: 1rem;
                            margin-top: 1rem;
                        }

                        .chat-input input {
                            flex: 1;
                            padding: 0.75rem;
                            border: 2px solid var(--light-green);
                            border-radius: 8px;
                            font-size: 1rem;
                            transition: border-color 0.2s;
                        }

                        .chat-input input:focus {
                            outline: none;
                            border-color: var(--primary-green);
                        }

                        .message {
                            margin-bottom: 1rem;
                            padding: 0.75rem;
                            border-radius: 8px;
                            max-width: 80%;
                            animation: fadeIn 0.3s ease-out;
                        }

                        @keyframes fadeIn {
                            from { opacity: 0; transform: translateY(10px); }
                            to { opacity: 1; transform: translateY(0); }
                        }

                        .message-own {
                            background: var(--primary-green);
                            color: white;
                            margin-left: auto;
                        }

                        .message-other {
                            background: #f0f0f0;
                            margin-right: auto;
                        }

                        .message-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 0.5rem;
                            font-size: 0.85rem;
                        }

                        .message-own .message-username,
                        .message-own .message-time {
                            color: rgba(255, 255, 255, 0.9);
                        }

                        .message-username {
                            font-weight: 600;
                            color: var(--dark-green);
                        }

                        .message-time {
                            color: var(--gray);
                        }

                        .message-text {
                            word-break: break-word;
                            line-height: 1.4;
                        }

                        #send-message {
                            padding: 0.75rem 1.5rem;
                            border-radius: 8px;
                            transition: transform 0.2s;
                        }

                        #send-message:hover {
                            transform: translateY(-1px);
                        }

                        #send-message:active {
                            transform: translateY(1px);
                        }

                        .message-error {
                            background: #fff0f0;
                            color: #d32f2f;
                            padding: 1rem;
                            text-align: center;
                            border-radius: 8px;
                            margin: 1rem 0;
                        }

                        .chat-section:not(.initialized) .chat-messages {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: var(--gray);
                            font-style: italic;
                        }
                    </style>

                    <form method="post" action="/user/leave-group" class="leave-group-form">
                        <button type="submit" class="btn btn-danger">Leave Group</button>
                    </form>
                </div>
            </div>
            
            <!-- Chat JavaScript -->
            <script>
            document.addEventListener('DOMContentLoaded', function() {
                const chatMessages = document.getElementById('chat-messages');
                const messageInput = document.getElementById('message-input');
                const sendButton = document.getElementById('send-message');

                if (!chatMessages || !messageInput || !sendButton) {
                    console.error('Required chat elements not found');
                    return;
                }

                let lastMessageId = null;

                // Load new messages
                function loadMessages() {
                    fetch('/user/groups/messages')
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(messages => {
                            if (!messages || !Array.isArray(messages)) {
                                console.warn('No messages received or invalid format');
                                return;
                            }
                            
                            try {
                                // Check if we have new messages
                                const latestMessageId = messages[0]?.id;
                                if (lastMessageId === null) {
                                    // First load - clear and show all messages
                                    chatMessages.innerHTML = '';
                                    messages.reverse().forEach(msg => {
                                        if (msg && msg.messageText) {
                                            appendMessage(msg);
                                        }
                                    });
                                    lastMessageId = latestMessageId;
                                } else if (latestMessageId && latestMessageId !== lastMessageId) {
                                    // New messages - only append new ones
                                    const newMessages = messages.filter(msg => msg.id > lastMessageId);
                                    newMessages.reverse().forEach(msg => {
                                        if (msg && msg.messageText) {
                                            appendMessage(msg);
                                        }
                                    });
                                    lastMessageId = latestMessageId;
                                }
                                chatMessages.scrollTop = chatMessages.scrollHeight;
                            } catch (err) {
                                console.error('Error processing messages:', err);
                            }
                        })
                        .catch(error => {
                            console.error('Error loading messages:', error);
                            // Only show error once per session
                            if (!window.errorShown) {
                                window.errorShown = true;
                                chatMessages.innerHTML += `
                                    <div class="message-error">
                                        Unable to load messages. Please refresh the page.
                                    </div>
                                `;
                            }
                        });
                }

                // Append a new message to the chat
                function appendMessage(message) {
                    const currentUserId = '${currentUser.id}';
                    const isCurrentUser = message.user.id === parseInt(currentUserId);
                    const div = document.createElement('div');
                    div.className = 'message ' + (isCurrentUser ? 'message-own' : 'message-other');
                    
                    const timestamp = new Date(message.createdAt).toLocaleTimeString('en-US', {
                        hour: '2-digit',
                        minute: '2-digit',
                        hour12: false
                    });
                    
                    div.innerHTML = `
                        <div class="message-header">
                            <span class="message-username">${isCurrentUser ? 'You' : message.user.name}</span>
                            <span class="message-time">${timestamp}</span>
                        </div>
                        <div class="message-text">${message.messageText}</div>
                    `;
                    chatMessages.appendChild(div);
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                }

                // Send message handler
                function sendMessage() {
                    const message = messageInput.value.trim();
                    if (!message) return;

                    const formData = new FormData();
                    formData.append('message', message);

                    fetch('/user/groups/send-message', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            console.error(data.error);
                            return;
                        }
                        messageInput.value = '';
                        loadMessages();
                    })
                    .catch(error => console.error('Error sending message:', error));
                }

                // Event listeners
                sendButton.addEventListener('click', sendMessage);
                messageInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        sendMessage();
                    }
                });

                // Load messages initially and refresh periodically
                loadMessages();
                setInterval(loadMessages, 10000); // Refresh every 10 seconds
            });
            </script>

            <style>
            .chat-section {
                margin: 2rem 0;
                padding: 1.5rem;
                background: var(--light-green);
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .chat-messages {
                height: 400px;
                overflow-y: auto;
                padding: 1.5rem;
                background: white;
                border-radius: 8px;
                margin: 1rem 0;
                box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .chat-input {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .chat-input input {
                flex: 1;
                padding: 0.75rem;
                border: 2px solid var(--light-green);
                border-radius: 8px;
                font-size: 1rem;
                transition: border-color 0.2s;
            }

            .chat-input input:focus {
                outline: none;
                border-color: var(--primary-green);
            }

            .message {
                margin-bottom: 1rem;
                padding: 0.75rem;
                border-radius: 8px;
                max-width: 80%;
                animation: fadeIn 0.3s ease-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .message-own {
                background: var(--primary-green);
                color: white;
                margin-left: auto;
            }

            .message-other {
                background: #f0f0f0;
                margin-right: auto;
            }

            .message-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 0.5rem;
                font-size: 0.85rem;
            }

            .message-own .message-username,
            .message-own .message-time {
                color: rgba(255, 255, 255, 0.9);
            }

            .message-username {
                font-weight: 600;
                color: var(--dark-green);
            }

            .message-time {
                color: var(--gray);
            }

            .message-text {
                word-break: break-word;
                line-height: 1.4;
            }

            #send-message {
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                transition: transform 0.2s;
            }

            #send-message:hover {
                transform: translateY(-1px);
            }

            #send-message:active {
                transform: translateY(1px);
            }

            .message-error {
                background: #fff0f0;
                color: #d32f2f;
                padding: 1rem;
                text-align: center;
                border-radius: 8px;
                margin: 1rem 0;
            }

            .chat-section:not(.initialized) .chat-messages {
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--gray);
                font-style: italic;
            }
            </style>
        </c:if>

        <!-- Available Groups -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Available Groups</h2>
            </div>
            <div class="groups-grid">
                <c:choose>
                    <c:when test="${empty groups}">
                        <div class="no-groups-message">
                            <h3>No groups available yet</h3>
                            <p>There are currently no groups to join. Check back later!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="group" items="${groups}">
                            <c:if test="${currentUser.group == null || currentUser.group.id != group.id}">
                        <div class="group-card">
                            <div class="group-info">
                                <h3>${group.groupName}</h3>
                                <p class="description">${group.description != null ? group.description : 'No description available'}</p>
                                <div class="group-stats">
                                    <span class="member-count">${group.members != null ? group.members.size() : 0} members</span>
                                    <c:if test="${group.members != null and group.members.size() > 0}">
                                        <span class="avg-xp">
                                            Avg. XP: ${group.avgXp != null ? group.avgXp : 0}
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            <div class="group-actions">
                                <c:if test="${currentUser.group == null}">
                                    <form method="post" action="/user/join-group/${group.id}">
                                        <button type="submit" class="btn btn-primary">Join Group</button>
                                    </form>
                                </c:if>
                            </div>
                            <div class="members-preview">
                                <h4>Top Members</h4>
                                <div class="top-members">
                                    <c:forEach var="member" items="${group.topMembers}" varStatus="status">
                                        <div class="member-row">
                                            <span class="rank">#${status.index + 1}</span>
                                            <span class="name">${member.name}</span>
                                            <span class="xp">${member.xpPoints != null ? member.xpPoints : 0} XP</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <style>
        .groups-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .group-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .group-info h3 {
            color: var(--dark-green);
            margin: 0 0 0.5rem 0;
        }

        .description {
            color: var(--gray);
            margin-bottom: 1rem;
            line-height: 1.4;
        }

        .group-stats {
            display: flex;
            justify-content: space-between;
            color: var(--dark-gray);
            font-size: 0.9rem;
            margin: 1rem 0;
        }

        .members-table {
            width: 100%;
            border-collapse: collapse;
            margin: 1rem 0;
        }

        .members-table th,
        .members-table td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid var(--light-green);
        }

        .members-table th {
            background: var(--light-green);
            color: var(--dark-green);
            font-weight: 600;
        }

        .current-user {
            background: var(--light-green);
        }

        .badge {
            background: var(--primary-green);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            margin-left: 0.5rem;
        }

        .members-preview {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--light-green);
        }

        .top-members {
            margin-top: 0.5rem;
        }

        .member-row {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--light-green);
        }

        .member-row:last-child {
            border-bottom: none;
        }

        .rank {
            width: 2.5rem;
            color: var(--primary-green);
            font-weight: 600;
        }

        .name {
            flex: 1;
            margin: 0 1rem;
        }

        .xp {
            color: var(--dark-gray);
            font-weight: 500;
        }

        .leave-group-form {
            margin-top: 1.5rem;
            text-align: right;
        }

        .current-group {
            padding: 1rem;
        }

        .no-groups-message {
            text-align: center;
            padding: 3rem;
            color: var(--gray);
        }

        .no-groups-message h3 {
            color: var(--dark-green);
            margin-bottom: 1rem;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
    </style>
</body>
</html>
