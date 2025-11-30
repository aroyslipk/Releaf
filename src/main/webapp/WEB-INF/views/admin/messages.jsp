<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Messages</h1>
        <a href="/admin/messages/new" class="btn btn-primary">Send New Message</a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row">
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Received Messages (${receivedMessages.size()})</h6>
                </div>
                <div class="card-body">
                    <c:if test="${empty receivedMessages}">
                        <p class="text-center text-muted p-4">No messages received yet.</p>
                    </c:if>
                    <c:if test="${not empty receivedMessages}">
                        <div class="list-group list-group-flush" style="max-height: 600px; overflow-y: auto;">
                            <c:forEach var="message" items="${receivedMessages}">
                                <a href="#" class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">${message.subject}</h5>
                                        <small>${message.createdAt.toLocalDate()}</small>
                                    </div>
                                    <p class="mb-1">From: ${message.fromUser}</p>
                                    <small>${message.body.length() > 100 ? message.body.substring(0, 100).concat('...') : message.body}</small>
                                    <c:if test="${!message.isRead}">
                                        <span class="badge bg-danger rounded-pill">NEW</span>
                                    </c:if>
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Sent Messages (${sentMessages.size()})</h6>
                </div>
                <div class="card-body">
                    <c:if test="${empty sentMessages}">
                        <p class="text-center text-muted p-4">No messages sent yet.</p>
                    </c:if>
                    <c:if test="${not empty sentMessages}">
                        <div class="list-group list-group-flush" style="max-height: 600px; overflow-y: auto;">
                            <c:forEach var="message" items="${sentMessages}">
                                <a href="#" class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">${message.subject}</h5>
                                        <small>${message.createdAt.toLocalDate()}</small>
                                    </div>
                                    <p class="mb-1">To: ${message.toUser}</p>
                                    <small>${message.body.length() > 100 ? message.body.substring(0, 100).concat('...') : message.body}</small>
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Received</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${receivedMessages.size()}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-inbox fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Sent</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${sentMessages.size()}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-paper-plane fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Unread</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="unreadCount" value="0" />
                                <c:forEach var="message" items="${receivedMessages}">
                                    <c:if test="${!message.isRead}">
                                        <c:set var="unreadCount" value="${unreadCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${unreadCount}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-envelope-open fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Total</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${receivedMessages.size() + sentMessages.size()}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-comments fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

