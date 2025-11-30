<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Notice Management</h1>
        <a href="/admin/notices/new" class="btn btn-primary">Create New Notice</a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">All Notices (${notices.size()} total)</h6>
        </div>
        <div class="card-body">
            <c:if test="${empty notices}">
                <div class="text-center p-5">
                    <h2 class="text-muted">No Notices Found</h2>
                    <p>Get started by creating your first notice to keep users informed.</p>
                    <a href="/admin/notices/new" class="btn btn-primary">Create Your First Notice</a>
                </div>
            </c:if>
            <c:if test="${not empty notices}">
                <div class="list-group list-group-flush">
                    <c:forEach var="notice" items="${notices}">
                        <div class="list-group-item">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">${notice.title}</h5>
                                <small>Created: ${notice.createdAt.toLocalDate()}</small>
                            </div>
                            <p class="mb-1">${notice.content}</p>
                            <div class="mt-2">
                                <span class="badge ${notice.isActive ? 'bg-success' : 'bg-secondary'}">${notice.isActive ? 'Active' : 'Inactive'}</span>
                                <form method="post" action="/admin/notices/toggle/${notice.id}" class="d-inline">
                                    <button type="submit" class="btn btn-sm ${notice.isActive ? 'btn-warning' : 'btn-success'}">${notice.isActive ? 'Deactivate' : 'Activate'}</button>
                                </form>
                                <a href="/admin/notices/edit/${notice.id}" class="btn btn-sm btn-secondary">Edit</a>
                                <form method="post" action="/admin/notices/delete/${notice.id}" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this notice?')">
                                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <c:if test="${not empty notices}">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Notices</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${notices.size()}</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-scroll fa-2x text-gray-300"></i>
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
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Active Notices</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <c:set var="activeNotices" value="0" />
                                    <c:forEach var="notice" items="${notices}">
                                        <c:if test="${notice.isActive}">
                                            <c:set var="activeNotices" value="${activeNotices + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${activeNotices}
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card border-left-warning shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Inactive Notices</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <c:set var="inactiveNotices" value="0" />
                                    <c:forEach var="notice" items="${notices}">
                                        <c:if test="${!notice.isActive}">
                                            <c:set var="inactiveNotices" value="${inactiveNotices + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${inactiveNotices}
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-pause-circle fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="shared/footer.jsp" %>

