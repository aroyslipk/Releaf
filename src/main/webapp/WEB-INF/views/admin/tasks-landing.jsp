<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Task Management</h1>
        <a href="/admin/dashboard" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <div class="row">
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-body text-center p-5">
                    <h1 class="display-4 text-success"><i class="bi bi-tree-fill"></i></h1>
                    <h2 class="h1 mb-3">Greenverse Tasks</h2>
                    <p class="lead text-muted mb-4">Manage all sustainability tasks across 8 progressive topics. Create, edit, and monitor task completion for the entire community.</p>
                    <a href="/admin/greenverse/tasks" class="btn btn-primary btn-lg">Manage Greenverse Tasks</a>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-body text-center p-5">
                    <h1 class="display-4 text-warning"><i class="bi bi-lightbulb-fill"></i></h1>
                    <h2 class="h1 mb-3">FunLab Tasks</h2>
                    <p class="lead text-muted mb-4">Manage fun and creative eco-tasks! Create, edit, and monitor FunLab task submissions with flexible proof types.</p>
                    <a href="/admin/funlab" class="btn btn-warning btn-lg">Manage FunLab Tasks</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %> 