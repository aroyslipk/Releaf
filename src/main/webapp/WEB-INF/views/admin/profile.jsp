<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">Admin Profile</h1>

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
                    <h6 class="m-0 font-weight-bold text-primary">Profile Information</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-4">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width: 80px; height: 80px; font-size: 2rem;">
                            ${admin.username.substring(0, 1).toUpperCase()}
                        </div>
                        <div>
                            <h4 class="mb-0">${admin.username}</h4>
                            <p class="text-muted mb-0">Administrator</p>
                        </div>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><strong>Username:</strong> ${admin.username}</li>
                        <li class="list-group-item"><strong>Role:</strong> System Administrator</li>
                        <li class="list-group-item"><strong>Account Created:</strong> ${admin.createdAt.toLocalDate()}</li>
                        <li class="list-group-item"><strong>Last Updated:</strong> ${admin.updatedAt.toLocalDate()}</li>
                    </ul>
                </div>
            </div>

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Administrator Privileges</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <i class="bi bi-list-task me-2"></i> Task Management
                        </div>
                        <div class="col-md-6 mb-3">
                            <i class="bi bi-people-fill me-2"></i> User Management
                        </div>
                        <div class="col-md-6 mb-3">
                            <i class="bi bi-chat-dots-fill me-2"></i> Communications
                        </div>
                        <div class="col-md-6 mb-3">
                            <i class="bi bi-bar-chart-line-fill me-2"></i> Analytics
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Change Password</h6>
                </div>
                <div class="card-body">
                    <form method="post" action="/admin/change-password">
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control" required placeholder="Enter new password">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required placeholder="Confirm new password">
                        </div>
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </form>
                </div>
            </div>

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Security & Best Practices</h6>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Account Security</h5>
                    <ul>
                        <li>Use a strong, unique password for your admin account.</li>
                        <li>Change your password regularly (recommended every 90 days).</li>
                        <li>Never share your admin credentials with others.</li>
                        <li>Log out when finished with admin tasks.</li>
                    </ul>
                    <hr>
                    <h5 class="card-title">Platform Management</h5>
                    <ul>
                        <li>Regularly review and update task content for accuracy.</li>
                        <li>Monitor user engagement and platform statistics.</li>
                        <li>Respond promptly to user messages and concerns.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

