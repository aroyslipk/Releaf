<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Greenverse Task Management</h1>
        <a href="/admin/dashboard" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-body text-center p-5">
                    <h1 class="display-4 text-success"><i class="bi bi-tree-fill"></i></h1>
                    <h2 class="h1 mb-3">Greenverse Tasks</h2>
                    <p class="lead text-muted mb-4">Manage all sustainability tasks across 8 progressive topics. Create, edit, and monitor task completion for the entire community.</p>
                    <div class="row mb-4">
                        <div class="col-4">
                            <div class="h3 font-weight-bold">8</div>
                            <div class="text-muted">Topics</div>
                        </div>
                        <div class="col-4">
                            <div class="h3 font-weight-bold">3</div>
                            <div class="text-muted">Difficulty Levels</div>
                        </div>
                        <div class="col-4">
                            <div class="h3 font-weight-bold">∞</div>
                            <div class="text-muted">Possibilities</div>
                        </div>
                    </div>
                    <a href="/admin/greenverse/tasks" class="btn btn-primary btn-lg">Manage Tasks →</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %> 