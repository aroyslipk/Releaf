<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Task Management</h1>
        <div>
            <a href="/admin/tasks/new" class="btn btn-primary">Create New Task</a>
            <a href="/admin/greenverse/tasks" class="btn btn-secondary">GreenVerse Tasks</a>
            <a href="/admin/funlab" class="btn btn-secondary">FunLab Tasks</a>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Task Filters</h6>
        </div>
        <div class="card-body">
            <form method="get" action="/admin/tasks" class="row g-3 align-items-center">
                <div class="col-auto">
                    <select name="topic" class="form-select">
                        <option value="">All Topics</option>
                        <c:forEach var="topic" items="${topics}">
                            <option value="${topic}" ${selectedTopic == topic ? 'selected' : ''}>${topic}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <select name="level" class="form-select">
                        <option value="">All Levels</option>
                        <c:forEach var="level" items="${levels}">
                            <option value="${level}" ${selectedLevel == level ? 'selected' : ''}>${level}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <a href="/admin/tasks" class="btn btn-secondary">Clear</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">All Tasks (${tasks.size()} total)</h6>
        </div>
        <div class="card-body">
            <c:if test="${empty tasks}">
                <div class="text-center p-5">
                    <h2 class="text-muted">No tasks found.</h2>
                    <a href="/admin/tasks/new" class="btn btn-primary">Create Your First Task</a>
                </div>
            </c:if>
            <c:if test="${not empty tasks}">
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Topic</th>
                                <th>Level</th>
                                <th>Description</th>
                                <th>XP</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="task" items="${tasks}">
                                <tr>
                                    <td>${task.id}</td>
                                    <td>${task.title}</td>
                                    <td>${task.topic}</td>
                                    <td><span class="badge bg-secondary">${task.level}</span></td>
                                    <td>${task.description}</td>
                                    <td><span class="badge bg-success">${task.xpReward} XP</span></td>
                                    <td><span class="badge bg-info">${task.status}</span></td>
                                    <td>
                                        <a href="/admin/tasks/edit/${task.id}" class="btn btn-sm btn-warning">Edit</a>
                                        <form method="post" action="/admin/tasks/delete/${task.id}" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this task?')">
                                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

