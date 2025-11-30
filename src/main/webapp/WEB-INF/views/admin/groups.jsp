<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Group Management</h1>
        <a href="/admin/groups/new" class="btn btn-primary">Create New Group</a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row">
        <c:if test="${empty groups}">
            <div class="col-12">
                <div class="text-center p-5">
                    <h2 class="text-muted">No Groups Found</h2>
                    <p>There are no groups created yet.</p>
                    <a href="/admin/groups/new" class="btn btn-primary">Create Your First Group</a>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty groups}">
            <c:forEach var="group" items="${groups}">
                <div class="col-lg-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                            <h6 class="m-0 font-weight-bold text-primary">${group.groupName}</h6>
                            <span class="badge bg-secondary">${group.members.size()} members</span>
                        </div>
                        <div class="card-body">
                            <p>${group.description}</p>
                            <h6 class="mt-4">Members:</h6>
                            <ul class="list-group list-group-flush">
                                <c:forEach var="member" items="${group.members}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            ${member.name}
                                            <span class="badge bg-success rounded-pill">${member.xpPoints} XP</span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${group.members.size() > 5}">
                                    <li class="list-group-item text-center text-muted">...and ${group.members.size() - 5} more</li>
                                </c:if>
                            </ul>
                        </div>
                        <div class="card-footer">
                            <a href="/admin/groups/edit/${group.id}" class="btn btn-sm btn-warning">Edit</a>
                            <form method="post" action="/admin/groups/delete/${group.id}" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this group?')">
                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <c:if test="${not empty groups}">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Groups</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${groups.size()}</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-layer-group fa-2x text-gray-300"></i>
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
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Members</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <c:set var="totalMembers" value="0" />
                                    <c:forEach var="group" items="${groups}">
                                        <c:set var="totalMembers" value="${totalMembers + group.members.size()}" />
                                    </c:forEach>
                                    ${totalMembers}
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-users fa-2x text-gray-300"></i>
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
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Avg Members/Group</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <c:set var="avgMembers" value="0" />
                                    <c:if test="${groups.size() > 0}">
                                        <c:set var="totalMembers" value="0" />
                                        <c:forEach var="group" items="${groups}">
                                            <c:set var="totalMembers" value="${totalMembers + group.members.size()}" />
                                        </c:forEach>
                                        <c:set var="avgMembers" value="${totalMembers / groups.size()}" />
                                    </c:if>
                                    ${String.format("%.1f", avgMembers)}
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-calculator fa-2x text-gray-300"></i>
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
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Largest Group</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <c:set var="largestGroup" value="0" />
                                    <c:forEach var="group" items="${groups}">
                                        <c:if test="${group.members.size() > largestGroup}">
                                            <c:set var="largestGroup" value="${group.members.size()}" />
                                        </c:if>
                                    </c:forEach>
                                    ${largestGroup}
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-user-friends fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="shared/footer.jsp" %>

