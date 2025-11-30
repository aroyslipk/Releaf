<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">User Management</h1>

    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Users</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${users.size()}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total XP Earned</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="totalXP" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:set var="totalXP" value="${totalXP + user.xpPoints}" />
                                </c:forEach>
                                ${totalXP}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-star fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks Completed</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="totalCompleted" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:set var="totalCompleted" value="${totalCompleted + user.completedTasks.size()}" />
                                </c:forEach>
                                ${totalCompleted}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Users in Groups</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="usersWithGroups" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.group != null}">
                                        <c:set var="usersWithGroups" value="${usersWithGroups + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${usersWithGroups}
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

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Registered Users (${users.size()} total)</h6>
        </div>
        <div class="card-body">
            <form action="/admin/users" method="GET" class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                <div class="input-group">
                    <input type="text" name="searchName" class="form-control bg-light border-0 small" placeholder="Search for..." value="${param.searchName}">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search fa-sm"></i>
                        </button>
                    </div>
                </div>
            </form>
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>XP Points</th>
                            <th>Tasks</th>
                            <th>Group</th>
                            <th>Joined</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td><span class="badge bg-success">${user.xpPoints}</span></td>
                                <td>${user.completedTasks.size()}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.group != null}">
                                            <span class="badge bg-info">${user.group.groupName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">No Group</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.createdAt.toLocalDate()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Top Performers</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Name</th>
                            <th>XP Points</th>
                            <th>Completed Tasks</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}" varStatus="status" begin="0" end="9">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}">🥇</c:when>
                                        <c:when test="${status.index == 1}">🥈</c:when>
                                        <c:when test="${status.index == 2}">🥉</c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.name}</td>
                                <td><span class="badge bg-success">${user.xpPoints} XP</span></td>
                                <td>${user.completedTasks.size()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

