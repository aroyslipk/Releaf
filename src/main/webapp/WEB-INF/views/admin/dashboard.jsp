<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-lg-3 col-md-6">
            <div class="card bg-primary text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <i class="bi bi-people-fill" style="font-size: 3rem;"></i>
                        <div class="text-end">
                            <div class="huge">${totalUsers}</div>
                            <div>Total Users</div>
                        </div>
                    </div>
                </div>
                <a href="/admin/users" class="card-footer text-white clearfix small z-1">
                    <span class="float-start">View Details</span>
                    <span class="float-end"><i class="bi bi-arrow-right-circle-fill"></i></span>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="card bg-success text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <i class="bi bi-list-task" style="font-size: 3rem;"></i>
                        <div class="text-end">
                            <div class="huge">${totalTasks}</div>
                            <div>Active Tasks</div>
                        </div>
                    </div>
                </div>
                <a href="/admin/tasks" class="card-footer text-white clearfix small z-1">
                    <span class="float-start">View Details</span>
                    <span class="float-end"><i class="bi bi-arrow-right-circle-fill"></i></span>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="card bg-warning text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <i class="bi bi-person-bounding-box" style="font-size: 3rem;"></i>
                        <div class="text-end">
                            <div class="huge">${totalGroups}</div>
                            <div>Groups</div>
                        </div>
                    </div>
                </div>
                <a href="/admin/groups" class="card-footer text-white clearfix small z-1">
                    <span class="float-start">View Details</span>
                    <span class="float-end"><i class="bi bi-arrow-right-circle-fill"></i></span>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="card bg-danger text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <i class="bi bi-exclamation-triangle-fill" style="font-size: 3rem;"></i>
                        <div class="text-end">
                            <div class="huge">${totalNotices}</div>
                            <div>Active Notices</div>
                        </div>
                    </div>
                </div>
                <a href="/admin/notices" class="card-footer text-white clearfix small z-1">
                    <span class="float-start">View Details</span>
                    <span class="float-end"><i class="bi bi-arrow-right-circle-fill"></i></span>
                </a>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <i class="bi bi-lightning-fill"></i> Quick Actions
        </div>
        <div class="card-body">
            <a href="/admin/groups/new" class="btn btn-outline-primary m-1"><i class="bi bi-plus-circle-fill"></i> Create Group</a>
            <a href="/admin/notices/new" class="btn btn-outline-primary m-1"><i class="bi bi-plus-circle-fill"></i> Post Notice</a>
            <a href="/admin/messages/new" class="btn btn-outline-primary m-1"><i class="bi bi-plus-circle-fill"></i> Send Message</a>
            <a href="/admin/users" class="btn btn-outline-secondary m-1"><i class="bi bi-person-fill-gear"></i> Manage Users</a>
            <a href="/admin/reports" class="btn btn-outline-secondary m-1"><i class="bi bi-bar-chart-line-fill"></i> View Reports</a>
            <a href="/admin/task-reviews" class="btn btn-outline-secondary m-1"><i class="bi bi-check-circle-fill"></i> Review Tasks</a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header">
                    <i class="bi bi-star-fill"></i> Platform Features
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><i class="bi bi-person-check-fill"></i> User Registration & Authentication</li>
                        <li class="list-group-item"><i class="bi bi-list-task"></i> Task Management System</li>
                        <li class="list-group-item"><i class="bi bi-trophy-fill"></i> XP & Reward Tracking</li>
                        <li class="list-group-item"><i class="bi bi-people-fill"></i> Group Management</li>
                        <li class="list-group-item"><i class="bi bi-chat-dots-fill"></i> Notice & Messaging System</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header">
                    <i class="bi bi-tree-fill"></i> Environmental Topics
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><i class="bi bi-recycle"></i> Plastronauts</li>
                        <li class="list-group-item"><i class="bi bi-wind"></i> Aether Shield</li>
                        <li class="list-group-item"><i class="bi bi-droplet-fill"></i> Hydronauts</li>
                        <li class="list-group-item"><i class="bi bi-thermometer-sun"></i> ChronoClimbers</li>
                        <li class="list-group-item"><i class="bi bi-tree-fill"></i> Verdantra</li>
                        <li class="list-group-item"><i class="bi bi-flower1"></i> TerraFixers</li>
                        <li class="list-group-item"><i class="bi bi-cloud-haze2-fill"></i> SmogSmiths</li>
                        <li class="list-group-item"><i class="bi bi-book-fill"></i> EcoMentors</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

